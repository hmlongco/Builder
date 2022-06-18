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
