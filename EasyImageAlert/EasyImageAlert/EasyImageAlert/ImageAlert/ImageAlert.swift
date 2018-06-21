//
//  ImageAlertController.swift
//  AlertPratice
//
//  Created by Vincent Lin on 2018/6/11.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit



internal protocol ImageAlertDelegate: NSObjectProtocol {
    func didSelectedAction(_ alert: ImageAlert, action: ImageAlertAction, actionObject: AlertElementConvertible, index: Int)
    func alertDidDismiss(_ alert: ImageAlert)
}


internal class ImageAlert: UIViewController {
    
    
    @IBOutlet weak var alerTitleLabel: UILabel?
    @IBOutlet weak var alertImageView: AlertMainView?
    @IBOutlet weak var backgroundDismissButton: UIButton!
    
    @IBOutlet weak fileprivate var centerY: NSLayoutConstraint!
    @IBOutlet weak fileprivate var heightRatioFromView: NSLayoutConstraint!
//    @IBOutlet weak fileprivate var leftInterval: NSLayoutConstraint!
//    @IBOutlet weak fileprivate var rightInterval: NSLayoutConstraint!
    @IBOutlet weak var alertTitleLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak fileprivate var alertTitleTopInterval: NSLayoutConstraint!
    fileprivate let numberOfSections = 2
    
    @IBOutlet weak var subtitleTopInterval: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeftInterval: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightPercentOfView: NSLayoutConstraint?
    @IBOutlet weak fileprivate var imageViewRightInterval: NSLayoutConstraint?
    @IBOutlet weak fileprivate var imageViewTopInterval: NSLayoutConstraint?
    public typealias ImageAlertConfigure = ( (ImageAlert) -> () )
    public var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.setupViewCornerRadious(cornerRadius)
        }
    }
    public var alertImage: UIImage? = nil {
        didSet {
            guard let image = alertImage else { return }
            setupImage(image)
        }
    }
    public var actionModels: [[AlertElementConvertible]] = [] {
        didSet {
            DispatchQueue.main.async {
                self.alertImageView?.collectionView?.reloadData()
            }
        }
    }
    public var subtitleModels: [[AlertSubtitleModel]] = [] {
        didSet {
            DispatchQueue.main.async {
                self.alertImageView?.collectionView?.reloadData()
            }
        }
    }
    public var scrollDirection: UICollectionViewScrollDirection = .vertical
    public var alertTitleText: String = "Alert" {
        didSet {
            setupTitleLabelText(alertTitleText)
        }
    }
    public var alertTextColor: UIColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1) {
        didSet {
            setupTitleLabelTextColor(alertTextColor)
        }
    }
    public var alertTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 22) {
        didSet {
            setupTitleFont(alertTitleFont)
        }
    }
    public var canDismissWhenTapBackgroundView = false {
        didSet {
            updateBackgroundTapView(canDismissWhenTapBackgroundView)
        }
    }
    public var titleTopInterval: CGFloat = 10.0 {
        didSet {
            self.alertTitleTopInterval.constant = titleTopInterval
        }
    }
    public var imageViewLeftIntervalSpace: CGFloat = 10.0
    public var imageViewTopIntervalSpace: CGFloat = 10.0
    public var imageViewRightIntervalSpace: CGFloat = 10.0
    public var subtitleTopSpace: CGFloat = 17.0
    
    weak var delegate: ImageAlertDelegate? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViews()
    }

    private func setupCollectionView() {
        self.alertImageView?.collectionView?.register(UINib.init(nibName: "ImageAlertAction", bundle: nil), forCellWithReuseIdentifier: "ImageAlertAction")
        self.alertImageView?.collectionView?.dataSource = self
        self.alertImageView?.collectionView?.delegate = self
        self.alertImageView?.collectionView?.isScrollEnabled = true
    }
}

internal extension ImageAlert {
    
    @discardableResult
    func configure(item: ImageAlertConfigure) -> Self {
        item(self)
        return self
    }
    
    @discardableResult
    func addImage(_ image: UIImage) -> Self {
        self.alertImage = image
        return self
    }
    
    @discardableResult
    func setActions(_ actions: [[AlertElementConvertible]]) -> Self {
        self.actionModels.removeAll()
        self.actionModels = actions
        return self
    }
    
    @discardableResult
    func setSubtitles(_ subtitles: [[AlertElementConvertible]]) -> Self {
        self.subtitleModels.removeAll()
        if let subtitleModels = subtitles as? [[AlertSubtitleModel]] {
            self.subtitleModels = subtitleModels
        }
        return self
    }
    
    @discardableResult
    func setCustomCornerRadius(_ radius: CGFloat) -> Self {
        self.cornerRadius = radius
        return self
    }
    
    @discardableResult
    func setCustomScrollDirection(_ direction: UICollectionViewScrollDirection) -> Self {
        self.scrollDirection = direction
        return self
    }
    
    @discardableResult
    func setAlertTitle(_ alerTitle: String) -> Self {
        self.alertTitleText = alerTitle
        return self
    }
    
    @discardableResult
    func setCustomAlertTitleFont(_ font: UIFont) -> Self {
        self.alertTitleFont = font
        return self
    }
    
    @discardableResult
    func setAlertTitleTextColor(_ color: UIColor) -> Self {
        self.alertTextColor = color
        return self
    }
    
    @discardableResult
    func showAlert(_ view: UIViewController, animated: Bool = true) {
        view.present(self, animated: animated, completion: nil)
    }
    
    @discardableResult
    func setImageLeftInterval(_ space: CGFloat) -> Self {
        self.imageViewLeftIntervalSpace = space
        return self
    }
    
