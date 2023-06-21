//
//  VasylView.swift
//  RomaMVVM
//
//  Created by User on 19.06.2023.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    let alert = ErrorAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        alert.title = "alert_memory_unavailable_title"
        alert.desc = "alert_memory_unavailable_description"
        alert.image = UIImage(named: "memory.list.empty.state")
        alert.buttonTitle = "action_create_memory"
        alert.buttonImage = UIImage(named: "message.add24")
        alert.onButtonTapCompletion = { [weak self] in
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.alert.show(on: self.view)
        }
    }
}
    
    final class ErrorAlert: UIView {
        // MARK: - Properties
        var onButtonTapCompletion: (() -> Void)?
        
        var title: String? {
            get { titleLabel.text }
            set { titleLabel.text = newValue }
        }
        
        var desc: String? {
            get { descriptionLabel.text }
            set { descriptionLabel.text = newValue }
        }
        
        var image: UIImage? {
            get { imageView.image }
            set { imageView.image = newValue }
        }
        
        var buttonTitle: String? = nil {
            didSet {
                guard let buttonTitle = buttonTitle else { return }
                button.configuration?.attributedTitle = AttributedString(stringLiteral: buttonTitle)
                button.configuration?.attributedTitle?.font = .systemFont(ofSize: 14, weight: .medium)
            }
        }
        
        var buttonImage: UIImage? {
            get { button.configuration?.image }
            set { button.configuration?.image = newValue?.withRenderingMode(.alwaysTemplate) }
        }
        
        var imageUrl: URL? {
            didSet {
                //            imageView.sd_setImage(
                //                with: imageUrl,
                //                placeholderImage: nil,
                //                options: .highPriority
                //            )
                
                //            imageView.kf.setImage(with: imageUrl)
            }
        }
        
        private weak var parentView: UIView?
        
        private var bottomConstraint: NSLayoutConstraint?
        
        private var containerView: UIView = {
            let view = UIView()
            return view
        }()
        
        private var overlayView: UIView = {
            let view = UIView()
            view.backgroundColor = .black.withAlphaComponent(0.5)
            return view
        }()
        
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 12
            return stackView
        }()
        
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            return imageView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 24, weight: .medium)
            label.textColor = .label
            label.textAlignment = .center
            return label
        }()
        
        private let descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = .secondaryLabel
            label.numberOfLines = .zero
            label.textAlignment = .center
            return label
        }()
        
        private lazy var button: UIButton = {
            let button = UIButton()
            var config = UIButton.Configuration.filled()
            
            config.contentInsets = .init(top: 12, leading: 24, bottom: 12, trailing: 24)
            config.imagePadding = 6
            config.background.cornerRadius = 100
            config.baseBackgroundColor = .white
            config.baseForegroundColor = .black
            button.configuration = config
            button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            return button
        }()
        
        private lazy var mainPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        // MARK: - Life cycle
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        
        // MARK: - Internal methods
        func show(on parentView: UIView, completion: (() -> Void)? = nil) {
            isHidden = true
            
            self.parentView = parentView
            
            translatesAutoresizingMaskIntoConstraints = false
            parentView.addSubview(self)
            
            let bottomConstraint = bottomAnchor.constraint(
                equalTo: parentView.bottomAnchor,
                constant: .zero
            )
            self.bottomConstraint = bottomConstraint
            
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                bottomConstraint
            ])
            
            overlayView.alpha = .zero
            overlayView.translatesAutoresizingMaskIntoConstraints = false
            parentView.insertSubview(overlayView, belowSubview: self)
            NSLayoutConstraint.activate([
                overlayView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                overlayView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                overlayView.topAnchor.constraint(equalTo: parentView.topAnchor),
                overlayView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
            ])
            
            layoutIfNeeded()
            
            bottomConstraint.constant = bounds.height
            
            parentView.layoutIfNeeded()
            
            isHidden = false
            
            bottomConstraint.constant = .zero
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.overlayView.alpha = 1
                self?.parentView?.layoutIfNeeded()
            } completion: { _ in
                completion?()
            }
        }
        
        func hide(completion: (() -> Void)? = nil) {
            self.bottomConstraint?.constant = bounds.height
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.parentView?.layoutIfNeeded()
                self?.overlayView.alpha = .zero
            } completion: { [weak self] _ in
                self?.removeFromSuperview()
                self?.overlayView.removeFromSuperview()
                completion?()
            }
        }
        
        // MARK: - Private methods
        private func commonInit() {
            setupUI()
            layout()
        }
        
        private func setupUI() {
            addGestureRecognizer(mainPanGestureRecognizer)
            overlayView.addGestureRecognizer(tapGestureRecognizer)
            
            backgroundColor = .secondarySystemBackground
            layer.cornerRadius = 24
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        private func layout() {
            // containerView
            containerView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(containerView)
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                containerView.topAnchor.constraint(equalTo: topAnchor),
                containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
            
            // stackView
            stackView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 56)
            ])
            
            // imageView
            stackView.addArrangedSubview(imageView)
            
            // titleLabel
            stackView.addArrangedSubview(titleLabel)
            
            // descriptionLabel
            stackView.addArrangedSubview(descriptionLabel)
            
            // button
            button.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                button.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
                button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -70)
            ])
        }
        
        private func didEndPan(_ sender: UIPanGestureRecognizer) {
            guard let bottomConstraint = bottomConstraint else { return }
            let velocity = sender.velocity(in: self)
            if bottomConstraint.constant > 0.4 * bounds.height || velocity.y > 1000 {
                hide()
            } else {
                bottomConstraint.constant = .zero
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.parentView?.layoutIfNeeded()
                }
            }
        }
        
        @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
            switch sender.state {
            case .began, .changed:
                guard let bottomConstraint = bottomConstraint else { return }
                
                let translationY = sender.translation(in: self).y
                let newConstant = bottomConstraint.constant + translationY
                if newConstant < bounds.height && newConstant > 0 {
                    bottomConstraint.constant = newConstant
                }
            case .ended:
                didEndPan(sender)
            default:
                break
            }
            
            sender.setTranslation(.zero, in: self)
        }
        
        @objc private func handleTap(_ sender: UITapGestureRecognizer) {
            hide()
        }
        
        @objc private func didTapButton() {
            hide { [weak self] in
                self?.onButtonTapCompletion?()
            }
        }
    }
    

