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
    case pop
    case to(UIViewController)
    case root
    case dismiss
    }

    func onDismiss(_ action: Action, onReturn: ((_ r: ResultType) -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        self.dismissReturnHandler = onReturn
        self.dismissHandler = onDismiss
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

    private func doAction() {
        guard let vc = viewController, let nc = vc.navigationController else { return }
        switch action {
        case .none:
            break
        case .pop:
            nc.popViewController(animated: true)
        case .to(let vc):
            nc.popToViewController(vc, animated: true)
        case .root:
            nc.popToRootViewController(animated: true)
        case .dismiss:
            vc.dismiss(animated: true, completion: nil)
        }
    }

    private weak var viewController: UIViewController?

    private var action: Action = .none
    private var dismissReturnHandler: ((_ r: ResultType) -> Void)?
    private var dismissHandler: (() -> Void)?

}

class MasterViewController: UIViewController {

    func pushChildViewController() {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        if let vc = sb.instantiateViewController(identifier: "child") as? ChildViewController {
            vc.dismissible.onDismiss(.pop) { (result) in
                print(result)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func presentChildViewController() {
        let vc = ChildViewController()
        vc.dismissible.onDismiss(.dismiss) { (result) in
            print(result)
        }
        navigationController?.present(vc, animated: true)
    }

}

class ChildViewController: UIViewController {

    lazy var dismissible = Dismissible<String>(self)

    @IBAction func onSubmit(_ sender: Any) {
        dismissible.dismiss(returning: "This is a test")
    }

    @IBAction func onCancel(_ sender: Any) {
        dismissible.dismiss()
    }

}
