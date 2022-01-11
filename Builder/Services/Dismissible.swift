//
//  Dismissible.swift
//  Builder
//
//  Created by Michael Long on 2/5/21.
//

import UIKit
import RxSwift


class Dismissible<ResultType> {

    // lifecycle

    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    // setup functions

    enum Action {
    case none
    case automatic
    case pop
    case to(UIViewController)
    case root
    case dismiss
    }

    @discardableResult
    func action(_ action: Action) -> Self {
        self.action = action
        return self
    }

    @discardableResult
    func onReturn(handler: @escaping (_ r: ResultType) -> Void) -> Self {
        self.dismissReturnHandler = handler
        return self
    }

    @discardableResult
    func onDismiss(handler: @escaping () -> Void) -> Self {
        self.dismissHandler = handler
        return self
    }

    // return functions

    func dismiss(returning value: ResultType) {
        dismissReturnHandler?(value)
        doAction()
    }

    func dismiss() {
        dismissHandler?()
        doAction()
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func doAction() {
        guard let vc = viewController else { return }
        switch action {
        case .none:
            break
        case .automatic:
            if let nc = vc.navigationController, let index = nc.viewControllers.firstIndex(of: vc), index > 0 {
                nc.popToViewController(nc.viewControllers[index-1], animated: true)
            } else {
                vc.dismiss(animated: true)
            }
        case .pop:
            guard let nc = vc.navigationController else { return }
            nc.popViewController(animated: true)
        case .to(let vc):
            guard let nc = vc.navigationController else { return }
            nc.popToViewController(vc, animated: true)
        case .root:
            guard let nc = vc.navigationController else { return }
            nc.popToRootViewController(animated: true)
        case .dismiss:
            vc.dismiss(animated: true, completion: nil)
        }
    }

    private weak var viewController: UIViewController?

    private var action: Action = .automatic
    private var dismissReturnHandler: ((_ r: ResultType) -> Void)?
    private var dismissHandler: (() -> Void)?

}

//struct Account {
//    let id = UUID().uuidString
//}
//
//class MasterViewController: UIViewController {
//
//    func accountDetails(_ account: Account) {
//        let sb = UIStoryboard(name: "main", bundle: .main)
//        let nc = sb.instantiateViewController(identifier: "details")
//        if let nc = nc as? UINavigationController,
//           let vc = nc.topViewController as? DetailsVC {
//            vc.account = account
//            vc.callback = {
//                self.update(account: $0)
//            }
//        }
//        navigationController?.present(nc, animated: true)
//    }
//
//    func accountDetailsSBI(_ account: Account) {
//        let vc = UIStoryboard.instantiate("details", storyboard: "main") { (vc: DetailsVC) in
//            vc.account = account
//            vc.callback = {
//                self.update(account: $0)
//            }
//        }
//        navigationController?.present(vc, animated: true)
//    }
//
//    func accountDetailsNEW(_ account: Account) {
//        present("details", storyboard: "main") { (vc: DetailsVC) in
//            vc.account = account
//            vc.callback = {
//                self.update(account: $0)
//            }
//         }
//    }
//
//
//
//    //
//
//    func accountDetailsWTH(_ account: Account) {
//        let vc = with(DetailsVC()) {
//            $0.account = account
//            $0.callback = {
//                self.update(account: $0)
//            }
//        }
//        navigationController?.present(vc, animated: true)
//    }
//
//    func accountDetailsPRE(_ account: Account) {
//        present(DetailsVC()) {
//            $0.account = account
//            $0.callback = {
//                self.update(account: $0)
//            }
//        }
//    }
//
//    func update(account: Account) {
//
//    }
//
//}
//
//extension MasterViewController {
//
//    func editAccountNicknameDismissible(_ account: Account) {
//        present("edit", storyboard: "main") { (vc: DetailsVC2) in
//            vc.account = account
//            vc.dismissible
//                .onReturn { (account) in
//                    print(account)
//                }
//                .onDismiss {
//                    print("cancelled")
//                }
//        }
//    }
//
//}
//
//class DetailsVC: UIViewController {
//
//    var account: Account!
//    var callback: ((_ account: Account) -> Void)!
//
//    @IBAction func onSubmit(_ sender: Any) {
//        callback(account)
//        dismiss(animated: true)
//    }
//
//    @IBAction func onCancel(_ sender: Any) {
//        dismiss(animated: true)
//    }
//
//}
//
//class DetailsVC2: UIViewController {
//
//    var account: Account!
//
//    lazy var dismissible = Dismissible<Account>(self)
//
//    @IBAction func onSubmit(_ sender: Any) {
//        dismissible.dismiss(returning: account)
//    }
//
//    @IBAction func onCancel(_ sender: Any) {
//        dismissible.dismiss()
//    }
//
//}
