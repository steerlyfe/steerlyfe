//
//  StoreDetailInfoTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 29/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import Cosmos
import GoogleMaps
import SDWebImage
import MapKit

class StoreDetailInfoTVC: UITableViewCell {
    
    let TAG = "StoreDetailInfoTVC"
    
    var zoomValue : Float = 16.0
    var data : StoreDetail?
    var delegate : ButtonPressedDelegate?
    
    @IBOutlet weak var writeReviewLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var addReviewView: UIView!
    @IBOutlet weak var reviewsTitleView: UIView!
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var storeInfoView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        writeReviewLabel.textColor = UIColor.myGreyColor
        CommonMethods.addCardViewStyle(uiView: storeInfoView, cornerRadius: 10.0, shadowRadius: 5.0, shadowColor: UIColor.lightGray)
        locationButton.setTitleColor(UIColor.white, for: .normal)
        CommonMethods.roundCornerFilledGradientNew(uiView: locationButton, cornerRadius: locationButton.frame.height / 2.0)
//        CommonMethods.addRoundCornerFilled(uiview: locationButton, borderWidth: 0.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: locationButton.frame.height / 2.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : StoreDetail?, delegate : ButtonPressedDelegate?) {
        self.data = data
        self.delegate = delegate
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
            return CommonMethods.getTimeStringFromTimeStamp(timeStamp: CommonMethods.getTimestampFromTimeString(dateString: value ?? ""))
        }
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
