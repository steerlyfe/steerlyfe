//
//  OrderDetailProductInfoTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 07/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class OrderDetailProductInfoTVC: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    let TAG = "OrderDetailProductInfoTVC"
    
    var data : OrderProductInfo?
    var cellHeight : CGFloat = 50.0
    var logsList : [OrderProductLogDetail] = []
    var lastCheckedIndex = 0
    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var lastUpdatedAtLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusOuterView: UIView!
    @IBOutlet weak var statusHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.backgroundColor = UIColor.colorPrimaryDarkTrans
        CommonMethods.addRoundCornerFilled(uiview: buyButton, borderWidth: 1.0, borderColor: UIColor.black, backgroundColor: UIColor.white, cornerRadius: buyButton.frame.height / 2.0)
        CommonMethods.makeRoundImageView(imageView: productImage, cornerRadius: 10.0)
        CommonMethods.addRoundCornerFilled(uiview: statusOuterView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 10.0)
        CommonMethods.addRoundCornerFilled(uiview: statusLabel, borderWidth: 0.0, borderColor: UIColor.statusIndicatorLight, backgroundColor: UIColor.statusIndicatorLight, cornerRadius: statusLabel.frame.height / 2.0)
        statusLabel.textColor = UIColor.statusIndicatorDark
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : OrderProductInfo?, delegate : ButtonPressedAtPositionDelegate?, position : Int = 0) {
        self.data = data
        self.delegate = delegate
        self.position = position
        logsList = data?.status?.logsList ?? []
        productNameLabel.text = "\(data?.product_name ?? "") (\(data?.additional_feature ?? ""))"
        let salePrice = data?.sale_price ?? 0.0
        let additionalFeaturePrice = data?.additional_feature_price ?? 0.0
        var productPrice = salePrice + additionalFeaturePrice
        productPrice = CommonMethods.roundOffDouble(value: productPrice, roundOffDigits: 2)
        var totalPrice = productPrice * Double(data?.quantity ?? 0)
        totalPrice = CommonMethods.roundOffDouble(value: totalPrice, roundOffDigits: 2)
        CommonMethods.showLog(tag: TAG, message: "salePrice : \(salePrice)")
        CommonMethods.showLog(tag: TAG, message: "additionalFeaturePrice : \(additionalFeaturePrice)")
        CommonMethods.showLog(tag: TAG, message: "productPrice : \(productPrice)")
        CommonMethods.showLog(tag: TAG, message: "totalPrice : \(totalPrice)")
        priceLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\( productPrice )"
        productImage.sd_setImage(with: URL(string: data?.product_image ?? "" )) { (image, error, cacheType, url) in
        }
        quantityLabel.text = "Quantity : \(data?.quantity ?? 0)"
        totalPriceLabel.text = "\(MyConstants.CURRENCY_SYMBOL)\(productPrice) x \(data?.quantity ?? 0) = \(MyConstants.CURRENCY_SYMBOL)\(totalPrice)"
        statusHeightConstraint.constant = 100.0 + ( CGFloat(logsList.count) * cellHeight)
        updateStatus()
        setUI()
    }
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.BUY_AGAIN_PRESSED, position: position)
    }
    
    func setUI() {
        tableView.register(UINib(nibName: "OrderStatusIndicatorTVC", bundle: nil), forCellReuseIdentifier: "OrderStatusIndicatorTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusIndicatorTVC", for: indexPath) as! OrderStatusIndicatorTVC
        var nextData : OrderProductLogDetail?
        if indexPath.row < logsList.count - 1{
            nextData = logsList[indexPath.row + 1]
        }
        cell.setDetail(currentData: logsList[indexPath.row], nextData: nextData, currentIndex: indexPath.row, lastCheckedIndex: lastCheckedIndex)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func updateStatus() {
        lastCheckedIndex = -1
        statusLabel.text = CommonMethods.getStatusDisplayText(status: data?.status?.currentStatus)
        var timeStamp = NSDate().timeIntervalSince1970
        logsList.forEach({ (logValue) in
            if let isChecked = logValue.value{
                if isChecked{
                    if let timeValue = logValue.time{
                        timeStamp = timeValue
                    }
                    lastCheckedIndex = lastCheckedIndex + 1
                }
            }
        })
        lastUpdatedAtLabel.text = "Last Updated \(CommonMethods.getSpecialFormattedDate(format: "dd.MM.yyyy", timeStamp: timeStamp))"
    }
}
