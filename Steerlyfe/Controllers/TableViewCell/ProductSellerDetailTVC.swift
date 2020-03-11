//
//  ProductSellerDetailTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 13/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class ProductSellerDetailTVC: UITableViewCell, ViewPagerControllerDelegate, ViewPagerControllerDataSource {
    
    let TAG = "ProductSellerDetailTVC"
    
    var productDetail : ProductDetail?
    var additionalFeatureIndex : Int?
    var sellerDetailIndex : Int?
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    var viewPagerTabs : [ViewPagerTab] = []
    var uiViewController : UIViewController?
    var databaseMethods : DatabaseMethods?
    var delegate : OnProcessCompleteDelegate?
    
    @IBOutlet weak var mainContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonMethods.addBackgroundShadowStyle(uiView: mainContainer, cornerRadius: 0.0, shadowRadius: 20.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(uiViewController : UIViewController?, productDetail : ProductDetail?, additionalFeatureIndex : Int, sellerDetailIndex : Int, databaseMethods : DatabaseMethods?, delegate : OnProcessCompleteDelegate?) {
        self.uiViewController = uiViewController
        self.productDetail = productDetail
        self.additionalFeatureIndex = additionalFeatureIndex
        self.sellerDetailIndex = sellerDetailIndex
        self.databaseMethods = databaseMethods
        self.delegate = delegate
        CommonMethods.showLog(tag: TAG, message: "additionalFeatureIndex : \(additionalFeatureIndex)")
        CommonMethods.showLog(tag: TAG, message: "sellerDetailIndex : \(sellerDetailIndex)")
        setUI()
    }
    
    func setUI() {
        viewPagerTabs = []
        productDetail?.product_availability.forEach({ (innerData) in
            if innerData.type == MyConstants.PRODUCT_AVAILABLITY_IN_STORE{
                viewPagerTabs.append(ViewPagerTab(title: "In-Store", imageName: "", isLocalImage: false))
            }else if innerData.type == MyConstants.PRODUCT_AVAILABLITY_DELIVER_NOW{
                viewPagerTabs.append(ViewPagerTab(title: "Deliver Now", imageName: "", isLocalImage: false))
            }else if innerData.type == MyConstants.PRODUCT_AVAILABLITY_SHIPPING{
                viewPagerTabs.append(ViewPagerTab(title: "Shipping", imageName: "", isLocalImage: false))
            }
        })
        CommonMethods.showLog(tag: TAG, message: "viewPagerTabs : \(viewPagerTabs.count)")
        DispatchQueue.main.async {
            if self.viewPagerTabs.count > 0{
                self.setViewPagerAdapter()
            }
        }
    }
    
    func setViewPagerAdapter()  {
        options = ViewPagerOptions(viewPagerWithFrame: mainContainer.bounds)
        options.tabType = ViewPagerTabType.basic
        options.tabViewTextFont = UIFont.systemFont(ofSize: 14, weight: .bold)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        options.viewPagerFrame = mainContainer.bounds
        options.fitAllTabsInView = true
        options.isEachTabEvenlyDistributed = true
        options.tabViewHeight = 50
        options.tabViewBackgroundDefaultColor = .white
        options.tabViewBackgroundHighlightColor = .white
        options.tabIndicatorViewBackgroundColor = .black
        options.tabViewTextDefaultColor = .gray
        options.tabViewTextHighlightColor = .black
        options.tabViewBackgroundDefaultColor = .white
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        uiViewController?.addChild(viewPager)
        mainContainer.addSubview(viewPager.view)
        viewPager.didMove(toParent: uiViewController)
    }
    
    func numberOfPages() -> Int {
        return viewPagerTabs.count
    }
    
    func viewControllerAtPosition(position: Int) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerDetailVC") as! SellerDetailVC
        vc.productDetail = productDetail
        vc.additionalFeatureIndex = additionalFeatureIndex
        vc.productAvailabilityIndex = position
        vc.sellerDetailIndex = sellerDetailIndex
        vc.databaseMethods = databaseMethods
        vc.delegate = delegate
        return vc
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return viewPagerTabs
    }
}
