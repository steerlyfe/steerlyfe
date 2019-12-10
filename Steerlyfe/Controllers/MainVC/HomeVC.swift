//
//  HomeVC.swift
//  Steerlyfe
//
//  Created by nap on 28/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, HomeDataDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ButtonPressedAtPositionDelegate {
   
    let TAG = "HomeVC"
    let databaseMethods = DatabaseMethods()
    
    var data: HomeProductsResponse?
    var trendingCellWidth : CGFloat = 0.0
    var trendingCellHeight : CGFloat = 0.0
    var suggestedCellWidth : CGFloat = 0.0
    var suggestedCellHeight : CGFloat = 0.0
    
    @IBOutlet weak var suggestedProductsLabel: UILabel!
    @IBOutlet weak var trendingProductsLabel: UILabel!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var suggestedProductsCollectionView: UICollectionView!
    @IBOutlet weak var trendingProductsView: UIView!
    @IBOutlet weak var trendingProductsCollectionView: UICollectionView!
    @IBOutlet weak var suggestedProductsHeight: NSLayoutConstraint!
    @IBOutlet weak var trendingProductsHeight: NSLayoutConstraint!
    @IBOutlet weak var suggestedProductsView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonMethods.common.addCardViewStyle(uiView: searchView, cornerRadius: 25.0, shadowRadius: 0.0)
        CommonMethods.common.addCardViewStyle(uiView: suggestedProductsView, cornerRadius: 10.0, shadowRadius: 5.0)
        bottomView.isHidden = true
        CommonWebServices.api.getHomeData(navigationController: navigationController, delegate: self)
    }
    
    func setUI() {
        searchBackView.backgroundColor = UIColor.white
        searchLabel.textColor = UIColor.myGreyColor
        trendingProductsLabel.textColor = UIColor.myGreyColor
        suggestedProductsLabel.textColor = UIColor.myGreyColor
        trendingProductsCollectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        suggestedProductsCollectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        trendingProductsCollectionView.delegate = self
        trendingProductsCollectionView.dataSource = self
        suggestedProductsCollectionView.delegate = self
        suggestedProductsCollectionView.dataSource = self
        trendingProductsCollectionView.register(UINib(nibName: "TrendingProductsCVC", bundle: nil), forCellWithReuseIdentifier: "TrendingProductsCVC")
        suggestedProductsCollectionView.register(UINib(nibName: "SuggestedProductsCVC", bundle: nil), forCellWithReuseIdentifier: "SuggestedProductsCVC")
        let trendingWidth = trendingProductsView.frame.width
        trendingCellWidth = trendingWidth / 2.0
        trendingCellHeight = trendingCellWidth + 50.0
        trendingProductsHeight.constant = trendingCellHeight
        
        CommonMethods.common.showLog(tag: TAG, message: "trendingWidth : \(trendingWidth)")
        CommonMethods.common.showLog(tag: TAG, message: "trendingCellWidth : \(trendingCellWidth)")
        CommonMethods.common.showLog(tag: TAG, message: "trendingCellHeight : \(trendingCellHeight)")
        CommonMethods.common.showLog(tag: TAG, message: "screen width : \(self.view.frame.width)")
        
        let suggestedWidth = trendingProductsView.frame.width
        suggestedCellWidth = suggestedWidth / 2.5
        suggestedCellHeight = suggestedCellWidth
        suggestedProductsHeight.constant = suggestedCellHeight
    }
    
    func onHomeDataReceived(status: String, message: String, data: HomeProductsResponse?) {
        switch status {
        case "1":
            bottomView.isHidden = false
            self.data = data
            setUI()
            trendingProductsCollectionView.reloadData()
            suggestedProductsCollectionView.reloadData()
            break
        default:
            MyNavigations.navigation.showCommonMessageDialog(message: message, buttonTitle: "OK")
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == trendingProductsCollectionView{
            return data?.trendingProducts.count ?? 0
        }else{
            return data?.suggestedProducts.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == trendingProductsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingProductsCVC", for: indexPath) as! TrendingProductsCVC
            cell.setDetail(productDetail: data?.trendingProducts[indexPath.row], delegate: self, position: indexPath.row)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestedProductsCVC", for: indexPath) as! SuggestedProductsCVC
            cell.setDetail(productDetail: data?.suggestedProducts[indexPath.row], delegate: self, position: indexPath.row)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == trendingProductsCollectionView{
            return CGSize(width: trendingCellWidth, height: trendingCellHeight)
        }else{
            return CGSize(width: suggestedCellWidth, height: suggestedCellHeight)
        }
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.common.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case "AddToCart":
            if databaseMethods.checkAndUpdateCartProduct(productDetail: data?.trendingProducts[position], calledForAdd: true) ?? false{
                MyNavigations.navigation.showCommonMessageDialog(message: "Item Added to cart", buttonTitle: "OK")
            }
            break
        case "ViewDetail":
            break
        default:
            break
        }
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        MyNavigations.navigation.goToNearbyStores(navigationController: navigationController)
//        MyNavigations.navigation.goToStoreDetail(navigationController: navigationController, subStoreId: "2")
    }
    
    @IBAction func scannerPressed(_ sender: Any) {
    }
    @IBAction func searchViewClicked(_ sender: Any) {
        MyNavigations.navigation.goToProductList(navigationController: navigationController, type: .searchProducts, pageTitle: "Search Products", categoryId: "", subStoreId: "", storeId: "")
    }
    
}
