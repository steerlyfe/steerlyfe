//
//  PostListTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 20/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class PostListTVC: UITableViewCell, ViewPagerControllerDelegate, ViewPagerControllerDataSource {
    
    let TAG = "PostListTVC"
    
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    var viewPagerTabs : [ViewPagerTab] = []
    var uiViewController : UIViewController?
    var data : PostDetail?
    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var mainTopView: UIView!
    @IBOutlet weak var imagesContainer: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var saveIcon: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonMethods.addCardViewStyle(uiView: mainTopView, cornerRadius: 20.0, shadowRadius: 10.0, shadowColor: UIColor.colorPrimaryDarkTrans)
        CommonMethods.makeRoundImageView(imageView: logoImageView, cornerRadius: logoImageView.frame.width / 2.0)
        pageControl.currentPageIndicatorTintColor = UIColor.colorPrimaryDark
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : PostDetail?, uiViewController : UIViewController?, delegate : ButtonPressedAtPositionDelegate?, position : Int) {
        self.data = data
        self.uiViewController = uiViewController
        self.delegate = delegate
        self.position = position
        viewsLabel.text = "Views \(CommonMethods.convertCommaSeperateValue(number: data?.views ?? 0))"
        descLabel.text = data?.title
        logoImageView.sd_setImage(with: URL(string: data?.storeLogo ?? ""), placeholderImage: UIImage(named: "place_holder")) { (image, error, cacheType, url) in
        }
        nameLabel.text = data?.storeName
        timeLabel.text = CommonMethods.convertTimeAgo(timeStamp: data?.createdTime)
        let imageCount = data?.postImages?.count ?? 0
        pageControl.numberOfPages = imageCount
        checkAndShowSavedPost()
        setUI()
    }
    
    func checkAndShowSavedPost() {
        if data?.postSaved ?? false{
            saveIcon.image = UIImage(named: "bookmark_filled")
        }else{
            saveIcon.image = UIImage(named: "bookmark_empty")
        }
    }
    
    func setUI() {
        viewPagerTabs = []
        data?.postImages?.forEach({ (imageUrl) in
            viewPagerTabs.append(ViewPagerTab(title: "", imageName: "", isLocalImage: false))
        })
        CommonMethods.showLog(tag: TAG, message: "viewPagerTabs : \(viewPagerTabs.count)")
        DispatchQueue.main.async {
            if self.viewPagerTabs.count > 0{
                self.setViewPagerAdapter()
            }
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        var action = ""
        if data?.postSaved ?? false{
            action = MyConstants.CHANGE_POST_STATUS_REMOVE
        }else{
            action = MyConstants.CHANGE_POST_STATUS_SAVE
        }
        data?.postSaved = !(data?.postSaved ?? false)
        checkAndShowSavedPost()
        CommonWebServices.api.savePost(post_id: data?.postId ?? "", action: action)
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.SHARE_POST, position: position)
    }
    
    func setViewPagerAdapter()  {
        options = ViewPagerOptions(viewPagerWithFrame: imagesContainer.bounds)
//        options.tabType = ViewPagerTabType.basic
//        options.tabViewTextFont = UIFont.systemFont(ofSize: 14, weight: .bold)
//        options.tabViewPaddingLeft = 20
//        options.tabViewPaddingRight = 20
//        options.isTabHighlightAvailable = true
//        options.viewPagerFrame = imagesContainer.bounds
//        options.fitAllTabsInView = true
//        options.isEachTabEvenlyDistributed = true
        options.tabViewHeight = 0
//        options.tabViewBackgroundDefaultColor = .white
//        options.tabViewBackgroundHighlightColor = .white
//        options.tabIndicatorViewBackgroundColor = .black
//        options.tabViewTextDefaultColor = .gray
//        options.tabViewTextHighlightColor = .black
//        options.tabViewBackgroundDefaultColor = .white
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        uiViewController?.addChild(viewPager)
        imagesContainer.addSubview(viewPager.view)
        viewPager.didMove(toParent: uiViewController)
    }
    
    func numberOfPages() -> Int {
        return viewPagerTabs.count
    }
    
    func viewControllerAtPosition(position: Int) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostImageVC") as! PostImageVC
        vc.imageUrl = data?.postImages?[position]
        return vc
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return viewPagerTabs
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        CommonMethods.showLog(tag: TAG, message: "didMoveToControllerAtIndex : \(index)")
        pageControl.currentPage = index
    }
    
    
    @IBAction func pageControllerChanged(_ sender: UIPageControl) {
        CommonMethods.showLog(tag: TAG, message: "pageControllerChanged : \(sender.currentPage)")
        pageControl.currentPage = sender.currentPage
        viewPager.displayViewController(atIndex: sender.currentPage)
    }
}
