//
//  AddAddressVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 04/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import KVNProgress

class AddAddressVC: UIViewController, UITextFieldDelegate, AddNewAddressDelegate, UITableViewDelegate, UITableViewDataSource, ButtonPressedDelegate, CountrySelectionDelegate {
    
    let TAG = "AddAddressVC"
    let userDefaults = UserDefaults.standard
    
    var keyboardSize : CGFloat = 0
    var delegate : ChooseAddressDelegate?
    var addressDetail : AddressDetail?
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if MyConstants.FILL_STATIC_FORM{
            addressDetail = AddressDetail(address_id: "", calling_code: "+1", phone_number: "6505553434", name: "Paul Elliott", email: "paul@mind2matter.com", country: "United States of America", pincode: "123456", address: "Test Address", locality: "Near McDonald", city: "Miami", state: "Florida", isDefault: true)
        }else{
            addressDetail = AddressDetail(address_id: "", calling_code: "", phone_number: "", name: "", email: "", country: "", pincode: "", address: "", locality: "", city: "", state: "", isDefault: true)
        }
        addressDetail?.calling_code = userDefaults.string(forKey: MyConstants.CALLING_CODE)
        addressDetail?.name = userDefaults.string(forKey: MyConstants.FULL_NAME)
        addressDetail?.email = userDefaults.string(forKey: MyConstants.EMAIL)
        addressDetail?.phone_number = userDefaults.string(forKey: MyConstants.PHONE_NUMBER)
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        CommonMethods.dismissCurrentViewController()
    }
    
    func onAddressAdded(status: String, message: String, addressId: String?) {
        CommonMethods.showLog(tag: TAG, message: "onAddressAdded status : \(status)")
        CommonMethods.showLog(tag: TAG, message: "onAddressAdded message : \(message)")
        CommonMethods.showLog(tag: TAG, message: "onAddressAdded addressId : \(addressId ?? "")")
        switch status {
        case "1":
            addressDetail?.address_id = addressId
            KVNProgress.showSuccess(withStatus: message) {
                CommonMethods.dismissCurrentViewController()
                DispatchQueue.main.async {
                    self.delegate?.onAddressChoosed(type: MyConstants.NEW_ADDRESS_ADDED, addressDetail: self.addressDetail)
                }
            }            
            break
        default:
            MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "Ok")
            break
        }
    }
    
    func setUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "AddAddressTVC", bundle: nil), forCellReuseIdentifier: "AddAddressTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1200
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddAddressTVC", for: indexPath) as! AddAddressTVC
        cell.setDetail(addressDetail: addressDetail, delegate: self)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func onButtonPressed(type: String) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type)")
        switch type {
        case MyConstants.ADD_ADDRESS:
            var isValid = true
            var message = ""
            if addressDetail?.calling_code?.count == 0{
                isValid = false
                message = "Choose calling code"
            }else if addressDetail?.phone_number?.count == 0{
                isValid = false
                message = "Enter phone number"
            }else if addressDetail?.email?.count == 0{
                isValid = false
                message = "Enter email"
            }else if addressDetail?.name?.count == 0{
                isValid = false
                message = "Enter full name"
            }else if addressDetail?.country?.count == 0{
                isValid = false
                message = "Enter country name"
            }else if addressDetail?.pincode?.count == 0{
                isValid = false
                message = "Enter zip code"
            }else if addressDetail?.address?.count == 0{
                isValid = false
                message = "Enter address"
            }else if addressDetail?.city?.count == 0{
                isValid = false
                message = "Enter city name"
            }else if addressDetail?.state?.count == 0{
                isValid = false
                message = "Enter state"
            }else{
                isValid = true
            }
            if isValid{
                CommonWebServices.api.addAddress(navigationController: navigationController, calling_code: addressDetail?.calling_code ?? "", phone_number: addressDetail?.phone_number ?? "", email: addressDetail?.email ?? "", name: addressDetail?.name ?? "", country: addressDetail?.country ?? "", pincode: addressDetail?.pincode ?? "", address: addressDetail?.address ?? "", locality: addressDetail?.locality ?? "", city: addressDetail?.city ?? "", state: addressDetail?.state ?? "", delegate: self)
            }else{
                MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "Ok")
            }
            break
        case MyConstants.CHOOSE_CALLING_CODE:
            MyNavigations.goToChooseCountry(navigationController: navigationController, pageTitle: "Choose Calling Code", countrySelectionDelegate: self)
            break
        default:
            break
        }
    }
    
    func onCountrySelected(countryDetail: CountryDetail) {
        addressDetail?.calling_code = countryDetail.callingCode
        tableView.reloadData()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardSize == 0{
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.keyboardSize = keyboardSize.height
            }
        }
        bottomConstraint.constant = keyboardSize
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 10
    }
}
