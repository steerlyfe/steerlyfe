//
//  MainVC.swift
//  Steerlyfe
//
//  Created by nap on 29/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class MainVC: UITabBarController {
    
    let TAG = "MainVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setUI() {
        CommonMethods.common.showLog(tag: TAG, message: "HEIGHT \(tabBar.frame.height)")
        if tabBar.items?.count == 5{
            setTabBarDetail(item: tabBar.items?[0], imageName: "home_icon", selectedImageName: "home_icon_colored")
            setTabBarDetail(item: tabBar.items?[1], imageName: "search_icon", selectedImageName: "search_icon_colored")
            setTabBarDetail(item: tabBar.items?[2], imageName: "life_icon", selectedImageName: "life_icon_colored")
            setTabBarDetail(item: tabBar.items?[3], imageName: "user_icon", selectedImageName: "user_icon_colored")
            setTabBarDetail(item: tabBar.items?[4], imageName: "cart_icon", selectedImageName: "cart_icon_colored")
        }
    }
    
    func setTabBarDetail(item : UITabBarItem?, imageName : String, selectedImageName : String) {
        item?.title = ""
        item?.image = UIImage(named: imageName)
        item?.selectedImage = UIImage(named: selectedImageName)
    }
}
