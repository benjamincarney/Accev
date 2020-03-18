//
//  AppDelegate.swift
//  Accev
//
//  Copyright © Accev. All rights reserved.
//

import FBSDKCoreKit
import Firebase
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    lazy private var router = RootRouter()
    lazy private var deeplinkHandler = DeeplinkHandler()
    lazy private var notificationsHandler = NotificationsHandler()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        // Google maps and places config TODO: considered using cocoapods-keys to make this more secure
        GMSServices.provideAPIKey("AIzaSyAVgb6Laiht-CvWEkJUuFgoH4tdeJw-D18")
        GMSPlacesClient.provideAPIKey("AIzaSyAVgb6Laiht-CvWEkJUuFgoH4tdeJw-D18")

        // Firebase config
        FirebaseApp.configure()

        // Notifications
        notificationsHandler.configure()

        // Google SignIn Configuration
        GIDSignIn.sharedInstance().clientID =
            "801371533628-iodo8voj6svel41966dto7isib0oq3uv.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        // Facebook SignIn Configuration
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        // App structure
        router.loadMainAppStructure()

        return true
    }

    // Google sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }
        // Perform any operations on signed in user here..
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken:
            authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { _, _ in
            self.router.transitionTo(screen: .primaryMap, animatedWithOptions: nil)
        }
    }

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url)
        let facebookDidHandle = ApplicationDelegate.shared.application(app, open: url, options: options)
        return googleDidHandle || facebookDidHandle
    }

    // Depreciated method for <= iOS 8
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url)
        let facebookDidHandle =
            ApplicationDelegate.shared.application(application, open: url,
                                                   sourceApplication: sourceApplication, annotation: annotation)
        return googleDidHandle || facebookDidHandle
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // To enable full universal link functionality add and configure the associated domain capability
        // https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            deeplinkHandler.handleDeeplink(with: url)
        }
        return true
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // To enable full remote notifications functionality you should first register the device with your api service
        //https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/
        notificationsHandler.handleRemoteNotification(with: userInfo)
    }
}
