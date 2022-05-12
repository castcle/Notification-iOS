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
//  NotificationTableViewCell.swift
//  Notification
//
//  Created by Castcle Co., Ltd. on 17/9/2564 BE.
//

import UIKit
import Core
import Networking
import SwipeCellKit

protocol NotificationTableViewCellDelegate: AnyObject {
    func didMoreAction(_ notificationTableViewCell: NotificationTableViewCell, index: Int)
}

class NotificationTableViewCell: SwipeTableViewCell {

    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var deteLabel: UILabel!
    @IBOutlet var moreImage: UIImageView!

    public var notifyDelegate: NotificationTableViewCellDelegate?
    private var index: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.detailLabel.textColor = UIColor.Asset.white
        self.deteLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.deteLabel.textColor = UIColor.Asset.lightGray
        self.moreImage.image = UIImage.init(icon: .castcle(.ellipsisV), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(notify: Notify, index: Int) {
        self.index = index
        self.detailLabel.text = notify.message
        self.deteLabel.text = notify.notifyDate.timeAgoDisplay()
        let url = URL(string: notify.avatar.thumbnail)
        self.avatarView.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.avatarView.circle(color: UIColor.Asset.white)
    }

    @IBAction func moreAction(_ sender: Any) {
        self.notifyDelegate?.didMoreAction(self, index: self.index)
    }
}
