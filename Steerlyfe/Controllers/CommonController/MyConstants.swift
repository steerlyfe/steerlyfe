//
//  MyConstants.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//
import UIKit

class MyConstants {
    static let FILL_STATIC_FORM = false
    static let API_BASE_URL = "https://thepop.app/steerlyfe/app/v1/"
    static let MAP_API_KEY = "AIzaSyDgGMTzz9uhLFD7r1oefNrstuVAsXd3C9w"
    static let APP_NAME = "Steerlyfe"
    static let AUTHORIZATION = "authorization"
    static let USER_ID = "user_id"
    static let ACCOUNT_ID = "account_id"
    static let FULL_NAME = "full_name"
    static let PHONE_NUMBER = "phone_number"
    static let EMAIL = "email"
    static let SESSION_TOKEN = "session_token"
    static let LOGIN_STATUS = "login_status"
    static let STATIC_ERROR_MESSAGE = "Some error occured, please try again"
    static let FCM_TOKEN = "fcm_token"
    static let API_TOKEN_LOGIN = "abc#123OP*7L"
    static let API_TOKEN_SIGNUP = "gths8*t564pS"
    static let CURRENCY_SYMBOL = "$"
//    static let AUTH_VERIFICATION_ID = "authVerificationID"
    static var termsAndConditionsURL: URL {
        return URL(string: "TermsAndConditions")!
    }
    static var privacyAndPolicyURL: URL {
        return URL(string: "PrivacyAndPolicy")!
    }
}
