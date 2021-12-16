//
//  TabBarTest.swift
//  Builder
//
//  Created by Michael Long on 12/15/21.
//

import UIKit
import RxSwift

class CustomTabBarViewController: UIViewController {

    @Variable var selectedTab: Int = 0

    var tabs = [
        "Tab 1",
        "Tab 2",
        "Tab 3"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tab Bar Test"
        view.backgroundColor = .secondarySystemBackground
        view.embed(content())
    }

    func content() -> View {
        ZStackView {
            ContainerView()
                .insets(top: 40, left: 0, bottom: 0, right: 0)
                .onReceive($selectedTab) { context in
                    // testing to see if events are firing correctly when view is added and removed
                    let vc = EventTestViewController(CustomTestView(tab: context.value))
                    // testing host view
                    let host = ViewControllerHostView(viewController: vc)
                    context.transition(to: host)
                }
            CustomTabBarView(selectedTab: $selectedTab, tabs: tabs)
        }
    }

}

class EventTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Event Test"
        print("TEST - viewDidLoad")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TEST - viewWillAppear")

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("TEST - viewDidAppear")

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("TEST - viewWillDisappear")

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("TEST - viewDidDisappear")

    }

}

private struct CustomTestView: ViewBuilder {
    let tab: Int
    var body: View {
        VerticalScrollView {
            VStackView {
                ForEach(30) { _ in
                    LabelView("Tab \(tab+1) is selected.")
                }
                SpacerView()
            }
            .padding(20)
        }
    }
}

struct CustomTabBarView: ViewBuilder {

    @Variable var selectedTab: Int
    let tabs: [String]

    var body: View {
        ZStackView {
            ContainerView {
                HStackView {
                    ForEach(tabs.count) { index in
                        LabelView(tabs[index])
                            .alignment(.center)
                            .color(.white)
                            .contentHuggingPriority(.defaultLow, for: .horizontal)
                            .contentHuggingPriority(.defaultLow, for: .vertical)
                            .onTapGesture { context in
                                selectedTab = index
                            }
                    }
                }
                .distribution(.fillEqually)
            }
            .backgroundColor(.black)
            .position(.top)
            .height(40)

            HStackView {
                ForEach(tabs.count) { index in
                    ContainerView()
                        .height(4)
                        .roundedCorners(radius: 4, corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])
                        .bind(keyPath: \.backgroundColor, binding: $selectedTab.asObservable().map { $0 == index ? .red : .clear })
                }
            }
            .padding(top: 0, left: 4, bottom: 0, right: 4)
            .distribution(.fillEqually)
            .position(.bottom)
        }
        .position(.top)
        .height(42)
    }

}
