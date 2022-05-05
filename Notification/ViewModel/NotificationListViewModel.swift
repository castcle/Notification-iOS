//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  NotificationListViewModel.swift
//  Notification
//
//  Created by Castcle Co., Ltd. on 3/5/2565 BE.
//

import UIKit
import Foundation
import Core
import Networking
//import RealmSwift
import SwiftyJSON


final public class NotificationListViewModel {

    private var notificationRepository: NotificationRepository = NotificationRepositoryImpl()
    var notificationRequest: NotificationRequest = NotificationRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var notifyId: String = ""
    var notifications: [Notify] = []
    var state: State = .none
    var loadState: LoadState = .loading

    //MARK: Output
    var didGetNotificationFinish: (() -> ())?

    public init(section: NotificationSection = .profile) {
        self.notificationRequest.source = section
        self.tokenHelper.delegate = self
    }
    
    public func getBadges() {
        self.state = .getBadges
        self.notificationRepository.getBadges() { (success, response, isRefreshToken) in
            if success {
                UIApplication.shared.applicationIconBadgeNumber = UserManager.shared.badgeCount
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    func getNotification() {
        self.state = .getNotification
        self.notificationRepository.getNotification(notificationRequest: self.notificationRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.notifications = (json[JsonKey.payload.rawValue].arrayValue).map { Notify(json: $0) }
                    self.didGetNotificationFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    func deleteNotification(notifyId: String) {
        self.state = .deleteNotification
        self.notifyId = notifyId
        self.notificationRepository.deleteNotification(notifyId: self.notifyId) { (success, response, isRefreshToken) in
            if success {
                self.getBadges()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    func readNotification(notifyId: String) {
        self.state = .readNotification
        self.notifyId = notifyId
        self.notificationRepository.readNotification(notifyId:  self.notifyId) { (success, response, isRefreshToken) in
            if success {
                self.getBadges()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
}

extension NotificationListViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getNotification {
            self.getNotification()
        } else if self.state == .deleteNotification {
            self.deleteNotification(notifyId: self.notifyId)
        } else if self.state == .getBadges {
            self.getBadges()
        } else if self.state == .readNotification {
            self.readNotification(notifyId: self.notifyId)
        }
    }
}
