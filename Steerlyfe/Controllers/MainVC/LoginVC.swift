//
//  LoginVC.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextViewDelegate, CountrySelectionDelegate, UITextFieldDelegate, OtpSendDelegate {
    
    let TAG  = "LoginVC"
    let databaseMethods = DatabaseMethods()
    let userDefaults = UserDefaults.standard
    private var termsHeightObserver: NSKeyValueObservation?
    var countryDetail : CountryDetail?
    var calledFrom = ""
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var termsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var termConditionTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var countryCodeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.delegate.setUpFirebase()
        setupUI()
        var shortCode = "US"
        let currentLocale = NSLocale.current
        let value : String = currentLocale.identifier
        if value.count >= 2{
            shortCode = String(value.suffix(2))
        }
        CommonMethods.showLog(tag: TAG, message: "shortCode : \(shortCode)")
        if MyConstants.FILL_STATIC_FORM{
            shortCode = "US"
            phoneNumber.text = "6505553434"
        }
        if let countryDetail = databaseMethods.getCurrentCountry(shortCode: shortCode){
            onCountrySelected(countryDetail: countryDetail)
        }else{
            CommonMethods.showLog(tag: TAG, message: "Country Detail not available")
            countryCodeLabel.text = ""
        }
        phoneNumber.delegate = self
//        let verificationID = UserDefaults.standard.string(forKey: MyConstants.AUTH_VERIFICATION_ID)
//        if verificationID != ""{
//            MyNavigations.goToVerifyOtp(navigationController: self.navigationController, phoneNumber: phoneNumber)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        var pageTitle = ""
        if calledFrom == "login"{
            pageTitle = "Login"
        }else{
            pageTitle = "Phone Verification"
        }
        CommonMethods.setNavigationBar(navigationController: navigationController, navigationItem: navigationItem, title: pageTitle)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if self.countryDetail != nil{
            if let phone = phoneNumber.text?.trimmingCharacters(in: .whitespaces){
                if phone.count >= 10{
                    showChooserOption(callingCode: countryDetail?.callingCode ?? "", phoneNumber: phone)
                }else{
                    MyNavigations.showCommonMessageDialog(message: "Enter valid phone number", buttonTitle: "OK")
                }
            }else{
                MyNavigations.showCommonMessageDialog(message: "Enter phone number", buttonTitle: "OK")
            }
        }else{
            MyNavigations.showCommonMessageDialog(message: "Choose country code", buttonTitle: "OK")
        }
    }
    
    private func setupUI() {
        submitButton.setTitleColor(UIColor.white, for: .normal)
        CommonMethods.addRoundCornerStroke(uiview: countryCodeView, borderWidth: 1.0, borderColor: UIColor.colorPrimaryDark, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: phoneNumberView, borderWidth: 1.0, borderColor: UIColor.colorPrimaryDark, cornerRadius: 5.0)
        CommonMethods.addRoundCornerFilled(uiview: submitButton, borderWidth: 1.0, borderColor: UIColor.colorPrimaryDark, backgroundColor: UIColor.colorPrimaryDark, cornerRadius: 20.0)
        
        if calledFrom == "login"{
            let text = "By clicking 'Verify Account' you are agree to our Terms & Conditions and Privacy Policy."
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.font,
                                          value: UIFont.systemFont(ofSize: 13),
                                          range: NSRange(location: 0, length: text.count))
            
            let range1 = (text as NSString).range(of: "Privacy Policy")
            attributedString.addAttribute(.link, value: MyConstants.privacyAndPolicyURL, range: range1)
            let range2 = (text as NSString).range(of: "Terms & Conditions")
            attributedString.addAttribute(.link, value: MyConstants.termsAndConditionsURL, range: range2)
            
            termConditionTextView.attributedText = attributedString
            termConditionTextView.linkTextAttributes = ([
                NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: 13),
                NSAttributedString.Key.foregroundColor.rawValue: UIColor.colorPrimaryDark
                ] as! [NSAttributedString.Key : Any])
            
//            termsHeightObserver = termConditionTextView
//                .observe(\.contentSize,
//                         changeHandler: { [unowned self] (_, change) in
//                            guard let newHeight = change.newValue?.height else { return }
//                            self.termsHeightConstraint.constant = newHeight
//                })
            termsHeightConstraint.constant = termConditionTextView.contentSize.height
            termConditionTextView.textContainerInset = .zero
            if #available(iOS 11.0, *) {
                termConditionTextView.textDragInteraction?.isEnabled = false
            }
            //        termConditionTextView.backgroundColor = UIColor(white: 1, alpha: 0.1)
            termConditionTextView.textAlignment = .center
            termConditionTextView.delegate = self
        }else{
            termsHeightConstraint.constant = 0
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        switch URL {
        case MyConstants.privacyAndPolicyURL:
            CommonMethods.showLog(tag: TAG, message: "Privacy Policy")
            return false
        case MyConstants.termsAndConditionsURL:
            CommonMethods.showLog(tag: TAG, message: "Terms & Conditions")
            return false
        default:
            return true
        }
    }
//
//    func textView(_ textView: UITextView,
//                  shouldInteractWith URL: URL,
//                  in characterRange: NSRange,
//                  interaction: UITextItemInteraction) -> Bool {
//        switch URL {
//        case MyConstants.privacyAndPolicyURL:
//            CommonMethods.showLog(tag: TAG, message: "Privacy Policy")
//            return false
//        case MyConstants.termsAndConditionsURL:
//            CommonMethods.showLog(tag: TAG, message: "Terms & Conditions")
//            return false
//        default:
//            return true
//        }
//    }
    
    @IBAction func chooseCountryPressed(_ sender: Any) {
        MyNavigations.goToChooseCountry(navigationController: navigationController, pageTitle: "Choose Calling Code", countrySelectionDelegate: self)
    }
    
    func onCountrySelected(countryDetail: CountryDetail) {
        self.countryDetail = countryDetail
        countryCodeLabel.text = "+\(countryDetail.callingCode ?? "")"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func showChooserOption(callingCode : String, phoneNumber : String) {
        let alert = UIAlertController(title: MyConstants.APP_NAME, message: """
            We will be verifying the phone number : (+\(callingCode)) \(phoneNumber)
            Is this OK? or Would you like to edit the number?
            """, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (data) in
            CommonPhoneVerification.common.phoneVerification(callingCode: callingCode, phoneNumber: phoneNumber, delegate: self)
        }))
        alert.addAction(UIAlertAction(title: "Edit", style: UIAlertAction.Style.default, handler: { (data) in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func onOtpSend(phoneNumber: String, verificationID: String) {
        
    }
    
    func onOtpSend(callingCode: String, phoneNumber: String, verificationID: String) {
        MyNavigations.goToVerifyOtp(navigationController: self.navigationController, callingCode: callingCode, phoneNumber: phoneNumber, verificationID: verificationID)
    }
}
