//
//  HomeViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/5/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import GoogleMaps
import UIKit

class HomeController: RoutedViewController, GMSMapViewDelegate {

    // swiftlint:disable all
    var delegate: HomeControllerDelegate?
    // swiftlint:enable all
    var addPinState = false

    // Overrides
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
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
                                                            action: #selector(addPin))
    }

    @objc
    func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }

    @objc
    func addPin() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_clear_white_36pt_3x").withRenderingMode(.alwaysOriginal),
        style: .plain, target: self,
        action: #selector(cancelAddPin))
        navigationItem.title = "Tap to add a pin!"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: R.font.latoRegular(size: 20)
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
    func presentDetails() {
        let controller = PinDetailsController()
        controller.pinName = "Krusty Krab"
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    override func loadView() {
        // This sets the view, we'll eventually want to set this based on user's location
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view = mapView

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        let customPin = UIImage(named: "bluePin")
        marker.iconView = UIImageView(image: customPin)
        marker.map = mapView
        // populateMap()
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        if addPinState {
            let marker = GMSMarker()
            marker.position = coordinate
            marker.title = "Your mom's"
            marker.snippet = "house again lol"
            // using bluePin for now, but eventually we'll have to figure out color system for pins
            // also available: grayPin
            let customPin = UIImage(named: "bluePin")
            marker.iconView = UIImageView(image: customPin)
            marker.opacity = 0.7
            marker.map = mapView
            // TODO: Decide how we want proceeding behavior to play out
            addPinState = false
            cancelAddPin()
            // addPinToDatabase() SEE: Models/LocationPin.swift
        }
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
       presentDetails()
    }

    // TODO: Improve the appearance of this window
    // In reality we'll probably end up having to use certain properties from
    // the incoming GMS Marker as a means of looking up which marker we're dealing with
    // in some dictionary we have, then populating the fields below accordingly
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6

        // Title
        let lbl1 = UILabel(frame: CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: 20))
        lbl1.text = "Krusty Krab"
        lbl1.font = R.font.latoRegular(size: 18)
        view.addSubview(lbl1)

        // Description
        let lbl2 = UILabel(frame: CGRect(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y
                                        + lbl1.frame.size.height + 3, width: view.frame.size.width - 16,
                                                                      height: 15))
        lbl2.text = "Home of the Krabby Patty"
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
//        lazy var detailsButton: UIButton = {
//             // Details button
//             let infoButton = UIButton(frame: CGRect(x: lbl2.frame.origin.x, y: lbl2.frame.origin.y
//                                             + lbl2.frame.size.height + 10, width: view.frame.size.width - 16,
//                                                                           height: 15))
//             let buttonAttributes: [NSAttributedString.Key: Any] = [
//                 NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
//                 NSAttributedString.Key.foregroundColor: Colors.behindGradient
//                 // NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
//             ]
//             let attributeButtonString = NSMutableAttributedString(string: "Details",
//                                                             attributes: buttonAttributes)
//             infoButton.setAttributedTitle(attributeButtonString, for: .normal)
//             infoButton.addTarget(self, action: #selector(presentDetails), for: .touchUpInside)
//
//            return infoButton
//        }()
        
        view.addSubview(detailsButton)
        view.isUserInteractionEnabled = true
        return view
    }

    func populateMap() {
        // see Helpers/Utilities/BackendCaller for this function
        let markers = pullPinsBackend()
        for marker in markers{
          // add pins to view SEE loadView() above
        }
    }

    // Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var detailsButton: UIButton = {
         // Details button
        let infoButton = UIButton(frame: CGRect(x: 70, y: 60, width: 60,
                                                                       height: 15))
         let buttonAttributes: [NSAttributedString.Key: Any] = [
             NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
             NSAttributedString.Key.foregroundColor: Colors.behindGradient
             // NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
         ]
         let attributeButtonString = NSMutableAttributedString(string: "Details",
                                                         attributes: buttonAttributes)
         infoButton.setAttributedTitle(attributeButtonString, for: .normal)
         infoButton.addTarget(self, action: #selector(presentDetails), for: .touchUpInside)

        return infoButton
    }()
}
