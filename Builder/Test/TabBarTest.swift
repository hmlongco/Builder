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
                    let host = ViewControllerHostView(vc)
                    // testing transition code
                    context.transition(to: host)
                }
            CustomTabBarView(selectedTab: $selectedTab, tabs: tabs)
        }
    }

}

class EventTestViewController: UIViewController {

    let id = UUID()

    deinit {
        print("TEST - deinit - \(id)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Event Test"
        print("TEST - viewDidLoad - \(id)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TEST - viewWillAppear - \(id)")

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("TEST - viewDidAppear - \(id)")

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("TEST - viewWillDisappear - \(id)")

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("TEST - viewDidDisappear - \(id)")

    }

}

private struct CustomTestView: ViewBuilder {
    let tab: Int
    var body: View {
        VerticalScrollView {
            VStackView {
                ForEach(30) { row in
                    LabelView("Tab \(tab+1) is selected.")
                        .onTapGesture { context in
                            context.push(CustomDetailsView(title: "Details for tab \(tab+1), row \(row+1)"))
                        }
                }
                SpacerView()
            }
            .padding(20)
        }
    }
}

private struct CustomDetailsView: ViewBuilder {
    let title: String
    var body: View {
        VStackView {
            LabelView(title)
        }
        .alignment(.center)
        .onAppearOnce { context in
            context.viewController?.navigationItem.title = "Details"
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
                            .color(bind: tabTextColor(index))
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
                        .height(7)
                        .roundedCorners(radius: 4, corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])
                        .bind(keyPath: \.backgroundColor, binding: tabIndicatorColor(index))
                }
            }
            .padding(top: 0, left: 4, bottom: 0, right: 4)
            .distribution(.fillEqually)
            .position(.bottom)
        }
        .position(.top)
        .height(43, priority: .required)
    }

    func tabIndicatorColor(_ index: Int) -> Observable<UIColor?> {
        $selectedTab
            .asObservable()
            .map { $0 == index ? .red : .clear }
    }

    func tabTextColor(_ index: Int) -> Observable<UIColor?> {
        $selectedTab
            .asObservable()
            .map { $0 == index ? .white : .lightGray }
    }

}