    @discardableResult
    func setImageRightInterval(_ space: CGFloat) -> Self {
        self.imageViewRightIntervalSpace = space
        return self
    }
    
    @discardableResult
    func setImageTopInterval(_ space: CGFloat) -> Self {
        self.imageViewTopIntervalSpace = space
        return self
    }
    
    @discardableResult
    func setCustomSubtitleTopSpace(_ space: CGFloat) -> Self {
        self.subtitleTopSpace = space
        return self
    }
    
    @objc func doDismiss() {
        dismiss(animated: true) {
            if self.delegate != nil {
                self.delegate?.alertDidDismiss(self)
            }
        }
    }
}

//MARK: -

fileprivate extension ImageAlert {
    
    
    func setupViews() {
        setupViewCornerRadious(self.cornerRadius)
        setupImage(self.alertImage ?? UIImage())
        setupActions(actionModels)
        setupTitleLabelText(alertTitleText)
        setupTitleLabelTextColor(alertTextColor)
        setupTitleFont(alertTitleFont)
        updateBackgroundTapView(canDismissWhenTapBackgroundView)
        self.alertTitleTopInterval.constant = titleTopInterval
        self.imageViewTopInterval?.constant = imageViewTopIntervalSpace
        self.imageViewLeftInterval?.constant = imageViewLeftIntervalSpace
        self.imageViewRightInterval?.constant = imageViewRightIntervalSpace
        self.subtitleTopInterval.constant = subtitleTopSpace
    }
    
    func setupViewCornerRadious(_ radius: CGFloat) {
        alertImageView?.clipsToBounds = true
        alertImageView?.layer.cornerRadius = radius
    }
    
    func setupActions(_ actions: AlertElementCluster) {
        self.alertImageView?.actionObjects.removeAll()
        DispatchQueue.main.async {
            self.alertImageView?.collectionView?.reloadData()
        }
    }
    
    func setupImage(_ image: UIImage) {
        self.alertImageView?.alertImageView?.image = nil
        self.alertImageView?.alertImageView?.image = image
    }
    
    func setupTitleLabelText(_ text: String) {
        self.alerTitleLabel?.text = text
    }
    
    func setupTitleLabelTextColor(_ textColor: UIColor) {
        self.alerTitleLabel?.textColor = textColor
    }
    
    func updateBackgroundTapView(_ canDismiss: Bool) {
        backgroundDismissButton.removeTarget(self, action: nil, for: .allEvents)
        if canDismiss {
            backgroundDismissButton.addTarget(self, action: #selector(doDismiss), for: .touchUpInside)
        }
    }
    
    func setupTitleFont(_ font: UIFont) {
        self.alerTitleLabel?.font = font
    }
}


//MARK: - UICollectionViewDataSource

extension ImageAlert: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < 0 || section > numberOfSections { return 0 }
        switch section {
        case 0:
            return subtitleModels.count > 0 ? 1 : 0
        case 1:
            return actionModels.count > 0 ? 1 : 0
        default:
            assert(false, "The collection sections have error.")
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section < 0 || indexPath.section > numberOfSections { return UICollectionViewCell() }
        // todo: Build up section 1.
        switch indexPath.section {
        case 0:
            return getAlertSubtitle(collectionView,cellForItemAt: indexPath)
        case 1 :
            return getAlertAction(collectionView, cellForItemAt: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    private func getAlertSubtitle(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAlertAction", for: indexPath) as? ImageAlertAction else {
            return UICollectionViewCell()
        }
        if subtitleModels.count > indexPath.item {
            cell.type = ImageAlertActionType.subTitle(subtitleModels[indexPath.item])
        }
        return cell
    }
    
    private func getAlertAction(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAlertAction", for: indexPath) as? ImageAlertAction else {
            return UICollectionViewCell()
        }
        if actionModels.count > indexPath.item {
            cell.type = ImageAlertActionType.title(actionModels[indexPath.item])
        }
        cell.delegate = self;
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ImageAlert: UICollectionViewDelegate {}


//MARK: - UICollectionViewDelegateFlowLayout

extension ImageAlert: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let _ = self.alertImageView?.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        if subtitleModels.count > 0, indexPath.section == 0 {
            let allHeight = subtitleModels[indexPath.item].map({ $0.labelHeight }).reduce(0.0, +)
            return CGSize(width: self.alertImageView?.frame.width ?? 0.0, height: allHeight)
        }
        switch scrollDirection {
        case .horizontal:
            let alertViewWidth: CGFloat = self.alertImageView?.frame.width ?? 0.0
            let singleActionWidth: CGFloat = alertViewWidth / CGFloat(actionModels.count)
            return CGSize(width: singleActionWidth ,
                          height: self.alertImageView?.frame.height ?? 0.0)
        case .vertical:
            let alertViewHeight: CGFloat = self.alertImageView?.collectionView?.frame.height ?? 0.0
            let singleActionHeight: CGFloat = alertViewHeight / CGFloat(actionModels.count)
            // IMPORTANT: 54為seciton0 cellHeight, 這種寫法很不好, 請找時間修正喔
            return CGSize(width: self.alertImageView?.frame.width ?? 0.0,
                          height: singleActionHeight - 54.0)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}


//MARK: - ImageAlertActionDelegate
extension ImageAlert: ImageAlertActionDelegate {
    
    public func didSelectedAction(_ cell: ImageAlertAction, object: AlertElementConvertible, index: Int) {
        delegate?.didSelectedAction(self, action: cell, actionObject: object, index: index)
    }
    
}

//MARK: -
extension ImageAlert {
    
    static func instanceFromXIB() -> ImageAlert? {
        return ImageAlert.init(nibName: "ImageAlert", bundle: nil)
    }
}








