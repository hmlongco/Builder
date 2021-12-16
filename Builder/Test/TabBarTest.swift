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
                    let vc = UIViewController(CustomTestView(tab: context.value))
                    context.transition(to: vc)
//                    let view = CustomTestView(tab: context.value)
//                    context.transition(to: view, delay: 0)
                }
            CustomTabBarView(selectedTab: $selectedTab, tabs: tabs)
        }
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
