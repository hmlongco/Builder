# Builder

## Overview

Builder is a simple iOS Master/Detail app written in Swift that demonstrates quite a few technologies, tricks, and techniques:

1. Using declarative function-builder design patterns for constructing UIKit-based user interfaces.
2. Using builder patterns to construct network requests.
3. Using RxSwift for MVVM data binding.
4. Using the [Resolver](https://github.com/hmlongco/Resolver.git) dependency injection system to construct MVVM architectures.
5. Using Resolver to mock user data for application development.
6. Using Resolver to mock user data for unit tests.

With the inclusion of #4, #5, and #6, this app does double duty as the often requested *demo* app for [Resolver](https://github.com/hmlongco/Resolver.git) .

## Builder User Interface Library

The Builder user interface library allows declarative programming paradigms to be used when constructing UIKit-based applications. 

```swift
struct MainCardBuilder: UIViewBuilder {

    @Injected var viewModel: MainViewModel

    let user: User

    func build() -> View {
        ContainerView(
            HStackView {
                ImageView(thumbnail())
                    .cornerRadius(25)
                    .frame(height: 50, width: 50)
                VStackView {
                    LabelView(user.fullname)
                    LabelView(user.email)
                        .font(.footnote)
                        .color(.secondaryLabel)
                    SpacerView()
                }
                .spacing(4)
            }
            .padding(UIEdgeInsets(padding: 10))
        )
        .backgroundColor(.quaternarySystemFill)
        .cornerRadius(8)
    }
    
    func thumbnail() -> Observable<UIImage?> {
        return viewModel.thumbnail(forUser: user)
            .asObservable()
            .observe(on: MainScheduler.instance)
    }

}
```
Although small in size, it allows simple user interfaces to be constructed quickly and easily. 

I've used this in several projects to get the benefits of declarative programming in legacy UIKit-based applications that can't yet support SwiftUI and its minimum base SDK of iOS 13.

## Builder Networking Library

This URLSession-based library uses builder patterns to construct network requests.
```swift
struct UserService: UserServiceType {
    
    @Injected var session: ClientSessionManagerType

    func list() -> Single<[User]> {
        session.builder()
            .add(path: "/")
            .add(parameters: ["results":20, "nat":"us", "seed":"999"])
            .rx
            .send(.get)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
            .retry(1)
            .map { (results: UserResultType) in results.results }
    }

    func thumbnail(forUser user: User) -> Single<UIImage?> {
        guard let path = user.picture?.thumbnail else {
            return .just(nil)
        }
        return session.builder(forURL: URL(string: path))
            .rx
            .send(.get)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
            .map { (data: Data) -> UIImage? in UIImage(data: data) }
    }

}
```
There are extensions for using this functionality with RxSwift (as shown), Combine, as well as with a standard Result-based callback mechanism.

## Using RxSwift for MVVM Data Binding

Using Builder to construct UIKit-based interfaces leads to another question: how do we update our interfaces?

This app uses RxSwift in many places to bind views and view models and view controllers together.
```swift
    func setupSubscriptions() {
        viewModel.state
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (state) in
                switch state {
                case .loading:
                    self?.displayLoadingView()
                case .loaded(let users):
                    self?.displayUsers(users)
                case .empty(let message):
                    self?.displayEmptyView(message)
                case .error(let error):
                    self?.displayErrorView(error)
                }
            })
            .disposed(by: disposeBag)
    }
```
## Using Resolver for MVVM

The application also demonstrates using the [Resolver](https://github.com/hmlongco/Resolver.git) dependency injection system to construct MVVM architectures.

```swift
class MainViewModel {
    
    @Injected var service: UserServiceType
    @Injected var cache: UserImageCache

    ...
}
```
Above we're using Resolver's @Injected property wrapper to find and instantiate the dependencies needed for our main view model.

Injections tie together the master view, detail view, the view models, and the API and data caching layers of the application.


## Using Resolver to mock user data for application development

Using dependency injection and protocol-oriented programing allows us the ability to easily mock data and application behavior. Here our `MainViewModel` depends on a protocol, `UserServiceType`, that's used to return data from our API.

```swift
class MainViewModel {
    
    @Injected var service: UserServiceType
    @Injected var cache: UserImageCache
    
    ...
```
And here's the protocol.

```swift
protocol UserServiceType {
    func list() -> Single<[User]>
    func thumbnail(forUser user: User) -> Single<UIImage?>
}
```
The demo app has a MOCK scheme that, when built, allows the app to run in a mock data mode. That scheme includes a `MOCK` compiler flag we can check in our code.  

So let's use that to make a mock version of this service.
```swift
#if MOCK
struct MockUserService: UserServiceType {
    func list() -> Single<[User]> {
        return .just(User.users)
    }
    func thumbnail(forUser user: User) -> Single<UIImage?> {
        if let name = user.picture?.thumbnail, let image = UIImage(named: name) {
            return .just(image)
        }
        return .just(nil)
    }
}
#endif
```

### Depndency Injection Setup

To use it we first setup a `mock` container in our main injection file.

```swift
#if MOCK
extension Resolver {
    static var mock = Resolver(parent: main)
}
#endif

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        ...
        
        #if MOCK
        root = mock
        #endif
    }
}
```
Note that the mock's parent points to `main`, and that we switch the "root" container to point to `mock`. This means that our mock container will be searched first when Resolver attempts to resolve service dependencies.

But in order to find something there has to be something to find.

### Registering mock data

So when running in `MOCK` mode we add additional registrations to our `mock` container.

```swift
extension Resolver {
    public static func registerServices() {
        ...
        register { UserImageCache() }.scope(.shared)
        register { UserService() as UserServiceType }

        #if MOCK
        mock.register { MockUserService() as UserServiceType }
        #endif
    }
}
```

In this example when an instance of `UserServiceType` is needed in our `MainViewModel`, Resolver will grab the mock version from the mock container as that's the version it finds first.

## Using Resolver to mock user data for unit tests

Mocking data doesn't stop when running our application in mock mode. It also comes in handy when we want to create unit tests for our view models and for other components of our application.

### Dependency Injection Setup

A good way to accomplish this is by defining a `test` Resolver container, exactly as we did above when setting up our MOCK mode.

```swift
extension Resolver {

    static var test: Resolver!
    
    static func resetUnitTestRegistrations() {
        Resolver.test = Resolver(parent: .mock)
        Resolver.root = .test
        // note we're providing some standard "default" registrations
        Resolver.test.register { MockUserService() as UserServiceType }
        Resolver.test.register { UserImageCache() } // use our own and not global
    }
}
```

We  also create a helper function that constructs a new test container and makes it the root container each time its called. It also provides some common registrations that will be used in many of our tests. 

Then we call our helper function in each of our XCTestCase setup functions.

```swift
class MainViewModelSpec: XCTestCase {
    
    override func setUp() {
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        Resolver.root = .mock
    }

    ...
```

This ensures that each test gets a brand new container with no side effects from previous tests.

One thing to note is that our `test` container points to our `mock` container, and that it in turn points to our `main` container. As a consequence, any service not found in `test` or `mock` will be pulled from `main`. 

This includes services that might have been setup with `.application` or `.shared` scopes **and that were instantiated and run when the application was launched**. With that in mind, we also reregistered `UserImageCache` so that our tests will get a clean version and not the singleton used by the application.

Chaining containers means that you don't have to reregister *everything* when building your unit tests, but that convenience comes with a major caveat. Be careful.

### Testing

With our setup complete, let's move on to testing. When writing unit tests on view models you often want to test different scenarios, the most basic being what happens when our view model has data. 

Simply making a new instance of `MainViewModel` will trigger automatic dependency injection via Resolver's `@Injected` property wrapper. Which means for this test we'lll get the `MockUserService` class we registered in `resetUnitTestRegistrations`. 

Remember, our `setup` function is called before each test in our `XCTestCase` . That in turn calls `resetUnitTestRegistrations` and *that* sets up a new test container that registers the `MockUserService` factory that should be used when we need an instance of `UserServiceType`.

Note that these tests use some helper functions to manage XCTest expectations and to make testing RxSwift observables easier. You can find them in the project.

### Testing load data...

This is the primary function of our view model and as such, its biggest test case.

```swift
func testLoadedState() throws {
    let vm = MainViewModel()
    var loaded = 0
    
    test("Test loaded state") { done in
        _ = vm.state
            .subscribe(onNext: { (state) in
                switch state {
                case .loading:
                    loaded += 1
                    XCTAssert(loaded == 1)
                case .loaded(let users):
                    XCTAssert(loaded == 1)
                    XCTAssert(users.count == 2)
                    XCTAssert(users[0].fullname == "Jonny Quest")
                    XCTAssert(users[1].fullname == "Tom Swift")
                    done()
                case .empty(_):
                    XCTFail("Should not be empty")
                    done()
                case .error(_):
                    XCTFail("Should not error")
                    done()
                }
            })
        vm.load()
    }
}
```
We instantiate our view model, setup our subscription and call `load()`.  

We then wait to see if our `state` is updated accordingly.

Our initial state is `.loading` so we check that one and then wait to see what's next. 

If we get `.loaded` we have our data. First we check to make sure we've seen `.loading` at least once, and then we check to make sure we have the expected number of users, and that they're in the correct order. 

In regard to the test cases for `.empty` or `.error`, it's true that our `MockUserService` should never return empty data or an error, but it's possible that we *could* have a logic error in our code that maps to the wrong state, so we check for that.

It is, after all, why we do unit tests.

Finally, note that in the later three cases we call `done()` to signify our test is complete and that it's okay for our test expectation to move on.

### No data?

So what happens when we don't have data? 

Here we reregister  `UserServiceType`  with a `MockEmptyUserService` that simply returns empty data when called. Reregistering a given type replaces the registration factory for that type with the new version.

Now when we instantiate our `MainViewModel` it will receive and use our `MockEmptyUserService` instead of receiving an instance of `MockUserService`. 

```swift
func testEmptyState() throws {
    Resolver.test.register { MockEmptyUserService() as UserServiceType }

    let vm = MainViewModel()
    vm.load()

    test("Test empty state", value: vm.state) { (state) -> Bool in
        if case .empty(let message) = state {
            return message == "No current users found..."
        }
        return false
    }
}
```
And then we call load and test that our view model is returning the proper state and message when the API call returns an empty list of users.

### Thumbnails?

We can also make sure we're getting proper image data for our users. Or make sure that we get placeholder data if that user doesn't have an image available.

```swift
func testThumbnails() throws {
    let vm = MainViewModel()

    let image1 = vm.thumbnail(forUser: User.mockJQ).asObservable()
    test("Test has thumbnail for user", value: image1) {
        $0 == UIImage(named: "User-JQ")
    }

    let image2 = vm.thumbnail(forUser: User.mockTS).asObservable()
    test("Test has placeholder for user", value: image2) {
        $0 == UIImage(named: "User-Unknown")
    }
}
```
### Error handling.

We can do the same for errors.

Again we reregister and replace our  `UserServiceType`  with a `MockErrorUserService` that (surprise) returns errors on its API calls.

In which case `load()` should map the error *type* to an error *state*.
```swift
func testListErrorState() throws {
    Resolver.test.register { MockErrorUserService() as UserServiceType }
    
    let vm = MainViewModel()
    vm.load()

    test("Test list error state", value: vm.state) { (state) -> Bool in
        if case .error(let message) = state {
            return message.contains("Builder.APIError")
        }
        return false
    }
}
```
We can also test our image handler for errors.
```swift
func testImageErrorState() throws {
    Resolver.test.register { MockErrorUserService() as UserServiceType }

    let vm = MainViewModel()
    let imageObservable = vm.thumbnail(forUser: User.mockJQ).asObservable()

    test("Test image error state", error: imageObservable) { (error) -> Bool in
        error.localizedDescription.contains("Builder.APIError")
    }
}

```
Note here we're actually expecting to see an `Error` returned, whereas in the earlier example our view model was actually mapping any errors returned into an error state. 

Writing this test, however, made me realize that this function should probably *never* error out and should always at least return a placeholder image.

I'll go back into the code and fix that. And, of course, update my unit test accordingly.
```swift
func testImageErrorState() throws {
    Resolver.test.register { MockErrorUserService() as UserServiceType }

    let vm = MainViewModel()
    let image = vm.thumbnail(forUser: User.mockJQ).asObservable()

    test("Test receiving placeholder image on error", value: image) {
        $0 == UIImage(named: "User-Unknown")
    }
}
```
Another win for unit tests.

### Wrapup

By changing the factory provided for `UserServiceType` prior to constructing the view model we can test all of the above scenarios... and more.

## Installation

Just download the project and run it.

Currently it requires Xcode 12.4.
