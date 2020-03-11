//
//  NearbyStoresVC.swift
//  Steerlyfe
//
//  Created by nap on 03/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import GoogleMaps

class NearbyStoresVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NearbyStoresDelegate, ButtonPressedAtPositionDelegate {
   
    let TAG = "NearbyStoresVC"
    let locationManager = CLLocationManager()
    let myLocationMarkerImage = UIImage(named: "current_location_icon")!
    let selectedMarkerImage = UIImage(named: "selected_marker_icon")!
    let unselectedMarkerImage = UIImage(named: "unselected_marker_icon")!
    
    var storesList : [StoreDetail] = []
    var collectionCellWidth : CGFloat = 0.0
    var collectionCellHeight : CGFloat = 0.0
    var currentLat = 25.790654
    var currentLng = -80.1300455
    var zoomValue : Float = 16.0
    var location = CLLocation()
    var myLocationAvailable = false
    var animateCamera = false
    var locationUpdatedCalled = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        collectionView.register(UINib(nibName: "NearbyStoresCVC", bundle: nil), forCellWithReuseIdentifier: "NearbyStoresCVC")
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
        getData()
    }
    
    private func getData(){
        CommonWebServices.api.getNearbyStores(navigationController: navigationController, lat: currentLat, lng: currentLng, delegate: self)
    }
    
    func calculateConstraints() {
        let categoryCollectionWidth = self.collectionView.frame.width
        collectionCellWidth = ( categoryCollectionWidth * 3 ) / 4
        collectionCellHeight = self.collectionView.frame.height
        CommonMethods.showLog(tag: TAG, message: "collectionCellWidth : \(collectionCellWidth)")
        CommonMethods.showLog(tag: TAG, message: "collectionCellHeight : \(collectionCellHeight)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        CommonMethods.setNavigationBar(navigationController: navigationController, navigationItem: navigationItem, title: "Nearby Stores")
    }
    
    func onNearbyStoresListReceived(status: String, message: String, data: NearbyStoresResponse?) {
        switch status {
        case "1":
            self.storesList = data?.nearbyStores ?? []
            let camera = GMSCameraPosition.camera(withLatitude: currentLat, longitude: currentLng, zoom: zoomValue)
            mapView.camera = camera
            refreshAllMarkers()
            calculateConstraints()
            collectionView.reloadData()
            break
        default:
            MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "OK")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        CommonMethods.showLog(tag: TAG, message: "locationManager didChangeAuthorization \(status.rawValue)")
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        CommonMethods.showLog(tag: TAG, message: "locationManager didUpdateLocations \(locations)")
        location = locations[locations.count - 1]
        if location.horizontalAccuracy>1{
            if !locationUpdatedCalled{
                locationUpdatedCalled = true
                locationManager.stopUpdatingLocation()
                currentLat = location.coordinate.latitude
                currentLng = location.coordinate.longitude
                myLocationAvailable = true
                getData()
                refreshAllMarkers()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.locationUpdatedCalled = false
                    CommonMethods.showLog(tag: self.TAG, message: "locationUpdatedCalled : \(self.locationUpdatedCalled)")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        CommonMethods.showLog(tag: TAG, message: "LOCATION ERROR\(error)")
        myLocationAvailable = false
        getData()
    }
    
    func showMarker(position: CLLocationCoordinate2D, markerImage : UIImage, selected : Bool, markerTag : String, markerPosition : String){
        let marker = GMSMarker()
        let markerView = UIImageView(image: markerImage)
        markerView.tintColor = UIColor(white: 1, alpha: 0.0)
        marker.position = position
        marker.iconView = markerView
        marker.title = ""
        marker.snippet = ""
        marker.map = mapView
        marker.accessibilityLabel = markerTag
        marker.accessibilityHint = markerPosition
        if selected{
            if animateCamera{
                animateCamera = false
                mapView.animate(toLocation: position)
                
            }
//            mapView.selectedMarker = marker
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        CommonMethods.showLog(tag: TAG, message: marker)
        switch marker.accessibilityLabel {
        case "other":
            let position : Int = Int( marker.accessibilityHint ?? "0" ) ?? 0
            if storesList.count > 0{
                storesList.forEach({ (innerData) in
                    innerData.selected = false
                })
                storesList[position].selected = true
                refreshAllMarkers()
                collectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.collectionView.scrollToItem(at: IndexPath(row: position, section: 0), at: .left, animated: true)
                }
            }
            break
        default:
            break
        }
        return true
    }
    
    func refreshAllMarkers() {
        mapView.clear()
//        if myLocationAvailable{
//            showMarker(position: CLLocationCoordinate2D(latitude: currentLat, longitude: currentLng), markerImage: myLocationMarkerImage, selected: false, markerTag: "myMarker", markerPosition: "0")
//        }
        var count = 0
        storesList.forEach({ (innerData) in
            let lat : Double = Double( innerData.lat ?? currentLat )
            let lng : Double = Double( innerData.lng ?? currentLng )
            CommonMethods.showLog(tag: TAG, message: "refreshAllMarkers")
            CommonMethods.showLog(tag: TAG, message: "lat : \(lat)")
            CommonMethods.showLog(tag: TAG, message: "lng : \(lng)")
            if innerData.selected{
                let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: zoomValue)
                mapView.camera = camera
                showMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng), markerImage: selectedMarkerImage, selected: true, markerTag: "other", markerPosition: "\(count)")
            }else{
                showMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng), markerImage: unselectedMarkerImage, selected: true, markerTag: "other", markerPosition: "\(count)")
            }
            count = count + 1
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var count = 0
        storesList.forEach({ (innerData) in
            if innerData.selected{
                innerData.selected = false
                collectionView.reloadItems(at: [IndexPath(row: count, section: 0)])
            }
            count = count + 1
        })
        storesList[indexPath.row].selected = true
        collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
        animateCamera = true
        refreshAllMarkers()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyStoresCVC", for: indexPath) as! NearbyStoresCVC
        cell.setDetail(data: storesList[indexPath.row], buttonDelegate: self, position: indexPath.row)
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
