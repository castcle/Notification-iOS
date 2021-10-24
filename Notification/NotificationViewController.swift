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
//  NotificationViewController.swift
//  Notification
//
//  Created by Castcle Co., Ltd. on 17/9/2564 BE.
//

import UIKit
import Core
import Component
import Defaults
import BetterSegmentedControl

class NotificationViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentView: BetterSegmentedControl!
    @IBOutlet var segmentContainerView: UIView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var emptyTitleLabel: UILabel!
    @IBOutlet var emptyDetailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.configureTableView()
        
        self.segmentContainerView.backgroundColor = UIColor.clear
        self.segmentContainerView.custom(cornerRadius: 10)
        self.segmentView.segments = LabelSegment.segments(withTitles: ["Profile", "Page", "System"],
                                                          normalBackgroundColor: UIColor.Asset.darkGray,
                                                          normalFont: UIFont.asset(.regular, fontSize: .body),
                                                          normalTextColor: UIColor.Asset.lightGray,
                                                          selectedBackgroundColor: UIColor.Asset.lightBlue,
                                                          selectedFont: UIFont.asset(.regular, fontSize: .body),
                                                          selectedTextColor: UIColor.Asset.white)
        self.segmentView.addTarget(self, action: #selector(navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
        self.emptyTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.emptyTitleLabel.textColor = UIColor.Asset.white
        self.emptyDetailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.emptyDetailLabel.textColor = UIColor.Asset.lightGray
        
        self.emptyView.isHidden = false
        self.tableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Notification")
        
        var rightButton: [UIBarButtonItem] = []
        
        let icon = UIButton()
        icon.setTitle("Clear All", for: .normal)
        icon.titleLabel?.font = UIFont.asset(.bold, fontSize: .h4)
        icon.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        icon.addTarget(self, action: #selector(clearAllAction), for: .touchUpInside)
        rightButton.append(UIBarButtonItem(customView: icon))

        self.navigationItem.rightBarButtonItems = rightButton
    }
    
    @objc private func clearAllAction() {
        
    }
    
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        self.emptyView.isHidden = false
        self.tableView.isHidden = true
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: NotificationNibVars.TableViewCell.notification, bundle: ConfigBundle.notification), forCellReuseIdentifier: NotificationNibVars.TableViewCell.notification)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.font = UIFont.asset(.regular, fontSize: .overline)
        label.textColor = UIColor.Asset.white
        
        if section == 0 {
            label.text = "Today"
        } else {
            label.text = "Yesterday"
        }
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationNibVars.TableViewCell.notification, for: indexPath as IndexPath) as? NotificationTableViewCell
        cell?.backgroundColor = UIColor.clear
        return cell ?? NotificationTableViewCell()
    }
}
