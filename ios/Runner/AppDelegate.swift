import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsApiKey") as? String
    GMSServices.provideAPIKey(key ?? "")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
