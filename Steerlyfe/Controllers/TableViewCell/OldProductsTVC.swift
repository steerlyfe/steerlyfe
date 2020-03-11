//
//  OldProductsTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 06/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class OldProductsTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let TAG = "OldProductsTVC"
    
    var cellWidth : CGFloat = 0.0
    var cellHeight : CGFloat = 0.0
    var products : [ProductDetail] = []
    var delegate : ButtonPressedAtPositionDelegate?
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(products : [ProductDetail], delegate : ButtonPressedAtPositionDelegate?) {
        self.products = products
        self.delegate = delegate
        DispatchQueue.main.async {
            self.setUI()
        }
    }
    
    @IBAction func viewAllPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.VIEW_ALL_PRODUCTS, position: 0)
    }
    
    func setUI() {
        let width = collectionView.frame.width
        cellWidth = (width / 2.5) - 5.0
        cellHeight = cellWidth + 50.0
        heightConstraint.constant = cellHeight
        CommonMethods.showLog(tag: TAG, message: "width : \(width)")
        CommonMethods.showLog(tag: TAG, message: "cellWidth : \(cellWidth)")
        CommonMethods.showLog(tag: TAG, message: "cellHeight : \(cellHeight)")
        collectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "OldProductsCVC", bundle: nil), forCellWithReuseIdentifier: "OldProductsCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OldProductsCVC", for: indexPath) as! OldProductsCVC
        cell.setDetail(width: cellWidth, height: cellHeight, productDetail: products[indexPath.row], delegate: delegate, position: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
