//
//  TestViewController.swift
//  BottomSlidingMenu
//
//  Created by Oleg Chernyshenko on 23/08/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    var draggableControllers: [DraggableMenuController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addMenu(_ sender: AnyObject) {
        let childController = self.instantiateChildViewController()
        childController.view.backgroundColor = self.randomColor()
        let offset = CGFloat(draggableControllers.count * 10)
        let positions: [CGFloat] = [100 + offset, 200.0 + offset, 500.0 + offset]

        self.setupMenu(with: childController, positions: positions)
    }

    func randomColor() -> UIColor {
        let red = randomColorComponent()
        let green = randomColorComponent()
        let blue = randomColorComponent()
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    func randomColorComponent() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }

    func setupMenu(with viewController: UIViewController, positions: [CGFloat]) {

        self.addChildMenuController(controller: viewController)

        let menuView = viewController.view!
        self.setupConstraints(for: menuView)
        let topConstraint = self.addTopLayoutConstraint(for: menuView)
        menuView.layoutSubviews()
        let draggableController = DraggableMenuController(constraint: topConstraint,
                                                      slidingView: menuView,
                                                      containingView: self.view)
        draggableControllers.append(draggableController)

        draggableController.snapPositions = positions
        draggableController.containingView = self.view
        draggableController.snapToClosestPosition()
    }

    func instantiateChildViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let childController = storyboard.instantiateViewController(withIdentifier: "childController")
        return childController
    }

    func addChildMenuController(controller: UIViewController) {
        self.addChildViewController(controller)
        controller.view.frame = self.view.frame
        controller.view.frame.origin.y = self.view.frame.height
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }

    func setupConstraints(for menuView: UIView) {
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        menuView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }

    func addTopLayoutConstraint(for menuView: UIView) -> NSLayoutConstraint {
        let topAnchor = self.view.topAnchor
        let topConstraint = menuView.topAnchor.constraint(equalTo: topAnchor, constant: self.view.bounds.height)
        topConstraint.isActive = true
        return topConstraint
    }

    func removeMenu(menuController: UIViewController) {
        menuController.willMove(toParentViewController: nil)
        menuController.view .removeFromSuperview()
        menuController.removeFromParentViewController()
    }
}
