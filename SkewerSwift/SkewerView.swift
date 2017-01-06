//
//  SkewerView.swift
//  SkewerSwift
//
//  Created by Kaden, Joshua on 1/6/17.
//  Copyright © 2017 Kaden, Joshua. All rights reserved.
//

import UIKit

final class SkewerView: UIView {
    
    // MARK: - Public Properties
    var anchorX: CGFloat = 0.5
    var angle: CGFloat = 0
    var position: CGFloat = 0
    
    // MARK: - Subviews
    private let containerView = UIView()
    
    private let guideView = UIView()
    private let redView = UIView()
    private let redLabel = UILabel()
    
    private let sliderContainerView = UIView()
    private let anchorXLabel = UILabel()
    private let anchorXSlider = UISlider()
    private let angleLabel = UILabel()
    private let angleSlider = UISlider()
    private let positionLabel = UILabel()
    private let positionSlider = UISlider()
    
    // MARK: - Lifecycle
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let _ = newWindow else { return }
        
        backgroundColor = UIColor.darkGray
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(containerView)
        
        guideView.borderWidth = 1
        containerView.addSubview(guideView)
        
        redView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        containerView.addSubview(redView)
        
        redLabel.font = UIFont.systemFont(ofSize: 70)
        redLabel.text = "abc"
        redLabel.textAlignment = .center
        redView.addSubview(redLabel)
        
        containerView.addSubview(sliderContainerView)
        
        anchorXLabel.text = buildAnchorLabelText()
        sliderContainerView.addSubview(anchorXLabel)
        
        anchorXSlider.addTarget(self, action: #selector(didChangeAnchorX(_:)), for: .valueChanged)
        anchorXSlider.maximumValue = 1.5
        anchorXSlider.minimumValue = -0.5
        anchorXSlider.value = Float(anchorX)
        sliderContainerView.addSubview(anchorXSlider)
    }
    
    private func buildAnchorLabelText() -> String {
        return "anchor X: \(anchorX)"
    }
    
    private func fold() {
        let layer = redView.layer
        
//        layer.position = CGPoint(x: position, y: guideView.frame.midY)
        layer.anchorPoint = CGPoint(x: anchorX, y: layer.anchorPoint.y)
        
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        transform = CATransform3DRotate(transform, CGFloat(angle) * CGFloat(M_PI) / CGFloat(180), 0, 1, 0)
        
        layer.transform = transform
    }
    
    // MARK: - Actions
    
    func didChangeAnchorX(_ sender: UISlider) {
        anchorX = CGFloat(sender.value)
        anchorXLabel.text = buildAnchorLabelText()
        anchorXLabel.sizeToFit()
        fold()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.frame = bounds.insetBy(dx: 24, dy: 24)
        containerView.centerInSuperview()
        
        let guideSide: CGFloat
        let isPortrait: Bool
        if containerView.width > containerView.height {
            isPortrait = false
            guideSide = containerView.height
        } else {
            isPortrait = true
            guideSide = containerView.width
        }
        guideView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: guideSide, height: guideSide))
        guideView.cornerRadius = 10
        
        redView.frame = guideView.frame
        redView.cornerRadius = 10
        
        redLabel.sizeToFit()
        redLabel.centerInSuperview()
        
        if isPortrait {
            sliderContainerView.size = CGSize(width: containerView.width, height: containerView.height - guideView.maxY - 16)
            sliderContainerView.x = 0
            sliderContainerView.y = guideView.maxY + 16
        } else {
            sliderContainerView.size = CGSize(width: containerView.width - guideView.maxX - 16, height: containerView.height)
            sliderContainerView.x = guideView.maxX + 16
            sliderContainerView.y = 0
        }
        
        anchorXLabel.sizeToFit()
        anchorXLabel.origin = CGPoint.zero
        
        anchorXSlider.size = CGSize(width: sliderContainerView.width, height: 50)
        anchorXSlider.x = 0
        anchorXSlider.y = anchorXLabel.maxY
    }
}
