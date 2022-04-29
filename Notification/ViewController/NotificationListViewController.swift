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

class NotificationListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var pageIndex: Int = 0
    var pageTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
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
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: NotificationNibVars.TableViewCell.emptyNotification, bundle: ConfigBundle.notification), forCellReuseIdentifier: NotificationNibVars.TableViewCell.emptyNotification)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationNibVars.TableViewCell.emptyNotification, for: indexPath as IndexPath) as? EmptyNotificationTableViewCell
        cell?.backgroundColor = UIColor.clear
        return cell ?? EmptyNotificationTableViewCell()
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
        
    }
}

extension NotificationListViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab \(pageIndex)")
    }
}
