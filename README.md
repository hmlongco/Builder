# Builder: A Declarative UIKit Library

## Overview

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

### Views and View Builders

In Builder, screens are composed of views that are composed of views that are composed of views. Here's the card view "builder" code that generates the sample shown above.

```swift
struct DetailCardView: ViewBuilder {    

    @Injected(Container.detailViewModel) var viewModel

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

Any Builder `View` can be converted into its UIView or, in this case, its corresponding *set* of UIViews by simply calling `.build()`.

```swift
    let view: UIView = DetailCardView().build()
```
In many cases, however, some strategically placed UIView extensions do a lot of that behind-the-scenes scut-work for you, and you can just treat Builder views like any other UIView.
```swift
    anotherview.insertSubview(DetailCardView(), at: 0)
```

### Composition

Like SwiftUI, Builder *encourages* composition, an area where many other solutions fall short. 

View's can represent entire screens, as shown above; or they can be used to render portions of a screen, as shown in the `LabeledPhotoView` we used in our earlier view. 

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
Note that this view is small, well-defined, and self-contained. In fact, it would be pretty easy to use it elsewhere in the app if needed. It's a nice well-composed little component.

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

Note that, as with SwiftUI, Builder is somewhat opinionated as to how those views should be presented. Quite a few view options are "baked in" such that we dont have to continually set the things we're going to need over and over and over again. (Like repeatingly setting `translatesAutoresizingMaskIntoConstraints` to false on each and every manually constructed view. Been there, done that.)

Also note that using stacks eliminates a lot of the tedious constraint code usually required when manually creating views and wiring them together for AutoLayout. 

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

So we can use Builder to construct a UIKit-based interface. Great!

But that leads us to another question: Just how do we update our interfaces?

Unlike SwiftUI which is constantly diffing and comparing views and rebuilding our interfaces accordingly, In most cases Builder generates a standard, "static" set of UIViews. This means that we need some way to signal changes to our data and to update our user-interface accordingly.

Builder uses RxSwift in many places to bind views and view models and view controllers together. We saw this in `DetailPhotoView` example where an observable was passed to the view and "bound" to an ImageView in it's initializer so that it would be updated when the image for that user was eventually loaded.

Same for LabelViews and its associated text. But we can do more.

A lot more.

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

Another example from `MainStackViewController` demonstrates how we can subscribe to a Builder `@Variable` and update our interface when the variable state changes. This is similar to the `@State` driven behavior we see in SwiftUI. 

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
The code `self.transtion(to: ...)` basically replaces the current view tree on the view controller with a new one. Since Builder doesn't "diff" the treeview, we're basically manually replicatiing in UIKit what SwiftUI would do for us whenever a major state change occurs.

The view model defines the enumerated state and is updated when load is called. 

```swift
class MainViewModel {
    
