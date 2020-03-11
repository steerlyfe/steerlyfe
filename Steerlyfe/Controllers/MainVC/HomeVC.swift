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
    let userDefaults = UserDefaults.standard
    
    var data: HomeProductsResponse?
    var trendingCellWidth : CGFloat = 0.0
    var trendingCellHeight : CGFloat = 0.0
    var suggestedCellWidth : CGFloat = 0.0
    var suggestedCellHeight : CGFloat = 0.0
    var bottomMessageType : String = MyConstants.FAVOURITE_LIST
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomMessageButton: UIButton!
    @IBOutlet weak var bottomMessageLabel: UILabel!
    @IBOutlet weak var bottomMessageView: UIView!
    @IBOutlet weak var favouriteView: UIView!
    @IBOutlet weak var autoOrderView: UIView!
    @IBOutlet weak var messagesView: UIView!
    @IBOutlet weak var reorderView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
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
        CommonMethods.setLoadingIndicatorStyle(loadingIndicator: loadingIndicator)
        CommonMethods.addCardViewStyle(uiView: searchView, cornerRadius: 25.0, shadowRadius: 0.0)
        CommonMethods.addCardViewStyle(uiView: suggestedProductsView, cornerRadius: 10.0, shadowRadius: 5.0)
        bottomView.isHidden = true
        loadingIndicator.isHidden = false
//        CommonMethods.addRoundCornerFilled(uiview: bottomMessageView, borderWidth: 1.0, borderColor: UIColor.black, backgroundColor: UIColor.white, cornerRadius: 5.0)
        bottomMessageView.isHidden = true
        CommonMethods.addRoundCornerFilled(uiview: bottomMessageButton, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 5.0)
        setUI()
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
        
        CommonMethods.showLog(tag: TAG, message: "trendingWidth : \(trendingWidth)")
        CommonMethods.showLog(tag: TAG, message: "trendingCellWidth : \(trendingCellWidth)")
        CommonMethods.showLog(tag: TAG, message: "trendingCellHeight : \(trendingCellHeight)")
        CommonMethods.showLog(tag: TAG, message: "screen width : \(self.view.frame.width)")
        
        let suggestedWidth = trendingProductsView.frame.width
        suggestedCellWidth = suggestedWidth / 2.5
        suggestedCellHeight = suggestedCellWidth
        suggestedProductsHeight.constant = suggestedCellHeight
        setButtonStyle(uiView: reorderView)
        setButtonStyle(uiView: messagesView)
        setButtonStyle(uiView: autoOrderView)
        setButtonStyle(uiView: favouriteView)
    }
    
    func onHomeDataReceived(status: String, message: String, data: HomeProductsResponse?) {
        loadingIndicator.isHidden = true
        switch status {
        case "1":
            bottomView.isHidden = false
            self.data = data
            self.nameLabel.text = "\(CommonMethods.getWishingMessage()) \(userDefaults.string(forKey: MyConstants.FULL_NAME) ?? "")".uppercased()
            self.messageLabel.text = """
            "\(data?.homeMessage ?? "")"
            """
            setUI()
            trendingProductsCollectionView.reloadData()
            suggestedProductsCollectionView.reloadData()
            break
        default:
            MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "OK")
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
            cell.setDetail(productDetail: data?.trendingProducts[indexPath.row], delegate: self, position: indexPath.row, databaseMethods: databaseMethods)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestedProductsCVC", for: indexPath) as! SuggestedProductsCVC
            cell.setDetail(productDetail: data?.suggestedProducts[indexPath.row], delegate: self, position: indexPath.row, cellWidth: suggestedCellWidth, cellHeight: suggestedCellHeight)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == trendingProductsCollectionView{
            return CGSize(width: trendingCellWidth, height: trendingCellHeight)
        }else{
            return CGSize(width: suggestedCellWidth, height: suggestedCellHeight)
        }
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.ADD_TO_FAVOURITES:
            var showMessage = false
            let productDetail = data?.trendingProducts[position]
            if databaseMethods.isProductFavourite(productId: productDetail?.product_id ?? "") ?? false{
                if databaseMethods.deleteFavouriteProduct(productId: productDetail?.product_id ?? ""){
                    bottomMessageLabel.text = "Item removed from favorites"
                    showMessage = true
                }
            }else{
                if databaseMethods.addProductInFavourite(productDetail: productDetail){
                    bottomMessageLabel.text = "Item added to favorites"
                    showMessage = true
                }
            }
            if showMessage{
                bottomMessageButton.setTitle("Favorites", for: .normal)
                bottomMessageView.isHidden = false
                CommonMethods.fadeIn(view: bottomMessageView)
                trendingProductsCollectionView.reloadItems(at: [IndexPath(row: position, section: 0)])
                bottomMessageType = MyConstants.FAVOURITE_LIST
            }
            break
        case MyConstants.TRENDING_VIEW_DETAIL:
            if position < data?.trendingProducts.count ?? 0{
                MyNavigations.goToProductDetail(navigationController: navigationController, productId: data?.trendingProducts[position].product_id, refreshProductsListDelegate: nil)
            }
            break
        case MyConstants.SUGGESTED_VIEW_DETAIL:
            if position < data?.suggestedProducts.count ?? 0{
                MyNavigations.goToProductDetail(navigationController: navigationController, productId: data?.suggestedProducts[position].product_id, refreshProductsListDelegate: nil)
            }
            break
        default:
            break
        }
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        MyNavigations.goToNearbyStores(navigationController: navigationController)
//        MyNavigations.goToStoreDetail(navigationController: navigationController, subStoreId: "17")
    }
    
    @IBAction func scannerPressed(_ sender: Any) {
        MyNavigations.goToScanner(navigationController: navigationController)
    }
    
    @IBAction func searchViewClicked(_ sender: Any) {
        MyNavigations.goToCombinedSearch(navigationController: navigationController)
    }
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "favouriteButtonPressed")
        MyNavigations.goToFavouriteProducts(navigationController: navigationController)
    }
    
    @IBAction func autoOrderButtonPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "autoOrderButtonPressed")
    }
       
    @IBAction func messagesButtonPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "messagesButtonPressed")
    }
    
    @IBAction func reorderButtonPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "reorderButtonPressed")
    }
    
    func setButtonStyle(uiView : UIView) {
        CommonMethods.addRoundCornerFilled(uiview: uiView, borderWidth: 1.0, borderColor: UIColor.myLineLightColor, backgroundColor: UIColor.myLineLightColor, cornerRadius: uiView.frame.height / 2.0)
    }
    
    @IBAction func bottomButtonPressed(_ sender: Any) {
        if bottomMessageType == MyConstants.FAVOURITE_LIST{
            MyNavigations.goToFavouriteProducts(navigationController: navigationController)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        suggestedProductsCollectionView.reloadData()
        trendingProductsCollectionView.reloadData()
    }
    
}
