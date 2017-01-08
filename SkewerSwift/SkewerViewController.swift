//
//  SkewerViewController.swift
//  SkewerSwift
//
//  Created by Kaden, Joshua on 1/6/17.
//  Copyright © 2017 Kaden, Joshua. All rights reserved.
//

import UIKit

final class SkewerViewController: UIViewController {

    var skewerView: SkewerView {
        return view as! SkewerView
    }
    
    override func loadView() {
        view = SkewerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        gesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(gesture)
    }
    
    func didDoubleTap(_ sender: UIGestureRecognizer) {
        reset()
    }
    
    private func reset() {
        skewerView.reset()
    }
}
