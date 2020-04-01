//
//  CartVC.swift
//  Steerlyfe
//
//  Created by nap on 29/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//
import UIKit
import KVNProgress

class CartVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonPressedAtPositionDelegate, RefreshProductsListDelegate, ChooseAddressDelegate, AddressListDelegate, ConfirmationDialogDelegate, OnProcessCompleteDelegate, ApplyCouponDelegate{
    
    
    let TAG = "CartVC"
    let databaseMethods = DatabaseMethods()
    
    var keyboardSize : CGFloat = 0
    var data : [CartProductDetail] = []
    var mainControllerDelegate : OnProcessCompleteDelegate?
    var showBackArrow : Bool = false
    var selectedAddress : AddressDetail?
    var couponApplied = false
    var appliedCouponDetail : ApplyCouponResponse?
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var applyCouponButton: UIButton!
    @IBOutlet weak var applyCouponView: UIView!
    @IBOutlet weak var backArrowView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonMethods.addRoundCornerFilled(uiview: applyCouponView, borderWidth: 0.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: applyCouponView.frame.height / 2.0)
        CommonMethods.addRoundCornerFilled(uiview: checkoutView, borderWidth: 0.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: checkoutView.frame.height / 2.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backArrowView.isHidden = !showBackArrow
        data = databaseMethods.getAllCartProducts()
        CommonMethods.showLog(tag: TAG, message: "COUNT : \(data.count)")
        self.setUI()
        refreshData()
    }
    
    func setUI() {
        tableView.register(UINib(nibName: "CartProductListTVC", bundle: nil), forCellReuseIdentifier: "CartProductListTVC")
        tableView.register(UINib(nibName: "TotalPriceTVC", bundle: nil), forCellReuseIdentifier: "TotalPriceTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        //        CommonMethods.setTableViewSeperatorColor(tableView: tableView)
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return data.count
        case 1:
            return data.count > 0 ? 1 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartProductListTVC", for: indexPath) as! CartProductListTVC
            cell.setDetail(data: data[indexPath.row], delegate: self, position: indexPath.row, databaseMethods: databaseMethods)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalPriceTVC", for: indexPath) as! TotalPriceTVC
            cell.setDetail(cartProducts: data, couponApplied: couponApplied, appliedCouponDetail: appliedCouponDetail)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.REMOVE_ITEM:
            data.remove(at: position)
            tableView.reloadData()
            checkAndUpdateView()
            break
        case MyConstants.ADD_TO_CART:
            MyNavigations.goToProductDetail(navigationController: navigationController, productId: data[position].product_id, refreshProductsListDelegate: self)
            break
        case MyConstants.REFRESH_DATA:
            refreshData()
            break
        case MyConstants.VIEW_DETAIL:
            MyNavigations.goToProductDetail(navigationController: navigationController, productId: data[position].product_id, refreshProductsListDelegate: self)
            break
        default:
            break
        }
    }
    
