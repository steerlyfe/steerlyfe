//
//  VerifyOtpVC.swift
//  Steerlyfe
//
//  Created by nap on 27/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import Firebase

class VerifyOtpVC: UIViewController, UITextFieldDelegate, OtpSendDelegate {
   
    let TAG = "VerifyOtpVC"
    
    var phoneNumber : String = ""
    var verificationID : String = ""
    var callingCode : String = ""
    
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    @IBOutlet weak var fifthTextField: UITextField!
    @IBOutlet weak var sixthTextField: UITextField!
    @IBOutlet weak var sixthView: UIView!
    @IBOutlet weak var fifthView: UIView!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonMethods.showLog(tag: TAG, message: "phoneNumber : \(phoneNumber)")
        setUI()
        if MyConstants.FILL_STATIC_FORM{
            firstTextField.text = "1"
            secondTextField.text = "2"
            thirdTextField.text = "3"
            fourthTextField.text = "4"
            fifthTextField.text = "5"
            sixthTextField.text = "6"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        CommonMethods.setNavigationBar(navigationController: navigationController, navigationItem: navigationItem, title: "Verify OTP")
    }
    
    func setUI() {
        let borderWidth : CGFloat = 1.0
        let borderColor = UIColor.colorPrimaryDark
        verifyButton.setTitleColor(UIColor.white, for: .normal)
        resendButton.setTitleColor(UIColor.colorPrimaryDark, for: .normal)
        CommonMethods.addRoundCornerStroke(uiview: firstView, borderWidth: borderWidth, borderColor: borderColor, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: secondView, borderWidth: borderWidth, borderColor: borderColor, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: thirdView, borderWidth: borderWidth, borderColor: borderColor, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: fourthView, borderWidth: borderWidth, borderColor: borderColor, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: fifthView, borderWidth: borderWidth, borderColor: borderColor, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: sixthView, borderWidth: borderWidth, borderColor: borderColor, cornerRadius: 5.0)
        CommonMethods.addRoundCornerFilled(uiview: verifyButton, borderWidth: 1.0, borderColor: UIColor.colorPrimaryDark, backgroundColor: UIColor.colorPrimaryDark, cornerRadius: 20.0)
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        fifthTextField.delegate = self
        sixthTextField.delegate = self
        setTextChangeTarget(textField: firstTextField)
        setTextChangeTarget(textField: secondTextField)
        setTextChangeTarget(textField: thirdTextField)
        setTextChangeTarget(textField: fourthTextField)
        setTextChangeTarget(textField: fifthTextField)
        setTextChangeTarget(textField: sixthTextField)
    }
    
    func setTextChangeTarget(textField : UITextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        CommonMethods.showLog(tag: TAG, message: "textFieldDidChange : \(textField.text ?? "")")
        switch textField {
        case firstTextField:
            changeTextFieldFocus(previousTextField: firstTextField, currentTextField: firstTextField, nextTextField: secondTextField)
            break
        case secondTextField:
            changeTextFieldFocus(previousTextField: firstTextField, currentTextField: secondTextField, nextTextField: thirdTextField)
            break
        case thirdTextField:
            changeTextFieldFocus(previousTextField: secondTextField, currentTextField: thirdTextField, nextTextField: fourthTextField)
            break
        case fourthTextField:
            changeTextFieldFocus(previousTextField: thirdTextField, currentTextField: fourthTextField, nextTextField: fifthTextField)
            break
        case fifthTextField:
            changeTextFieldFocus(previousTextField: fourthTextField, currentTextField: fifthTextField, nextTextField: sixthTextField)
            break
        case sixthTextField:
            changeTextFieldFocus(previousTextField: fifthTextField, currentTextField: sixthTextField, nextTextField: sixthTextField)
            break
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func changeTextFieldFocus(previousTextField : UITextField, currentTextField : UITextField, nextTextField : UITextField) {
        currentTextField.resignFirstResponder()
        if let text = currentTextField.text{
            if text.count == 0{
                previousTextField.becomeFirstResponder()
            }else{
                nextTextField.becomeFirstResponder()
            }
        }else{
            previousTextField.becomeFirstResponder()
        }
        CommonMethods.showLog(tag: TAG, message: "OTP : \(prepareOtpValue())")
    }
    
    func prepareOtpValue() -> String {
        return "\(firstTextField.text ?? "")\(secondTextField.text ?? "")\(thirdTextField.text ?? "")\(fourthTextField.text ?? "")\(fifthTextField.text ?? "")\(sixthTextField.text ?? "")"
    }
    
    @IBAction func resendCode(_ sender: Any) {
        CommonPhoneVerification.common.phoneVerification(callingCode: callingCode, phoneNumber: phoneNumber, delegate: self)
    }
    
    @IBAction func verifyButtonPressed(_ sender: Any) {
        let optValue = prepareOtpValue()
        if optValue.count < 6{
            MyNavigations.showCommonMessageDialog(message: "Enter otp", buttonTitle: "Ok")
        }else{
            CommonPhoneVerification.common.verifyOTP(navigationController: navigationController, callingCode: callingCode, phoneNumber: phoneNumber, otpValue: optValue, verificationID: verificationID)
        }
    }
    
    func onOtpSend(callingCode: String, phoneNumber: String, verificationID: String) {
        self.verificationID = verificationID
        MyNavigations.showCommonMessageDialog(message: "Verification code has been send to (+\(callingCode)) \(phoneNumber)", buttonTitle: "OK")
    }
    
}
