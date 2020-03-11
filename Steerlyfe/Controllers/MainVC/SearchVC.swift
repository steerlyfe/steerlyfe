//
//  SearchVC.swift
//  Steerlyfe
//
//  Created by nap on 29/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, ViewPagerControllerDelegate, ViewPagerControllerDataSource {

    let TAG = "SearchVC"
    
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    var viewPagerTabs : [ViewPagerTab] = []
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var searchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setUI()
        }
    }
    
    func setUI() {
        viewPagerTabs = []
        viewPagerTabs.append(ViewPagerTab(title: "Categories", imageName: "", isLocalImage: false))
        viewPagerTabs.append(ViewPagerTab(title: "Discover", imageName: "", isLocalImage: false))
        setViewPagerAdapter()
        CommonMethods.addCardViewStyle(uiView: searchView, cornerRadius: searchView.frame.height / 2.0, shadowRadius: 0.0)
        searchView.backgroundColor = UIColor.white
        searchLabel.textColor = UIColor.myGreyColor
    }
    
    func setViewPagerAdapter()  {
        options = ViewPagerOptions(viewPagerWithFrame: mainContainer.bounds)
        options.tabType = ViewPagerTabType.basic
        options.tabViewTextFont = UIFont.systemFont(ofSize: 14)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = false
        options.viewPagerFrame = mainContainer.bounds
        options.fitAllTabsInView = true
        options.isEachTabEvenlyDistributed = true
        options.tabViewHeight = 50
        options.tabViewBackgroundDefaultColor = UIColor.white
        options.tabViewBackgroundHighlightColor = UIColor.white
        options.tabIndicatorViewBackgroundColor = UIColor.black
        options.tabViewTextDefaultColor = UIColor.black
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        self.addChild(viewPager)
        mainContainer.addSubview(viewPager.view)
        viewPager.didMove(toParent: self)
    }
    
    func numberOfPages() -> Int {
        return viewPagerTabs.count
    }
    
    func viewControllerAtPosition(position: Int) -> UIViewController {
        if position == 0{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
            return vc
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DiscoverVC") as! DiscoverVC
            return vc
        }
        
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return viewPagerTabs
    }
    
    @IBAction func searchViewClicked(_ sender: Any) {
        MyNavigations.goToCombinedSearch(navigationController: navigationController)
//        MyNavigations.goToProductList(navigationController: navigationController, type: .searchProducts, pageTitle: "Search Products", categoryId: "", subStoreId: "", storeId: "")
    }
}

