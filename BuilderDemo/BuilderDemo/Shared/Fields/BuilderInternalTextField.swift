//
//  Extensions.swift
//  Builder
//
//  Created by Michael Long on 11/26/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

private enum ComponentState {
    case normal
    case selected
    case error
    case disabled
    case initial
}

public protocol TextFieldBehaviorDelegate: AnyObject {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

/**
  Not all required styles and behaviors can be accomplished with UIAppearance styles.
  Please set the class type of `CustomTextField` on all UITextFields in the app to get
  all styling behaviors
 */

public class BuilderInternalTextField: UITextField, UITextFieldDelegate {

    public var inputID: Int = 0

    public var hasUnderLineView: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    public var hasError: Bool {
        return errorText.value.isEmpty
    }

    public var isTextEmpty: Bool {
        return text?.isEmpty ?? true
    }

    public var behavior: TextFieldBehaviorDelegate? {
        didSet {
            delegate = behavior == nil ? nil : self
        }
    }

    public var errorText = BehaviorRelay(value: "")

    private var errorLabel: UILabel?
    private var underline: CALayer?
    private var oldTextColor: UIColor?
    private var disposeBag = DisposeBag()
    private var componentState: ComponentState {
        let defaultValue: ComponentState = .normal
        switch defaultValue {
        case _ where !hasError:
            return .error
        case _ where isFirstResponder:
            return .selected
        case _ where !isEnabled:
            return .disabled
        default:
            return defaultValue
        }
    }

    func alignErrorTextRight() {
        errorLabel?.textAlignment = .right
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }

    private func sharedSetup() {
        font = UIFont.preferredFont(forTextStyle: .callout)
        setupErrorObserver()
        clipsToBounds = false // note label is drawn BELOW the frame
    }

    func setupErrorObserver() {
        errorText.asObservable()
            .skip(while: { $0.isEmpty })
            .subscribe(onNext: { [weak self] _ in
                self?.updateSubcomponents()
            })
            .disposed(by: disposeBag)
    }

    // MARK: Public API

    open func validateNotEmpty() {
        errorText.accept(isTextEmpty ? "Required" : "")
    }

    // MARK: - Overridden methods

    override public var isEnabled: Bool {
        get {
            return super.isEnabled
        }
        set {
            super.isEnabled = newValue
            if !isEnabled {
                oldTextColor = textColor
                textColor = .lightGray
            } else if let oldTextColor = oldTextColor {
                textColor = oldTextColor
            }
            setNeedsDisplay()
        }
    }

    override public func becomeFirstResponder() -> Bool {
        setNeedsDisplay()
        return super.becomeFirstResponder()
    }

    override public func resignFirstResponder() -> Bool {
        setNeedsDisplay()
        return super.resignFirstResponder()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        updateSubcomponents()
    }

   // MARK: - Drawing functions

    override public func draw(_ rect: CGRect) {
        updateSubcomponents()
        super.draw(rect)
    }

    private func updateSubcomponents() {
        buildUnderline(for: componentState)
        buildErrorLabel(with: errorText.value)
    }

    private func buildUnderline(for state: ComponentState) {
        underline?.removeFromSuperlayer()
        underline = nil
        if hasUnderLineView {
            let lineThickness: CGFloat = state == .selected ? 2.0 : 1.0
            let lineColor = color(for: state)
            underline = addUnderline(lineThickness: lineThickness, lineColor: lineColor, dashed: state == .disabled)
        }
    }

    private func buildErrorLabel(with text: String?) {
        guard let text = text, !text.isEmpty else {
            accessibilityLabel = nil
            errorLabel?.removeFromSuperview()
            errorLabel = nil
            return
        }
        let newFrame = CGRect(x: frame.minX, y: frame.maxY + 1, width: frame.width, height: 15)
        if errorLabel == nil {
            let newLabel = UILabel(frame: newFrame)
            newLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            newLabel.textColor = .red
            newLabel.isAccessibilityElement = false
            newLabel.translatesAutoresizingMaskIntoConstraints = false
            superview?.insertSubview(newLabel, aboveSubview: self)
            newLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            newLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            newLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 1).isActive = true
            self.errorLabel = newLabel
        } else if let labelFrame = errorLabel?.frame, labelFrame != newFrame {
            errorLabel?.frame = newFrame
        }
        if let accessibilityIdentifier = self.accessibilityIdentifier {
            errorLabel?.accessibilityIdentifier = accessibilityIdentifier + ".error"
        }
        accessibilityLabel = "Error: " + text.lowercased()
        errorLabel?.text = text
    }

    private func color(for state: ComponentState) -> UIColor {
        switch componentState {
        case .normal:
            return bottomLineColor ?? .cyan
        case .selected:
            return selectedBottomLineColor ?? .cyan
        case .error:
            return errorColor ?? .cyan
        case .disabled:
            return bottomLineColor ?? .cyan
        case .initial:
            return .clear
        }
    }

    // MARK: - Behavior delegate

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let behavior = behavior {
            // return should return for tabbing
            if string == "\n" {
                return true
            }
            // If we have a custom input view or picker assigned (e.g. states) prevent normal operation.
            if textField.inputView != nil {
                return false
            }

            return behavior.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }

}
