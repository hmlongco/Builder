//
//  LoginErrorView.swift
//  Builder
//
//  Created by Michael Long on 11/11/21.
//

import UIKit
import Builder
import Factory
import RxSwift
import RxCocoa

struct LoginErrorView: ViewBuilder {

    @Variable var error: String?

    var body: View {
        ContainerView {
            LabelView($error)
                .alignment(.center)
                .font(.headline)
                .color(.white)
                .numberOfLines(0)
        }
        .backgroundColor(.red)
        .cornerRadius(2)
        .padding(8)
        .hidden(true)
        .onReceive($error.asObservable().skip(1), handler: { context in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                UIView.animate(withDuration: 0.2) {
                    context.view.isHidden = context.value == nil
                }
            }
        })
    }
    
}
