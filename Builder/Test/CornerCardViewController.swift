//
//  ViewController.swift
//  BuilderTest
//
//  Created by Michael Long on 11/7/21.
//

import UIKit
import RxSwift
import Resolver

class CornerCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.embed(content())

    }
        
    func content() -> View {
        VerticalScrollView {
            VStackView {
                ZStackView {
                    CustomCornerBackgroundView()
                    VStackView {
                        LabelView("Test card view...")
                            .alpha(0.9)
                        SpacerView()
                    }
                    .padding(20)
                }
                    .height(200)
            }
            .spacing(16)
            .padding(30)
        }
        .backgroundColor(.systemBackground)
    }

}

class CustomCornerBackgroundView: UIView, CustomCornerPathProvider {

    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }

    func common() {
        let shadow = CustomCornerShadowView(frame: self.bounds)
        shadow.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(shadow)
        let content = CustomCornerContentView(frame: self.bounds)
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(content)
    }

}

private class CustomCornerContentView: UIView, CustomCornerPathProvider {

    var lastRect = CGRect.zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }

    func common() {
        backgroundColor = .secondarySystemBackground
    }

    override func draw(_ rect: CGRect) {
        if rect != lastRect {
            let path = path(for: rect)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
            backgroundColor?.set()
            path.fill()
            lastRect = rect
        }
        super.draw(rect)
    }

}

private class CustomCornerShadowView: UIView, CustomCornerPathProvider {

    var lastRect = CGRect.zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }

    func common() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.25
    }

    override func draw(_ rect: CGRect) {
        if rect != lastRect {
            let path = path(for: rect)
            layer.shadowPath = path.cgPath
            lastRect = rect
        }
        super.draw(rect)
    }

}


private protocol CustomCornerPathProvider{
    func path(for rect: CGRect) -> UIBezierPath
}


private extension CustomCornerPathProvider {
    func path(for rect: CGRect) -> UIBezierPath {
        let largeRadius = CGFloat(16)
        let smallRadius = CGFloat(2)

        let minX = rect.origin.x
        let minY = rect.origin.y
        let maxX = minX + rect.size.width
        let maxY = minY + rect.size.height

        let path = UIBezierPath()
        // start
        path.move(to: CGPoint(x: minX + largeRadius, y: minY))
        // top line
        path.addLine(to: CGPoint(x: maxX - smallRadius, y: minY))
        // top right corner
        path.addArc(
            withCenter: CGPoint(x: maxX - smallRadius, y: minY + smallRadius),
            radius: smallRadius,
            startAngle: CGFloat(Double.pi * 3 / 2),
            endAngle: CGFloat(0),
            clockwise: true
        )
        // right side
        path.addLine(to: CGPoint(x: maxX, y: maxY - smallRadius))
        // bottom right corner
        path.addArc(
            withCenter: CGPoint(x: maxX - smallRadius, y: maxY - smallRadius),
            radius: smallRadius,
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi / 2),
            clockwise: true
        )
        // bottom line
        path.addLine(to: CGPoint(x: minX - smallRadius, y: maxY))
        // bottom left cornet
        path.addArc(
            withCenter: CGPoint(x: minX - smallRadius, y: maxY - smallRadius),
            radius: smallRadius,
            startAngle: CGFloat(Double.pi / 2),
            endAngle: CGFloat(Double.pi),
            clockwise: true
        )
        // left side
        path.addLine(to: CGPoint(x: minX, y: minY + largeRadius))
        // top-left corner
        path.addArc(
            withCenter: CGPoint(x: minX + largeRadius, y: minY + largeRadius),
            radius: largeRadius,
            startAngle: CGFloat(Double.pi),
            endAngle: CGFloat(Double.pi / 2 * 3),
            clockwise: true
        )
        path.close()

        return path
    }
}
