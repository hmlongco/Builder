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

Here's the detail view for the app.

![Image](https://github.com/hmlongco/Builder/blob/main/SampleDetail.png?raw=true)

And the card view "builder" code that generates it.

```swift
struct DetailCardView: ViewBuilder {    

    @Injected var viewModel: DetailViewModel

    init(user: User) {
        viewModel.configure(user)
    }

    func build() -> View {
        ContainerView {
            VStackView {
                DetailPhotoView(photo: viewModel.photo(), name: viewModel.fullname)
                
                VStackView {
                    NameValueView(name: "Address", value: viewModel.street)
                    NameValueView(name: "", value: viewModel.cityStateZip)
                    
                    SpacerView(16)
                    
                    NameValueView(name: "Email", value: viewModel.email)
                    NameValueView(name: "Phone1", value: viewModel.phone)
                    
                    SpacerView(16)
                    
                    NameValueView(name: "Age", value: viewModel.age)
                }
                .spacing(2)
                .padding(20)
            }
        }
        .backgroundColor(.quaternarySystemFill)
        .cornerRadius(16)
    }

}
```
And here are the dependent subviews which show the actual UIKit views being constructed.

```swift
struct DetailPhotoView: ViewBuilder {
    
    let photo: Observable<UIImage?>
    let name: String

    func build() -> View {
        ZStackView {
            ImageView(photo)
                .contentMode(.scaleAspectFill)
                .clipsToBounds(true)
            
            LabelView(name)
                .alignment(.right)
                .font(.headline)
                .color(.white)
                .padding(h: 8, v: 8)
                .backgroundColor(.black)
                .alpha(0.7)
                .position(.bottom)
        }
        .height(250)
    }
}

struct NameValueView: ViewBuilder {

    let name: String?
    let value: String?

    func build() -> View {
        HStackView {
            LabelView(name)
                .color(.secondaryLabel)
            SpacerView()
            LabelView(value)
                .alignment(.right)
        }
        .spacing(4)
    }

}
```
Although small in size, it allows simple user interfaces to be constructed quickly and easily. 

I've used this in several projects to get the benefits of declarative programming in legacy UIKit-based applications that can't yet support SwiftUI and its minimum base SDK of iOS 13, iOS 14, or iOS 15.

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

## Structuring Applications for Mocking and Testing

Everyone knows that using an architecture like MVVM in your iOS application can help to avoid Massive-View-Controller-Syndrome, where the entirity of your screen's logic and code is shoehorned into a single, massive `UIViewController`. And everyone knows that breaking out all of that business logic can help make the components of your application easier to understand.

That's a given... or is it? Something smaller is probably easier to understand, of course. But breaking components down into smaller components and services also tends to *increase* overall application complexity. After all, all of those pieces and parts are going to have to be created and wired back together again, and all of that wiring has an associated cost all of its own.

So if we're going to "pay" more for our applications, then the cost-benefit ratio had better be worth it. In fact, I'd argue that the benefit gained would have to be *massive* in order to justify the increase in costs and complexity.

Fortunately, there is a major benefit to be gained... and that benefit comes from unit testing.

### Why test?

Testing our view models and services lets us inspect our code to ensure that it's working as expected. It lets us see how our code behaves under error conditions and under uncommon but specific edge cases, like, say, when you fetch a list of accounts and the list is emtpy. 

And it gives us confidence that our code will *continue* to work as expected when it's changed, either directly or when someone makes an unexpected change to a dependency that alters the contract between that code and your own.

Further, if you or your company is an adherent of Continuous Integration/Continuous Deployment (CI/CD), then performing unit tests and integration tests on your code is almost an absolute requirement, as there's little to no time for QA to perform a full regression suite on your app for every point release.

### What are the costs?

Writing unit and integration tests incur costs of their own, obviously, as those tests have to be written and maintained, and that takes development time away from writing features and fixing bugs.

On the flip side, no one likes fixing bugs, and writing unit tests on error conditions and edge cases tends to shine a spotlight into the very places where the pesky critters like to hide. Every bug found and patched due to an error in a unit test is one that failed to make its way into production code. In fact, it's probably one that failed to make its way to QA.

Another set of wins.

### 


## Using Resolver to mock user data for application development

### Overview

Using dependency injection and protocol-oriented programing allows us the ability to easily mock data and application behavior.

### Testing Dependencies

 Here our `MainViewModel` depends on a service that's based on a protocol, `UserServiceType`.

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




### The MOCK scheme

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
Remember that by default Resolver will register objects in the `main` container, but when its asked to resolve them it will pull registrations from the container referenced by `root`. Normally the two are one and the same: `root` simply points to `main`. 

But we can change that if we wish... and we do.

Because changing `root` lets us perform the magic trick we're about to do now. We set the mock container's parent to `main`, and then we switch the "root" container to point to `mock`. This means that our mock container will now be searched first when Resolver attempts to resolve service dependencies. Should it not find the registered factory it's looking for in `mock` it will move on to `main`.

Got it? Resolver will now search `mock` first, then `main`.

But in order to find something in `mock` there has to be something to find.

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

This is an *extremely* powerful concept.

### With data? Or without?

I'm not limited to just a single mock. I can create an `MockEmptyUserService` that returns empty data, register *that* class instead, and then see how my app and view model will behave if our app doesn't have any users at all. :(

Or I can create a `MockErrorUserService` that does nothing but return errors when called, which means I can make sure my error handling and display functionality is working correctly.

My standard mock dataset can even be enhanced with problematic data. I can add users like "Michael ThisIsAnExtremelyLongUserName" to make sure my display code doesn't break. Or I can add users that don't have addresses, or email addresses, or... whatever.

The point is that I can add all of the edge cases I need to make sure my app will behave properly under any and all circumstances.

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

### Application dependencies

One thing to note is that our `test` container points to our `mock` container, and that it in turn points to our `main` container. As a consequence, any service not found in `test` or `mock` will be pulled from `main`. 

This includes services that might have been setup with `.application` or `.shared` scopes **and that were instantiated and run when the application was launched**. With that in mind, we also reregistered `UserImageCache` so that our tests will get a clean version and not the singleton used by the application.

Chaining containers means that you don't have to reregister *everything* when building your unit tests, but that convenience comes with a major caveat. Be careful.

### Testing

With our setup complete, let's move on to testing. When writing unit tests on view models you often want to test different scenarios, the most basic being what happens when our view model has data. 

Simply making a new instance of `MainViewModel` will trigger automatic dependency injection via Resolver's `@Injected` property wrapper. Which means for this test we'lll get the `MockUserService` class we registered in `resetUnitTestRegistrations`. 

Remember, our `setup` function is called before each test in our `XCTestCase` . That in turn calls `resetUnitTestRegistrations` and *that* sets up a new test container that registers the `MockUserService` factory that should be used when we need an instance of `UserServiceType`.

Note that these tests use some helper functions to manage XCTest expectations and to make testing RxSwift observables easier. If you want to borrow them you can find them in the project.

### Testing load data...

This is the primary function of our view model and as such, its biggest test case.

```swift
func testLoadedState() throws {
    let vm = MainViewModel()
    var eventCounter = 0
    
    test("Test loaded state") { done in
        _ = vm.state
            .subscribe(onNext: { (state) in
                eventCounter += 1
                switch state {
                case .loading:
                    XCTAssert(eventCounter == 1)
                case .loaded(let users):
                    XCTAssert(eventCounter == 2)
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
We instantiate our view model, setup our subscription, and then call `load()`.  

Our initial state is `.loading` so we make sure we see that first. 

The next event we get should be a `.loaded` state which has our data. Before we move on we check our counter to make sure we've seen `.loading` at least once and that our sequence of events is correct. 

We then test to make sure we've received the correct number of users. One of the functions of our view model is sorting the results from our API, and so we also check to make sure our list of users is in the proper order. (Our `MockUserService` builds the list of users out of order specifically so we can test this criteria.)

Notice there are also test cases for `.empty` or `.error`. The data provided by `MockUserService` should never cause those to appear, but the operative word in that sentence is *should*. After all, it's possible that we could have a logic error in our code that's mapping to the wrong state, so we check for that. 

It is, after all, why we do unit tests.

Finally, note that in the later three cases we call `done()` to signify our test is complete and that it's okay for our test expectation to move on and not wait to time out.

### No data?

So what happens when we don't have data? 

Here we reregister  `UserServiceType`  with a `MockEmptyUserService` that simply returns empty data when called. Reregistering a given type replaces the registration factory for that type with the new version.

Now when we instantiate our `MainViewModel` it will receive and use our `MockEmptyUserService` instead of receiving an instance of `MockUserService`. 

```swift
func testEmptyState() throws {
    Resolver.test.register { MockEmptyUserService() as UserServiceType }
    
    let vm = MainViewModel()
    
    test("Test empty state") { done in
        _ = vm.state
            .subscribe(onNext: { (state) in
                switch state {
                case .loading:
                    break
                case .empty(let message):
                    XCTAssert(message == "No current users found...")
                    done()
                default:
                    XCTFail("No other state is valid")
                    done()
                }
            })
        vm.load()
    }
}
```
And then we call load and test that our view model is returning the proper state and message when the API call returns an empty list of users. Any other states are errors and treated as such.

### Thumbnails?

We can also test to make sure we're getting the proper thumbnail images for our users. If no user image is available we want to show a placeholder image instead, so we check to make sure that's working as well.

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

Finally,  we should also test to make sure we're handling our errors correctly.

Once more we reregister and replace our  `UserServiceType`  with a `MockErrorUserService` that (surprise) returns errors on its API calls.

In which case `load()` should map the error *type* to an error *state*.
```swift
func testErrorState() throws {
    Resolver.test.register { MockErrorUserService() as UserServiceType }
    
    let vm = MainViewModel()
    
    test("Test list error state") { done in
        _ = vm.state
            .subscribe(onNext: { (state) in
                switch state {
                case .loading:
                    break
                case .error(let message):
                    XCTAssert(message.contains("Builder.APIError"))
                    done()
                default:
                    XCTFail("No other state is valid")
                    done()
                }
            })
        vm.load()
    }
}
```
We can also test our image handler for errors.
```swift
func testThumbnailImageError() throws {
    Resolver.test.register { MockErrorUserService() as UserServiceType }

    let vm = MainViewModel()
    let imageObservable = vm.thumbnail(forUser: User.mockJQ).asObservable()

    test("Test image error returned", error: imageObservable) { (error) -> Bool in
        error.localizedDescription.contains("Builder.APIError")
    }
}

```
Note here we're actually expecting to see an `Error` returned, whereas in the earlier example our view model was actually mapping errors returned into an error state. 

Writing this test, however, made me realize that this function should probably *never* error out and should always return a placeholder image.

I'll go back into the code and fix that. And, of course, update my unit test accordingly. Mock user Jonny Quest has an image available, but here I should see the placeholder since the image API is returning an error.
```swift
func testThumbnailImageError() throws {
    Resolver.test.register { MockErrorUserService() as UserServiceType }

    let vm = MainViewModel()
    let image = vm.thumbnail(forUser: User.mockJQ).asObservable()

    test("Test receiving placeholder image on error", value: image) {
        $0 == UIImage(named: "User-Unknown")
    }
}
```
And I do. Another win for unit tests.

### Complexity

It may look like a lot of code to test my view model and--in a way-- it is. But from an implementation standpoint the hardest test to write was my first test, `testLoadedState`. The others were largely copy and paste versions of the first, which meant that, effectively, each additional test only took a minute or so to write.

But I'm now confident that my view model is performing exactly as it should. Both under normal conditions and if and when it runs into an error. Further, should I update my model, say by adding a `refresh` state, I can be confident that should I manage to break something I'll be the one to find out about it.

And not my users.

### Wrapup

By changing the factory provided for `UserServiceType` prior to constructing the view model we can test all of the above scenarios... and more.

## Installation

Just download the project and run it.

Currently it requires Xcode 12.4.
