//
//  NotificationManager.swift
//  BookXpertProject
//
//  Created by sona on 17/05/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            print("🔔 Notification permission: \(granted)")
        }
    }

    func sendDeletedItemNotification(itemName: String, itemData: String) {
        let userDefaults = UserDefaults.standard
        let notificationsEnabled = userDefaults.bool(forKey: "notifications_enabled")

        guard notificationsEnabled else {
            print("🚫 Notifications are disabled")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Item Deleted"
//        content.body = "Deleted"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification error: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled for deleted item")
            }
        }
    }
}

