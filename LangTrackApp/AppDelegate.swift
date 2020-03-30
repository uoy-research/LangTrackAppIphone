//
//  AppDelegate.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

enum Identifiers {
    static let viewAction = "VIEW_IDENTIFIER"
    static let viewAction2 = "VIEW_IDENTIFIER2"
    static let newsCategory = "NEWS_CATEGORY"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        
        //om appen är stängd och man får en notis så visas alert, men ingen funktion körs... man måste hantera badge via notisen, man måste hålla räkningen i backend!!
        registerForPushNotifications()
        print("makeNewItem in didFinishLaunchingWithOptions1")
        
        // Kolla om appen startas genom klick på notifikation, här hanteras notifikation om appen inte är igång
        //om appen redan är igång, i förgrund eller bakgrund, hanteras notifikationer i didReceiveRemoteNotification
        /*
         Kolla om värdet UIApplication.LaunchOptionsKey.remoteNotification existerar i launchOptions. Om det gör det är appen uppstartad genom att användaren klickade på en notifikation.
         .remoteNotification innehåller det skickade meddelandet
         */
        let notificationOption = launchOptions?[.remoteNotification]
        print("running didFinishLaunchingWithOptions...")
        
        // 1
        if let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
            
            // 2
            //setBadge()
            print("makeNewItem in didFinishLaunchingWithOptions2")
        }
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    /*
     Registrera appen för push, görs i slutet av didFinishLaunchingWithOptions
     Här väljer man vilken typ av notiser man vill använda:
     
     .badge: Visar en siffra i hörnet på ikonen.
     .sound: Spelar upp en signal.
     .alert: Visar text.
     .carPlay: Visas notifikation i CarPlay.
     .provisional: Icke störande notifikation. Användaren frågas inte efter tillstånd när man använder detta val, men notisen visas endast tyst i Notiscenter.
     .providesAppNotificationSettings: Indikerar att appen har eget UI för notification settings.
     .criticalAlert: Ignorerar mute switch och Do Not Disturb. Man behöver särskilt tillstånd från Apple för att använda detta då detta val är menat att använda endast när det är absolut nödvändigt.
     */
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Notification Permission granted: \(granted)")
                guard granted else { return }
                
                // 1
                let viewAction = UNNotificationAction(
                    identifier: Identifiers.viewAction, title: "View",
                    options: [.foreground])
                let viewAction2 = UNNotificationAction(
                    identifier: Identifiers.viewAction2, title: "View2",
                    options: [.foreground])
                
                // 2
                let newsCategory = UNNotificationCategory(
                    identifier: Identifiers.newsCategory, actions: [viewAction, viewAction2],
                    intentIdentifiers: [], options: [])
                
                // 3
                UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
                
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        //This method returns the settings the user has granted.
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            //print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                //Now that you have permissions, you’ll now actually register for remote notifications
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    /*
     det två följande metoderna hanterar svaret efter man kört registerForRemoteNotifications()
     */
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        /*
         här hanteras appens token (installationens)
         Denna bör sparas i backend för att kunna skicka notiser till just denna installation
         Sparas tillsammans med användarinfo för att rikta notiser
         Uppdatera token om ändrad. Token följer installation så om användaren avinstallerar appen och installerar på nytt får den installationen ett nytt token, som måste på nytt sparas med användareinfo
         */
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        SurveyRepository.deviceToken = token
        var username = Auth.auth().currentUser?.email
        username!.until("@")
        SurveyRepository.userId = username ?? ""
        SurveyRepository.postDeviceToken()
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    //här hanteras notifikation om appen är igång
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void
    ) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        //setBadge()
        print("makeNewItem in didReceiveRemoteNotification")
        //send notification to update surveys
        NotificationCenter.default.post(
            name: .newNotification,
            object: nil)
        completionHandler(.newData)
    }
    
    /*func setBadge()  {
        var ind = 0
        let newsStore = ItemsStore.shared
        for j in newsStore.items {
            if(j.viewed != true){
                ind += 1
            }
        }
        if(ind <= 0){
            UIApplication.shared.applicationIconBadgeNumber = 0
        }else{
            UIApplication.shared.applicationIconBadgeNumber = ind
        }
    }*/

}
//Whenever a notification action is triggered
//här hanteras även tryck på View(knapp) i notis
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // 1
        let notificationPayload = response.notification.request.content.userInfo
        
        // 2
        if let aps = notificationPayload["aps"] as? [String: AnyObject]{
            //setBadge()
            print("makeNewItem in didReceive response:")
            
            // 3
            /*if response.actionIdentifier == Identifiers.viewAction{
                print("du valde viewAction")
            }
            if (response.actionIdentifier == Identifiers.viewAction2){
                print("du valde viewAction2")
            }*/
            //send notification with notification info, to update surveys
            NotificationCenter.default.post(
                name: .newNotification,
                object: nil)
        }
        
        
        
        // 4
        completionHandler()
    }
}

