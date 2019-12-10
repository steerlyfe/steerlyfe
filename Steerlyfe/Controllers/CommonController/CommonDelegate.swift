//
//  CommonDelegate.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

protocol OnProcessCompleteDelegate {
    func onProcessComplete(type : String, status : String, message : String)
}

protocol ButtonPressedAtPositionDelegate {
    func onButtonPressed(type : String, position : Int)
}

protocol ButtonPressedDelegate {
    func onButtonPressed(type : String)
}

protocol CountrySelectionDelegate {
    func onCountrySelected(countryDetail : CountryDetail)
}

protocol LoginUserDelegate {
    func onLoginCountrySelected(countryDetail : CountryDetail)
}

protocol ConfirmationDialogDelegate {
    func onConfirmationButtonPressed(yesPressed : Bool)
}

protocol HomeDataDelegate {
    func onHomeDataReceived(status : String, message : String, data : HomeProductsResponse?)
}

protocol ProductsListDelegate {
    func onProductListReceived(status : String, message : String, data : CategoryProductsResponse?)
}

protocol NearbyStoresDelegate {
    func onNearbyStoresListReceived(status : String, message : String, data : NearbyStoresResponse?)
}

protocol StoreDetailDelegate {
    func onStoreDetailReceived(status : String, message : String, data : StoreDetailResponse?)
}

protocol OtpSendDelegate {
    func onOtpSend(phoneNumber : String, verificationID : String)
}
