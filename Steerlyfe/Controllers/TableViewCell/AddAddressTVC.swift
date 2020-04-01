//
//  AddAddressTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 06/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class AddAddressTVC: UITableViewCell, UITextFieldDelegate {
    
    let TAG = "AddAddressTVC"
    
    var addressDetail : AddressDetail?
    var delegate : ButtonPressedDelegate?
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var localityView: UIView!
    @IBOutlet weak var pincodeView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var localityTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var pincodeTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var callingCodeLabel: UILabel!
    @IBOutlet weak var callingCodeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        fullnameTextField.delegate = self
        countryTextField.delegate = self
        pincodeTextField.delegate = self
        addressTextField.delegate = self
        localityTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        CommonMethods.addRoundCornerStroke(uiview: callingCodeView, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: phoneNumberView, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        CommonMethods.addRoundCornerFilled(uiview: addAddressButton, borderWidth: 1.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: 20.0)
        
        CommonMethods.addRoundCornerStroke(uiview: emailView, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: nameView, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: countryView, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: pincodeView, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: addressView, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: localityView, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: cityView, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: stateView, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        setTextChange(textfield: phoneNumberTextField)
        setTextChange(textfield: emailTextField)
        setTextChange(textfield: fullnameTextField)
        setTextChange(textfield: countryTextField)
        setTextChange(textfield: pincodeTextField)
        setTextChange(textfield: addressTextField)
        setTextChange(textfield: localityTextField)
        setTextChange(textfield: cityTextField)
        setTextChange(textfield: stateTextField)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(addressDetail : AddressDetail?, delegate : ButtonPressedDelegate?) {
        self.addressDetail = addressDetail
        self.delegate = delegate
        callingCodeLabel.text = "+\(addressDetail?.calling_code ?? "")"
        phoneNumberTextField.text = addressDetail?.phone_number
        emailTextField.text = addressDetail?.email
        fullnameTextField.text = addressDetail?.name
        countryTextField.text = addressDetail?.country
        pincodeTextField.text = addressDetail?.pincode
        addressTextField.text = addressDetail?.address
        localityTextField.text = addressDetail?.locality
        cityTextField.text = addressDetail?.city
        stateTextField.text = addressDetail?.state
    }
    
    @IBAction func chooseCallingCode(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.CHOOSE_CALLING_CODE)
    }
    
    @IBAction func addAddressPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.ADD_ADDRESS)
    }
    
    func setTextChange(textfield : UITextField) {
        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == phoneNumberTextField{
            addressDetail?.phone_number = textField.text?.trimmingCharacters(in: .whitespaces)
        }else if textField == emailTextField{
            addressDetail?.email = textField.text?.trimmingCharacters(in: .whitespaces)
        }else if textField == fullnameTextField{
            addressDetail?.name = textField.text?.trimmingCharacters(in: .whitespaces)
        }else if textField == countryTextField{
            addressDetail?.country = textField.text?.trimmingCharacters(in: .whitespaces)
        }else if textField == pincodeTextField{
            addressDetail?.pincode = textField.text?.trimmingCharacters(in: .whitespaces)
        }else if textField == addressTextField{
            addressDetail?.address = textField.text?.trimmingCharacters(in: .whitespaces)
        }else if textField == localityTextField{
            addressDetail?.locality = textField.text?.trimmingCharacters(in: .whitespaces)
        }else if textField == cityTextField{
            addressDetail?.city = textField.text?.trimmingCharacters(in: .whitespaces)
        }else if textField == stateTextField{
            addressDetail?.state = textField.text?.trimmingCharacters(in: .whitespaces)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField{
            return canEdit(maxLength: 10, textField: textField, range: range, string: string)
        }else if textField == emailTextField{
            return canEdit(maxLength: 100, textField: textField, range: range, string: string)
        }else if textField == fullnameTextField{
            return canEdit(maxLength: 50, textField: textField, range: range, string: string)
        }else if textField == countryTextField{
            return canEdit(maxLength: 50, textField: textField, range: range, string: string)
        }else if textField == pincodeTextField{
            return canEdit(maxLength: 10, textField: textField, range: range, string: string)
        }else if textField == localityTextField{
            return canEdit(maxLength: 100, textField: textField, range: range, string: string)
        }else if textField == cityTextField{
            return canEdit(maxLength: 100, textField: textField, range: range, string: string)
        }else if textField == stateTextField{
            return canEdit(maxLength: 60, textField: textField, range: range, string: string)
        }else{
            return true
        }
    }
    
    func canEdit(maxLength : Int, textField : UITextField, range: NSRange, string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
