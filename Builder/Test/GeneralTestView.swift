//
//  GeneralTestView.swift
//  Builder
//
//  Created by Michael Long on 1/6/22.
//

import UIKit
import RxSwift
import Resolver

class GeneralTestViewController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.embed(content())

        print(UITraitCollection.current.userInterfaceStyle == .light ? "Light Mode" : "Dark Mode")

    }

    func content() -> View {
        VStackView {
            VerticalScrollView {
                VStackView {
                    ContainerView {
                        LabelView("This is a test!")
                            .backgroundColor(.red)
                            .color(.white)
//                            .margins(20) // only within container
                            .padding(10)
                    }
                    .padding(20)
                    .backgroundColor(.yellow)
                    .height(100)

                    SpacerView()
                }
                .padding(20)
            }
            ContainerView {
                MyButtonView()
                    .safeArea(true)
            }
        }
    }

}

struct MyButtonView: ViewBuilder {
    var body: View {
        ViewModifier(DLSInsetFilledActionButton("Submit"))
            .height(58)
            .onTap { context in
                print("tapped")
            }

    }
}


class DLSInsetFilledActionButton: UIButton {

    var backgroundView: UIView!

    public init(_ title: String = "") {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        setupCommon()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommon()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCommon()
    }

    func setupCommon() {
        backgroundView = Builder.with(UIView()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .red
            $0.isUserInteractionEnabled = false
            $0.layer.cornerRadius = 2.0
        }
        insertConstrainedSubview(backgroundView, at: 0, position: .fill, padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
        backgroundColor = .systemBackground
        setTitleColor(.systemBackground, for: .normal)
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.backgroundView.backgroundColor = self.isHighlighted ? .red.darker() : .red
            }, completion: nil)
        }
    }

}
