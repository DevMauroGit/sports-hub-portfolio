import Flutter
import UIKit
import FirebaseAppCheck
import FirebaseMessaging
import UserNotificationsUI

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate  {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let providerFactory = AppCheckDebugProviderFactory()
    AppCheck.setAppCheckProviderFactory(providerFactory)

      
      Messaging.messaging().delegate = self
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
          guard success else {
              return
          }
          print("Success in APN registry")
      }
      
      application.registerForRemoteNotifications()
      
      func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?){
          messaging.token { token, _ in
              guard let token = token else {
                  return
              }
              print("Token: \(token)")
          }
      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

