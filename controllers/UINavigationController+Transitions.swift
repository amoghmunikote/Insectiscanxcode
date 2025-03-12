//
//  UINavigationController+Transitions.swift
//  insectiscan
//
//  Created by Jason Grife on 3/10/25.
//
// Add this extension to a new file called UINavigationController+Transitions.swift
import UIKit

extension UINavigationController {
    func smoothTransition() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        view.layer.add(transition, forKey: nil)
    }
    
    func pushViewControllerWithFade(_ viewController: UIViewController, animated: Bool) {
        smoothTransition()
        pushViewController(viewController, animated: false)
    }
    
    func popViewControllerWithFade(animated: Bool) -> UIViewController? {
        smoothTransition()
        return popViewController(animated: false)
    }
}
