//
//  AccountInfoVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 27/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class AccountInfoVC: UIViewController {
    
    let TAG = "AccountInfoVC"
    let userDefault = UserDefaults.standard
    
    var keyboardSize : CGFloat = 0
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var updateInfoButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderWidth : CGFloat = 1.0
        let borderColor = UIColor.black
        CommonMethods.addRoundCornerStroke(uiview: nameView, borderWidth: borderWidth, borderColor: borderColor, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: emailView, borderWidth: borderWidth, borderColor: borderColor, cornerRadius: 5.0)
        CommonMethods.addRoundCornerFilled(uiview: updateInfoButton, borderWidth: 1.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: updateInfoButton.frame.height / 2.0)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        nameTextField.text = userDefault.string(forKey: MyConstants.FULL_NAME)
        emailTextField.text = userDefault.string(forKey: MyConstants.EMAIL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        CommonMethods.dismissCurrentViewController()
    }
    
    @IBAction func updateInfoButtonPressed(_ sender: Any) {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let email = emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if name == ""{
            MyNavigations.showCommonMessageDialog(message: "Enter name", buttonTitle: "OK")
        }else if email == ""{
            MyNavigations.showCommonMessageDialog(message: "Enter email", buttonTitle: "OK")
        }else{
            CommonWebServices.api.updateProfileInfo(navigationController: navigationController, name: name, email: email)
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

}
