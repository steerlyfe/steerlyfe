//
//  CommonMethods.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import Cosmos
import KVNProgress

class CommonMethods {
    
    static let TAG = "CommonMethods"
    static let common = CommonMethods()
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    init() {
        
    }
    
    public static func showLog(tag : String, message : String) {
//        print(tag + " : " + message)
    }
    
    public static func showLog(tag : String, message : Any) {
//        print(tag + " : ")
//        print(message)
    }
    
    public static func roundCornerView(uiView : UIView, cornerRadius : CGFloat) {
        uiView.layer.cornerRadius = cornerRadius
        uiView.clipsToBounds = true
    }
    
    public static func addCardViewStyle(uiView : UIView, cornerRadius : CGFloat, shadowRadius : CGFloat) {
        uiView.layer.cornerRadius = cornerRadius
        uiView.layer.shadowColor = UIColor.black.cgColor
        uiView.layer.shadowOffset = .zero
        uiView.layer.shadowRadius = shadowRadius
        uiView.layer.shadowOpacity = 1.0
        uiView.clipsToBounds = true
    }
    
    public static func addCardViewStyle(uiView : UIView, cornerRadius : CGFloat, shadowColor : UIColor) {
        uiView.layer.cornerRadius = cornerRadius
        uiView.layer.shadowColor = shadowColor.cgColor
        uiView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        uiView.layer.shadowRadius = cornerRadius / 2.0
        uiView.layer.shadowOpacity = 0.7
    }
    
    public static func addCardViewStyle(uiView : UIView, cornerRadius : CGFloat, shadowRadius : CGFloat, shadowColor : UIColor) {
        uiView.layer.cornerRadius = cornerRadius
        uiView.layer.shadowColor = shadowColor.cgColor
        uiView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        uiView.layer.shadowRadius = shadowRadius
        uiView.layer.shadowOpacity = 0.7
    }
    
    public static func addBackgroundShadowStyle(uiView : UIView, cornerRadius : CGFloat, shadowRadius : CGFloat) {
        uiView.layer.cornerRadius = cornerRadius
        var color = UIColor.colorPrimaryDark
        color = color.withAlphaComponent(0.2)
        uiView.layer.shadowColor = color.cgColor
        uiView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        uiView.layer.shadowRadius = shadowRadius
        uiView.layer.shadowOpacity = 1.0
    }
    
    public static func addWhiteRoundCornerStroke(uiview : UIView, cornerRadius : CGFloat){
        uiview.layer.borderWidth = 1
        uiview.layer.cornerRadius = cornerRadius
        var whiteColor = UIColor.white.cgColor
        uiview.layer.borderColor = whiteColor
        whiteColor = whiteColor.copy(alpha: 0.0) ?? whiteColor
        uiview.layer.backgroundColor = whiteColor
    }
    
    public static func addWhiteRoundCornerFilled(uiview : UIView, cornerRadius : CGFloat){
        uiview.layer.borderWidth = 1
        uiview.layer.cornerRadius = cornerRadius
        uiview.layer.borderColor = UIColor.white.cgColor
        uiview.layer.backgroundColor =  UIColor.white.cgColor
    }
    
    public static func addRoundCornerFilled(uiview : UIView, borderWidth : CGFloat, borderColor : UIColor?, backgroundColor : UIColor?, cornerRadius : CGFloat){
        uiview.layer.borderWidth = borderWidth
        uiview.layer.cornerRadius = cornerRadius
        uiview.layer.borderColor = borderColor?.cgColor
        uiview.layer.backgroundColor =  backgroundColor?.cgColor
    }
    
    public static func addRoundCornerStroke(uiview : UIView, borderWidth : CGFloat, borderColor : UIColor?, cornerRadius : CGFloat){
        uiview.layer.borderWidth = borderWidth
        uiview.layer.cornerRadius = cornerRadius
        uiview.layer.borderColor = borderColor?.cgColor
        var whiteColor = UIColor.white.cgColor
        whiteColor = whiteColor.copy(alpha: 0.0) ?? whiteColor
        uiview.layer.backgroundColor = whiteColor
    }
    
    public static func addRoundCornerStrokeFill(uiview : UIView, borderWidth : CGFloat, borderColor : UIColor?, backgroundColor : UIColor?, cornerRadius : CGFloat){
        uiview.layer.borderWidth = borderWidth
        uiview.layer.cornerRadius = cornerRadius
        uiview.layer.borderColor = borderColor?.cgColor
        uiview.layer.backgroundColor = backgroundColor?.cgColor
    }
    
