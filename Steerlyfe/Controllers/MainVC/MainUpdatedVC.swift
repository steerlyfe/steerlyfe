//
//  MainUpdatedVC.swift
//  Steerlyfe
//
//  Created by nap on 23/12/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class MainUpdatedVC: UIViewController, ViewPagerControllerDelegate, ViewPagerControllerDataSource, OnProcessCompleteDelegate {
    
    let TAG = "MainUpdatedVC"
    
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    var viewPagerTabs : [ViewPagerTab] = []
    var currentIndex = 0
    let databaseMethods = DatabaseMethods()
    
    @IBOutlet weak var cartItemCountView: UIView!
    @IBOutlet weak var cartItemCountLabel: UILabel!
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var exploreIcon: UIImageView!
    @IBOutlet weak var exploreLabel: UILabel!
    @IBOutlet weak var lifestyleIcon: UIImageView!
    @IBOutlet weak var lifestyleLabel: UILabel!
    @IBOutlet weak var accountIcon: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var cartIcon: UIImageView!
    @IBOutlet weak var cartLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var viewPagerContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonMethods.addRoundCornerFilled(uiview: cartItemCountView, borderWidth: 0.0, borderColor: UIColor.red, backgroundColor: UIColor.red, cornerRadius: cartItemCountView.frame.width / 2.0)
