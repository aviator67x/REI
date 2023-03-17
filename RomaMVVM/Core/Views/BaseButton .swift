//
//  LoadingButton .swift
//  Interngram-Bravo
//
//  Created by Aleksandra on 25.10.2022.
//

import Foundation

import UIKit

enum ButtonState {
    case login
    case next
    case sendCode
    case confirm
    case createNewAccount
    case editProfile
    case saveChanges
    case follow
    case message
    case exit
    case restorePassword
    case signUp
    case filter
    case avatar
    case chosePhoto
    case logout
}

class BaseButton: UIButton {
    var buttonState: ButtonState
    var activityIndicator: UIActivityIndicatorView!

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction],
                animations: {
                    self.alpha = self.isHighlighted ? 0.5 : 1
                },
                completion: nil
            )
        }
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }

    init(buttonState: ButtonState) {
        self.buttonState = buttonState
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialSetup() {
        setTitle(buttonState.titleForButton, for: .normal)
        layer.cornerRadius = 6
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
        titleLabel?.font = UIFont(name: "SFProText-Bold", size: 21)
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor(named: "fillButtonBackground")
    }

    func showLoading() {
        setTitle("", for: .normal)
        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }
        isUserInteractionEnabled = false
        showSpinning()
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.setTitle(self?.buttonState.titleForButton, for: .normal)
            self?.activityIndicator.stopAnimating()
            self?.isUserInteractionEnabled = true
        }
    }

    private func setupView() {
        initialSetup()
        switch buttonState {
        case .createNewAccount, .message, .exit:
            setTitleColor(UIColor(named: "violet"), for: .normal)
            backgroundColor = .clear
        default:
            setTitleColor(.white, for: .normal)
         
        }
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: activityIndicator,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )
        addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: activityIndicator,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        addConstraint(yCenterConstraint)
    }

    func setGradientBorder() {
        layer.cornerRadius = 6
        clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [
            UIColor(named: "gradientFirst")?.cgColor,
            UIColor(named: "gradientSecond")?.cgColor,
            UIColor(named: "gradientThird")?.cgColor,
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        let shape = CAShapeLayer()
        shape.lineWidth = 3
        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: 6).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        layer.addSublayer(gradient)
    }
}

extension ButtonState {
    var titleForButton: String {
        switch self {
        case .login:
            return "Login"
        case .next:
            return "Next"
        case .confirm:
            return "Confirm"
        case .sendCode:
            return "Send Code"
        case .createNewAccount:
            return "Create new account"
        case .editProfile:
            return "Edit profile"
        case .saveChanges:
            return "Save changes"
        case .follow:
            return "Follow"
        case .message:
            return "Send message"
        case .exit:
            return "Exit"
        case .restorePassword:
            return "Restore password"
        case .signUp:
            return "Sign Up"
        case .filter:
            return "Search"
        case .avatar:
            return "Add avatar"
        case .chosePhoto:
            return "Chose photo from Gallery"
        case .logout:
            return "Log Out"
        }
    }
}
