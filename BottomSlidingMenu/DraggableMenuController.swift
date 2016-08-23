//
//  DraggableMenuController.swift
//  BottomSlidingMenu
//
//  Created by Oleg Chernyshenko on 23/08/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

protocol DraggableView {
    weak var topContainerConstraint: NSLayoutConstraint! {get set}
    func configure()
}

class DraggableMenuContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    func configure() {
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.2

        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10)
        self.layer.shadowPath = shadowPath.cgPath
    }
}

class DraggableMenuController: NSObject {

    var topContainerConstraint: NSLayoutConstraint
    var snapPositions:[CGFloat] = [50]
    var containingView: UIView
    var slidingView: UIView

    var touchOffset: CGFloat = 0.0
    var dragging = false

    init(constraint: NSLayoutConstraint, slidingView: UIView, containingView: UIView) {
        self.topContainerConstraint = constraint
        self.slidingView = slidingView
        self.containingView = containingView
        super.init()

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler))
        self.slidingView.addGestureRecognizer(panRecognizer)
    }

    func snapToClosestPosition(with velocity: CGFloat = 0) {
        var closestPosition = snapPositions[0]
        var minDistance: CGFloat = CGFloat(MAXFLOAT)

        for position in snapPositions {
            let distance = abs(topContainerConstraint.constant - position + velocity/10)
            print("distance: \(distance)")

            if distance < minDistance {
                minDistance = distance
                closestPosition = position
            }
        }

        let duration = self.snapAnimationDuration(from: minDistance, with: velocity)

        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [UIViewAnimationOptions.allowUserInteraction],
                       animations: {
                        self.topContainerConstraint.constant = closestPosition
                        self.containingView.layoutSubviews()
        }) { (completed) in
            //Report about the reached zone through delegate or block
        }
    }

    func snapAnimationDuration(from distance: CGFloat, with velocity: CGFloat = 0) -> TimeInterval {
        let duration = max(0.01, TimeInterval(abs(distance * 0.005)))
        return duration
    }

    func panGestureHandler(recognizer: UIPanGestureRecognizer) {

        let touch = recognizer.location(in: self.containingView)
        switch recognizer.state {
        case .began:
            if touch.y >= topContainerConstraint.constant - 20 {
                dragging = true
                touchOffset = topContainerConstraint.constant - touch.y
            }
            break
        case .changed:
            if dragging {
                topContainerConstraint.constant = touch.y + touchOffset
                //Report the position through delegate or block
            }
            break
        case .ended:
            if dragging {
                let velocity = recognizer.velocity(in: self.containingView).y
                self.snapToClosestPosition(with: velocity)
            }
            dragging = false
            break
            
        default:
            break
        }
    }
}
