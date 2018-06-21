//
//  ViewController.swift
//  EasyImageAlert
//
//  Created by Vincent Lin on 2018/6/21.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let button: UIButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        button.frame = CGRect(x: 0.0,
                              y: 100.0,
                              width: view.frame.size.width,
                              height: 50.0)
        button.setTitle("Show Alert", for: UIControlState())
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func showAlert() {
        EasyImageAlert.shared.callBack = self
        EasyImageAlert.shared.showAlert(self)
    }
}

extension ViewController: ImageAlertDelegate {
    func didSelectedAction(_ alert: ImageAlert, action: ImageAlertAction, actionObject: AlertElementConvertible, index: Int) {
        print("\(#function)")
//        alert.doDismiss()
    }
    
    func alertDidDismiss(_ alert: ImageAlert) {
        print("\(#function)")
    }
}
