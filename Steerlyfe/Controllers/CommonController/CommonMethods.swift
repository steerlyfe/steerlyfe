//
//  CommonMethods.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import Cosmos

class CommonMethods {
    
    let TAG = "CommonMethods"
    static let common = CommonMethods()
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    init() {
        
    }
    
    func showLog(tag : String, message : String) {
//        print(tag + " : " + message)
    }
    
    func showLog(tag : String, message : Any) {
//        print(tag + " : ")
//        print(message)
    }
    
    func roundCornerView(uiView : UIView, cornerRadius : CGFloat) {
        uiView.layer.cornerRadius = cornerRadius
        uiView.clipsToBounds = true
    }
    
    func addCardViewStyle(uiView : UIView, cornerRadius : CGFloat, shadowRadius : CGFloat) {
        uiView.layer.cornerRadius = cornerRadius
        uiView.layer.shadowColor = UIColor.black.cgColor
        uiView.layer.shadowOffset = .zero
        uiView.layer.shadowRadius = shadowRadius
        uiView.layer.shadowOpacity = 1.0
        uiView.clipsToBounds = true
    }
    
    func addWhiteRoundCornerStroke(uiview : UIView, cornerRadius : CGFloat){
        uiview.layer.borderWidth = 1
        uiview.layer.cornerRadius = cornerRadius
        var whiteColor = UIColor.white.cgColor
        uiview.layer.borderColor = whiteColor
        whiteColor = whiteColor.copy(alpha: 0.0) ?? whiteColor
        uiview.layer.backgroundColor = whiteColor
    }
    
    func addWhiteRoundCornerFilled(uiview : UIView, cornerRadius : CGFloat){
        uiview.layer.borderWidth = 1
        uiview.layer.cornerRadius = cornerRadius
        uiview.layer.borderColor = UIColor.white.cgColor
        uiview.layer.backgroundColor =  UIColor.white.cgColor
    }
    
    func addRoundCornerFilled(uiview : UIView, borderWidth : CGFloat, borderColor : UIColor?, backgroundColor : UIColor?, cornerRadius : CGFloat){
        uiview.layer.borderWidth = borderWidth
        uiview.layer.cornerRadius = cornerRadius
        uiview.layer.borderColor = borderColor?.cgColor
        uiview.layer.backgroundColor =  backgroundColor?.cgColor
    }
    
    func addRoundCornerStroke(uiview : UIView, borderWidth : CGFloat, borderColor : UIColor?, cornerRadius : CGFloat){
        uiview.layer.borderWidth = borderWidth
        uiview.layer.cornerRadius = cornerRadius
        uiview.layer.borderColor = borderColor?.cgColor
        var whiteColor = UIColor.white.cgColor
        whiteColor = whiteColor.copy(alpha: 0.0) ?? whiteColor
        uiview.layer.backgroundColor = whiteColor
    }
    
    func addRoundCornerStrokeFill(uiview : UIView, borderWidth : CGFloat, borderColor : UIColor?, backgroundColor : UIColor?, cornerRadius : CGFloat){
        uiview.layer.borderWidth = borderWidth
        uiview.layer.cornerRadius = cornerRadius
        uiview.layer.borderColor = borderColor?.cgColor
        uiview.layer.backgroundColor = backgroundColor?.cgColor
    }
    
    func makeRoundImageView(imageView : UIImageView, cornerRadius : CGFloat){
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
    }
    
    func setColoredNavigationBar(navigationController : UINavigationController?, navigationItem : UINavigationItem, title : String)  {
        let uiLabel = UILabel()
        uiLabel.text = title
        uiLabel.textColor = UIColor.white
        navigationItem.titleView = uiLabel
        let nav = navigationController?.navigationBar
        nav?.tintColor = UIColor.black
        nav?.barTintColor = UIColor.colorPrimaryDark
        nav?.tintColor = UIColor.white
    }
    
    func setNavigationBar(navigationController : UINavigationController?, navigationItem : UINavigationItem, title : String)  {
        let uiLabel = UILabel()
        uiLabel.text = title
        uiLabel.textColor = UIColor.black
        navigationItem.titleView = uiLabel
        let nav = navigationController?.navigationBar
        nav?.tintColor = UIColor.black
        nav?.barTintColor = UIColor.white
        nav?.tintColor = UIColor.black
    }
    
    func setNavigationBarTransparent(navigationController : UINavigationController?, navigationItem : UINavigationItem, title : String)  {
        let uiLabel = UILabel()
        uiLabel.text = title
        uiLabel.textColor = UIColor.black
        navigationItem.titleView = uiLabel
        let nav = navigationController?.navigationBar
        nav?.tintColor = UIColor.black
        nav?.barTintColor = UIColor.transparentBackground
        nav?.tintColor = UIColor.black
    }
    
    func getNavigationController() -> UINavigationController? {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            return navigationController
        }else{
            return nil
        }
    }
    
    func logout(navigationController : UINavigationController?) {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        let databaseMethods = DatabaseMethods()
        databaseMethods.deleteAllCartItems()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setTableViewSeperatorColor(tableView : UITableView) {
        tableView.separatorColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    func backPressed() {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
            navigationController.dismiss(animated: true)
        }
    }
    
    func timeStampToDate(timeStamp : Double)-> String {
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
    
    func getServerFormattedDate(timeStamp : Double)-> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    func getTimestampFromTimeString(dateString : String) -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="HH:mm:ss"
        let dateString = dateFormatter.date(from: dateString)
        return dateString!.timeIntervalSince1970
    }
    
    func getTimeStringFromTimeStamp(timeStamp : Double)-> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "hh:mm aa"
        return dateFormatter.string(from: date)
    }
    
    func getOnlyDate(timeStamp : Double)-> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    func setRatingStarStyle(ratingView : CosmosView) {
        ratingView.settings.filledColor = UIColor.myStarColor
        ratingView.settings.emptyColor = UIColor.myLineColor
        ratingView.settings.emptyBorderColor = UIColor.myLineColor
        ratingView.settings.filledBorderColor = UIColor.myStarColor
    }
}
