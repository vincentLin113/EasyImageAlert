//
//  ImageAlertAction.swift
//  AlertPratice
//
//  Created by Vincent Lin on 2018/6/12.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit

class ImageAlertBaseCell: UICollectionViewCell {
    fileprivate var object: AlertElementConvertible? = nil
}
enum ImageAlertActionType {
    case title(_ :[AlertElementConvertible])
    case subTitle(_: [AlertElementConvertible])
}

public protocol ImageAlertActionDelegate: NSObjectProtocol {
    func didSelectedAction(_ cell: ImageAlertAction, object: AlertElementConvertible, index: Int)
}

public class ImageAlertAction: UICollectionViewCell {
    
    weak var delegate: ImageAlertActionDelegate? = nil
    
    var type: ImageAlertActionType? {
        didSet {
            guard let type = type else {
                return
            }
            switch type {
            case .title(let objects):
                self.actionObjects = objects
            case .subTitle(let objects):
                self.subtitleObjects = objects
            }
        }
    }
    
    public var actionObjects: [AlertElementConvertible] = [] {
        didSet {
            setupSubtitles(actionObjects)
        }
    }
    
    public var subtitleObjects: [AlertElementConvertible] = [] {
        didSet {
            setupSubtitles(subtitleObjects)
        }
    }
    
    @IBOutlet weak fileprivate var actionStackView: UIStackView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // For prevents button tap gesture interruped cell itself.
        actionStackView.isHidden = false
        actionStackView.axis = .vertical
        actionStackView.distribution = .fillEqually
    }
    
    fileprivate func generateAdjustedTitle(_ object: AlertElementConvertible) -> UIButton {
        let button = UIButton()
        button.setTitle(object.title, for: UIControlState())
        button.setTitleColor(object.titleTextColor, for: UIControlState())
        button.titleLabel?.font = object.titleFont
        button.titleLabel?.textAlignment = object.titleTextAlignment
        switch object.titleTextAlignment {
        case .left:
            button.contentHorizontalAlignment = .left
        case .center:
            button.contentHorizontalAlignment = .center
        case .right:
            button.contentHorizontalAlignment = .right
        default:
            break;
        }
        button.contentEdgeInsets = object.titleInset
        return button
    }
    
    fileprivate func styleButton(_ buttons: [UIButton]) -> [PaddingColorBackgroundButton] {
        if buttons.count <= 0 { return [] }
        var targetTypeButtons: [PaddingColorBackgroundButton] = []
        buttons.enumerated().forEach({
            let newType = PaddingColorBackgroundButton(buttonFrame: .zero, customSize: .zero)
            newType.translatesAutoresizingMaskIntoConstraints = false ;
            let width: CGFloat = frame.width / 2 * 0.73
            let height: CGFloat = 38
            newType.customSize = CGSize.init(width: width, height: height)
            newType.customRadius = height / 2
            newType.setTitleColor(.white, for: .normal)
            newType.backgroundColor = .clear
            newType.setTitleColor($1.titleColor(for: .normal), for: .normal)
            newType.setTitle($1.title(for: .normal), for: .normal)
            newType.titleLabel?.font = $1.titleLabel?.font
            newType.tag = $0
            newType.removeTarget(self, action: nil, for: .allEvents)
            newType.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
            newType.sizeToFit()
            targetTypeButtons.append(newType)
        })
        return targetTypeButtons
    }
    
    fileprivate func setupActionButton(_ object: AlertElementConvertible) {
        let titleButton = generateAdjustedTitle(object)
        actionStackView.addArrangedSubview(titleButton)
    }
    
    fileprivate func setupSubtitles(_ objects: [AlertElementConvertible]) {
        _ = actionStackView.arrangedSubviews.map({ $0.removeFromSuperview() })
        guard let type = type else { return }
        
        switch type {
        case .title(_):
            actionStackView.axis = .horizontal
            if objects.count > 0 {
                let buttons = styleButton(objects.map({ generateAdjustedTitle($0) }))
                buttons.forEach({ actionStackView.addArrangedSubview($0) })
            }
        case .subTitle(_):
            actionStackView.axis = .vertical
            if objects.count > 0 {
                objects.forEach({ actionStackView.addArrangedSubview( generateAdjustedTitle($0) ) })
            }
        }
        
    }
    
    @objc fileprivate func action(_ sender: UIButton) {
        guard let type = type else { return }
        switch type {
        case .subTitle(_):
            return ;
        case .title(let objects):
            if sender.tag >= objects.count { return }
            if delegate != nil {
                delegate?.didSelectedAction(self, object: objects[sender.tag], index: sender.tag)
            }
            return ;
        }
    }
    
    static func instanceFromXIB() -> ImageAlertAction? {
        return UINib.init(nibName: "ImageAlertAction", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ImageAlertAction
    }
}
