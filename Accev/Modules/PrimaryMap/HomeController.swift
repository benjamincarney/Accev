//
//  HomeViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/5/20.
//  Copyright © 2020 Accev. All rights reserved.
//  swiftlint:disable all

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

    var delegate: HomeControllerDelegate?
    var locationManager: CLLocationManager!
    var addPinState = false
    var pins = [String: [String: Any]]()
    let backendCaller = BackendCaller()
    let mapHelperFunctions = MapHelper()
    var resultsFromPinEntry = [String: Any]()

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
        mapView.addSubview(filterButton)
        mapView.addSubview(searchButton)

        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30).isActive = true
        filterButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30).isActive = true

        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 30).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30).isActive = true
        self.view = mapView
        refreshLocalPins(mapView, true)
    }

    @objc
    func presentFilter() {
        let controller = FilterController()
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    @objc
    func presentSearch() {
        print("present search bar")
    }

    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = Colors.behindGradient
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        addNavButtons()
    }

    /// Place menu and add pin nav buttons
    func addNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self,
                                                           action: #selector(handleMenuToggle))
        // TODO: change pin image? small rn and slightly left
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:
            UIImage(named: "addPinSmall")?.withRenderingMode(.alwaysOriginal),
                                                            style: .plain, target: self,
                                                            action: #selector(addPinButtonPressed))
    }

    // PinEntryControllerDelegate
    func pinEntryControllerWillDismiss(pinEntryVC: PinDetailsEntryController, mapView: GMSMapView) {
        // Store info from user in HomeController
        resultsFromPinEntry = pinEntryVC.pinInfo
        // swiftlint:disable all

        // first grab the documentID from the pin that you created, this will be important
        let pinID = backendCaller.addPinBackend(mapView, pinEntryVC.coordinate!, self.resultsFromPinEntry)

        // add pin to our member dictionary, also important
        self.pins.updateValue(self.resultsFromPinEntry, forKey: pinID)

        addPinUI(mapView, pinEntryVC.coordinate!, pinID)

        // Present alert controller
        let pinMessage = "Pin successfully submitted."
        let pinSubmissionAlert = UIAlertController(title: "Success!", message: pinMessage, preferredStyle: .alert)
        pinSubmissionAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        pinEntryVC.present(pinSubmissionAlert, animated: true, completion: nil)
        // swiftlint:enable all
    }

    @objc
    func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }

    @objc
    func addPinButtonPressed() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
//            guard let currentLocation = locationManager.location else {
//                return
//            }
            // this is the users location
//            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
//                                                  longitude: currentLocation.coordinate.longitude, zoom: 17.0)
            // this is Ann Arbor
            let camera = GMSCameraPosition.camera(withLatitude: 42.279594, longitude: -83.732124, zoom: 10.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.delegate = self
            mapView.addSubview(filterButton)
            mapView.addSubview(searchButton)

            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30).isActive = true
            filterButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30).isActive = true

            searchButton.translatesAutoresizingMaskIntoConstraints = false
            searchButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 30).isActive = true
            searchButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30).isActive = true
            self.view = mapView
            loadPins(mapView, false)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "x24white").withRenderingMode(.alwaysOriginal),
        style: .plain, target: self,
        action: #selector(cancelAddPin))
        navigationItem.rightBarButtonItem = nil
        navigationItem.title = "Tap to add a pin!"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: R.font.latoRegular(size: 22)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key: Any]
        addPinState = true
    }

    @objc
    func cancelAddPin() {
        addNavButtons()
        navigationItem.title = ""
        addPinState = false
    }

    @objc
    func presentDetails(_ identifier: String) {
        let controller = PinDetailsController()
        controller.pinID = identifier
        controller.upvotes = self.pins[identifier]?["upvotes"] as? Int
        controller.downvotes = self.pins[identifier]?["downvotes"] as? Int
        controller.accessibleBraille = self.pins[identifier]?["accessibleBraille"] as? Bool
        controller.accessibleHearing = self.pins[identifier]?["accessibleHearing"] as? Bool
        controller.accessibleWheelchair = self.pins[identifier]?["accessibleWheelchair"] as? Bool
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 42.279594, longitude: -83.732124, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        mapView.addSubview(filterButton)
        mapView.addSubview(searchButton)

        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30).isActive = true
        filterButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30).isActive = true

        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 30).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30).isActive = true
        self.view = mapView
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
                    mapView.addSubview(filterButton)
                    mapView.addSubview(searchButton)

                    filterButton.translatesAutoresizingMaskIntoConstraints = false
                    filterButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30).isActive = true
                    filterButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30).isActive = true

                    searchButton.translatesAutoresizingMaskIntoConstraints = false
                    searchButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 30).isActive = true
                    searchButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30).isActive = true
                    self.view = mapView
                    loadPins(mapView, false)
                }
            }
        } else {
            let camera = GMSCameraPosition.camera(withLatitude: 42.279594, longitude: -83.732124, zoom: 10.0)
                    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                    mapView.delegate = self
                    mapView.addSubview(filterButton)
            // this is the users location
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                                  longitude: currentLocation.coordinate.longitude, zoom: 17.0)
           
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.delegate = self
            mapView.addSubview(filterButton)
            mapView.addSubview(searchButton)

            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30).isActive = true
            filterButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30).isActive = true

            searchButton.translatesAutoresizingMaskIntoConstraints = false
            searchButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 30).isActive = true
            searchButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30).isActive = true
            self.view = mapView
            loadPins(mapView, false)
        }
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        if addPinState {
            // Create pin entry controller and assign members to be used later
            let entryController = PinDetailsEntryController()
            entryController.coordinate = coordinate
            entryController.delegate = self
            entryController.mapView = mapView

            // Present the controller
            present(UINavigationController(rootViewController: entryController), animated: true, completion: nil)

            // Cancel adding the pin
            addPinState = false
            cancelAddPin()
            // The rest is done inside pinEntryControllerWillDismiss
        }
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        presentDetails(marker.title ?? "")
    }

    // TODO: Improve the appearance of this custom info window
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
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
    }

    func loadPins(_ mapView: GMSMapView, _ filtersApplied: Bool) {
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
    }

    func refreshLocalPins(_ mapView: GMSMapView, _ filtersApplied: Bool) {
        var displayPin: Bool = true
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
        let image = UIImage(named: "filter48.png")
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        filterButton.setBackgroundImage(image, for: .normal)
        filterButton.setImage(image, for: .normal)
        filterButton.addTarget(self, action: #selector(presentFilter), for: .touchUpInside)
        return filterButton
    }()

    lazy var searchButton: UIButton = {
        let image = UIImage(named: "search4848.png")
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        filterButton.setBackgroundImage(image, for: .normal)
        filterButton.setImage(image, for: .normal)
        filterButton.addTarget(self, action: #selector(presentSearch), for: .touchUpInside)
        return filterButton
    }()

    func addInfoViewIcons(pinData: [String: Any]) -> NSAttributedString {
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
    }
}
// swiftlint:enable all
