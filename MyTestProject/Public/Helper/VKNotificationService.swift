//
//  VKNotificationService.swift
//  VKLocationNotifications
//
//  Created by Vamshi Krishna on 26/05/18.
//  Copyright © 2018 Vamshi Krishna. All rights reserved.
//

import Foundation
import UserNotifications

enum NotificationActionID: String {   
    case location = "userNotification.action.location"
}

class VKNotificationService: NSObject, UNUserNotificationCenterDelegate {
    
    static let sharedInstance = VKNotificationService()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        
    }
    
    /// 注册通知
    func requestAuthorization() {
        let options : UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]
        notificationCenter.requestAuthorization(options: options) { (authorized, error) in
            if let err = error{
                print(err.localizedDescription)
            }
            
            guard authorized else {
                print("Authorization failed")
                return
            }
            
            print("Authorization success")
            self.notificationCenter.delegate = self
            self.setupActionsAndCategories()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let action = NotificationActionID(rawValue: response.actionIdentifier) {
            NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleAction"),
                                            object: action)
        }
        
        completionHandler()
        print("Notification received")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
        
        print("Will present Notification")
    }
    
    //MARK: - Local Notification Request
    func localNotificationRequest(title: String = "", body: String = "", logo: String = "") {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "userNotification.category.location"
        
        if let attachment = getAttachment(logo: logo){
            content.attachments = [attachment]
        }
        
        let request = UNNotificationRequest(identifier: "userNotification.location",  content: content, trigger: nil)
        notificationCenter.add(request)
    }
    
    func getAttachment(logo: String) -> UNNotificationAttachment? {
        guard let url = Bundle.main.url(forResource: logo, withExtension: "png") else {
            return nil
        }
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "userNotification.attachment.location", url: url)
            return attachment
        } catch {
            return nil
        }
    }
    
    func setupActionsAndCategories() {
        let action = UNNotificationAction(identifier: "userNotification.action.location",
                                          title: "Run location logic",
                                          options: [.foreground])
        
        let category = UNNotificationCategory(identifier: "userNotification.category.location",
                                              actions: [action],
                                              intentIdentifiers: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
}

