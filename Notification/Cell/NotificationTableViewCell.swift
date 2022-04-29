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

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var lineView: UIView!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lineView.backgroundColor = UIColor.Asset.black
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.detailLabel.textColor = UIColor.Asset.lightGray
        let url = URL(string: "https://www.posttoday.com/media/content/2021/05/17/8C4E98ACE9B5485161DC86BC839A69CA.jpg")
        self.avatarView.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.avatarView.circle(color: UIColor.Asset.white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}