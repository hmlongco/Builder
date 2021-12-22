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
                .position(.top)
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

    let HEIGHT: CGFloat = 44
    let INDICATOR_HEIGHT: CGFloat = 12

    var body: View {
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
                        .position(.top)
                        .height(HEIGHT)
                        .onTapGesture { context in
                            selectedTab = index
                        }

                    ContainerView()
                        .roundedCorners(radius: INDICATOR_HEIGHT / 2, corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])
                        .bind(keyPath: \.backgroundColor, binding: tabIndicatorColor(index))
                        .height(INDICATOR_HEIGHT)
                        .insets(top: 0, left: 4, bottom: 0, right: 4)
                        .position(.bottom)
                }
            }
        }
        .distribution(.fillEqually)
        .spacing(0)
        .height(HEIGHT + (INDICATOR_HEIGHT / 2))
    }

    func tabIndicatorColor(_ index: Int) -> Observable<UIColor?> {
        $selectedTab
            .asObservable()
            .map { $0 == index ? .red : .clear }
    }

}

struct AnnimatingTabBarView: ViewBuilder {

    @Variable var selectedTab: Int
    let tabs: [String]

    let HEIGHT: CGFloat = 44
    let INDICATOR_HEIGHT: CGFloat = 12

    var body: View {
        ZStackView {
            HStackView {
                ForEach(tabs.count) { index in
                    ContainerView {
                        LabelView(tabs[index])
                            .alignment(.center)
                            .color(.white)
                            .contentHuggingPriority(.defaultLow, for: .horizontal)
                            .contentHuggingPriority(.defaultLow, for: .vertical)
                            .padding(h: 10, v: 0)
                            .onTapGesture { context in
                                selectedTab = index
                                guard let container = context.find("tabContainer"), let underline = context.find("tabIdentifier") else { return }
                                let rect = context.view.convert(context.view.frame, to: container)
                                let left = underline.superview?.constraints
                                    .first(where: { ($0.firstItem as? UIView) === underline && $0.identifier == "left" })
                                underline.constraints.first(where: { $0.identifier == "width" })?.constant = rect.size.width - 8
                                UIView.animate(withDuration: 0.2) {
                                    left?.constant = rect.origin.x + 4
                                    underline.superview?.layoutIfNeeded()
                                }

                            }
                    }
                    .backgroundColor(.black)
                }
            }
            .identifier("tabContainer")
            .distribution(.fillEqually)
            .spacing(0)
            .position(.top)
            .height(HEIGHT)

            ContainerView()
                .identifier("tabIdentifier")
                .roundedCorners(radius: INDICATOR_HEIGHT / 2, corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])
                .backgroundColor(.red)
                .height(INDICATOR_HEIGHT)
                .insets(top: 0, left: 4, bottom: 0, right: 4)
                .position(.bottomLeft)
                .width(100)
        }
        .height(HEIGHT + (INDICATOR_HEIGHT / 2))
    }

    func tabIndicatorColor(_ index: Int) -> Observable<UIColor?> {
        $selectedTab
            .asObservable()
            .map { $0 == index ? .red : .clear }
    }

}
