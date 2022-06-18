//
//  UIViewController+Extensions.swift
//  UIViewController+Extensions
//
//  Created by Michael Long on 8/10/21.
//

import UIKit

//extension UIStoryboard {
//    static func instantiate<VC:UIViewController>(_ identifier: String, storyboard: String, configure: (_ vc: VC) -> Void) -> UIViewController {
//        let sb = UIStoryboard(name: storyboard, bundle: .main)
//        let vc = sb.instantiateViewController(identifier: identifier)
//        if let vc = vc as? VC {
//            configure(vc)
//        } else if let nc = vc as? UINavigationController, let vc = nc.topViewController as? VC {
//            configure(vc)
//        }
//        return vc
//    }
//}
//
//extension UIViewController {
//    
//    func push<VC:UIViewController>(_ identifier: String, storyboard: String, configure: (_ vc: VC) -> Void) {
//        let vc = UIStoryboard.instantiate(identifier, storyboard: storyboard, configure: configure)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func present<VC:UIViewController>(_ identifier: String, storyboard: String, style: UIModalPresentationStyle = .pageSheet, configure: (_ vc: VC) -> Void) {
//        let vc = UIStoryboard.instantiate(identifier, storyboard: storyboard, configure: configure)
//        vc.modalPresentationStyle = style
//        navigationController?.present(vc, animated: true)
//    }
//    
//}
//
//extension UIViewController {
//    
//    func push<VC:UIViewController>(_ vc: VC, configure: ((_ vc: VC) -> Void)? = nil) {
//        configure?(vc)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func present<VC:UIViewController>(_ vc: VC, style: UIModalPresentationStyle = .pageSheet, configure: ((_ vc: VC) -> Void)? = nil) {
//        configure?(vc)
//        vc.modalPresentationStyle = style
//        navigationController?.present(vc, animated: true)
//    }
//
//    func present<VC:UIViewController>(wrapped vc: VC, style: UIModalPresentationStyle = .pageSheet, configure: ((_ vc: VC) -> Void)? = nil) {
//        let nc = UINavigationController(rootViewController: vc)
//        configure?(vc)
//        vc.modalPresentationStyle = style
//        navigationController?.present(nc, animated: true)
//    }
//
//}
