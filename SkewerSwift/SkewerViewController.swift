//
//  SkewerViewController.swift
//  SkewerSwift
//
//  Created by Kaden, Joshua on 1/6/17.
//  Copyright © 2017 Kaden, Joshua. All rights reserved.
//

import UIKit

final class SkewerViewController: UIViewController {

    private let redViewController = RedViewController()
    
    var skewerView: SkewerView {
        return view as! SkewerView
    }
    
    override func loadView() {
        view = SkewerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Skewer", comment: "")
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        gesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(gesture)
        
        adoptChildViewController(redViewController, targetView: skewerView.containerView)
        skewerView.redView = redViewController.view as? RedView ?? nil
    }
    
    deinit {
        redViewController.leaveParentViewController()
    }
    
    func didDoubleTap(_ sender: UIGestureRecognizer) {
        reset()
    }
    
    private func reset() {
        skewerView.reset()
    }
}
