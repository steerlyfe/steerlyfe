//
//  CategoriesVC.swift
//  Steerlyfe
//
//  Created by nap on 30/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ButtonPressedAtPositionDelegate {
    
    let TAG = "CategoriesVC"
    let databaseMethods = DatabaseMethods()
    
    var data : [CategoryDetail] = []
    var cellWidth : CGFloat = 0.0
    var cellHeight : CGFloat = 0.0
    
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = databaseMethods.getAllCategories()
        CommonMethods.common.showLog(tag: TAG, message: "Categories : \(data.count)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setUI()
        }
    }
    
    func setUI() {
        collectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CategoryCVC", bundle: nil), forCellWithReuseIdentifier: "CategoryCVC")
        let width = collectionView.frame.width
        cellWidth = (width / 2.0) - 5.0
        cellHeight = cellWidth + 50.0
        if data.count > 0{
            noDataMessage.isHidden = true
        }else{
            noDataMessage.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCVC", for: indexPath) as! CategoryCVC
        cell.setDetail(data: data[indexPath.row], delegate: self, position: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.common.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case "ViewDetail":
            MyNavigations.navigation.goToProductList(navigationController: navigationController, type: .categoryProducts, pageTitle: "\(data[position].categoryName ?? "")'s Products", categoryId: data[position].categoryId ?? "", subStoreId: "", storeId: "")
            break
        default:
            break
        }
    }
}


