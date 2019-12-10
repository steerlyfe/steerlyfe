//
//  StoreDetailTopTVC.swift
//  Steerlyfe
//
//  Created by nap on 04/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import Cosmos
import GoogleMaps
import SDWebImage
import MapKit

class StoreDetailTopTVC: UITableViewCell {
    
    let TAG = "StoreDetailTopTVC"
    
    var zoomValue : Float = 16.0
    var data : StoreDetail?
    var delegate : ButtonPressedDelegate?
    
    @IBOutlet weak var writeReviewLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var topEmptyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addReviewView: UIView!
    @IBOutlet weak var reviewsTitleView: UIView!
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var storeInfoOuterView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var storeDesc: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeLogo: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var topRoundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        CommonMethods.common.setRatingStarStyle(ratingView: ratingView)
        menuButton.setTitleColor(UIColor.white, for: .normal)
        locationButton.setTitleColor(UIColor.white, for: .normal)
        writeReviewLabel.textColor = UIColor.myGreyColor
        CommonMethods.common.makeRoundImageView(imageView: storeLogo, cornerRadius: 10.0)
        CommonMethods.common.roundCornerView(uiView: messageView, cornerRadius: 25.0)
        CommonMethods.common.roundCornerView(uiView: topRoundView, cornerRadius: 12.5)
        CommonMethods.common.addCardViewStyle(uiView: storeInfoOuterView, cornerRadius: 10.0, shadowRadius: 10.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : StoreDetail?, height : CGFloat, delegate : ButtonPressedDelegate?) {
        self.data = data
        self.delegate = delegate
        CommonMethods.common.showLog(tag: TAG, message: "height : \(height)")
        topEmptyViewHeight.constant = height - UIApplication.shared.statusBarFrame.height - 100.0
//        topEmptyViewHeight.constant = 10.0
        storeName.text = data?.storeName
        ratingView.rating = data?.storeRating ?? 0.0
        storeLogo.sd_setImage(with: URL(string: data?.storeLogo ?? "" )) { (image, error, cacheType, url) in
        }
        storeDesc.text = data?.description
        addressLabel.text = data?.address
        timingLabel.text = "\(getTimeString(value: data?.openingTime)) - \(getTimeString(value: data?.closingTime))"
        phoneLabel.text = data?.phoneNumber
        emailLabel.text = data?.email
        if let lat = data?.lat{
            if let lng = data?.lng{
                let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: zoomValue)
                googleMapView.camera = camera
                showMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng), markerImage: UIImage(named: "location_pin")!)
            }
        }
        self.googleMapView.isUserInteractionEnabled = false
    }
    
    func getTimeString(value : String?) -> String {
        if value == ""{
            return ""
        }else{
            return CommonMethods.common.getTimeStringFromTimeStamp(timeStamp: CommonMethods.common.getTimestampFromTimeString(dateString: value ?? ""))
        }
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) {
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: "MenuPressed")
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        openMapForPlace()
    }
    
    @IBAction func addNewReview(_ sender: Any) {
    }
    
    func showMarker(position: CLLocationCoordinate2D, markerImage : UIImage){
        let marker = GMSMarker()
        let markerView = UIImageView(image: markerImage)
        markerView.tintColor = UIColor(white: 1, alpha: 0.0)
        marker.position = position
        marker.iconView = markerView
        marker.title = ""
        marker.snippet = ""
        marker.map = googleMapView
        googleMapView.selectedMarker = marker
    }
    
    func openMapForPlace() {
        let latitude: CLLocationDegrees = data?.lat ?? 0.0
        let longitude: CLLocationDegrees = data?.lng ?? 0.0
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = data?.address
        mapItem.openInMaps(launchOptions: options)
    }
}
