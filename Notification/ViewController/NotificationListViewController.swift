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
//  NotificationListViewController.swift
//  Notification
//
//  Created by Tanakorn Phoochaliaw on 29/4/2565 BE.
//

import UIKit
import Core
import Component
import XLPagerTabStrip
import SwipeCellKit

class NotificationListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var viewModel = NotificationListViewModel()
    var pageIndex: Int = 0
    var pageTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
        self.viewModel.getNotification()
        
//        self.viewModel.delegate = self
//        self.tableView.cr.addHeadRefresh(animator: FastAnimator()) {
//            self.tableView.cr.resetNoMore()
//            self.tableView.isScrollEnabled = false
//            self.viewModel.searchUserLoaded = false
//            self.tableView.reloadData()
//            self.viewModel.reloadData()
//        }
        
//        self.tableView.cr.addFootRefresh(animator: NormalFooterAnimator()) {
//            if self.viewModel.searchUserCanLoad {
//                self.viewModel.searchUserMore()
//            } else {
//                self.tableView.cr.noticeNoMoreData()
//            }
//        }
        
//        if !self.viewModel.searchUserLoaded {
//            self.tableView.isScrollEnabled = false
//            if let searchUdid: String = self.viewModel.notification?.rawValue, let keyword: String = UserDefaults.standard.string(forKey: searchUdid) {
//                self.viewModel.reloadData(with: keyword)
//            } else {
//                if !self.viewModel.searchRequest.keyword.isEmpty {
//                    self.viewModel.reloadData(with: "")
//                }
//            }
//
//        } else {
//            self.tableView.isScrollEnabled = true
//        }
        
        self.viewModel.didGetNotificationFinish = {
            self.viewModel.loadState = .loaded
            self.tableView.isScrollEnabled = true
            UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() }, completion: nil)
        }
    }
    
    func configureTableView() {
        self.tableView.isScrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.skeletonNotify, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.skeletonNotify)
        self.tableView.register(UINib(nibName: NotificationNibVars.TableViewCell.emptyNotification, bundle: ConfigBundle.notification), forCellReuseIdentifier: NotificationNibVars.TableViewCell.emptyNotification)
        self.tableView.register(UINib(nibName: NotificationNibVars.TableViewCell.notification, bundle: ConfigBundle.notification), forCellReuseIdentifier: NotificationNibVars.TableViewCell.notification)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    private func readNotify(index: Int) {
        self.viewModel.readNotification(notifyId: self.viewModel.notifications[index].id)
        self.viewModel.notifications[index].read = true
        UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() }, completion: nil)
    }
    
    private func removeNotify(index: Int) {
        self.viewModel.deleteNotification(notifyId: self.viewModel.notifications[index].id)
        self.viewModel.notifications.remove(at: index)
        UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() }, completion: nil)
    }
}

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.loadState == .loading {
            return 5
        } else {
            if self.viewModel.notifications.isEmpty {
                return 1
            } else {
                return self.viewModel.notifications.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.loadState == .loading {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.skeletonNotify, for: indexPath as IndexPath) as? SkeletonNotifyTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.configCell()
            return cell ?? SkeletonNotifyTableViewCell()
        } else {
            if self.viewModel.notifications.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: NotificationNibVars.TableViewCell.emptyNotification, for: indexPath as IndexPath) as? EmptyNotificationTableViewCell
                cell?.backgroundColor = UIColor.clear
                return cell ?? EmptyNotificationTableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NotificationNibVars.TableViewCell.notification, for: indexPath as IndexPath) as? NotificationTableViewCell
                let notify = self.viewModel.notifications[indexPath.section]
                if notify.read {
                    cell?.backgroundColor = UIColor.Asset.darkGray
                } else {
                    cell?.backgroundColor = UIColor.Asset.notifyFocus
                }
                cell?.configCell(notify: notify, index: indexPath.section)
                cell?.delegate = self
                cell?.notifyDelegate = self
                return cell ?? NotificationTableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 5))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notify = self.viewModel.notifications[indexPath.section]
        if notify.landingPage == .follower {
            let notifyDict: [String: String] = [
                JsonKey.profileId.rawValue: notify.profileId
            ]
            NotificationCenter.default.post(name: .openFollerDelegate, object: nil, userInfo: notifyDict)
        } else if notify.landingPage == .cast {
            let castDict: [String: String] = [
                JsonKey.contentId.rawValue: notify.contentId
            ]
            NotificationCenter.default.post(name: .openCastDelegate, object: nil, userInfo: castDict)
        } else if notify.landingPage == .comment {
            let commentDict: [String: String] = [
                JsonKey.contentId.rawValue: notify.contentId,
                JsonKey.commentId.rawValue: notify.commentId
            ]
            NotificationCenter.default.post(name: .openCommentDelegate, object: nil, userInfo: commentDict)
        }
    }
}

extension NotificationListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.removeNotify(index: indexPath.section)
        }
        deleteAction.image = UIImage.init(icon: .castcle(.delete), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        deleteAction.backgroundColor = UIColor.Asset.denger
        
        let readAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.readNotify(index: indexPath.section)
        }
        readAction.image = UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        readAction.backgroundColor = UIColor.Asset.lightBlue

        return [deleteAction, readAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .drag
        return options
    }
}

extension NotificationListViewController: NotificationTableViewCellDelegate {
    func didMoreAction(_ notificationTableViewCell: NotificationTableViewCell, index: Int) {
        let actionSheet = CCActionSheet()
        let removeButton = CCAction(title: "Remove this notification", image: UIImage.init(icon: .castcle(.notInterested), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
            actionSheet.dismissActionSheet()
            self.removeNotify(index: index)
        }
        let readButton = CCAction(title: "Mark as read", image: UIImage.init(icon: .castcle(.show), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
            actionSheet.dismissActionSheet()
            self.readNotify(index: index)
        }
        actionSheet.addActions([removeButton, readButton])
        Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
    }
}

extension NotificationListViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab \(pageIndex)")
    }
}
