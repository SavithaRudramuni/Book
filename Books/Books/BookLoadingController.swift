//
//  BookLoadingController.swift
//  Books
//
//  Created by Savitha Rudramuni on 04/12/20.
//

import Foundation
import UIKit


class BookLoadingController:UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var blockerView: UIView!
    
    var isPresenting: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationCapturesStatusBarAppearance = true
        modalPresentationStyle = .custom
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.blockerView.backgroundColor = UIColor.clear
        self.popUpView.backgroundColor =  UIColor.white
        self.popUpView.layer.masksToBounds = true
        self.popUpView.layer.cornerRadius =  5
    }
    
    func dismissLoader(animation:Bool) {
        
        self.dismiss(animated: animation, completion: nil)
    }


}

extension BookLoadingController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            
            popUpView.frame.origin.y += popUpView.frame.height
            blockerView.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.popUpView.frame.origin.y -= self.popUpView.frame.height
                self.blockerView.alpha = 1
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.popUpView.frame.origin.y += self.popUpView.frame.height
                self.blockerView.alpha = 0
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        }
        
    }
}
