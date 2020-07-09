//
//  ActionView.swift
//  CredApp
//
//  Created by Priya Arora on 24/06/20.
//  Copyright © 2020 deeporg. All rights reserved.
//

import UIKit

enum StackPosition {
    case left
    case right
}

protocol ActionViewInput {
    func showActions(_ actions: [String])
    func shiftStackViewToPosition(_ position: StackPosition)
}

protocol ActionViewOutput: class {
    func actionBtnClickAtIndex(_ index: Int)
}

class ActionView: UIView, ActionViewInput {
    private enum Constants {
        static let actionViewBGColor = UIColor(red: 27.0/255, green: 33.0/255, blue: 46.0/255, alpha: 1)
        static let stackViewSpacing: CGFloat = 15
        static let stackViewWidth: CGFloat = 100
        static let stackViewLeftSpacing: CGFloat = -120
        static let stackViewRightSpacing: CGFloat = 60
        static let actionBtnTitleColor = UIColor(red: 27.0/255, green: 33.0/255, blue: 46.0/255, alpha: 1)
        static let actionBtnIcon = "Icon1"
        static let actionViewWidth: CGFloat = 170
        static let actionViewHeight: CGFloat = 60
        static let actionViewImageSide: CGFloat = 44
        static let actionViewImageLeading: CGFloat = 5
        static let actionViewBtnLeading: CGFloat = 54
        static let actionViewBtnWidth: CGFloat = 100
        static let actionViewBtnHeight: CGFloat = 44
    }

    var stackViewXAnchor: NSLayoutConstraint?
    weak var delegate: ActionViewOutput?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = Constants.actionViewBGColor
        addSubview(stackView)
        stackViewXAnchor =  stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        stackViewXAnchor?.isActive = true
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: Constants.stackViewWidth),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc func actionButtonClicked(_ btn: UIButton) {
        delegate?.actionBtnClickAtIndex(btn.tag)
    }
    
    func showActions(_ actions: [String]) {
        // Created if needed
        if stackView.arrangedSubviews.count == 0 {
            createActions()
        }
        
        // hide all
        for view in stackView.arrangedSubviews {
            view.isHidden = true
        }
        
        // show only that are needed
        for (index, action) in actions.enumerated() {
            let view = stackView.arrangedSubviews[index]
            view.isHidden = false
            if let button = view.subviews[1] as? UIButton {
                button.setTitle(action, for: .normal)
            }
        }
    }
    
    func shiftStackViewToPosition(_ position: StackPosition) {
        if position == .left {
            stackViewXAnchor?.constant =  Constants.stackViewLeftSpacing
        } else {
            stackViewXAnchor?.constant = Constants.stackViewRightSpacing
        }
    }
    
    
    private func createActions() {
        // assuming max 3 actions
        for index in 0..<3 {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: Constants.actionBtnIcon)
            view.addSubview(imageView)
            
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.textColor = Constants.actionBtnTitleColor
            button.contentHorizontalAlignment = .left
            button.setTitle("", for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(ActionView.actionButtonClicked(_:)), for: .touchUpInside)
            view.addSubview(button)
            
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: Constants.actionViewHeight),
                view.widthAnchor.constraint(equalToConstant: Constants.actionViewWidth)
            ])
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.actionViewImageLeading),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: Constants.actionViewImageSide),
                imageView.heightAnchor.constraint(equalToConstant: Constants.actionViewImageSide)
            ])
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.actionViewBtnLeading),
                button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                button.widthAnchor.constraint(equalToConstant: Constants.actionViewBtnWidth),
                button.heightAnchor.constraint(equalToConstant: Constants.actionViewBtnHeight)
            ])
            
            stackView.addArrangedSubview(view)
        }
    }
}