    public static func makeRoundImageView(imageView : UIImageView, cornerRadius : CGFloat){
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
    }
    
    public static func setColoredNavigationBar(navigationController : UINavigationController?, navigationItem : UINavigationItem, title : String)  {
        let uiLabel = UILabel()
        uiLabel.text = title
        uiLabel.textColor = UIColor.white
        navigationItem.titleView = uiLabel
        let nav = navigationController?.navigationBar
        nav?.tintColor = UIColor.black
        nav?.barTintColor = UIColor.colorPrimaryDark
        nav?.tintColor = UIColor.white
    }
    
    public static func setNavigationBar(navigationController : UINavigationController?, navigationItem : UINavigationItem, title : String)  {
        //        let uiLabel = UILabel()
        //        uiLabel.text = title
        //        uiLabel.textColor = UIColor.black
        //        navigationItem.titleView = uiLabel
        //        let nav = navigationController?.navigationBar
        //        nav?.tintColor = UIColor.black
        //        nav?.barTintColor = UIColor.white
        //        nav?.tintColor = UIColor.black
        
        let uiLabel = UILabel()
        uiLabel.text = title
        uiLabel.textColor = UIColor.black
        navigationItem.titleView = uiLabel
//        navigationItem.title = title
        let nav = navigationController?.navigationBar
        nav?.tintColor = UIColor.white
        nav?.barTintColor = UIColor.white
        nav?.tintColor = UIColor.black
    }
    
    public static func setNavigationBarTransparent(navigationController : UINavigationController?, navigationItem : UINavigationItem, title : String)  {
        let uiLabel = UILabel()
        uiLabel.text = title
        uiLabel.textColor = UIColor.black
        navigationItem.titleView = uiLabel
        let nav = navigationController?.navigationBar
        nav?.tintColor = UIColor.black
        nav?.barTintColor = UIColor.transparentBackground
        nav?.tintColor = UIColor.black
    }
    
