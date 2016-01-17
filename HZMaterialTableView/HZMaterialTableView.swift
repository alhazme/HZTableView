//
//  HZMaterialTableView.swift
//  HZMaterialDesign
//
//  Created by Moch Fariz Al Hazmi on 12/31/15.
//  Copyright © 2015 alhazme. All rights reserved.
//

import UIKit

@objc protocol HZMaterialTableViewDelegate {
    optional func materialHeaderFloatButtonTouched(materialHeaderFloatButton: UIButton)
}

class HZMaterialTableView: UITableView {
    
    // Delegate
    var materialDelegate: HZMaterialTableViewDelegate?
    
    // UIComponents
    var materialNavigationController: UINavigationController? {
        didSet {
            if let navigationController = self.materialNavigationController as? HZMaterialNavigationController {
                navigationController.visibility = .Visible
            }
        }
    }
    var materialHeaderView: UIView?
    var materialHeaderImageView: UIImageView?
    var materialHeaderFloatButton: HZMaterialButton?

    // UIComponent Value
    var height: CGFloat = 250 {
        didSet {
            setupMaterialHeaderView(height: height)
            setuMaterialHeaderImageView(height: height)
            setupMaterialHeaderFloatButton(width: buttonWidth, height: buttonWidth)
        }
    }
    var shadowColor: UIColor = UIColor.blackColor() {
        didSet {
            materialHeaderView!.layer.shadowColor = shadowColor.CGColor
        }
    }
    var shadowOpacity: Float = 0.2 {
        didSet {
            materialHeaderView!.layer.shadowOpacity = shadowOpacity
        }
    }
    var shadowRadius: CGFloat = 5.0 {
        didSet {
            materialHeaderView!.layer.shadowRadius = shadowRadius
        }
    }
    var shadowOffset: CGSize = CGSizeMake(0, 4.0) {
        didSet {
            materialHeaderView!.layer.shadowOffset = shadowOffset
        }
    }
    var borderWidth: CGFloat = 0.0 {
        didSet {
            materialHeaderView!.layer.borderWidth = borderWidth
        }
    }
    var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            materialHeaderView!.layer.borderColor = borderColor.CGColor
        }
    }
    var image: UIImage? {
        didSet {
            materialHeaderImageView?.image = image
            materialHeaderImageView?.contentMode = .ScaleAspectFill
        }
    }
    var buttonWidth: CGFloat = 48.0 {
        didSet {
            setupMaterialHeaderFloatButton(width: buttonWidth, height: buttonWidth)
        }
    }
    var buttonColor: UIColor = HZMaterialColor.yellow.base {
        didSet {
            materialHeaderFloatButton?.backgroundColor = buttonColor
        }
    }
    var buttonIcon: UIImage? {
        didSet {
            materialHeaderFloatButton?.setImage(buttonIcon, forState: .Normal)
        }
    }
    var topConstraint: [NSLayoutConstraint]!
    var leftConstraint: [NSLayoutConstraint]!
    var rightConstraint: [NSLayoutConstraint]!
    
    // Init
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setupMaterialHeaderView(height: height)
        setuMaterialHeaderImageView(height: height)
        setupMaterialHeaderFloatButton(width: buttonWidth, height: buttonWidth)
        addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupMaterialHeaderView(height: height)
        setuMaterialHeaderImageView(height: height)
        setupMaterialHeaderFloatButton(width: buttonWidth, height: buttonWidth)
        addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentOffset")
        materialNavigationController?.navigationBar.translucent = true
    }
    
    // Setup
    
    /**
     *  This method setup Header View
     *
     *  @author         Moch Fariz Al Hazmi
     *  @version        1.0.0
     *  @since          1.0.0
     *
     */
    
    private func setupMaterialHeaderView(height height: CGFloat) {
        if materialHeaderView != nil {
            materialHeaderView?.removeFromSuperview()
            materialHeaderView = nil
        }
        materialHeaderView = UIView(
            frame: CGRectMake(
                0,
                0,
                UIScreen.mainScreen().bounds.width,
                height
            )
        )
        materialHeaderView!.backgroundColor     = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        materialHeaderView!.layer.shadowColor   = shadowColor.CGColor
        materialHeaderView!.layer.shadowOpacity = shadowOpacity
        materialHeaderView!.layer.shadowRadius  = shadowRadius
        materialHeaderView!.layer.shadowOffset  = shadowOffset
        materialHeaderView!.layer.borderWidth   = borderWidth
        materialHeaderView!.layer.borderColor   = borderColor.CGColor
        tableHeaderView = nil
        self.addSubview(materialHeaderView!)
        contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        contentOffset = CGPoint(x: 0, y: -height)
        updateMaterialHeaderView()
    }
    
    /**
     *  This method setup Header Image View
     *
     *  @author         Moch Fariz Al Hazmi
     *  @version        1.0.0
     *  @since          1.0.0
     *
     */
    
    private func setuMaterialHeaderImageView(height height: CGFloat) {
        if materialHeaderImageView != nil {
            materialHeaderImageView?.removeFromSuperview()
            materialHeaderImageView = nil
        }
        materialHeaderImageView = UIImageView(
            frame: CGRectMake(
                0,
                0,
                UIScreen.mainScreen().bounds.width,
                height
            )
        )
        materialHeaderImageView!.contentMode = .ScaleAspectFill
        materialHeaderImageView!.image = UIImage(named: "image-background")
        materialHeaderImageView!.clipsToBounds = true
        materialHeaderView!.addSubview(materialHeaderImageView!)
    }
    
    /**
     *  This method setup Header Float Button
     *
     *  @author         Moch Fariz Al Hazmi
     *  @version        1.0.0
     *  @since          1.0.0
     *
     */
    
    private func setupMaterialHeaderFloatButton(width width: CGFloat, height: CGFloat) {
        if materialHeaderFloatButton != nil {
            materialHeaderFloatButton?.removeFromSuperview()
            materialHeaderFloatButton?.removeTarget(self, action: "materialFloatButtonTouched:", forControlEvents: .TouchUpInside)
            materialHeaderFloatButton = nil
        }
        materialHeaderFloatButton = HZMaterialButton(
            frame: CGRectMake(
                UIScreen.mainScreen().bounds.width - (15 + width),
                -(height / 2),
                width,
                height
            )
        )
        materialHeaderFloatButton!.image = UIImage(named: "icon-ticket")
        materialHeaderFloatButton!.backgroundColor = buttonColor
        materialHeaderFloatButton!.shape = .Circle
        materialHeaderFloatButton!.buttonPosition = .Right
        materialHeaderFloatButton!.addTarget(self, action: "materialFloatButtonTouched:", forControlEvents: .TouchUpInside)
        
        addSubview(materialHeaderFloatButton!)
    }
    
    /*
    private func updateButtonConstraint() {
        
        // Constraint
        
        materialHeaderFloatButton!.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary = ["button": materialHeaderFloatButton!]
        
        if topConstraint != nil {
            self.removeConstraints(topConstraint)
        }
        let topFormat = String(format:"V:|-(-%f)-[button(%f)]", (buttonWidth / 2), buttonWidth)
        topConstraint = NSLayoutConstraint.constraintsWithVisualFormat(topFormat, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        self.addConstraints(topConstraint)
        
        if materialHeaderFloatButton!.buttonPosition == .Right {
            if rightConstraint != nil {
                self.removeConstraints(rightConstraint)
            }
            let rightFormat = String(format:"H:|-(>=%f)-[button(%f)]-%f-|", (self.frame.size.width - (buttonWidth + 15)), buttonWidth, 15.0)
            rightConstraint = NSLayoutConstraint.constraintsWithVisualFormat(rightFormat, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
            self.addConstraints(rightConstraint)
        }
        else {
            if leftConstraint != nil {
                self.removeConstraints(leftConstraint)
            }
            let leftFormat = String(format:"H:|-%f-[button(%f)]", 15.0, buttonWidth)
            leftConstraint = NSLayoutConstraint.constraintsWithVisualFormat(leftFormat, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
            self.addConstraints(leftConstraint)
        }
    }
    */
    
    /**
     *  This method update Header View frame if list scrolled
     *
     *  @author         Moch Fariz Al Hazmi
     *  @version        1.0.0
     *  @since          1.0.0
     *
     */
    
    
    private func updateMaterialHeaderView() {
        var headerRect = CGRect(x: 0, y: -height, width: self.bounds.width, height: height)
        if self.contentOffset.y < -height {
            headerRect.origin.y = self.contentOffset.y
            headerRect.size.height = -self.contentOffset.y
        }
        materialHeaderView!.frame = headerRect
        if materialHeaderImageView != nil {
            headerRect.origin.y = 0
            materialHeaderImageView!.frame = headerRect
        }
    }
    
    /**
     *  This method handle hide / show button
     *
     *  @author         Moch Fariz Al Hazmi
     *  @version        1.0.0
     *  @since          1.0.0
     *
     */
    
    func hideShowButton() {
        if materialHeaderFloatButton != nil {
            let halfHeight = -(materialHeaderFloatButton!.frame.size.height / 2)
            if contentOffset.y >= halfHeight {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.materialHeaderFloatButton?.alpha = 0
                })
            }
            else {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.materialHeaderFloatButton?.alpha = 1.0
                })
            }
        }
    }
    
    /**
     *  This method handle hide / show navigation bar
     *
     *  @author         Moch Fariz Al Hazmi
     *  @version        1.0.0
     *  @since          1.0.0
     *
     */
    
    func hideShowNavigationBar() {
        if materialNavigationController != nil {
            let halfHeight = -(materialHeaderFloatButton!.frame.size.height)
            if contentOffset.y >= halfHeight {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    if let navigationController = self.materialNavigationController as? HZMaterialNavigationController {
                        navigationController.visibility = .Visible
                    }
                })
            }
            else {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    if let navigationController = self.materialNavigationController as? HZMaterialNavigationController {
                        navigationController.visibility = .Hidden
                    }
                })
            }
        }
    }
    
    // Delegate
    
    /**
    *  This method handle Float Button on touched
    *
    *  @author         Moch Fariz Al Hazmi
    *  @version        1.0.0
    *  @since          1.0.0
    *
    */
    
    func materialFloatButtonTouched(sender: UIButton) {
        self.materialDelegate?.materialHeaderFloatButtonTouched!(sender)
    }
    
    // KVO
    
    /**
    *  This method handle observe contentOffset value
    *
    *  @author         Moch Fariz Al Hazmi
    *  @version        1.0.0
    *  @since          1.0.0
    *
    */
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        updateMaterialHeaderView()
        hideShowButton()
        hideShowNavigationBar()
    }
    
    /**
     *  This method handle button position if change content size
     *
     *  @author         Moch Fariz Al Hazmi
     *  @version        1.0.0
     *  @since          1.0.0
     *
     */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if materialHeaderFloatButton != nil {
            var frame = materialHeaderFloatButton!.frame
            if materialHeaderFloatButton!.buttonPosition == .Right {
                frame.origin.x = UIScreen.mainScreen().bounds.width - (15 + buttonWidth)
                frame.origin.y = -(buttonWidth / 2)
                frame.size.width = buttonWidth
                frame.size.height = buttonWidth
            }
            else {
                frame.origin.x = 15
                frame.origin.y = -(buttonWidth / 2)
                frame.size.width = buttonWidth
                frame.size.height = buttonWidth
            }
            materialHeaderFloatButton!.frame = frame
        }
    }
}
