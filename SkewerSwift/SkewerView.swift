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
        
        angleLabel.text = buildAngleLabelText()
        sliderContainerView.addSubview(angleLabel)
        
        angleSlider.addTarget(self, action: #selector(didChangeAngle(_:)), for: .valueChanged)
        angleSlider.maximumValue = 360
        angleSlider.minimumValue = -180
        angleSlider.value = Float(angle)
        sliderContainerView.addSubview(angleSlider)
        
        positionLabel.text = buildPositionLabelText()
        sliderContainerView.addSubview(positionLabel)
        
        positionSlider.addTarget(self, action: #selector(didChangePosition(_:)), for: .valueChanged)
        sliderContainerView.addSubview(positionSlider)
    }
    
    private func buildAnchorLabelText() -> String {
        return "anchor X: \(anchorX)"
    }
    
    private func buildAngleLabelText() -> String {
        return "angle: \(angle)"
    }
    
    private func buildPositionLabelText() -> String {
        return "position: \(position)"
    }
    
    private func fold() {
        let layer = redView.layer
        
        layer.position = CGPoint(x: position, y: guideView.frame.midY)
        layer.anchorPoint = CGPoint(x: anchorX, y: layer.anchorPoint.y)
        
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        transform = CATransform3DRotate(transform, CGFloat(angle) * CGFloat(M_PI) / CGFloat(180), 0, 1, 0)
        
        layer.transform = transform
    }
    
    private func updatePositionSliderIfNeeded() {
        let maxValue = Float(guideView.width + (guideView.width / 2.0))
        if positionSlider.maximumValue != maxValue {
            positionSlider.maximumValue = maxValue
            positionSlider.minimumValue = Float((guideView.width / 2.0) * -1.0)
            position = containerView.frame.midX
            positionSlider.value = Float(position)
        }
    }
    
    // MARK: - Actions
    
    func didChangeAnchorX(_ sender: UISlider) {
        anchorX = CGFloat(sender.value)
        anchorXLabel.text = buildAnchorLabelText()
        anchorXLabel.sizeToFit()
        fold()
    }
    
    func didChangeAngle(_ sender: UISlider) {
        angle = CGFloat(sender.value)
        angleLabel.text = buildAngleLabelText()
        angleLabel.sizeToFit()
        fold()
    }
    
    func didChangePosition(_ sender: UISlider) {
        position = CGFloat(sender.value)
        positionLabel.text = buildPositionLabelText()
        positionLabel.sizeToFit()
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
        
        let sliderSize = CGSize(width: sliderContainerView.width, height: 50)
        
        angleLabel.sizeToFit()
        angleLabel.origin = CGPoint.zero
        
        angleSlider.size = sliderSize
        angleSlider.origin = CGPoint(x: 0, y: angleLabel.maxY)
        
        anchorXLabel.sizeToFit()
        anchorXLabel.origin = CGPoint(x: 0, y: angleSlider.maxY + 8)
        
        anchorXSlider.size = sliderSize
        anchorXSlider.origin = CGPoint(x: 0, y: anchorXLabel.maxY)
        
        positionLabel.sizeToFit()
        positionLabel.origin = CGPoint(x: 0, y: anchorXSlider.maxY + 8)
        
        positionSlider.size = sliderSize
        positionSlider.origin = CGPoint(x: 0, y: positionLabel.maxY)
        
        updatePositionSliderIfNeeded()
    }
}
