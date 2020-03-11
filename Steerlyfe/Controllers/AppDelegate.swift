//
//  AppDelegate.swift
//  Steerlyfe
//
//  Created by nap on 24/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import GoogleMaps
import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let TAG = "AppDelegate"
    let userDefaults = UserDefaults.standard
    static let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?
    var application: UIApplication?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey(MyConstants.MAP_API_KEY)
        GMSServices.provideAPIKey(MyConstants.MAP_API_KEY)
        self.application = application
        window?.tintColor = UIColor.colorPrimaryDark
        FirebaseApp.configure()
        setUpFirebase()
        return true
    }
        
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func setUpFirebase() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            self.application?.registerUserNotificationSettings(settings)
        }
        self.application?.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
    
    func generateFCMToken()  {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                CommonMethods.showLog(tag: self.TAG, message: "Error fetching remote instance ID: \(error)")
            } else if let result = result {
                self.sendToServer(fcmToken: result.token)
            }
        }
    }
    
    func sendToServer(fcmToken : String) {
        CommonMethods.showLog(tag: TAG, message: "sendToServer TOKEN \(fcmToken)")
        userDefaults.set(fcmToken, forKey: MyConstants.FCM_TOKEN)
        if userDefaults.bool(forKey: MyConstants.LOGIN_STATUS) {
            //            CommonWebServices.api.updateDeviceToken()
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Foreground
        CommonMethods.showLog(tag: TAG, message: "Foreground")
        let userInfo = notification.request.content.userInfo
        CommonMethods.showLog(tag: TAG, message: "UNNotificationPresentationOptions userInfo : \(userInfo)")
        //        if userInfo["message"] != nil{
        //            let showNotification = handleForgroundNotification(notificationData: userInfo["message"] as! String)
        //            if showNotification{
        //                completionHandler(UNNotificationPresentationOptions.alert)
        //            }
        //        }
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //        When Open notification
        CommonMethods.showLog(tag: TAG, message: "Background")
        let userInfo = response.notification.request.content.userInfo
        CommonMethods.showLog(tag: TAG, message: "userNotificationCenter userInfo : \(userInfo)")
        if userInfo["message"] != nil{
            handleBackgroundNotificationData(notificationData: userInfo["message"] as! String)
        }
        completionHandler()
    }
    
    func handleBackgroundNotificationData(notificationData : String)  {
        CommonMethods.showLog(tag: TAG, message: "notificationData \(notificationData)")
        let loginStatus : Bool = userDefaults.bool(forKey: MyConstants.LOGIN_STATUS)
        let navController = CommonMethods.getNavigationController();
        //        if loginStatus {
        //            let data = notificationData.data(using: .utf8)!
        //            do {
        //                if let jsonData = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
        //                {
        //                    let notificationType : String = jsonData["notification_type"] as! String
        //                    switch notificationType{
        //                    case "new_message":
        //                        break
        //                    default:
        //                        MyNavigations.goToSplash(navigationController: navController)
        //                        break
        //                    }
        //                } else {
        //                    CommonMethods.showLog(tag: TAG, message: "Bad Json Format")
        //                    MyNavigations.goToSplash(navigationController: navController)
        //                }
        //            } catch let error as NSError {
        //                CommonMethods.showLog(tag: TAG, message: "JSON ERROR \(error)")
        //                MyNavigations.goToSplash(navigationController: navController)
        //            }
        //        }else{
        //            MyNavigations.goToSplash(navigationController: navController)
        //        }
        MyNavigations.goToSplash(navigationController: navController)
    }
    
    
    func handleForgroundNotification(notificationData : String)->Bool{
        let showNotification = false
        let data = notificationData.data(using: .utf8)!
        do {
            if let jsonData = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
                let notificationType : String = jsonData["notification_type"] as! String
                switch notificationType{
                case "new_message":
                    break
                default:
                    break
                }
            } else {
                CommonMethods.showLog(tag: TAG, message: "Bad Json Format")
            }
        } catch let error as NSError {
            CommonMethods.showLog(tag: TAG, message: "JSON ERROR \(error)")
        }
        return showNotification
    }
}

extension AppDelegate : MessagingDelegate {
    //     Receive data message on iOS 10 devices while app is in the foreground.
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        CommonMethods.showLog(tag: TAG, message: "remoteMessage received ")
        CommonMethods.showLog(tag: TAG, message: remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        CommonMethods.showLog(tag: TAG, message: "InstanceID token: \(fcmToken)")
        sendToServer(fcmToken: fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        CommonMethods.showLog(tag: TAG, message: "remoteMessage didReceive")
        CommonMethods.showLog(tag: TAG, message: remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        sendToServer(fcmToken: fcmToken)
    }
}
