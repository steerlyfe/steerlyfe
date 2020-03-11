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
    func onOtpSend(callingCode : String, phoneNumber : String, verificationID : String)
}

protocol SortingOptionDelegate {
    func onSortingChanged(sortingType : SortingType?)
}

protocol ProductDetailDelegate {
    func onProductDetailReceived(status : String, message : String, data : ProductDetailResponse?)
}

protocol AddNewAddressDelegate {
    func onAddressAdded(status : String, message : String, addressId : String?)
}

protocol AddressListDelegate {
    func onAddressListReceived(status : String, message : String, data : AddressListResponse?)
}

protocol RefreshProductsListDelegate {
    func onProductRefreshCalled()
}

protocol ChooseAddressDelegate {
    func onAddressChoosed(type : String, addressDetail : AddressDetail?)
}

protocol OrderHistoryResponseDelegate {
    func onOrderHistoryReceived(status : String, message : String, data : OrderHistoryResponse?)
}

protocol OrderFeedbackQuestionsDelegate {
    func onOrderFeedbackQuestionReceived(status : String, message : String, data : OrderFeedbackQuestionsResponse?)
}

protocol RatingChangeDelegate {
    func onRatingChanged(position : Int, rating : Double?)
}

protocol AllPostsDelegate {
    func onPostDataReceived(status : String, message : String, data : AllPostsResponse?)
}

protocol CommonSearchDelegate {
    func onSearchResultReceived(status : String, message : String, data : CommonSearchResponse?)
}
