//
//  NotificationsController.swift
//  RacingGameApp
//
//  Created by alexKoro on 8/14/21.
//

import Foundation
import UserNotifications

class NotificationsController {
    static let shared = NotificationsController()
    let notificationCenter = UNUserNotificationCenter.current()

    private init() { }

    func addNotification(
        identifier: TypeOfNotification,
        title: String,
        body: String,
        date: DateComponents,
        repeats: Bool
    ) {
        notificationCenter.requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { (canUse, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard canUse else { return }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        let request = UNNotificationRequest(
            identifier: identifier.rawValue,
            content: content,
            trigger: trigger
        )
                self.notificationCenter.add(request) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            })
    }
}