//        CommonMethods.addRoundCornerFilled(uiview: bottomView, borderWidth: 1.0, borderColor: UIColor.black, backgroundColor: UIColor.myOffWhiteColor, cornerRadius: bottomView.frame.height / 2.0)
        CommonMethods.addCardViewStyle(uiView: bottomView, cornerRadius: bottomView.frame.height / 2.0, shadowColor: UIColor.colorPrimaryDarkTrans)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setUI()
        }
        checkAndUpdateTabStyle()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        checkAndShowCartCount()
    }
    
    func checkAndShowCartCount() {
        let count = databaseMethods.getCartItemsCount()
        if count > 0{
            if count > 10{
                cartItemCountLabel.text = "10+"
            }else{
                cartItemCountLabel.text = "\(count)"
            }
            cartItemCountView.isHidden = false
        }else{
            cartItemCountView.isHidden = true
        }
    }
    
    func setUI() {
        viewPagerTabs = []
        viewPagerTabs.append(ViewPagerTab(title: "Home", imageName: "", isLocalImage: false))
        viewPagerTabs.append(ViewPagerTab(title: "Explore", imageName: "", isLocalImage: false))
        viewPagerTabs.append(ViewPagerTab(title: "Lifestyle", imageName: "", isLocalImage: false))
        viewPagerTabs.append(ViewPagerTab(title: "Account", imageName: "", isLocalImage: false))
        viewPagerTabs.append(ViewPagerTab(title: "Cart", imageName: "", isLocalImage: false))
        setViewPagerAdapter()
    }
    
    func setViewPagerAdapter()  {
        options = ViewPagerOptions(viewPagerWithFrame: viewPagerContainer.bounds)
        options.tabType = ViewPagerTabType.basic
        options.tabViewTextFont = UIFont.systemFont(ofSize: 14)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = false
        options.viewPagerFrame = viewPagerContainer.bounds
        options.fitAllTabsInView = true
        options.isEachTabEvenlyDistributed = true
        options.tabViewHeight = 0
        options.tabViewBackgroundDefaultColor = UIColor.white
        options.tabViewBackgroundHighlightColor = UIColor.white
        options.tabIndicatorViewBackgroundColor = UIColor.black
        options.tabViewTextDefaultColor = UIColor.black
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        self.addChild(viewPager)
        viewPagerContainer.addSubview(viewPager.view)
        viewPager.didMove(toParent: self)
    }
    
    func numberOfPages() -> Int {
        return viewPagerTabs.count
    }
    
    func viewControllerAtPosition(position: Int) -> UIViewController {
        if position == 0{
            let vc = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            return vc
        }else if position == 1{
            let vc = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            return vc
        }else if position == 2{
            let vc = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "LifeStyleVC") as! LifeStyleVC
            return vc
        }else if position == 3{
            let vc = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            return vc
        }else{
            let vc = UIStoryboard(name: "TabVC", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
            vc.mainControllerDelegate = self
            vc.showBackArrow = false
            return vc
        }        
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return viewPagerTabs
    }
    
    @IBAction func tabButtonPressed(_ sender: UIButton) {
        if currentIndex != sender.tag - 1{
            currentIndex = sender.tag - 1
            viewPager.displayViewController(atIndex: currentIndex)
            checkAndUpdateTabStyle()
        }
    }
    
    func checkAndUpdateTabStyle() {
        CommonMethods.showLog(tag: TAG, message: "tabButtonPressed : \(currentIndex)")
        switch currentIndex {
        case 0:
            selectedLabelColor(label: homeLabel)
            unselectedLabelColor(label: exploreLabel)
            unselectedLabelColor(label: lifestyleLabel)
            unselectedLabelColor(label: accountLabel)
            unselectedLabelColor(label: cartLabel)
            homeIcon.image = UIImage(named: "home_icon_colored")
            exploreIcon.image = UIImage(named: "search_icon")
            lifestyleIcon.image = UIImage(named: "life_icon")
            accountIcon.image = UIImage(named: "user_icon")
            cartIcon.image = UIImage(named: "cart_icon")
            break
        case 1:
            unselectedLabelColor(label: homeLabel)
            selectedLabelColor(label: exploreLabel)
            unselectedLabelColor(label: lifestyleLabel)
            unselectedLabelColor(label: accountLabel)
            unselectedLabelColor(label: cartLabel)
            homeIcon.image = UIImage(named: "home_icon")
            exploreIcon.image = UIImage(named: "search_icon_colored")
            lifestyleIcon.image = UIImage(named: "life_icon")
            accountIcon.image = UIImage(named: "user_icon")
            cartIcon.image = UIImage(named: "cart_icon")
            break
        case 2:
            unselectedLabelColor(label: homeLabel)
            unselectedLabelColor(label: exploreLabel)
            selectedLabelColor(label: lifestyleLabel)
            unselectedLabelColor(label: accountLabel)
            unselectedLabelColor(label: cartLabel)
            homeIcon.image = UIImage(named: "home_icon")
            exploreIcon.image = UIImage(named: "search_icon")
            lifestyleIcon.image = UIImage(named: "life_icon_colored")
            accountIcon.image = UIImage(named: "user_icon")
            cartIcon.image = UIImage(named: "cart_icon")
            break
        case 3:
            unselectedLabelColor(label: homeLabel)
            unselectedLabelColor(label: exploreLabel)
            unselectedLabelColor(label: lifestyleLabel)
            selectedLabelColor(label: accountLabel)
            unselectedLabelColor(label: cartLabel)
            homeIcon.image = UIImage(named: "home_icon")
            exploreIcon.image = UIImage(named: "search_icon")
            lifestyleIcon.image = UIImage(named: "life_icon")
            accountIcon.image = UIImage(named: "user_icon_colored")
            cartIcon.image = UIImage(named: "cart_icon")
            break
        default:
            unselectedLabelColor(label: homeLabel)
            unselectedLabelColor(label: exploreLabel)
            unselectedLabelColor(label: lifestyleLabel)
            unselectedLabelColor(label: accountLabel)
            selectedLabelColor(label: cartLabel)
            homeIcon.image = UIImage(named: "home_icon")
            exploreIcon.image = UIImage(named: "search_icon")
            lifestyleIcon.image = UIImage(named: "life_icon")
            accountIcon.image = UIImage(named: "user_icon")
            cartIcon.image = UIImage(named: "cart_icon_colored")
            break
        }
    }
    
    func unselectedLabelColor(label : UILabel) {
        CommonMethods.setGradient(uiLabel: label, startColor: UIColor.myLineColor, endColor: UIColor.myLineColor)
    }
    
     func selectedLabelColor(label : UILabel) {
        CommonMethods.setGradient(uiLabel: label, startColor: UIColor.colorPrimary, endColor: UIColor.colorPrimaryDark)
    }
    
    func willMoveToControllerAtIndex(index: Int) {
        CommonMethods.showLog(tag: TAG, message: "willMoveToControllerAtIndex : \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        CommonMethods.showLog(tag: TAG, message: "didMoveToControllerAtIndex : \(index)")
        currentIndex = index
        checkAndUpdateTabStyle()
    }
    
    func onProcessComplete(type: String, status: String, message: String) {
        CommonMethods.showLog(tag: TAG, message: "onProcessComplete type : \(type) status : \(status) message : \(message)")
        switch type {
        case MyConstants.REFRESH_CART_DATA:
            checkAndShowCartCount()
            break
        default:
            break
        }
    }
}
