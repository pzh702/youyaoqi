//
//  USearchCell.swift
//  U17
//
//  Created by PT iOS Mac on 2020/8/27.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import SnapKit

class USearchCell: UICollectionViewCell {

	let titleLabel: UILabel = {
		let title = UILabel.init()
		title.textColor = .black
		title.font = .systemFont(ofSize: 14)
		title.textAlignment = .center
		return title
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initSubViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func initSubViews() -> Void {
		self.contentView.backgroundColor = .lightGray
		self.contentView.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { (make) in
			make.center.equalTo(self.contentView)
			make.top.equalTo(self.contentView).offset(10)
			make.left.equalTo(self.contentView).offset(20)
		}
	}
}
