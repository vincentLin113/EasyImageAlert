//
//  JBImageAlert.swift
//  AlertPratice
//
//  Created by Vincent Lin on 2018/6/14.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit


/**
 The class just for using ImageAlert more easily.
 
 
 ---
 sample code:
 ```swift
 JBImageAlert.shared.callBack = self
 JBImageAlert.shared.showMessageNotification(self)
 ```
 
 */
public class EasyImageAlert: NSObject {
    
    weak var callBack: ImageAlertDelegate? = nil
    
    /// Singleton
    public static let shared: EasyImageAlert = EasyImageAlert()
    
    
    /**
     Show instant message notification permission alert.
     
     ---
     
     ```swift
      JBImageAlert.shared.showMessageNotification(self)
     
     ```
     
     - note:
     Do not dismiss when tap background view.
     
     - parameter from:           The viewController who call the method.
     - parameter subtitles:      The subtitles those below imageView.
     - parameter actionTitles:   Those action buttons title informations.
     
     */
    func showAlert(
        _ from: UIViewController,
        subtitles:[String] = ["Cute", "Puppy"],
        actionTitles:[String] = ["Corgi", "Pitbull"]) {
        let alert = ImageAlert.instanceFromXIB()
        alert?.modalPresentationStyle = .overFullScreen
        alert?.modalTransitionStyle = .crossDissolve
        
        var subtitleArray: [AlertElementConvertible] = []
        var actionArray: [AlertElementConvertible] = []
        subtitleArray = subtitles.map({ return AlertSubtitleModel.init(title: $0) })
        actionArray = actionTitles.map({ return AlertActionModel.init(title: $0) })
        
        alert?.configure(item: {
            let bundle = Bundle.init(for: EasyImageAlert.self)
            let image = UIImage(named: "resource.bundle/images/jobPuppy", in: bundle, compatibleWith: nil) ?? UIImage()
            $0.addImage(image).setActions([actionArray]).setAlertTitle("Choose an answer")
                .setCustomAlertTitleFont(UIFont.boldSystemFont(ofSize: 22))
                .setCustomCornerRadius(5.0)
                .setCustomScrollDirection(.vertical)
                .setImageTopInterval(22)
                .setImageLeftInterval(10)
                .setImageRightInterval(10)
                .setCustomSubtitleTopSpace(17.0)
                .setSubtitles([subtitleArray])
                .showAlert(from)
            $0.canDismissWhenTapBackgroundView = false ;
            $0.delegate = self.callBack
        })
    }
    
}

//MARK: - ImageAlertDelegate

extension EasyImageAlert: ImageAlertDelegate {
    internal func didSelectedAction(_ alert: ImageAlert, action: ImageAlertAction, actionObject: AlertElementConvertible, index: Int) {
        callBack?.didSelectedAction(alert, action: action, actionObject: actionObject, index: index)
    }
    
    internal func alertDidDismiss(_ alert: ImageAlert) {
        callBack?.alertDidDismiss(alert)
    }
}

