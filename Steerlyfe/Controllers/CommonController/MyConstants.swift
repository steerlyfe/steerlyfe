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
    static let API_BASE_URL = "https://steerlyfe.com/app/app/v1/"
    static let MAP_API_KEY = "AIzaSyDgGMTzz9uhLFD7r1oefNrstuVAsXd3C9w"
    static let POST_SHARE_BASE_URL = "https://steerlyfe.com/app/share/#/post/"
    static let APP_NAME = "Steerlyfe"
    static let AUTHORIZATION = "authorization"
    static let USER_ID = "user_id"
    static let ACCOUNT_ID = "account_id"
    static let FULL_NAME = "full_name"
    static let PHONE_NUMBER = "phone_number"
    static let CALLING_CODE = "calling_code"
    static let EMAIL = "email"
    static let SESSION_TOKEN = "session_token"
    static let QUESTION_SUBMITTED = "question_submitted"
    static let LOGIN_STATUS = "login_status"
    static let STATIC_ERROR_MESSAGE = "Some error occured, please try again"
    static let FCM_TOKEN = "fcm_token"
    static let API_TOKEN_LOGIN = "abc#123OP*7L"
    static let API_TOKEN_SIGNUP = "gths8*t564pS"
    static let CURRENCY_SYMBOL = "$"
    static let ADD_TO_FAVOURITES = "add_to_favourites"
    static let ADD_TO_CART = "add_to_cart"
    static let DELETE_FAVOURITE = "delete_favourite"
    static let REMOVE_ITEM = "remove_item"
    static let REFRESH_DATA = "refresh_data"
    static let PLUS_PRESSED = "plus_pressed"
    static let MINUS_PRESSED = "minus_pressed"
    static let REFRESH_CART_DATA = "refresh_cart_data"
    static let REFRESH_PRODUCT_LIST_DATA = "refresh_product_list_data"
    static let CART_LIST = "cart_list"
    static let FAVOURITE_LIST = "favourite_list"
    static let ITEM_SELECTED = "item_selected"
    static let VIEW_DETAIL = "view_detail"
    static let VIEW_ORDER_DETAIL = "view_order_detail"
    static let BUY_AGAIN_PRESSED = "buy_again_pressed"
    static let VIEW_PRODUCT_DETAIL = "view_product_detail"
    static let SUGGESTED_VIEW_DETAIL = "suggested_view_detail"
    static let TRENDING_VIEW_DETAIL = "trending_view_detail"
    static let PLACEHOLDER_IMAGE_NAME = "place_holder"
    
    static let PRODUCT_AVAILABLITY_IN_STORE = "in_store"
    static let PRODUCT_AVAILABLITY_DELIVER_NOW = "deliver_now"
    static let PRODUCT_AVAILABLITY_SHIPPING = "shipping"
    static let ADDITIONAL_FEATURE_CLICKED = "additional_feature_clicked"
    
    static let DATABASE_VERSION = "database_version"
    
    static let USE_ADDRESS = "use_address"
    static let DELETE_ADDRESS = "delete_address"
    static let MAKE_DEFAULT_ADDRESS = "make_default_address"
    static let ORDER_PLACED = "order_placed"
    
    static let ORDER_STATUS_PENDING = "pending"
    static let ORDER_STATUS_COMPLETED = "completed"
    static let ORDER_STATUS_CANCELLED = "cancelled"
    static let CHOOSE_CALLING_CODE = "choose_calling_code"
    static let ADD_ADDRESS = "add_address"
    static let NEW_ADDRESS_ADDED = "new_address_added"
    static let CHOOSE_ADDRESS = "choose_address"
    
    static let ORDER_STATUS_ORDER_PLACED = "order_placed"
    static let ORDER_STATUS_READY_TO_PICK = "ready_to_pick"
    static let ORDER_STATUS_RECEIVED = "product_received"
    static let ORDER_STATUS_PROCESSING = "processing"
    static let ORDER_STATUS_DISPATCHED = "dispatched"
    static let ORDER_STATUS_DELIVERED = "delivered"
    static let VIEW_ALL_PRODUCTS = "view_all_products"
    static let SUBMIT_ORDER_RATING = "submit_order_rating"
    static let SHARE_POST = "share_post"
    static let CHANGE_POST_STATUS_SAVE = "save"
    static let CHANGE_POST_STATUS_REMOVE = "remove"
    static let COMMON_PRODUCT_LIST = "common_product_list"
    static let STORE_MENU = "store_menu"
    static let LOAD_REVIEWS = "load_reviews"
    static let APPLY_COUPON = "ApplyCoupon"
    static let DISCOUNT_TYPE_AMOUNT = "amount"
    static let YES = "yes"
    static let NO = "no"
    
//    static let AUTH_VERIFICATION_ID = "authVerificationID"
    static var termsAndConditionsURL: URL {
        return URL(string: "TermsAndConditions")!
    }
    static var privacyAndPolicyURL: URL {
        return URL(string: "PrivacyAndPolicy")!
    }
}
