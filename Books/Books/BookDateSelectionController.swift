//
//  BookLoadingController.swift
//  Books
//
//  Created by Savitha Rudramuni on 04/12/20.
//

import Foundation
import UIKit

protocol DateSelectionProtocol: class {
    
    func selectedDate(date:Date)
}


class BookDateSelectionController:UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var blockerView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isPresenting: Bool = false
    
    weak var delegate:DateSelectionProtocol?
    
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
        self.blockerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.popUpView.backgroundColor =  UIColor.white
        self.popUpView.layer.masksToBounds = true
        self.popUpView.layer.cornerRadius =  5
        //self.datePicker.datePickerStyle =  UIDatePickerStyle.inline
        datePicker.backgroundColor = .white
        self.datePicker.addTarget(self, action: #selector(dateSelectionAction), for: UIControl.Event.valueChanged)
        
        blockerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BookDateSelectionController.closeAction(_:))))
    }
    
    @objc func dateSelectionAction() {
        delegate?.selectedDate(date: self.datePicker.date)
    }
    
    func dismissLoader() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }


}

extension BookDateSelectionController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
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
