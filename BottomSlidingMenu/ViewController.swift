//
//  ViewController.swift
//  BottomSlidingMenu
//
//  Created by Oleg Chernyshenko on 18/08/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!

    let positions:[CGFloat] = [30.0, 200.0, 500.0]
    var dragging = false
    var touchOffset: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler))
        self.view.addGestureRecognizer(panRecognizer)

        self.containerView.layer.cornerRadius = 10.0
        self.containerView.clipsToBounds = false
        self.containerView.layer.shadowColor = UIColor.black.cgColor
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowOpacity = 0.2

        topContainerConstraint.constant = positions[0]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: 10)
        self.containerView.layer.shadowPath = shadowPath.cgPath
    }

    func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        let touch = recognizer.location(in: self.view)
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
            }
            break
        case .ended:
            if dragging {
                let velocity = recognizer.velocity(in: self.view).y
                self.snapToClosestPosition(with: velocity)
            }
            dragging = false
            break

        default:
            break
        }
    }

    func snapToClosestPosition(with velocity: CGFloat = 0) {
        var closestPosition = positions[0]
        var minDistance = self.view.frame.height

        for position in positions {
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
                       options: [],
                       animations: {
                        self.topContainerConstraint.constant = closestPosition
                        self.view.layoutSubviews()
        }) { (completed) in
            
        }
    }

    func snapAnimationDuration(from distance: CGFloat, with velocity: CGFloat = 0) -> TimeInterval {
        let duration = max(0.01, TimeInterval(abs(distance * 0.005)))
        return duration
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

