//
//  ViewController.swift
//  Steerlyfe
//
//  Created by nap on 24/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import KVNProgress

class SplashVC: UIViewController, OnProcessCompleteDelegate {
    
    let TAG = "SplashVC"
    let databaseMethods = DatabaseMethods()
    let userDefault = UserDefaults.standard
    
    var goToNext : Bool = false
    var calledFrom : String = ""
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.isHidden = true
        loginButton.isHidden = true
        loginButton.setTitleColor(UIColor.black, for: .normal)
        signupButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: MyConstants.LOGIN_STATUS){
            MyNavigations.navigation.goToMain(navigationController: navigationController)
        }else{
            signupButton.isHidden = false
            loginButton.isHidden = false
            CommonMethods.common.addWhiteRoundCornerFilled(uiview: loginButton, cornerRadius: 25)
            CommonMethods.common.addWhiteRoundCornerStroke(uiview: signupButton, cornerRadius: 25)
            if databaseMethods.getCountriesCount() == 0{
                KVNProgress.show()
                CommonWebServices.api.getStaticData(delegate: self)
            }
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        calledFrom = "signup"
        if databaseMethods.getCountriesCount() == 0{
            goToNext = true
            KVNProgress.show()
            CommonWebServices.api.getStaticData(delegate: self)
        }else{
            MyNavigations.navigation.goToLogin(navigationController: navigationController, calledFrom: calledFrom)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        calledFrom = "login"
        if databaseMethods.getCountriesCount() == 0{
            goToNext = true
            KVNProgress.show()
            CommonWebServices.api.getStaticData(delegate: self)
        }else{
            MyNavigations.navigation.goToLogin(navigationController: navigationController, calledFrom: calledFrom)
        }
    }
    
    func onProcessComplete(type: String, status: String, message: String) {
        KVNProgress.dismiss {
            CommonMethods.common.showLog(tag: self.TAG, message: "onProcessComplete type : \(type)")
            CommonMethods.common.showLog(tag: self.TAG, message: "onProcessComplete status : \(status)")
            CommonMethods.common.showLog(tag: self.TAG, message: "onProcessComplete message : \(message)")
            switch type {
            case "GetStaticData":
                switch status{
                case "1":
                    if self.goToNext{
                        MyNavigations.navigation.goToLogin(navigationController: self.navigationController, calledFrom: self.calledFrom)
                    }
                    break
                default:
                    break
                }
                break
            default:
                break
            }
        }
    }
}

