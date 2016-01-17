//
//  HZMaterialButton.swift
//  HZMaterialDesign
//
//  Created by Moch Fariz Al Hazmi on 12/31/15.
//  Copyright © 2015 alhazme. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@objc protocol HZMaterialButtonDelegate {
    
}

enum Shape {
    case Default
    case Circle
    case Square
}

class HZMaterialButton: UIButton {

    var materialDelegate: HZMaterialButtonDelegate?
    
    var x: CGFloat = 0 {
        didSet {
            layer.frame.origin.x = x
        }
    }
    var y: CGFloat = 0 {
        didSet {
            layer.frame.origin.y = y
        }
    }
    var width: CGFloat = 48 {
        didSet {
            layer.frame.size.width = width
            if shape != .None {
                layer.frame.size.height = width
            }
            setupLayer()
        }
    }
    var height: CGFloat = 48 {
        didSet {
            layer.frame.size.height = height
            if shape != .None {
                layer.frame.size.width = height
            }
            setupLayer()
        }
    }
    var image: UIImage? {
        didSet {
            setImage(image, forState: .Normal)
        }
    }
    var imageHighlighted: UIImage? {
        didSet {
            setImage(imageHighlighted, forState: .Highlighted)
        }
    }
    var shape: Shape? {
        didSet {
            if shape != .None {
                if width < height {
                    frame.size.width = height
                }
                else {
                    frame.size.height = width
                }
                setupLayer()
            }
        }
    }
    var shadowColor: UIColor = UIColor.blackColor() {
        didSet {
            layer.shadowColor = shadowColor.CGColor
        }
    }
    var shadowOpacity: Float = 0.2 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    var shadowRadius: CGFloat = 5.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    var shadowOffset: CGSize = CGSizeMake(0, 4.0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    enum Position {
        case Left
        case Right
    }
    var buttonPosition: Position = .Right
    
    
    var pulseEffectView = UIView()
    var pulseEffectBackgroundView = UIView()
    var pulseEffectPercent: Float = 0.8 {
        didSet {
            setupPulseEffect()
        }
    }
    var pulseEffectColor: UIColor = UIColor(white: 0.9, alpha: 0.5) {
        didSet {
            pulseEffectView.backgroundColor = pulseEffectColor
        }
    }
    var pulseEffectBackgroundColor: UIColor = UIColor(white: 0.95, alpha: 0.3) {
        didSet {
            pulseEffectBackgroundView.backgroundColor = pulseEffectBackgroundColor
        }
    }
    var pulseEffectOverBounds: Bool = false
    var pulseEffectShadowRadius: Float = 1.0
    var pulseEffectShadowEnable: Bool = true
    var pulseEffectTrackTouchLocation: Bool = true
    var pulseEffectTouchUpAnimationTime: Double = 0.6
    var pulseEffectTempShadowRadius: CGFloat = 0
    var pulseEffectTempShadowOpacity: Float = 0
    var pulseEffectTouchCenterLocation: CGPoint?
    var pulseEffectLayer: CAShapeLayer? {
        get {
            if !pulseEffectOverBounds {
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).CGPath
                return maskLayer
            }
            else {
                return nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        setupPulseEffect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
        setupPulseEffect()
    }
    
    func setupLayer() {
        layer.shadowColor = shadowColor.CGColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        if shape == .Circle {
            layer.cornerRadius = width / 2
        }
    }
    
    func setupPulseEffect() {
        setupPulseEffectView()
        setupPulseEffectBackgroundView()
    }
    
    func setupPulseEffectView() {
        let pulseEffectSize                = CGRectGetWidth(bounds) * CGFloat(pulseEffectPercent)
        let pulseEffectX                   = (CGRectGetWidth(bounds) / 2) - (pulseEffectSize / 2)
        let pulseEffectY                   = (CGRectGetHeight(bounds) / 2) - (pulseEffectSize / 2)
        let corner                         = pulseEffectSize / 2
        pulseEffectView.backgroundColor    = pulseEffectColor
        pulseEffectView.frame              = CGRectMake(pulseEffectX, pulseEffectY, pulseEffectSize, pulseEffectSize)
        pulseEffectView.layer.cornerRadius = corner
    }
    
    func setupPulseEffectBackgroundView() {
        pulseEffectBackgroundView.backgroundColor  = pulseEffectBackgroundColor
        pulseEffectBackgroundView.frame = bounds
        layer.addSublayer(pulseEffectBackgroundView.layer)
        pulseEffectBackgroundView.layer.addSublayer(pulseEffectView.layer)
        pulseEffectBackgroundView.alpha = 0
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).CGColor
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        pulseEffectTouchCenterLocation = touch.locationInView(self)
        
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.pulseEffectBackgroundView.alpha = 1
        }, completion: nil)
        pulseEffectView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        UIView.animateWithDuration(0.7, delay: 0, options: [UIViewAnimationOptions.CurveEaseOut, UIViewAnimationOptions.AllowUserInteraction],
            animations: {
            self.pulseEffectView.transform = CGAffineTransformIdentity
        }, completion: nil)
        
        if pulseEffectShadowEnable {
            
            pulseEffectTempShadowRadius = layer.shadowRadius
            pulseEffectTempShadowOpacity = layer.shadowOpacity
            
            let shadowAnimate = CABasicAnimation(keyPath: "shadowRadius")
            shadowAnimate.toValue = pulseEffectShadowRadius

            let opacityAnimate = CABasicAnimation(keyPath: "shadowOpacity")
            opacityAnimate.toValue = 1
            
            let groupAnimate = CAAnimationGroup()
            groupAnimate.duration = 0.7
            groupAnimate.fillMode = kCAFillModeForwards
            groupAnimate.removedOnCompletion = false
            groupAnimate.animations = [shadowAnimate, opacityAnimate]
            layer.addAnimation(groupAnimate, forKey: "shadow")
        }
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        super.cancelTrackingWithEvent(event)
        animateToNormal()
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        animateToNormal()
    }
    
    func animateToNormal() {
        
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.pulseEffectBackgroundView.alpha = 1
            }, completion: {(success: Bool) -> () in
                UIView.animateWithDuration(self.pulseEffectTouchUpAnimationTime, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    self.pulseEffectBackgroundView.alpha = 0
                }, completion: nil)
        })
        
        UIView.animateWithDuration(0.7, delay: 0,
            options: [.CurveEaseOut, .BeginFromCurrentState, .AllowUserInteraction],
            animations: {
                self.pulseEffectView.transform = CGAffineTransformIdentity
                
                let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
                shadowAnim.toValue = self.pulseEffectTempShadowRadius
                
                let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
                opacityAnim.toValue = self.pulseEffectTempShadowOpacity
                
                let groupAnim = CAAnimationGroup()
                groupAnim.duration = 0.7
                groupAnim.fillMode = kCAFillModeForwards
                groupAnim.removedOnCompletion = false
                groupAnim.animations = [shadowAnim, opacityAnim]
                
                self.layer.addAnimation(groupAnim, forKey:"shadowBack")
            }, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupPulseEffectView()
        if let knownTouchCenterLocation = pulseEffectTouchCenterLocation {
            pulseEffectView.center = knownTouchCenterLocation
        }
        
        pulseEffectBackgroundView.layer.frame = bounds
        pulseEffectBackgroundView.layer.mask = pulseEffectLayer
    }
}