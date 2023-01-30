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
}

class BaseButton: UIButton {
    
    var buttonState: ButtonState
    var activityIndicator: UIActivityIndicatorView!
    
    override var isHighlighted: Bool {
            didSet {
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               options: [.beginFromCurrentState, .allowUserInteraction],
                               animations: {
                    self.alpha = self.isHighlighted ? 0.5 : 1
                }, completion: nil)
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
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialSetup() {
        setTitle(buttonState.titleForButton, for: .normal)
        layer.cornerRadius = 6
        titleLabel?.font = UIFont(name: "SF-Pro-Text-Bold", size: 13)
    }
    
    func showLoading() {
        self.setTitle("", for: .normal)
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
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
            layer.cornerRadius = 6
        default:
            tintColor = .white
            backgroundColor = UIColor(named: "fillButtonBackground")
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
        self.addSubview(activityIndicator)
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
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: activityIndicator,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        self.addConstraint(yCenterConstraint)
    }
    
    func setGradientBorder() {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            UIColor(named: "gradientFirst")?.cgColor,
            UIColor(named: "gradientSecond")?.cgColor,
            UIColor(named: "gradientThird")?.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        let shape = CAShapeLayer()
        shape.lineWidth = 3
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 6).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        self.layer.addSublayer(gradient)
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
        }
    }
}