    @IBAction func checkoutNow(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "checkoutNow")
        if isAddressRequired(){
            KVNProgress.show()
            CommonWebServices.api.allAddress(navigationController: navigationController, delegate: self)
        }else{
            prepareOrderJson()
        }
    }
    
    func isAddressRequired()->Bool {
        var required = false
        data.forEach { (innerData) in
            if innerData.available_type == MyConstants.PRODUCT_AVAILABLITY_DELIVER_NOW || innerData.available_type == MyConstants.PRODUCT_AVAILABLITY_SHIPPING{
                required = true
            }
        }
        return required
    }
    
    func refreshData() {
        data = databaseMethods.getAllCartProducts()
        tableView.reloadData()
        mainControllerDelegate?.onProcessComplete(type: MyConstants.REFRESH_CART_DATA, status: "1", message: "")
        checkAndUpdateView()
        if couponApplied{
            CommonWebServices.api.checkCouponWithOrder(navigationController: navigationController, coupon_id: appliedCouponDetail?.couponId ?? "", delegate: self,  closeViewController: false)
        }
    }
    
    func checkAndUpdateView()  {
        let count = data.count
        if count == 1 {
            itemCountLabel.text = "1 ITEM"
        }else{
            itemCountLabel.text = "\(count) ITEMS"
        }
        if data.count > 0{
            noDataMessage.isHidden = true
            //            bottomView.isHidden = false
            bottomViewHeight.constant = 110.0
        }else{
            noDataMessage.isHidden = false
            //            bottomView.isHidden = true
            bottomViewHeight.constant = 0.0
        }
        if couponApplied{
            applyCouponButton.setTitle("Remove Coupon".uppercased(), for: .normal)
        }else{
            applyCouponButton.setTitle("Apply Coupon".uppercased(), for: .normal)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        CommonMethods.dismissCurrentViewController()
    }
    
    func onProductRefreshCalled() {
        refreshData()
    }
    
    func onAddressChoosed(addressDetail: AddressDetail?) {
        self.selectedAddress = addressDetail
        prepareOrderJson()
    }
    
    func onAddressListReceived(status: String, message: String, data: AddressListResponse?) {
        CommonMethods.showLog(tag: TAG, message: "onAddressAdded status : \(status)")
        CommonMethods.showLog(tag: TAG, message: "onAddressAdded message : \(message)")
        CommonMethods.showLog(tag: TAG, message: "onAddressAdded address list count : \(data?.addressList.count ?? 0)")
        switch status {
        case "1":
            KVNProgress.dismiss {
                let addressList = data?.addressList ?? []
                if addressList.count > 0{
                    var outerAddressDetail :  AddressDetail?
                    addressList.forEach { (addressDetail) in
                        if addressDetail.isDefault ?? false{
                            outerAddressDetail = addressDetail
                        }
                    }
                    if let addressDetail = outerAddressDetail{
                        self.selectedAddress = addressDetail
                        self.showAddressConfirmation()
                    }else{
                        self.chooseNewAddress()
                    }
                }else{
                    self.chooseNewAddress()
                }
            }
            break
        default:
            KVNProgress.dismiss {
                MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "Ok")
            }
            break
        }
    }
    
    func onConfirmationButtonPressed(yesPressed: Bool) {
        if yesPressed{
            prepareOrderJson()
        }else{
            chooseNewAddress()
        }
    }
    
    func chooseNewAddress() {
        MyNavigations.goToAddressList(navigationController: self.navigationController, calledForChoose: true, delegate: self)
    }
    
    func prepareOrderJson() {
        var jsonCollection = [Any]()
        for loopValue in data {
            var dataCollection = [String:Any]()
            dataCollection["product_id"] = loopValue.product_id
            dataCollection["product_name"] = loopValue.product_name
            dataCollection["product_image"] = loopValue.image_url
            dataCollection["actual_price"] = loopValue.actual_price
            dataCollection["sale_price"] = loopValue.sale_price
            dataCollection["store_id"] = loopValue.store_id
            dataCollection["store_name"] = loopValue.store_name
            dataCollection["sub_store_id"] = loopValue.sub_store_id
            dataCollection["sub_store_address"] = loopValue.sub_store_address
            dataCollection["product_availability"] = loopValue.available_type
            dataCollection["product_availability_price"] = loopValue.additional_charges
            dataCollection["additional_feature"] = loopValue.additional_feature
            dataCollection["additional_feature_price"] = loopValue.additional_feature_price
            dataCollection["quantity"] = loopValue.quantity
            jsonCollection.append(dataCollection)
        }
        let finalJson = CommonMethods.prepareJson(from: jsonCollection) ?? "[]"
        CommonMethods.showLog(tag: TAG, message: "finalJson : \(finalJson)")
        let totalAmount = CommonMethods.getTotalPrice(data: data)
        let discountAmount = 0.0
        let amountPaid = totalAmount - discountAmount - (appliedCouponDetail?.discountAmount ?? 0.0)
//        CommonWebServices.api.placeOrder(navigationController: navigationController, total_amount: totalAmount, discount_amount: discountAmount, amount_paid: amountPaid, coupon_used: couponUsed, coupon_name: couponName, coupon_discount: couponDiscount, address_id: selectedAddress?.address_id ?? "", payment_info: "[]", order_info: finalJson, delegate: self)
        CommonWebServices.api.placeOrder(navigationController: navigationController, total_amount: totalAmount, discount_amount: discountAmount, amount_paid: amountPaid, coupon_used: couponApplied ? MyConstants.YES : MyConstants.NO, coupon_name: appliedCouponDetail?.couponCode ?? "", coupon_discount: couponApplied ? appliedCouponDetail?.discountAmount ?? 0.0 : 0.0, coupon_id: couponApplied ? appliedCouponDetail?.couponId ?? "" : "0", coupon_count: appliedCouponDetail?.couponCountCheck ?? MyConstants.NO, address_id: selectedAddress?.address_id ?? "", payment_info: "[]", order_info: finalJson, delegate: self)
    }
    
    func onProcessComplete(type: String, status: String, message: String) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) status : \(status) message : \(message)")
        switch type {
        case MyConstants.ORDER_PLACED:
            if status == "1"{
                KVNProgress.showSuccess(withStatus: message) {
                    if self.databaseMethods.deleteAllCartItems(){
                        CommonMethods.dismissCurrentViewController()
                    }
                }
            }else{
                MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "Ok")
            }
            break
        default:
            break
        }
    }
    
    func onAddressChoosed(type: String, addressDetail: AddressDetail?) {
        switch type {
        case MyConstants.CHOOSE_ADDRESS:
            self.selectedAddress = addressDetail
            showAddressConfirmation()
            break
        default:
            break
        }
    }
    
    func showAddressConfirmation()  {
        let message = """
        Your current shipping address is :
        \(CommonMethods.getAddressText(addressDetail: selectedAddress))
        Press continue to use this address.
        """
        CommonAlertMethods.showConfirmationAlert(navigationController: self.navigationController, title: MyConstants.APP_NAME, message: message, yesText: "Continue", noString: "Change Address", delegate: self)
    }
    
    @IBAction func applyCouponPressed(_ sender: Any) {
        if couponApplied{
            couponApplied = false
            tableView.reloadData()
            applyCouponButton.setTitle("Apply Coupon".uppercased(), for: .normal)
        }else{
            MyNavigations.goToCouponList(navigationController: navigationController, applyCouponDelegate: self)
        }
    }
    
    func onCouponApplied(applyCouponResponse: ApplyCouponResponse?) {
        switch(applyCouponResponse?.status ?? ""){
        case "1":
            couponApplied = true
            self.appliedCouponDetail = applyCouponResponse
            tableView.reloadData()
            break
        default:
            couponApplied = false
            tableView.reloadData()
            break
        }
    }
    
}
