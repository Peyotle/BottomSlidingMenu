//
//  ViewController.swift
//  BottomSlidingMenu
//
//  Created by Oleg Chernyshenko on 18/08/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topContainerConstraint: NSLayoutConstraint?
    @IBOutlet weak var containerView: UIView?

    var draggableMenuController: DraggableMenuController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureMenuController()
    }

    func configureMenuController() {
        guard let topContainerConstraint = self.topContainerConstraint else {
            return
        }
        guard let containerView = self.containerView else {
            return
        }
        draggableMenuController = DraggableMenuController(constraint: topContainerConstraint, slidingView: containerView, containingView: self.view)
        draggableMenuController?.containingView = self.view
//        draggableMenuController?.slidingView = containerView
        let positions: [CGFloat] = [30.0, 200.0, 500.0]
        draggableMenuController?.snapPositions = positions
    }
}
