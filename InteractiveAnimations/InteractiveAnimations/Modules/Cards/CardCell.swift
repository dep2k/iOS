//
//  CardCell.swift
//  CredApp
//
//  Created by Priya Arora on 23/06/20.
//  Copyright © 2020 deeporg. All rights reserved.
//

import UIKit

protocol CardCellInput {
    func showLaunchAnimation()
    func animateCardToCenterIfNeeded()
    func addActions(_ actions:[String])
}

protocol CardTableViewDelegate: UITableViewDelegate {
    func didSelectActionAtIndex(_ actionIndex: Int, cellIndexPath: IndexPath)
}

class CardCell: UITableViewCell, CardCellInput, ActionViewOutput {
    
    private enum State {
        case left
        case right
        case center
    }
    
    private enum Constants {
        static let threshold: CGFloat = 10.0
        static let cardImageName = "Card1"
        static let cardViewRadius: CGFloat = 20
        static let cardViewShift: CGFloat = 300
        static let animationDuration: CGFloat = 0.3
        static let animationCurve: AnimationCurve = .easeIn
        static let sizeMultiplier: CGFloat = 0.9
    }
    
    private var state: State = .center
    private var animator: UIViewPropertyAnimator?
    
    private lazy var cardImageView: UIImageView = {
        let cardImageView = UIImageView()
        cardImageView.contentMode = .scaleAspectFit
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.image = UIImage(named: Constants.cardImageName)
        return cardImageView
    }()
    
    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = Constants.cardViewRadius
        cardView.clipsToBounds = true
        let panRecognizer = UIPanGestureRecognizer(target:self, action: #selector(self.onDrag(_:)))
        panRecognizer.delegate = self
        cardView.addGestureRecognizer(panRecognizer)
        return cardView
    }()
    
    private lazy var actionView: ActionView = {
        let actionView = ActionView()
        actionView.delegate = self
        actionView.layer.cornerRadius = Constants.cardViewRadius
        actionView.translatesAutoresizingMaskIntoConstraints = false
        return actionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(actionView)
        contentView.addSubview(cardView)
        cardView.addSubview(cardImageView)
        
        NSLayoutConstraint.activate([
            cardView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.sizeMultiplier),
            cardView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.sizeMultiplier),
            cardView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cardImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            cardImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            cardImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            actionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.sizeMultiplier),
            actionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.sizeMultiplier),
            actionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func goLeft() {
        if !(animator?.isRunning ?? false) {
            animator = UIViewPropertyAnimator(duration: TimeInterval(Constants.animationDuration), curve: Constants.animationCurve, animations: {
                self.cardView.frame = self.cardView.frame.offsetBy(dx: -1 * Constants.cardViewShift, dy: 0)
            })
            
            animator?.addCompletion { position in
                switch position {
                case .end:
                    switch self.state {
                    case .left:
                        self.state = .left
                    case .right:
                        self.state = .center
                    case .center:
                        self.state = .left
                    }
               
                default:
                    ()
                }
            }
        }
    }
    
    func goRight() {
        if !(animator?.isRunning ?? false) {
            animator = UIViewPropertyAnimator(duration: TimeInterval(Constants.animationDuration), curve: Constants.animationCurve, animations: {
                self.cardView.frame = self.cardView.frame.offsetBy(dx: Constants.cardViewShift, dy: 0)
            })
            
            animator?.addCompletion { position in
                switch position {
                case .end:
                    switch self.state {
                    case .left:
                        self.state = .center
                    case .center:
                        self.state = .right
                    case .right:
                        self.state = .right
                    }
                default:
                    ()
                }
            }
        }
    }
    
    
    @objc func onDrag(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            let velocity = gestureRecognizer.velocity(in: cardView)
            let translation = gestureRecognizer.translation(in: cardView)
            print(translation.x, translation.y, velocity.x, velocity.y)
            if (velocity.x > 0 && state != .right) {
                goRight()
                if state == .center {
                    actionView.shiftStackViewToPosition(.left)
                }
            } else if (velocity.x < 0 && state != .left){
                goLeft()
                if state == .center {
                    actionView.shiftStackViewToPosition(.right)
                }
            } else {
                return
            }
            animator?.pauseAnimation()
            
        case .changed:
            let translation = gestureRecognizer.translation(in: cardView)
            animator?.fractionComplete = abs(translation.x) / 100
            
        case .ended:
            let translation = gestureRecognizer.translation(in: cardView)
            if abs(translation.x) < Constants.threshold {
                animator?.isReversed = true
            } else {
                dismissSwipeOnAnotherCellIfNeeded()
            }
            animator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
        default:
            ()
        }
    }
    
    func animateCardToCenterIfNeeded() {
        if !(animator?.isRunning ?? false) {
            switch state {
            case .left:
                goRight()
                animator?.startAnimation()
            case .right:
                goLeft()
                animator?.startAnimation()
            default:
                break;
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let rec = gestureRecognizer as? UIPanGestureRecognizer {
            let shouldBegin =  abs((rec.velocity(in: rec.view)).x) > abs((rec.velocity(in: rec.view)).y)
            return shouldBegin
        }
        return false
    }
    
    private func dismissSwipeOnAnotherCellIfNeeded() {
        guard let tableView = superview as? UITableView, let visibleCells = tableView.visibleCells as? [CardCell]  else { return }
        for cell in visibleCells {
            if cell != self {
                cell.animateCardToCenterIfNeeded()
            }
        }
    }
    
    func actionBtnClickAtIndex(_ index: Int) {
        guard let tableView = superview as? UITableView, let delegate = tableView.delegate as? CardTableViewDelegate, let indexPath = tableView.indexPath(for: self) else { return }
        
        delegate.didSelectActionAtIndex(index, cellIndexPath: indexPath)
    }
    
    func addActions(_ actions: [String]) {
        actionView.showActions(actions)
    }
    
    func showLaunchAnimation() {
        goLeft()
        animator?.startAnimation()
        animator?.addCompletion({ (_) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.animateCardToCenterIfNeeded()
            }
        })
    }
}
