//
//  SkewerView.swift
//  SkewerSwift
//
//  Created by Kaden, Joshua on 1/6/17.
//  Copyright © 2017 Kaden, Joshua. All rights reserved.
//

import UIKit

final class SkewerView: UIView {
    
    // MARK: - Defaults
    let defaultAnchorX = CGFloat(0.5)
    let defaultAngle = CGFloat(0)
    var defaultPosition: CGFloat {
        return guideView.frame.midX
    }
    
    // MARK: - Public Properties
    var anchorX: CGFloat {
        get { return CGFloat(anchorXSlider.value) }
        set {
            anchorXSlider.value = Float(newValue)
            didChangeAnchorX(anchorXSlider)
        }
    }
    var angle: CGFloat {
        get { return CGFloat(angleSlider.value) }
        set {
            angleSlider.value = Float(newValue)
            didChangeAngle(angleSlider)
        }
    }
    var position: CGFloat {
        get { return CGFloat(positionSlider.value) }
        set {
            positionSlider.value = Float(newValue)
            didChangePosition(positionSlider)
        }
    }
    
    // MARK: - Private Properties
    
    private var positionMaxValue: Float {
        return Float(guideView.width + (guideView.width / 2.0))
    }
    
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
        
        backgroundColor = UIColor.lightGray
        
        setupSubviews()
        
        reset()
    }
    
    private func setupSubviews() {
        addSubview(containerView)
        
        guideView.borderWidth = 1
        containerView.addSubview(guideView)
        
        redView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        containerView.addSubview(redView)
        
        redLabel.adjustsFontSizeToFitWidth = true
        redLabel.minimumScaleFactor = 0.1
        redLabel.font = UIFont.systemFont(ofSize: 140)
        redLabel.text = "abc"
        redLabel.textAlignment = .center
        redView.addSubview(redLabel)
        
        containerView.addSubview(sliderContainerView)
        
        anchorXLabel.text = buildAnchorLabelText()
        sliderContainerView.addSubview(anchorXLabel)
        
        anchorXSlider.addTarget(self, action: #selector(didChangeAnchorX(_:)), for: .valueChanged)
        anchorXSlider.maximumValue = 1.5
        anchorXSlider.minimumValue = -0.5
        sliderContainerView.addSubview(anchorXSlider)
        
        angleLabel.text = buildAngleLabelText()
        sliderContainerView.addSubview(angleLabel)
        
        angleSlider.addTarget(self, action: #selector(didChangeAngle(_:)), for: .valueChanged)
        angleSlider.maximumValue = 360
        angleSlider.minimumValue = -180
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
    
    private func updatePositionSlider() {
        positionSlider.maximumValue = positionMaxValue
        positionSlider.minimumValue = Float((positionMaxValue / 2.0) * -1.0)
        position = defaultPosition
    }
    
    private func updatePositionSliderIfNeeded() {
        if positionSlider.maximumValue != positionMaxValue {
            updatePositionSlider()
        }
    }
    
    // MARK: - Public Methods
    
    func reset() {
        anchorX = defaultAnchorX
        angle = defaultAngle
        updatePositionSlider()
    }
    
    // MARK: - Actions
    
    func didChangeAnchorX(_ sender: UISlider) {
        anchorXLabel.text = buildAnchorLabelText()
        anchorXLabel.sizeToFit()
        fold()
    }
    
    func didChangeAngle(_ sender: UISlider) {
        angleLabel.text = buildAngleLabelText()
        angleLabel.sizeToFit()
        fold()
    }
    
    func didChangePosition(_ sender: UISlider) {
        positionLabel.text = buildPositionLabelText()
        positionLabel.sizeToFit()
        fold()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.frame = bounds.insetBy(dx: 24, dy: 24)
        containerView.height -= 100
        containerView.centerInSuperview()

        let marginX = width * 0.025
        let marginY = height * 0.025
        
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
            sliderContainerView.size = CGSize(width: containerView.width, height: containerView.height - guideView.maxY - marginY)
            sliderContainerView.x = 0
            sliderContainerView.y = guideView.maxY + marginY
        } else {
            sliderContainerView.size = CGSize(width: containerView.width - guideView.maxX - marginX, height: containerView.height)
            sliderContainerView.x = guideView.maxX + marginX
            sliderContainerView.y = 0
        }
        
        let sliderSize = CGSize(width: sliderContainerView.width, height: 50)
        
        angleLabel.sizeToFit()
        angleLabel.origin = CGPoint.zero
        
        angleSlider.size = sliderSize
        angleSlider.origin = CGPoint(x: 0, y: angleLabel.maxY)
        
        anchorXLabel.sizeToFit()
        anchorXLabel.origin = CGPoint(x: 0, y: angleSlider.maxY + marginY)
        
        anchorXSlider.size = sliderSize
        anchorXSlider.origin = CGPoint(x: 0, y: anchorXLabel.maxY)
        
        positionLabel.sizeToFit()
        positionLabel.origin = CGPoint(x: 0, y: anchorXSlider.maxY + marginY)
        
        positionSlider.size = sliderSize
        positionSlider.origin = CGPoint(x: 0, y: positionLabel.maxY)
        
        updatePositionSliderIfNeeded()
    }
}
