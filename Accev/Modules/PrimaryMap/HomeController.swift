//
//  HomeViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/5/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import CoreLocation
import GoogleMaps
import UIKit

struct GlobalFilterVariables {
    static var accessibleWheelchairFilter = false
    static var accessibleHearingFilter = false
    static var accessibleBrailleFilter = false
}

class HomeController: RoutedViewController, GMSMapViewDelegate,
CLLocationManagerDelegate {

    // swiftlint:disable all
    var delegate: HomeControllerDelegate?
    var locationManager: CLLocationManager!
    // swiftlint:enable all
    var addPinState = false
    var pins = Dictionary<String, Dictionary<String, Any>>()
    let backendCaller = BackendCaller()
    let mapHelperFunctions = MapHelper()

    // Overrides
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFilters),
                                               name: NSNotification.Name(rawValue: "DoUpdateLabel"),
                                               object: nil)
        configureNavigationBar()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    @objc
    func updateFilters(notif: NSNotification) {
        let camera = GMSCameraPosition.camera(withLatitude: 42.279594,
                                              longitude: -83.732124, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
        mapView.addSubview(filterButton)
        refreshLocalPins(mapView, true)
    }

    @objc
    func presentFilter() {
        let controller = FilterController()
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = Colors.behindGradient
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self,
                                                           action: #selector(handleMenuToggle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:
            UIImage(named: "addPin72")?.withRenderingMode(.alwaysOriginal),
                                                            style: .plain, target: self,
                                                            action: #selector(addPinButtonPressed))
    }

    @objc
    func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }

    @objc
    func addPinButtonPressed() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
            guard let currentLocation = locationManager.location else {
                return
            }
            // this is the users location
