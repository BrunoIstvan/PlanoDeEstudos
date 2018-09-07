//
//  AppDelegate.swift
//  PlanoDeEstudos
//
//  Created by Eric Brito
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = UIColor(named: "main")
        
        center.delegate = self
        // verificar se o usuário autorizou a exibição de notificações
        center.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                print("Usuário já autorizou o uso de notificações.")
                
            case .denied:
                print("Usuário negou o uso de notificações.")
            case .notDetermined:
                // pedir a autorização do usuário
                let options: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]
                self.center.requestAuthorization(options: options, completionHandler: { (authorized, error) in
                    if error == nil {
                        print(authorized)
                        
                        // para receber push notifications
                        // UIApplication.shared.registerForRemoteNotifications()
                        
                    }
                })
            }
        }
        
        let confirmAction = UNNotificationAction(identifier: "Confirm", title: "Já estudei 👍", options: [.foreground])
        
        let cancelAction = UNNotificationAction(identifier: "Cancel", title: "Cancelar", options: [])

        let category = UNNotificationCategory(identifier: "Lembrete", actions: [confirmAction, cancelAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [.customDismissAction])
        
        center.setNotificationCategories([category])
        
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Deu erro para registrar o push notification")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // manda o deviceToken para a API que gerencia as notificações
        let token = deviceToken.map({String(format: "%02.2hhx", $0)}).joined()
        
        print(token)
        
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // irá apresentar uma notificação quando o aplicativo estiver aberto...
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
        
    }
    
    // será disparado quando o usuário selecionar uma notificação ...
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Selecionei uma notificação")
        
        
        let id = response.notification.request.identifier
        print(id)
        
        switch response.actionIdentifier {
        case "Confirm":
            print("Usuário confirmou que estudou a matéria")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Confirmed"), object: nil, userInfo: ["id": id])
            
        case "Cancel":
            print("Usuário cancelou a notificação")
        case UNNotificationDefaultActionIdentifier:
            print("Usuário tocou na notificação")
        case UNNotificationDismissActionIdentifier:
            print("Usuário fez o dismiss da notificação")
        default:
            break
        }
        
        completionHandler()
        
    }
    
    
    
    
}
