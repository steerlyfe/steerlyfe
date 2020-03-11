//
//  ProductAdditionalFeaturesTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 13/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class ProductAdditionalFeaturesTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let TAG = "ProductAdditionalFeaturesTVC"
    
    var additionalFeatures : [AdditionalFeatures]?
    var selectedPosition : Int?
    var delegate : ButtonPressedAtPositionDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(additionalFeatures : [AdditionalFeatures]?, selectedPosition : Int?, delegate : ButtonPressedAtPositionDelegate?) {
        self.additionalFeatures = additionalFeatures
        self.selectedPosition = selectedPosition
        self.delegate = delegate
        setUI()
    }
    
    func setUI() {
        collectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductAdditionalFeatureCVC", bundle: nil), forCellWithReuseIdentifier: "ProductAdditionalFeatureCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return additionalFeatures?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductAdditionalFeatureCVC", for: indexPath) as! ProductAdditionalFeatureCVC
        cell.setDetail(data: additionalFeatures?[indexPath.row], currentPosition: indexPath.row, selectedPosition: selectedPosition)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPosition = indexPath.row
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        delegate?.onButtonPressed(type: MyConstants.ADDITIONAL_FEATURE_CLICKED, position: selectedPosition ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = additionalFeatures?[indexPath.row]
        let text = "\(data?.value ?? "") \(data?.unitType ?? "")"
        var width = text.width(withConstrainedHeight: collectionView.frame.height, font: UIFont.systemFont(ofSize: 12.0))
        CommonMethods.showLog(tag: TAG, message: "position : \(indexPath.row) width : \(width)")
        if width < 80.0{
            width = 80.0
        }
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