    public static func getNavigationController() -> UINavigationController? {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            return navigationController
        }else{
            return nil
        }
    }
    
    public static func logout(navigationController : UINavigationController?) {
        let userDefaults = UserDefaults.standard
        let databaseVersion = userDefaults.integer(forKey: MyConstants.DATABASE_VERSION)
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()
        let databaseMethods = DatabaseMethods()
        databaseMethods.deleteAllCartItems()
        userDefaults.set(databaseVersion, forKey: MyConstants.DATABASE_VERSION)
        navigationController?.popToRootViewController(animated: true)
    }
    
    public static func setTableViewSeperatorColor(tableView : UITableView) {
        tableView.separatorColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    public static func setTableViewSeperatorTransparentColor(tableView : UITableView) {
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.0)
        tableView.tableFooterView = UIView()
    }
    
    public static func backPressed() {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
            navigationController.dismiss(animated: true)
        }
    }
    
    public static func timeStampToDate(timeStamp : Double)-> String {
        let calendar = NSCalendar.current
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        if calendar.isDateInYesterday(date) {
            dateFormatter.dateFormat = "hh:mm aa"
            return "Yesterday \(dateFormatter.string(from: date))"
        }else if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "hh:mm aa"
            return "Today \(dateFormatter.string(from: date))"
        }else if calendar.isDateInTomorrow(date) {
            dateFormatter.dateFormat = "hh:mm aa"
            return "Tomorrow \(dateFormatter.string(from: date))"
        }else {
            dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm aa"
            return dateFormatter.string(from: date)
        }
    }
    
    public static func getSpecialFormattedDate(format : String, timeStamp : Double)-> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    public static func getServerFormattedDate(timeStamp : Double)-> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    public static func getTimestampFromTimeString(dateString : String) -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="HH:mm:ss"
        let dateString = dateFormatter.date(from: dateString)
        return dateString!.timeIntervalSince1970
    }
    
    public static func getTimeStringFromTimeStamp(timeStamp : Double)-> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "hh:mm aa"
        return dateFormatter.string(from: date)
    }
    
    public static func getOnlyDate(timeStamp : Double)-> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    public static func setRatingStarStyle(ratingView : CosmosView) {
        ratingView.settings.filledColor = UIColor.myStarColor
        ratingView.settings.emptyColor = UIColor.myLineColor
        ratingView.settings.emptyBorderColor = UIColor.myLineColor
        ratingView.settings.filledBorderColor = UIColor.myStarColor
    }
    
    public static func setGradient(uiLabel:UILabel, startColor : UIColor, endColor : UIColor){
        
        let gradient = CAGradientLayer()
        
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = (uiLabel.bounds)
        
        let label = UILabel(frame: (uiLabel.bounds))
        label.text = uiLabel.text
        label.font = uiLabel.font
        label.textAlignment = uiLabel.textAlignment
        uiLabel.layer.addSublayer(gradient)
        uiLabel.addSubview(label)
        uiLabel.mask = label
    }
    
    public static func getWishingMessage()->String{
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12 : return "Good Morning"
        case 12 : return "Good Noon"
        case 13..<17 : return "Good Afternoon"
        case 17..<22 : return "Good Evening"
        default: return "Good Night"
        }
    }
    
    public static func fadeIn(view : UIView) {
        view.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            view.alpha = 1.0
        }, completion: {(finished: Bool)-> Void in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.fadeOut(view: view)
            }
        })
    }
    
    public static func fadeOut(view : UIView) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            view.alpha = 0.0
        }, completion: nil)
    }
    
    public static func setLoadingIndicatorStyle(loadingIndicator : UIActivityIndicatorView){
        loadingIndicator.startAnimating()
        loadingIndicator.tintColor = UIColor.colorPrimary
    }
    
    public static func roundCornerFilledGradientNew(uiView : UIView, cornerRadius : CGFloat) {
        let uiImage = UIImage(named: "gradient_back_new")!
        //        uiView.backgroundColor = UIColor(patternImage: uiImage)
        uiView.layer.contents = uiImage.cgImage
        uiView.layer.cornerRadius = cornerRadius
        uiView.clipsToBounds = true
    }
    
    public static func roundCornerFilledGradient(uiView : UIView, cornerRadius : CGFloat) {
        let uiImage = UIImage(named: "gradient_back")!
        //        uiView.backgroundColor = UIColor(patternImage: uiImage)
        uiView.layer.contents = uiImage.cgImage
        uiView.layer.cornerRadius = cornerRadius
        uiView.clipsToBounds = true
    }
    
    public static func dismissCurrentViewController() {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
            navigationController.dismiss(animated: true)
        }
    }
    
    public static func prepareJson(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    public static func dismissLoadingAndShowMessage(message : String, buttonTitle : String){
        KVNProgress.dismiss {
            MyNavigations.showCommonMessageDialog(message: message, buttonTitle: buttonTitle)
        }
    }
    
    public static func roundOffDouble(value : Double, roundOffDigits : Int )->Double {
        let stringValue = String(format: "%.\(roundOffDigits)f", value)
        if let value = Double(stringValue){
            return value
        }else{
            return 0.0
        }
    }
    
    public static func getSortingOptionsList()->[SortingOptions] {
        var data : [SortingOptions] = []
        data.append(SortingOptions(sortingName: "Top Rated", sortingType: .topRated, apiType: "sorting_top_rated"))
        data.append(SortingOptions(sortingName: "Price Low to High", sortingType: .priceLowToHigh, apiType: "sorting_price_low_to_high"))
        data.append(SortingOptions(sortingName: "Price High to Low", sortingType: .priceHighToLow, apiType: "sorting_price_high_to_low"))
        data.append(SortingOptions(sortingName: "Most Popular", sortingType: .mostPopular, apiType: "sorting_most_popular"))
        data.append(SortingOptions(sortingName: "Newest Arrivals", sortingType: .newestArrivals, apiType: "sorting_newest_arrival"))
        data.append(SortingOptions(sortingName: "Featured", sortingType: .featured, apiType: "sorting_featured"))
        return data
    }
    
    public static func getSortingOptionValue(sortingType : SortingType?)->SortingOptions? {
        let data : [SortingOptions] = getSortingOptionsList()
        var finalData : SortingOptions?
        data.forEach { (sortingOption) in
            if sortingOption.sortingType == sortingType{
                finalData = sortingOption
            }
        }
        return finalData
    }
    
    public static func getAddressText(addressDetail : AddressDetail?)->String{
        var text = ""
        var localityText = ""
        if let locality = addressDetail?.locality{
            if locality.count > 0{
                localityText = """
                ,
                \(locality)
                """
            }
        }
        text = """
        \(addressDetail?.name ?? "")
        Mob. +\(addressDetail?.calling_code ?? "")\(addressDetail?.phone_number ?? "")
        \(addressDetail?.address ?? "")\(localityText)
        \(addressDetail?.city ?? "") - \(addressDetail?.pincode ?? "")
        \(addressDetail?.state ?? ""), \(addressDetail?.country ?? "")
        """
        CommonMethods.showLog(tag: CommonMethods.TAG, message: "getAddressText \(text)")
        return text
    }
    
    public static func getStatusDisplayText(status : String?)->String{
        var finalValue = "Unknown"
        if let statusValue = status{
            switch statusValue {
            case MyConstants.ORDER_STATUS_ORDER_PLACED:
                finalValue = "Order Placed"
                break
            case MyConstants.ORDER_STATUS_READY_TO_PICK:
                finalValue = "Ready To Pick"
                break
            case MyConstants.ORDER_STATUS_RECEIVED:
                finalValue = "Received"
                break
            case MyConstants.ORDER_STATUS_PROCESSING:
                finalValue = "Processing"
                break
            case MyConstants.ORDER_STATUS_DISPATCHED:
                finalValue = "Dispatched"
                break
            case MyConstants.ORDER_STATUS_DELIVERED:
                finalValue = "Delivered"
                break
            default:
                break
            }
        }
        return finalValue
    }
    
    public static func convertCommaSeperateValue(number : Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:number)) ?? ""
    }
    
    public static func convertTimeAgo(timeStamp : Double?) -> String {
        let date = Date(timeIntervalSince1970: timeStamp ?? NSDate().timeIntervalSince1970)
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: Date())
        //        let seconds = difference.second ?? 0 //s"
        let minutes = difference.minute ?? 0 //m" + " " + seconds
        let hours = difference.hour ?? 0 //h" + " " + minutes
        let days = difference.day ?? 0 //d" + " " + hours
        if days > 0 {
            if days > 7{
                return CommonMethods.getSpecialFormattedDate(format: "dd MMM yyyy", timeStamp: date.timeIntervalSince1970)
            }else{
                return days == 1 ? "\(days)" + " Day Ago" : "\(days)" + " Days Ago"
            }
        }else if hours > 0{
            return hours == 1 ? "\(hours)" + " Hour Ago" : "\(hours)" + " Hours Ago"
        }else if minutes > 0{
            return minutes == 1 ? "\(minutes)" + " Min Ago" : "\(minutes)" + " Mins Ago"
        }else{
            return "Just Now"
        }
    }
    
    public static func sharePost(navigationController : UINavigationController?, title : String, imageUrl : [String], sourceView : UIView){
        var activityItems : [Any] = []
        activityItems.append(title)
        imageUrl.forEach { (imageUrl) in
            let url = URL(string:imageUrl)
            if let data = try? Data(contentsOf: url!)
            {
                if let image: UIImage = UIImage(data: data){
                    activityItems.append(image)
                }
            }
        }
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceView
        
        // This line remove the arrow of the popover to show in iPad
        //        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.allZeros
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        navigationController?.present(activityViewController, animated: true, completion:{
        })
    }
    
    public static func sharePost(navigationController : UINavigationController?, postPublicId : String, sourceView : UIView){
        var activityItems : [Any] = []
        activityItems.append("\(MyConstants.POST_SHARE_BASE_URL)\(postPublicId)")
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceView
        
        // This line remove the arrow of the popover to show in iPad
        //        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.allZeros
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        navigationController?.present(activityViewController, animated: true, completion:{
        })
    }
    
    public static func getTotalPrice(data : [CartProductDetail]) -> Double {
        var price = 0.0
        data.forEach { (productDetail) in
            let salePrice = productDetail.sale_price ?? 0.0
            let additionalFeaturePrice = productDetail.additional_feature_price ?? 0.0
            let additionalCharges = productDetail.additional_charges ?? 0.0
            let quantity = Double(productDetail.quantity ?? 0)
            price = price + ( (salePrice + additionalFeaturePrice) * quantity ) + additionalCharges
        }
        return CommonMethods.roundOffDouble(value: price, roundOffDigits: 2)
    }
}
