//
//  FABMenuView.swift
//  Builder
//
//  Created by Michael Long on 12/15/21.
//

import UIKit
import RxSwift

struct FABMenuView: ViewBuilder {

    let menuItems: [String]
    var content: () -> ViewConvertable

    @Variable var showFABMenu = false

    init(menuItems: [String], @ViewResultBuilder _ builder: @escaping () -> ViewConvertable) {
        self.menuItems = menuItems
        self.content = builder
    }

    var body: View {
        ZStackView {
            content()

            ContainerView {
                ImageView(systemName: "plus")
                    .tintColor(.white)
                    .contentMode(.center)
                    .frame(height: 50, width: 50)
                    .cornerRadius(25)
                    .backgroundColor(.red)
                    .position(.topCenter)
                    .onTapGesture { context in
                        showFABMenu.toggle()
                    }
            }
            .position(.bottomCenter)
            .frame(height: 80, width: 50)

            // disabled area
            ContainerView {
                VStackView {
                    SpacerView()

                    // close area
                    ZStackView {
                        ContainerView()
                            .backgroundColor(.black)
                            .position(.bottom)
                            .height(25)

                        ImageView(systemName: "xmark")
                            .tintColor(.white)
                            .contentMode(.center)
                            .frame(height: 50, width: 50)
                            .cornerRadius(25)
                            .backgroundColor(.red)
                            .position(.bottomCenter)
                            .onTapGesture { context in
                                showFABMenu.toggle()
                            }
                    }

                    // menu area
                    ContainerView {
                        VStackView {
                            ForEach(menuItems) { item  in
                                LabelView(item)
                                    .color(.white)
                                    .height(44)
                                    .onTapGesture { context in
                                        showFABMenu.toggle()
                                        print("TAPPED \(item)")
                                    }
                            }
                        }
                        .alignment(.center)
                        .padding(20)
                        .spacing(0)
                    }
                    .backgroundColor(.black)
                    .position(.bottom)
                }
                .spacing(0)
            }
            .backgroundColor(UIColor(white: 0.5, alpha: 0.3))
            .width(UIScreen.main.bounds.width)
            .hidden(bind: $showFABMenu.asObservable().map { !$0 })
            .onTapGesture { context in
                showFABMenu.toggle()
            }
        }
    }
}
