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
        if userDefault.bool(forKey: MyConstants.LOGIN_STATUS){
            signupButton.isHidden = true
            loginButton.isHidden = true
        }else{
            signupButton.isHidden = false
            loginButton.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: MyConstants.LOGIN_STATUS){
            if userDefault.integer(forKey: MyConstants.QUESTION_SUBMITTED) == 1{
                MyNavigations.goToMain(navigationController: navigationController)
            }else if userDefault.integer(forKey: MyConstants.QUESTION_SUBMITTED) == 2{
                MyNavigations.goToMain(navigationController: navigationController)
            }else{
                MyNavigations.goToQuizQuestions(navigationController: navigationController)
            }
        }else{
            signupButton.isHidden = false
            loginButton.isHidden = false
            CommonMethods.addWhiteRoundCornerFilled(uiview: loginButton, cornerRadius: 25)
            CommonMethods.addWhiteRoundCornerStroke(uiview: signupButton, cornerRadius: 25)
            if databaseMethods.getCountriesCount() == 0{
                KVNProgress.show()
                CommonWebServices.api.getStaticData(delegate: self)
            }
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        calledFrom = "signup"
        checkAndContinue()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        calledFrom = "login"
        checkAndContinue()
    }
    
    func checkAndContinue() {
        if databaseMethods.getCountriesCount() == 0{
            goToNext = true
            getStaticData()
        }else if databaseMethods.getCategoriesCount() == 0{
            goToNext = true
            getStaticData()
        }else if databaseMethods.getQuizQuestionCount() == 0{
            goToNext = true
            getStaticData()
        }else{
//            MyNavigations.goToSignup(navigationController: navigationController, callingCode: "91", phoneNumber: "8699249405")
            MyNavigations.goToLogin(navigationController: navigationController, calledFrom: calledFrom)
        }
    }
    
    func getStaticData() {
        KVNProgress.show()
        CommonWebServices.api.getStaticData(delegate: self)
    }
        
    func onProcessComplete(type: String, status: String, message: String) {
        KVNProgress.dismiss {
            CommonMethods.showLog(tag: self.TAG, message: "onProcessComplete type : \(type)")
            CommonMethods.showLog(tag: self.TAG, message: "onProcessComplete status : \(status)")
            CommonMethods.showLog(tag: self.TAG, message: "onProcessComplete message : \(message)")
            switch type {
            case "GetStaticData":
                switch status{
                case "1":
                    if self.goToNext{
                        MyNavigations.goToLogin(navigationController: self.navigationController, calledFrom: self.calledFrom)
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

