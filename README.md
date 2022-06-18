# Builder

## Overview

Builder is a simple iOS Master/Detail app written in Swift that demonstrates quite a few technologies, tricks, and techniques:

1. Using declarative function-builder design patterns for constructing UIKit-based user interfaces.
2. Using RxSwift for MVVM data binding.
3. Using the [Resolver](https://github.com/hmlongco/Resolver.git) dependency injection system to construct MVVM architectures.
4. Using builder patterns to construct network requests.
5. Using Resolver to mock user data for application development.
6. Using Resolver to mock user data for unit tests.

With the inclusion of #3, #5, and #6, this app does double duty as the often requested *demo* app for [Resolver](https://github.com/hmlongco/Resolver.git) .

---

## Builder User Interface Library

Builder lets you define your UIKit-based user interfaces using a simple, declarative format similar to that used by SwiftUI and Flutter. Builder is also based on RxSwift, with means that you have all of the reactive data binding and user interface control and functionality you'd expect from such a marriage.

With Builder, interfaces are composed and described using "views" and "modifiers" in a builder pattern. 

```
    LabelView($title)
        .color(.red)
        .font(.title1)
```

When rendered, each "view" of a given type builds a corresponding UIView which is then modified as needed with the desired properties and behaviors.

Combine just a few views together, and you can quickly and easily achieve some dynamic user interfaces

![Detail Card View](https://github.com/hmlongco/Builder/blob/main/SampleDetail.png?raw=true)

Declarative programming using Builder eliminates the need for Interface Builder Storyboards, Segues, and NIBs, and even custom UIViewControllers. All of those things are still there, of course, lying in wait for the times when they're truly needed for some bit of custom functionality.

Like SwiftUI, the goal behind Builder is to eliminate much of the hassle behind creating and developing user interfaces.

But unlike SwiftUI, with Builder you also have the power to reach under the hood at any point in time and directly work with the generated views and interface elements and tweak them to your hearts content.

### Why Builder?

With SwiftUI and Combine available, why use Builder and RxSwift? Well, I guess the answer to that question actually depends on your definition of *available*.

**The problem is that SwiftUI and Combine both require iOS 13 at a minimum.** No support for iOS 12 or iOS 11. 

And if I were using SwiftUI in a production app I'd probably consider **iOS 14** to be the minimum version suitable for application development. And even then there are some critical components that require iOS 15!

Same for using Combine. That too would have tied me to iOS 13/14 as the minimum version... which is what I was trying to avoid in the first place.

Hence the problem. There aren't too many developers who can drop support for earlier versions of iOS in their applications and go iOS 14 or 15 only. Which in turn means that most of us wouldn't see any of the benefits of doing declarative, reactive programming for another couple of **years**. 

That's simply too long.

#### CwlViews

There are a few other declarative frameworks out there, the most notable of which is Matt Gallagher's [CwlViews](https://www.cocoawithlove.com/blog/introducing-cwlviews.html).

While CwlViews has some cool and interesting features, it's biggest drawback lies in its implementation of its own reactive framework. I firmly believe in RxSwift and perhaps more to the point, RxSwift has a large and loyal base of users plus tons of available resources, books, and articles devoted to it.

I wanted declarative development *and* I wanted my RxSwift. What can I say? I'm greedy.

#### Flutter, React Native, et. al.

There are other "cross-platform" frameworks out there, but I'm an iOS Swift developer at heart and doing iOS development in Dart or JavaScript simply doesn't interest me.

#### RxSwiftWidgets

Builder wasn't my first attempt at a SwiftUI-like library. I created [RxSwiftWidgets](https://github.com/hmlongco/RxSwiftWidgets) almost immediately after SwiftUI was announced, but was frustrated by several issues inherent in its implementation.

I started over with Builder to see if I could do better. (Spoiler alert: I could.)

### Views and View Builders

In Builder, screens are composed of views that are composed of views that are composed of views. Here's the card view "builder" code that generates the sample shown above.

```swift
struct DetailCardView: ViewBuilder {    

    @Injected var viewModel: DetailViewModel

    init(user: User) {
        viewModel.configure(user)
    }

    var body: View {
        StandardCardView {
            VStackView {
                LabeledPhotoView(photo: viewModel.photo(), name: viewModel.fullname)
                    .height(250)
                VStackView {
                    NameValueView(name: "Address", value: viewModel.street)
                    NameValueView(name: "", value: viewModel.cityStateZip)
                    SpacerView(8)
                    NameValueView(name: "Email", value: viewModel.email)
                    NameValueView(name: "Phone1", value: viewModel.phone)
                    SpacerView(8)
                    NameValueView(name: "Age", value: viewModel.age)
                }
                .spacing(0)
                .padding(20)
            }
        }
    }
}

```
Builder uses structs to define views just like SwiftUI, even down to the `var body: View` paradigm. But unlike SwiftUI, it uses those definitions to create an underlying one-for-one set of UIKit views that reflects our interface.

Any Builder view can be converted into its UIView or, in this case, its corresponding *set* of UIViews by simply calling `.build()`.

```swift
    let view: UIView = DetailCardView().build()
```
In many cases, however, some strategically placed UIView extensions do a lot of that behind-the-scenes scut-work for you, and you can just treat Builder views like any other UIView.
```swift
    anotherview.insertSubview(DetailCardView(), at: 0)
```
Finally, converting a view into a UIView is such a common operation that there's a callAsFunction shorcut. Just call a generated `View` as a function.
```swift
    let view = getHeaderViewForTable()
    tableView.tableHeaderView = view()
```


### Composition

Like SwiftUI and Flutter, Builder encourages composition. View's can represent entire screens, as shown above; or they can be used to render portions of a screen, as shown in the `LabeledPhotoView` we used in our earlier view. 

```swift
struct LabeledPhotoView: ViewBuilder {
    
    let photo: Observable<UIImage?>
    let name: String

    var body: View {
        ZStackView {
            ImageView(photo)
                .contentMode(.scaleAspectFill)
                .clipsToBounds(true)
            LabelView(name)
                .alignment(.right)
                .font(.title2)
                .color(.white)
                .padding(h: 20, v: 8)
                .backgroundColor(.black)
                .alpha(0.7)
                .position(.bottom)
        }
     }
}
```
Note that this view is small, well-defined, and self-contained. In fact, it would be pretty easy to use it elsewhere in the app if needed. It's a nice little well-composed component.

So, is there a downside to interface composition? Well, practically speaking... nope.

Builder views are highly performant and non-resource intensive. As with SwiftUI, view "definitions" are typically struct-based value types, and many of the modifiers are little more than key path-based assignments.

Generating the actual corresponding UIViews *is* more resource intensive, true, but those views need to be created anyway, regardless of whether or not you use Builder, construct them manually, or generate them from Storyboards. 

The upside? Well, unlike using Storyboards and NIBs and binding them to UIViewControllers and UIViews with dozens of IBOUtlets, this approach actively *encourages* breaking your interface down in small, individual, easily understood and easily testable interface elements.

### Stack-Based Layouts

As with SwiftUI, almost all of our view layouts are constructed by nesting views within vertical and horizontal stackviews. (Though sometimes we also use single containers and z-stacks to enhance our layouts.)

Here's another one of our card view's dependent subviews that shows we're using two label views in a horizontal stack view.

```swift
struct NameValueView: ViewBuilder {

    let name: String?
    let value: String?

    var body: View {
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
`HStackView` and `LabelView` are elemental Builder views that directly generate the corresponding `UIStackView` and `UILabelViews` for us. 

And again, as with SwiftUI, Builder is somewhat opinionated as to how those views should be presented. Quite a few view options are "baked in" such that we dont have to continually set the things we're going to need over and over and over again. (Like repeatingly setting `translatesAutoresizingMaskIntoConstraints` to false on each and every manually constructed view. Been there, done that.)

### Table Views

While stacks are Builder's primary "stock in trade", here's a basic table view layout.
```swift
struct MainUsersTableView: ViewBuilder {
    
    let users: [User]
    
    var body: View {
        TableView(DynamicItemViewBuilder(users) { user in
            TableViewCell {
                MainCardView(user: user)
            }
            .accessoryType(.disclosureIndicator)
            .onSelect { (context) in
                context.push(DetailViewController(user: user))
                return false
            }
        })
    }
    
}
```
That's it. Note we didn't need to manually create and configure a UITableViewController. No delegates. No datasources. But we still have a complete table view with navigation and custom table view cells, all in about 17 lines of code.

Although relatively small in size, Builder allows simple user interfaces to be constructed quickly and easily. 

I've used Builder in several projects to get the benefits of declarative programming in legacy UIKit-based applications that can't yet support SwiftUI and its minimum base SDK of iOS 13, iOS 14, or iOS 15.

---

## Using RxSwift for MVVM Data Binding

Using Builder to construct UIKit-based interfaces leads to another question: how do we update our interfaces?

Unlike SwiftUI which is constantly diffing and comparing views and rebuilding our interfaces accordingly, Builder tends to generate a standard, "static" set of UIViews. This means that we need some way to signal changes to our data and to update our user-interface accordingly.

This app uses RxSwift in many places to bind views and view models and view controllers together. We saw this in `DetailPhotoView` example where an observable was passed to the view and "bound" to an ImageView in it's initializer so that it would be updated when the image for that user was eventually loaded.

Same for LabelViews and its associated text. But we can do more.

### Minor State Changes

One thing we do a lot of in Builder is bind an observable to a view's `hidden` attribure and let the stackview show and hide the element accordingly.
```swift
    LabelView("Opps! An unexpected error occurred!")
        .hidden(bind: viewModel.showErrorMessage)
```
Builder has extensions for binding to hidden attributes, colors, and a few other common attachment points. If Builder doesn't already have a built-in binding for that property, just use a keypath.
```swift
    LabelView("Some text")
        .bind(keyPath: \.backgroundColor, binding: $color)
```

And if all else fails you can simply listen to an observable and handle state accordingly.

```swift
    LabelView(viewModel.terms)
        .onReceive(viewModel.$accepted) { context, value in
            context.view.accessibilityLabel = value ? "Terms accepted." : "Terms not yet accepted."
        }
```
Finally, you may have noticed that in the previous examples we're binding to a property or subscribing to an observable, but no `Disposable` is in evidence. 

That's because Builder is managing that for us behind the scenes. Builder will, if needed, create a `DisposeBag` for us and associate it with the view in question. When the view is eventually released any bindings associated with that view will be unsubscribed.

This happens automatically, so we don't have to worry about it. I might also mention that only views where a binding is actually specified in the code get an associated `DisposeBag`, so we don't have to worry about any negative performance aspects when dealing with the majority of views that don't have bound properties.

### Major State Changes

Another example from `MainStackViewController` demonstrates how we can subscribe to a Builder `@Variable` and update our interface when the variable state changes. This is similar to `@State` in SwiftUI. 

```swift
    viewModel.$state
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .initial:
                self.viewModel.load()
            case .loading:
                self.transtion(to: StandardLoadingPage())
            case .loaded(let users):
                self.transtion(to: MainUsersStackView(users: users))
            case .empty(let message):
                self.transtion(to: StandardEmptyPage(message: message))
            case .error(let error):
                self.transtion(to: StandardErrorPage(error: error))
            }
        })
        .disposed(by: disposeBag)
