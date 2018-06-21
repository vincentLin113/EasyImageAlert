//
//  AlertActionConvertible.swift
//  AlertPratice
//
//  Created by Vincent Lin on 2018/6/12.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit

public protocol AlertElementConvertible {
    var title: String { get set }
    var titleFont: UIFont { get set }
    var titleTextColor: UIColor { get set }
    var titleTextAlignment: NSTextAlignment { get set }
    var titleInset: UIEdgeInsets { get set }
}

typealias AlertElementCluster = [[AlertElementConvertible]]

extension String: AlertElementConvertible {
    public var title: String {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    
    public var titleFont: UIFont {
        get {
            return  UIFont.systemFont(ofSize: 16.0)
        }
        set {
            titleFont = newValue
        }
    }
    public var titleTextColor: UIColor {
        get {
            return UIColor.white
        }
        set {
            titleTextColor = newValue
        }
    }
    public var titleTextAlignment: NSTextAlignment {
        get {
            return .center
        }
        set {
            titleTextAlignment = newValue
        }
    }
    public var titleInset: UIEdgeInsets {
        get {
            return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        set {
            titleInset = newValue
        }
    }
    
}


public struct AlertSubtitleModel: AlertElementConvertible {
    public var title: String
    
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 15.0)
    
    public var titleTextColor: UIColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    
    public var titleTextAlignment: NSTextAlignment = .center
    
    public var titleInset: UIEdgeInsets = UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)
    
    public var labelHeight: CGFloat = 27.0
    
    public init(title: String) {
        self.title = title
    }
}

public struct AlertActionModel: AlertElementConvertible {
    public var title: String = ""
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 16.0)
    public var titleTextColor: UIColor = UIColor.white
    public var titleTextAlignment: NSTextAlignment = .center
    public var titleInset: UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    init(title: String) {
        self.title = title
    }
}