    @Injected(Container.userImageCache) var images
    @Injected(Container.userServiceType) var service

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
Note the use of `private(set)` on the state variable. This ensures that our view model (and only our view model) can manipulate our state variable. 

*(This is better than exposing a RxSwift BehaviorRelay or PublishSubject over which we'd have no such control.)*

### Variable

The nature of the build mechanism means that we can't do a "pure" RxSwift-style view-triggers-action-triggers-result-triggers-view data flow in our application. Any Observable pased into a view tree must exist *before* the tree is built.

Because of this we're forced to adopt pretty much the same approach used in SwiftUI: Define some variable that we can observe. In SwiftUI we use the `@State` property wrapper but in Builder ours is named `@Variable`.

We use `@Variable` any time we want one of our views to change state whenever the bound value is changed. Bindings in Builder can actually observe any Rx Observable, but Variable is easier to work with in many cases.

Like SwiftUI, we use a dollar-sign whenever we want access to the RxSwift-backed observable. This lets us subscribe to it, as shown above in the Major State Change code, or pass it to one of the binding modifiers as we've also shown.

```swift
LabelView("Some text")
    .bind(keyPath: \.backgroundColor, binding: $color)
```
Unlike SwiftUI, Variables can be created and used anywhere, in a view, in a view model, or even in a view controller.

You can also subscribe to changes yourself, should you desire.
```swift
@Variable var title: String = "Builder Test View"

$title
    .onChange { value in
        print(value)
    }
    .disposed(by: disposeBag)
```

---

## Using Factory for MVVM

The application also demonstrates using the [Factory](https://github.com/hmlongco/Factory) dependency injection system to construct MVVM architectures.

```swift
class MainViewModel {
    
    @Injected(Container.userImageCache) var images
    @Injected(Container.userServiceType) var service

    ...
}
```
Above we're using Factory's @Injected property wrapper to find and instantiate the dependencies needed for our main view model.

Injections tie together the master view, detail view, the view models, and the API and data caching layers of the application.

Note that this project formerly used [Resolver](https://github.com/hmlongco/Resolver.git).

___

## Why Builder?

With SwiftUI and Combine available, why use Builder and RxSwift? Well, I guess the answer to that question actually depends on your definition of *available*.

**The problem is that SwiftUI and Combine both require iOS 13 at a minimum.** No support for iOS 12 or iOS 11. 

And if I were using SwiftUI in a production app I'd probably consider **iOS 14** to be the minimum version suitable for application development. And even then there are some critical components that require iOS 15!

Note to mention the minor fact that SwiftUI is still in flux. With the beta relase of iOS 16 Apple has shown that even fundamental SwiftUI constructs like `NavigationView` can and will be deprecated. Are you ready to make iOS 16 your minimum required version of iOS?

Same for using Combine. Builder could be accomplished using Combine... but that too would have tied me to iOS 13/14 as the minimum version... which is what I was trying to avoid in the first place.

Hence the problem. There aren't too many developers who can drop support for earlier versions of iOS in their applications and go iOS 14 or 15 or 16 only. Which in turn means that most of us wouldn't see any of the benefits of doing declarative, reactive programming for another couple of **years**. 

That's simply too long.

#### CwlViews

There are a few other declarative frameworks out there, the most notable of which is Matt Gallagher's [CwlViews](https://www.cocoawithlove.com/blog/introducing-cwlviews.html).

While CwlViews has some cool and interesting features, it's biggest drawback lies in its implementation of its own reactive framework. I firmly believe in RxSwift and perhaps more to the point, RxSwift has a large and loyal developer base plus tons of available resources, books, and articles devoted to it.

I wanted declarative development *and* I wanted my RxSwift. What can I say? I'm greedy.

#### Flutter, React Native, et. al.

There are other "cross-platform" frameworks out there, but I'm an iOS Swift developer at heart and doing iOS development in Dart or JavaScript simply doesn't interest me.

#### RxSwiftWidgets

Builder wasn't my first attempt at a SwiftUI-like library. I created [RxSwiftWidgets](https://github.com/hmlongco/RxSwiftWidgets) almost immediately after SwiftUI was announced, but was frustrated by several issues inherent in my initial implementation.

I started over with Builder to see if I could do better. I could.

---

## Demo Project

The project includes a `BuilderDemo` app that includes a lot of the actual code I used to test Builder while it was under developmemt.

This includes the main "Menu" screen, a User list that displays user detail cards like the one shown above, a data-entry form, and more.

Just open and run `BuilderDemo.xcodeproj` located in the BuilderDemo folder.

---

## Installation

Builder is now available as a Swift package. Just install it in the usual fashion.

Note that RxSwift 6.5 is a minimum required dependency.

Currently Builder requires Xcode 13.4 as a minimum.

---

## License and Usage

Builder is available under the MIT license. See the LICENSE file for more info.

Just remember tha that Builder is first and foremost an example and exploration of how to accomplish SwiftUI-like declarative interfaces in UIKit. Note that Builder is provided *as is* and that ongoing support and documentation for this project may be limited.

I firmly believe SwiftUI *is the future* for development on iOS, iPadOS macOS, tvOS, and watchOS.

Builder just lets me do some of those things *today*.

---

## Author

Builder is designed, implemented, documented, and maintained by [Michael Long](https://www.linkedin.com/in/hmlong/), a Lead iOS Software Engineer and a Top 1,000 Technology Writer on Medium.

* LinkedIn: [@hmlong](https://www.linkedin.com/in/hmlong/)
* Medium: [@michaellong](https://medium.com/@michaellong)
* Twitter: @hmlco

## Additional Resources

* [Factory: A Modern Swift Dependency Injection System](https://github.com/hmlongco/Factory)
* [RxSwift: A ReactiveX implementation for Swift](https://github.com/ReactiveX/RxSwift)
