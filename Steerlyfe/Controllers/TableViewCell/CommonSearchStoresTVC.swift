//
//  CommonSearchStoresTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 28/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class CommonSearchStoresTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ButtonPressedAtPositionDelegate {
    
    let TAG = "CommonSearchStoresTVC"
    
    var navigationController : UINavigationController?
    var storesList : [StoreDetail] = []
    var collectionCellWidth : CGFloat = 0.0
    var collectionCellHeight : CGFloat = 0.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(storesList : [StoreDetail], navigationController : UINavigationController?) {
        self.storesList = storesList
        self.navigationController = navigationController
        collectionView.register(UINib(nibName: "NearbyStoresCVC", bundle: nil), forCellWithReuseIdentifier: "NearbyStoresCVC")
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        calculateConstraints()
        collectionView.reloadData()
    }
    
    func calculateConstraints() {
        let categoryCollectionWidth = self.collectionView.frame.width
        collectionCellWidth = ( categoryCollectionWidth * 3 ) / 4
        collectionCellHeight = self.collectionView.frame.height
        CommonMethods.showLog(tag: TAG, message: "collectionCellWidth : \(collectionCellWidth)")
        CommonMethods.showLog(tag: TAG, message: "collectionCellHeight : \(collectionCellHeight)")
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var count = 0
//        storesList.forEach({ (innerData) in
//            if innerData.selected{
//                innerData.selected = false
//                collectionView.reloadItems(at: [IndexPath(row: count, section: 0)])
//            }
//            count = count + 1
//        })
//        storesList[indexPath.row].selected = true
//        collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyStoresCVC", for: indexPath) as! NearbyStoresCVC
        let store = storesList[indexPath.row]
        store.selected = true
        cell.setDetail(data: store, buttonDelegate: self, position: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionCellWidth , height: collectionCellHeight)
    }
    
    func onButtonPressed(type: String, position: Int) {
        switch type {
        case "MoreDetail":
            MyNavigations.goToStoreDetail(navigationController: navigationController, subStoreId: storesList[position].subStoreId ?? "")
            break
        default:
            break
        }
    }
    
}
