//
//  ULeftHeaderCell.swift
//  U17
//
//  Created by PT iOS Mac on 2020/8/25.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import SnapKit

class ULeftHeaderView: UIView {

	let backImgView: UIImageView = {
		let imgView = UIImageView.init()
		imgView.image = UIImage.init(named: "mine_bg_for_boy")
		return imgView
	}()

	let avatarImgView: UIImageView = {
		let avatar = UIImageView.init()
		avatar.layer.cornerRadius = 40
		avatar.layer.masksToBounds = true
		avatar.image = UIImage.init(named: "avtar")
		return avatar
	}()

	let nameLabel: UILabel = {
		let name = UILabel.init()
		name.text = "pzhds"
		name.textColor = .black
		name.font = .systemFont(ofSize: 16)
		return name
	}()


	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initSubViews()
	}
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

	func initSubViews() -> Void {
		self.addSubview(backImgView)
		self.addSubview(avatarImgView)
//		self.contentView.addSubview(nameLabel)

		backImgView.snp.makeConstraints { (make) in
			make.top.left.bottom.right.equalTo(self)
		}
		avatarImgView.snp.makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.centerY.equalTo(self).offset(20)
			make.width.height.equalTo(80)
		}
//		nameLabel.snp.makeConstraints { (make) in
//			make.top.equalTo(avatarImgView.snp.bottom).offset(10)
//			make.centerX.equalTo(contentView)
//		}

	}
}
