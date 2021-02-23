# Builder

### Overview

Builder is a simple iOS Master/Detail app written in Swift that demonstrates...

1. Using Builder patterns for constructing the user interface construction.
2. Using builder patterns to construct network requests.
3. Using the [Resolver](https://github.com/hmlongco/Resolver.git) dependency injection system to construct MVVM architectures.
4. Using RxSwift for MVVM data binding.
5. Using Resolver to mock user data for application development.
6. Using Resolver to mock user data for unit tests.

### Builder User Interface Library

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
While small, it allows simple user interfaces to be constructed quickly and easily. I've used this in several projects to get the benefits of declarative programming in legacy UIKit-based applications that can't yet support SwiftUI and its minimum base SDK of iOS 13.

### Builder Networking Library

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

### Using Resolver for MVVM

The application also demonstrates using the [Resolver](https://github.com/hmlongco/Resolver.git) dependency injection system to construct MVVM architectures.

```swift
class MainViewModel {
    
    @Injected var service: UserServiceType
    @Injected var cache: UserImageCache

    ...
}
```
Above we're using Resolver's @Injected property wrapper to find and instantiate the dependencies needed for our main view model.

### Using RxSwift for MVVM Data Binding

Using Builder to construct UIKit-based interfaces leads to another question: how do we update our interfaces?

This app uses RxSwift in many places to bind Views and ViewModels and ViewControllers together.
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

### Using Resolver to mock user data for application development

The demo app has a MOCK scheme that, when built, allows the app to run in a mock data mode.
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
When an instance of `UserServiceType` is needed, Resolver will grab the mock version from the mock container.

### Using Resolver to mock user data for unit tests

When writing unit tests you often want to supply different data to test different scenarios, like what happens when we have data...
```swift
func testLoadedState() throws {
    Resolver.mock.register { MockUserService() as UserServiceType }
    
    let vm = MainViewModel()

    let expectation = XCTestExpectation(description: "Test loaded state")
    
    _ = vm.state
        .subscribe(onNext: { (state) in
            if case .loaded(let users) = state {
                XCTAssert(users.count == 2)
                XCTAssert(users[0].fullname == "Jonny Quest")
                XCTAssert(users[1].fullname == "Tom Swift")
                expectation.fulfill()
            }
        })
    vm.load()
    
    wait(for: [expectation], timeout: 5.0)
}
```
Verses what happens when we do not?
```swift
func testEmptyState() throws {
    Resolver.mock.register { MockEmptyUserService() as UserServiceType }
    
    let vm = MainViewModel()
    vm.load()

    test("Test empty state", observable: vm.state) { (state) -> Bool in
        if case .empty(let message) = state {
            return message == "No current users found..."
        }
        return false
    }
}
```
Or if we have an error.
```swift
func testErrorState() throws {
    Resolver.mock.register { MockErrorUserService() as UserServiceType }
    
    let vm = MainViewModel()
    vm.load()

    test("Test error state", observable: vm.state) { (state) -> Bool in
        if case .error(let message) = state {
            return message.contains("Builder.APIError")
        }
        return false
    }
}
```
By changing the type provided for `UserServiceType` prior to constructing the view model we can test all of the above scenarios... and more.

### Installation

Just download the project and run it.

Currently it requires Xcode 12.4.