//            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
//                                                  longitude: currentLocation.coordinate.longitude, zoom: 17.0)
            // this is Ann Arbor
            let camera = GMSCameraPosition.camera(withLatitude: 42.279594, longitude: -83.732124, zoom: 10.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.delegate = self
            self.view = mapView
            mapView.addSubview(filterButton)
            loadPins(mapView, false)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "x24white").withRenderingMode(.alwaysOriginal),
        style: .plain, target: self,
        action: #selector(cancelAddPin))
        navigationItem.title = "Tap to add a pin!"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: R.font.latoRegular(size: 22)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key: Any]
        addPinState = true
    }

    @objc
    func cancelAddPin() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal),
        style: .plain, target: self,
        action: #selector(handleMenuToggle))
        navigationItem.title = ""
        addPinState = false
    }

    @objc
    func presentDetails(_ identifier: String) {
        let controller = PinDetailsController()
        controller.pinID = identifier
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 42.279594, longitude: -83.732124, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
        mapView.addSubview(filterButton)
        // addSubview(searchBar)
        loadPins(mapView, false)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    guard let currentLocation = manager.location else {
                        return
                    }
                    let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                                          longitude: currentLocation.coordinate.longitude, zoom: 15.0)
                    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                    mapView.delegate = self
                    self.view = mapView
                    mapView.addSubview(filterButton)
                    loadPins(mapView, false)
                }
            }
        } else {
            let camera = GMSCameraPosition.camera(withLatitude: 42.279594, longitude: -83.732124, zoom: 10.0)
                    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                    mapView.delegate = self
                    self.view = mapView
                    mapView.addSubview(filterButton)
                    // addSubview(searchBar)
                    loadPins(mapView, false)
        }
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // swiftlint:disable all
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        if addPinState {
            // TODO: Direct user to inputing more info before moving on
            // For now let's assume we have some mock user input dictionary
            // And we'll add to our pins member dictionary
            var mockInputInfo = [String : Any]()
            mockInputInfo["latitude"] = coordinate.latitude
            mockInputInfo["longitude"] = coordinate.longitude
            mockInputInfo["upvotes"] = Int.random(in: 0..<1000)
            mockInputInfo["downvotes"] = Int.random(in: 0..<1000)
            mockInputInfo["accessibleWheelchair"] = true
            mockInputInfo["accessibleBraille"] = true
            mockInputInfo["accessibleHearing"] = true
            // TODO: have PinDetailsEntryController return relevant info through
            // a completion handler or something to be sent into addPinBackend.
            // Have some sort of submit button at the buttom to trigger
            // Could even through addPinBackend call inside PinDetailsEntryController
            // and return it with the other info, might make more sense
            // none of the events below should occur if the user exits out of details entry
            let controller = PinDetailsEntryController()
            controller.pinID = ""
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            // first grab the documentID from the pin that you created, this will be important
            let identifier = backendCaller.addPinBackend(mapView, coordinate, mockInputInfo)
            // add pin to our member dictionary, also important
            self.pins.updateValue(mockInputInfo, forKey: identifier)
            addPinUI(mapView, coordinate, identifier)
            addPinState = false
            cancelAddPin()
        }
        // swiftlint:enable all
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        presentDetails(marker.title ?? "")
    }

    // TODO: Improve the appearance of this custom info window
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // swiftlint:disable all
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        // shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 210, height: 110)
        view.layer.shadowRadius = 8
        let pinDict = self.pins[marker.title!]
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 1
        let borderColor = UIColor(red: 16.0/255.0, green: 96.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        view.layer.borderColor = borderColor.cgColor

        // Title
        let lbl1 = UILabel(frame: CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: 30))
        lbl1.attributedText = self.addInfoViewIcons(pinData: pinDict!)
        lbl1.font = R.font.latoRegular(size: 16)
        view.addSubview(lbl1)

        // Description
        let lbl2 = UILabel(frame: CGRect(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y
                                        + lbl1.frame.size.height + 3, width: view.frame.size.width - 16,
                                                                      height: 18))
        let trustRating = mapHelperFunctions.calculateTrustRating(pinDict?["upvotes"] as! Int,
                                                                  pinDict?["downvotes"] as! Int)
        lbl2.text = "\(trustRating)% of users agree"
        lbl2.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.addSubview(lbl2)
        view.addSubview(detailsButton)
        view.isUserInteractionEnabled = true
        // UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = .black
        return view
        // swiftlint:enable all
    }

    func loadPins(_ mapView: GMSMapView, _ filtersApplied: Bool) {
        // swiftlint:disable all
        backendCaller.pullPinsBackend(completion: {pins in
            self.pins = pins
            for (key, data) in pins {
                let marker = GMSMarker()
                marker.title = key
                marker.position = CLLocationCoordinate2D(latitude: data["latitude"] as! CLLocationDegrees,
                                                         longitude: data["longitude"] as! CLLocationDegrees)
                let customPin = UIImage(named: "bluePin")
                marker.iconView = UIImageView(image: customPin)
                marker.opacity = self.mapHelperFunctions.determineOpacity(data["upvotes"] as! Int,
                                                                     data["downvotes"] as! Int)
                marker.map = mapView
            }
        })
        // swiftlint:enable all
    }

    func refreshLocalPins(_ mapView: GMSMapView, _ filtersApplied: Bool) {
        var displayPin: Bool = true
        // swiftlint:disable all
            for (key, data) in self.pins {
                if filtersApplied{
                    let accessibleWheelchair : Bool = data["accessibleWheelchair"] as! Bool
                    let accessibleHearing : Bool = data["accessibleHearing"] as! Bool
                    let accessibleBraille : Bool = data["accessibleBraille"] as! Bool
                    if GlobalFilterVariables.accessibleWheelchairFilter {
                        if !accessibleWheelchair {
                            displayPin = false
                        }
                    }
                    if (GlobalFilterVariables.accessibleHearingFilter) {
                        if !accessibleHearing {
                            displayPin = false
                        }
                    }
                    if (GlobalFilterVariables.accessibleBrailleFilter) {
                        if !accessibleBraille {
                            displayPin = false
                        }
                    }
                }
                if displayPin {
                    let marker = GMSMarker()
                    marker.title = key
                    marker.position = CLLocationCoordinate2D(latitude: data["latitude"] as! CLLocationDegrees,
                                                             longitude: data["longitude"] as! CLLocationDegrees)
                    let customPin = UIImage(named: "bluePin")
                    marker.iconView = UIImageView(image: customPin)
                    marker.opacity = self.mapHelperFunctions.determineOpacity(data["upvotes"] as! Int,
                                                                         data["downvotes"] as! Int)
                    marker.map = mapView
                }
                displayPin = true
            }
        // swiftlint:enable all
    }

    func addPinUI(_ mapView: GMSMapView, _ coordinate: CLLocationCoordinate2D, _ identifier: String) {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = identifier
        let customPin = UIImage(named: "bluePin")
        marker.iconView = UIImageView(image: customPin)
        marker.opacity = 0.2
        marker.map = mapView
    }

    lazy var detailsButton: UIButton = {
        print()
        let infoButton = UIButton(frame: CGRect(x: 70, y: 75, width: 60, height: 15))
         let buttonAttributes: [NSAttributedString.Key: Any] = [
             NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
             NSAttributedString.Key.foregroundColor: Colors.behindGradient
         ]
         let attributeButtonString = NSMutableAttributedString(string: "Details",
                                                         attributes: buttonAttributes)
         infoButton.setAttributedTitle(attributeButtonString, for: .normal)
         infoButton.addTarget(self, action: #selector(presentDetails), for: .touchUpInside)

         return infoButton
    }()

    lazy var filterButton: UIButton = {
        let image = UIImage(named: "filter.png")
        // FIX: This is horrible, fix constraints so that it binds to buttom right off screen no matter what
        let filterButton = UIButton(frame: CGRect(x: 335, y: 735, width: 48, height: 48))
        filterButton.setBackgroundImage(image, for: .normal)
        filterButton.setImage(image, for: .normal)
        filterButton.addTarget(self, action: #selector(presentFilter), for: .touchUpInside)
        return filterButton
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 10, y: 730, width: UIScreen.main.bounds.width - 100, height: 60))
        // searchBar.searchTextField.backgroundColor = Colors.behindGradient
        searchBar.layer.cornerRadius = 10
        // textField.layer.masksToBounds = true
        // searchBar.tintColor = Colors.behindGradient
        return searchBar
    }()

    func addInfoViewIcons(pinData: [String: Any]) -> NSAttributedString {
        // swiftlint:disable all
        let completeText = NSMutableAttributedString(string: "")
        
        if pinData["accessibleWheelchair"] as! Bool{
            let imageAttachment =  NSTextAttachment()
            imageAttachment.image = UIImage(named: "wheelchair64pxBlue.png")
            let imageOffsetY:CGFloat = -5.0;
            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 24, height: 24)
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            completeText.append(attachmentString)
            completeText.append(NSAttributedString(string: "  "))
        }
        if pinData["accessibleBraille"] as! Bool{
            
            let imageAttachment =  NSTextAttachment()
            imageAttachment.image = UIImage(named: "braille64pxBlue.png")
            let imageOffsetY:CGFloat = -5.0;
            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 24, height: 24)
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            completeText.append(attachmentString)
            completeText.append(NSAttributedString(string: "  "))
        }
        if pinData["accessibleHearing"] as! Bool {
            
            let imageAttachment =  NSTextAttachment()
            imageAttachment.image = UIImage(named: "noise64pxBlue.png")
            let imageOffsetY:CGFloat = -5.0;
            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 24, height: 24)
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            completeText.append(attachmentString)
            
        }
        return completeText == NSMutableAttributedString(string: "") ?
                                NSMutableAttributedString(string:"No tags to display",
                                attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]) : completeText
        // swiftlint:enable all
    }
}
