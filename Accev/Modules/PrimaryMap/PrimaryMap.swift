//
//  PrimaryMap.swift
//  Accev
//
//  Created by Benjamin Carney on 3/4/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import GoogleMaps
import SideMenu
import UIKit

class PrimaryMapViewController: RoutedViewController {

    // Overrides
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //let menuLeftNavigationController = SideMenuNavigationController(rootViewController: PrimaryMapViewController)
    }

    lazy var hamburgerButton: UIButton = {
        let image = R.image.hamburger()
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.frame = CGRect(x: 20, y: 50, width: 40, height: 40)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        return button
    }()

    lazy var addPinButton: UIButton = {
        let image = R.image.plus()
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.frame = CGRect(x: view.bounds.maxX - 50, y: 50, width: 35, height: 35)
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        button.setImage(image, for: .normal)
        // button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        return button
    }()

    @objc
    func buttonTapped(sender: UIButton) {
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: RoutedViewController())
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        leftMenuNavigationController.leftSide = true
        present(leftMenuNavigationController, animated: true, completion: nil)
    }

    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView

        view.addSubview(hamburgerButton)
        view.addSubview(addPinButton)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }

    // Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init() {

        super.init(nibName: nil, bundle: nil)
    }

}
