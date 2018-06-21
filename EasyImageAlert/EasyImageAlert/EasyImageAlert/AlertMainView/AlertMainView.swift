//
//  AlertMainView.swift
//  AlertPratice
//
//  Created by Vincent Lin on 2018/6/12.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit


public class AlertMainView: UIView {
    @IBOutlet weak var alertTitleLabel: UILabel!
    
    @IBOutlet weak var alertImageView: UIImageView?
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    public var actionObjects: [AlertElementConvertible] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func instanceFromXIB() -> AlertMainView? {
        return UINib.init(nibName: "AlertMainView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? AlertMainView
    }
    
}
