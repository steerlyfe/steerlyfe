//
//  SignupVC.swift
//  Steerlyfe
//
//  Created by nap on 27/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class SignupVC: UIViewController, UITextViewDelegate{

    let TAG = "SignupVC"
    
    var phoneNumber : String = ""
    var keyboardSize : CGFloat = 0
    private var termsHeightObserver: NSKeyValueObservation?
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var termsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var termConditionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        CommonMethods.common.setNavigationBar(navigationController: navigationController, navigationItem: navigationItem, title: "Signup")
    }
    
    func setUI() {
        let borderWidth : CGFloat = 1.0
        let borderColor = UIColor.colorPrimaryDark
        signupButton.setTitleColor(UIColor.white, for: .normal)
        CommonMethods.common.addRoundCornerStroke(uiview: nameView, borderWidth: borderWidth, borderColor: borderColor, cornerRadius: 5.0)
        CommonMethods.common.addRoundCornerStroke(uiview: emailView, borderWidth: borderWidth, borderColor: borderColor, cornerRadius: 5.0)
        CommonMethods.common.addRoundCornerFilled(uiview: signupButton, borderWidth: 1.0, borderColor: UIColor.colorPrimaryDark, backgroundColor: UIColor.colorPrimaryDark, cornerRadius: 20.0)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let text = "By clicking 'Signup' you are agree to our Terms & Conditions and Privacy Policy."
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
        
        termsHeightObserver = termConditionTextView
            .observe(\.contentSize,
                     changeHandler: { [unowned self] (_, change) in
                        guard let newHeight = change.newValue?.height else { return }
                        self.termsHeightConstraint.constant = newHeight
            })
        termsHeightConstraint.constant = termConditionTextView.contentSize.height
        termConditionTextView.textContainerInset = .zero
        if #available(iOS 11.0, *) {
            termConditionTextView.textDragInteraction?.isEnabled = false
        }
        //        termConditionTextView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        termConditionTextView.textAlignment = .center
        termConditionTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        switch URL {
        case MyConstants.privacyAndPolicyURL:
            CommonMethods.common.showLog(tag: TAG, message: "Privacy Policy")
            return false
        case MyConstants.termsAndConditionsURL:
            CommonMethods.common.showLog(tag: TAG, message: "Terms & Conditions")
            return false
        default:
            return true
        }
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
        bottomConstraint.constant = 0
    }

    @IBAction func signupButtonPressed(_ sender: Any) {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let email = emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if name == ""{
            MyNavigations.navigation.showCommonMessageDialog(message: "Enter name", buttonTitle: "OK")
        }else if email == ""{
            MyNavigations.navigation.showCommonMessageDialog(message: "Enter email", buttonTitle: "OK")
        }else{
            CommonWebServices.api.signup(navigationController: navigationController, phoneNumber: phoneNumber, name: name, email: email)
        }
    }
    
}
