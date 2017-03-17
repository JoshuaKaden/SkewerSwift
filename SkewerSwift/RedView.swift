//
//  RedView.swift
//  SkewerSwift
//
//  Created by Kaden, Joshua on 3/17/17.
//  Copyright © 2017 Kaden, Joshua. All rights reserved.
//

import UIKit

final class RedView: UIView {
    var foldLayer: CALayer {
        return redView.layer
    }
    
    private let guideView = UIView()
    private let redView = UIView()
    private let redLabel = UILabel()

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let _ = newWindow else { return }
        
        guideView.borderWidth = 1
        guideView.cornerRadius = 10
        addSubview(guideView)
        
        redView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        redView.cornerRadius = guideView.cornerRadius
        addSubview(redView)
        
        redLabel.adjustsFontSizeToFitWidth = true
        redLabel.minimumScaleFactor = 0.1
        redLabel.font = UIFont.systemFont(ofSize: 140)
        redLabel.text = "abc"
        redLabel.textAlignment = .center
        redView.addSubview(redLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guideView.frame = bounds
        
        redView.frame = guideView.frame
        
        redLabel.sizeToFit()
        redLabel.centerInSuperview()
    }
}
