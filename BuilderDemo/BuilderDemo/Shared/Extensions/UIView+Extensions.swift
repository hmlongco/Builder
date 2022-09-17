//
//  UIView+Extensions.swift
//  Builder
//
//  Created by Michael Long on 12/7/21.
//

import UIKit

extension UIView {
    
    public func addUnderline(lineThickness: CGFloat, lineColor: UIColor, dashed: Bool = false) -> CALayer {

        let width = frame.size.width
        let height = frame.size.height

        // Create a line at the bottom of the view
        let lineShape = CAShapeLayer()
        lineShape.strokeStart = 0.0
        lineShape.strokeColor = lineColor.cgColor
        lineShape.fillColor = UIColor.clear.cgColor
        lineShape.lineWidth = lineThickness

        // We might draw the line with a dashed style
        if dashed {
            let dashThickness = lineThickness as NSNumber
            let emptyThickness = lineThickness * 4 as NSNumber
            lineShape.lineDashPattern = [dashThickness, emptyThickness]
        }

        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height - (lineThickness / 2)))
        path.addLine(to: CGPoint(x: width, y: height - (lineThickness / 2)))
        lineShape.path = path

        // Modify this view with a clear background
        backgroundColor = UIColor.clear

        // Attach the line at the bottom of the ivew
        layer.addSublayer(lineShape)

        return lineShape
    }

}


extension UIView {

    func addHighlightOverlay(animated: Bool = true, removeAfter delay: TimeInterval? = nil) {
        let overlay = UIView(frame: self.bounds)
        overlay.backgroundColor = .label
        overlay.alpha = animated ? 0.0 : 0.15
        overlay.tag = 999
        addSubview(overlay)
        if animated {
            UIView.animate(withDuration: 0.1) {
                overlay.alpha = 0.15
            }
        }
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if animated {
                    UIView.animate(withDuration: 0.1) {
                        overlay.alpha = 0.15
                    } completion: { _ in
                        overlay.removeFromSuperview()
                    }
                } else {
                    overlay.removeFromSuperview()
                }
            }
        }
    }

    func removeHighlightOverlay(animated: Bool = true) {
        if let overlay = find(subview: 999) {
            overlay.removeFromSuperview()
        }
    }

}
