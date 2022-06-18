//
//  TabBarTest.swift
//  Builder
//
//  Created by Michael Long on 12/15/21.
//

import UIKit
import Builder
import RxSwift

class ScrollingTabBarViewController: UIViewController {

    @Variable var selectedTab: Int = 0

    var tabs = [
        "Accounts",
        "Transactions",
        "Balances",
        "Loans",
        "Credit Cards",
        "IRAs/401Ks",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scrolling Tab Bar"
        view.backgroundColor = .secondarySystemBackground
        view.embed(content())
    }

    func content() -> View {
        ZStackView {
            ContainerView()
                .margins(top: 40, left: 0, bottom: 0, right: 0)
                .onReceive($selectedTab) { context in
                    context.transition(to: CustomTestView(tab: context.value))
                }
            ScrollingTabBarView(selectedTab: $selectedTab, tabs: tabs)
                .position(.top)
        }
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

struct ScrollingTabBarView: ViewBuilder {

    @Variable var selectedTab: Int
    let tabs: [String]

    let HEIGHT: CGFloat = 44
    let INDICATOR_HEIGHT: CGFloat = 10

    var body: View {
        ZStackView {
            ContainerView()
                .backgroundColor(.black)
                .contentHuggingPriority(.defaultLow, for: .horizontal)
                .position(.top)
                .height(HEIGHT)

            ScrollView {
                HStackView {
                    ForEach(tabs.count) { index in
                        ZStackView {
                            ButtonView(tabs[index])
                                .identifier("TAB-\(tabs[index])")
                                .color(.white)
                                .backgroundColor(.black)
                                .contentHuggingPriority(.defaultLow, for: .horizontal)
                                .contentHuggingPriority(.defaultLow, for: .vertical)
                                .selected(bind: $selectedTab.asObservable().map { $0 == index })
                                .padding(h: 10, v: 0)
                                .position(.top)
                                .height(HEIGHT)
                                .onTapGesture { context in
                                    context.view.scrollIntoView()
                                    selectedTab = index
                                }

                            ContainerView()
                                .roundedCorners(radius: INDICATOR_HEIGHT / 2, corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])
                                .bind(keyPath: \.backgroundColor, binding: tabIndicatorColor(index))
                                .height(INDICATOR_HEIGHT)
                                .margins(top: 0, left: 4, bottom: 0, right: 4)
                                .position(.bottom)
                        }

                        .contentCompressionResistancePriority(.required, for: .horizontal)
                        .height(HEIGHT + (INDICATOR_HEIGHT / 2))
                    }
                    SpacerView(width: 0)
                }
                .spacing(0)
            }
            .with {
                $0.showsVerticalScrollIndicator = false
                $0.showsHorizontalScrollIndicator = false
                $0.bounces = false
            }
        }
        .height(HEIGHT + (INDICATOR_HEIGHT / 2))
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