```
The code `self.transtion(to: ...)` basically replaces the current view tree with a new one. Since Builder doesn't "diff" the treeview, we're basically manually replicatiing in UIKit what SwiftUI would do for us whenever a major state change occurs.

The view model defines the enumerated state and is updated when load is called. 
```swift
class MainViewModel {
    
    @Injected var images: UserImageCache
    @Injected var service: UserServiceType

    enum State: Equatable {
        case initial
        case loading
        case loaded([User])
        case empty(String)
        case error(String)
     }
    
    @Variable private(set) var state = State.initial
    
    private var disposeBag = DisposeBag()
    
    func load() {
        state = .loading
        service.list()
            .map { $0.sorted(by: { ($0.name.last + $0.name.first) < ($1.name.last + $1.name.first) }) }
            .subscribe { [weak self] (users) in
                if users.isEmpty {
                    self?.state = .empty("No current users found...")
                } else {
                    self?.state = .loaded(users)
                }
            } onFailure: { [weak self] (e) in
                self?.state = .error(e.localizedDescription)
            }
            .disposed(by: disposeBag)
    }

}
```
Note the use of `private(set)` on our state variable. This ensures that our view model (and only our view model) can manipulate our state variable. 

*(This is better than exposing a RxSwift BehaviorRelay or PublishSubject over which we'd have no such control.)*

---

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

---

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
There are extensions for using this functionality with RxSwift (as shown), Combine, as well as with a standard Result-based callback mechanism. That said, using Combine would tie us once again to a recent version version of iOS and largely defeat the benefits of using Builder.

---

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

---


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

Currently it requires Xcode 12.5 as a minimum.
