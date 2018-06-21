//
//  PaddingColorBackgroundButton.swift
//  AlertPratice
//
//  Created by Vincent Lin on 2018/6/13.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit

/**
 Build a easily custom view in button☺️
 */
public class PaddingColorBackgroundButton: UIButton {
    
    public enum PaddingColorBackgroundButtonAlignment {
        case top, left, bottom, right, center
    }
    
    var customViewAlignment: PaddingColorBackgroundButtonAlignment = .center
    
    public var customColor: UIColor = #colorLiteral(red: 0.1294117647, green: 0.5450980392, blue: 0.9137254902, alpha: 1) {
        didSet {
            setupViews()
        }
    }
    
    public var customRadius: CGFloat = 5.0 {
        didSet {
            setupViews()
        }
    }
    
    public var customSize: CGSize = .zero {
        didSet {
            setupViews()
        }
    }
    
    public var canShowColorView: Bool = true {
        didSet {
            setupViews()
        }
    }
    
    public var customCenterOffset: CGFloat = -7.0 {
        didSet {
            setupViews()
        }
    }
    
    var image: UIImage? {
        get {
            return image(for: UIControlState())
        }
    }
    
    var title: String? {
        get {
            return title(for: UIControlState())
        }
    }
    
    var titleColor: UIColor? {
        get {
            return titleColor(for: UIControlState())
        }
    }

    var titleFont: UIFont? {
        get {
            return self.titleLabel?.font
        }
    }
    
    fileprivate let colorButton: UIButton = {
       let _colorButton = UIButton()
        _colorButton.backgroundColor = .clear
        _colorButton.isHidden = true
        // 別搶走主要按鈕的點擊範圍
        _colorButton.isUserInteractionEnabled = false
        return _colorButton
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(
        buttonFrame: CGRect,
        customSize: CGSize,
        customAlignment: PaddingColorBackgroundButtonAlignment = .center
        ) {
        self.init(frame: buttonFrame)
        self.customSize = customSize
        self.customViewAlignment = customAlignment
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
}

fileprivate extension PaddingColorBackgroundButton {
    
    func configure() {
        // 隱藏底層title
        self.titleLabel?.isHidden = true
        self.titleLabel?.textColor = .clear
        colorButton.removeFromSuperview()
        addSubview(colorButton)
    }
    
    func setupViews() {
        colorButton.backgroundColor = customColor
        colorButton.clipsToBounds = true
        colorButton.layer.cornerRadius = customRadius
        let centerX: CGFloat = (frame.width - customSize.width) / 2
        let adjustedOriginalX = self.tag % 2 == 0 // tag = indexPath.row, 故能被整除的才是奇數(因為01234...)
        ? centerX - customCenterOffset
        : centerX + customCenterOffset
        let adjustedOriginalY = (frame.height - customSize.height) / 2
        colorButton.frame = CGRect(
            x: adjustedOriginalX,
            y: adjustedOriginalY,
            width: customSize.width,
            height: customSize.height)
        
        colorButton.setImage(image, for: UIControlState())
        colorButton.setTitle(title, for: UIControlState())
        colorButton.setTitleColor(titleColor, for: UIControlState())
        colorButton.titleLabel?.font = titleFont
        
        updateColorView()
        
        layoutIfNeeded()
    }
    
    func updateColorView() {
        // 若隱藏colorButton, 就打開titleLabel
        self.colorButton.isHidden = !canShowColorView
        self.titleLabel?.isHidden = canShowColorView
        self.titleLabel?.textColor = canShowColorView ? UIColor.clear : titleColor
    }
}
























