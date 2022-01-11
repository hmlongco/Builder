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

    @Variable var searchText: String? = ""

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.embed(content())

        print(UITraitCollection.current.userInterfaceStyle == .light ? "Light Mode" : "Dark Mode")

        $searchText.asObservable()
            .subscribe { text in
                print(text)
            }
            .disposed(by: disposeBag)

    }
        
    func content() -> View {
        VerticalScrollView {
            VStackView {
                DLSSearchBarView(text: $searchText)

                VStackView {

                    CustomCardView(text: "Selected card view...")

                    ContainerView {
                        VStackView {
                            LabelView("Disabled card view...")
                                .alpha(0.9)
                                .alpha(0.9)
                            LabelView("This is a description")
                                .color(.secondaryLabel)
                                .font(.footnote)
                            SpacerView()
                        }
                        .spacing(4)
                        .padding(h: 8, v: 16)
                    }
                    .height(100)
                    .addCustomCornerViews()
                    .onTapGesture({ context in
                        context.view.isCustomCornerViewEnabled.toggle()
                    })

                    CustomCardView(text: "Normal card view...")

                    CustomCardView(text: "Normal card view...")

                }
                .spacing(16)
                .padding(30)
            }
        }
        .backgroundColor(.systemBackground)
    }

}

struct DLSSearchBarView: ViewBuilder {

    @Variable var text: String?

    var body: View {
        With(UISearchBar()) {
            $0.placeholder = "Search"
            $0.tintColor = .gray
            $0.barTintColor = .black
            $0.barStyle = .black
            $0.showsCancelButton = false
            $0.returnKeyType = .search
            $0.setImage(UIImage(named: "search-template"), for: .search, state: .normal)
            $0.setImage(UIImage(named: "close"), for: .clear, state: .normal)
            if let textField = $0.getTextField() {
                ViewModifier(textField).text(bidirectionalBind: $text)
                textField.backgroundColor = .white
            }
        }
    }

}


private extension UISearchBar {

    func getTextField() -> UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            return subviews.first(where: { type(of: $0) == UITextField.self }) as? UITextField
        }
    }

}







struct CustomCardView: ViewBuilder {
    let text: String
    var body: View {
        CustomCornerCardView {
            VStackView {
                LabelView(text)
                    .alpha(0.9)
                LabelView("This is a description")
                    .color(.secondaryLabel)
                    .font(.footnote)
                SpacerView()
            }
            .spacing(4)
        }
        .height(100)
        .onTapGesture({ context in
            (context.view as? ContainerView.Base)?.isCustomCornerViewSelected.toggle()
        })
    }
}

struct CustomCornerCardView: ViewBuilder {
    let content: () -> View
    init(_ content: @escaping () -> View) {
        self.content = content
    }
    var body: View {
        ContainerView {
            content()
        }
        .addCustomCornerViews()
        .padding(h: 8, v: 16)
    }
}


extension ModifiableView where Base: BuilderInternalContainerView {
    public func addCustomCornerViews() -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.addCustomCornerViews() }
    }
}

extension BuilderInternalContainerView: CustomCornerViewHosting {

}

protocol CustomCornerViewHosting: UIView {

    var isCustomCornerViewEnabled: Bool { get set }
    var isCustomCornerViewSelected: Bool { get set }

    func addCustomCornerViews()

}

extension CustomCornerViewHosting {

    var isCustomCornerViewEnabled: Bool {
        get {
            guard let contentView = firstSubview(ofType: CustomCornerContentView.self) else { return false }
            return contentView.isEnabled
        }
        set {
            guard let contentView = firstSubview(ofType: CustomCornerContentView.self) else { return }
            alpha = newValue ? 1.0 : 0.5
            contentView.isEnabled = newValue
        }
    }

    var isCustomCornerViewSelected: Bool {
        get {
            guard let contentView = firstSubview(ofType: CustomCornerContentView.self) else { return false }
            return contentView.isSelected
        }
        set {
            guard let contentView = firstSubview(ofType: CustomCornerContentView.self) else { return }
            contentView.isSelected = newValue
        }
    }

    func addCustomCornerViews() {
        let contentView = CustomCornerContentView(frame: self.bounds)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(contentView, at: 0)
        let shadowView = CustomCornerShadowView(frame: self.bounds)
        shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(shadowView, at: 0)
    }

}

private class CustomCornerContentView: UIView, CustomCornerPathProvider {

    var isEnabled: Bool = true {
        didSet {
            backgroundColor = isEnabled ? .secondarySystemBackground : .systemBackground
            setNeedsDisplay()
        }
    }

    var isSelected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var selectedLineWidth: CGFloat = 2.0

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
        clipsToBounds = true
    }

    override func draw(_ rect: CGRect) {

        let lineWidth: CGFloat = isSelected ? self.selectedLineWidth : isEnabled ? 0 : 1

        if lineWidth > 0 {
            let strokePath = path(for: rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2))
            strokePath.lineWidth = lineWidth
            let strokeColor = isEnabled ? UIColor.blue : UIColor.gray
            strokeColor.setStroke()
            strokePath.stroke()
        }

        let mask = CAShapeLayer()
        mask.path = path(for: rect).cgPath
        layer.mask = mask
    }

}

private class CustomCornerShadowView: UIView, CustomCornerPathProvider {

    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }

    func common() {
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.25
    }

    override func draw(_ rect: CGRect) {
        layer.shadowPath = path(for: rect).cgPath
    }

}


private protocol CustomCornerPathProvider: UIView {
    func path(for rect: CGRect) -> UIBezierPath
}


private extension CustomCornerPathProvider {
    func path(for rect: CGRect) -> UIBezierPath {
        let largeRadius = CGFloat(16)
        let smallRadius = CGFloat(3)

        let minX = rect.origin.x
        let minY = rect.origin.y
        let maxX = minX + rect.size.width
        let maxY = minY + rect.size.height

        let path = UIBezierPath()
        path.lineCapStyle = .round
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
            withCenter: CGPoint(x: minX + smallRadius, y: maxY - smallRadius),
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

class CustomCornerBackgroundView: UIView, CustomCornerViewHosting {

    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }

    func common() {
        addCustomCornerViews()
    }

}
