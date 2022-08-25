//
//  LoginStatusView.swift
//  Builder
//
//  Created by Michael Long on 11/11/21.
//

import UIKit
import Builder
import Factory
import RxSwift
import RxCocoa

struct LoginStatusView: ViewBuilder {

    @Variable var status: String? = nil

    var body: View {
        LabelView($status)
            .alignment(.center)
            .font(.body)
            .color(.white)
            .numberOfLines(0)
            .hidden(true)
            .onReceive($status.asObservable().skip(1), handler: { context in
                UIView.animate(withDuration: 0.2) {
                    context.view.isHidden = context.value == nil
                }
            })
            .onAppear { _ in
                self.load()
            }
    }

    func load() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.status = "This is a system status message that should be shown to the user."
        }
    }

}
