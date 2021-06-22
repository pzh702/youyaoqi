//
//  USearchHeadView.swift
//  U17
//
//  Created by PT iOS Mac on 2020/8/27.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import SnapKit

enum SearchType {
	case hot
	case history
}

class USearchHeadView: UICollectionReusableView {

	let titleLabel = UILabel.init()
	let rightBtn = UIButton.init()
	var rightBtnClick :(()->Void)?
	var searchType :SearchType?{
		didSet{
			titleLabel.text = (searchType == .hot) ? "大家都在搜":"搜过的漫画都在这里"
			let imgStr = (searchType == .hot) ? "search_keyword_refresh":"search_history_delete"
			rightBtn.setImage(UIImage.init(named: imgStr), for: .normal)
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initSubViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func initSubViews() {
		titleLabel.text = (searchType == .hot) ? "大家都在搜":"搜过的漫画都在这里"
		titleLabel.font = .systemFont(ofSize: 18)
		self.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { (make) in
			make.left.equalTo(self).offset(10)
			make.centerY.equalTo(self)
			make.top.equalTo(self).offset(10)
		}
		let imgStr = (searchType == .hot) ? "search_keyword_refresh":"search_history_delete"
		rightBtn.setImage(UIImage.init(named: imgStr), for: .normal)
		rightBtn.addTarget(self, action: #selector(clickRightBtn), for: .touchUpInside)
		self.addSubview(rightBtn)
		rightBtn.snp.makeConstraints { (make) in
			make.centerY.equalTo(self)
			make.right.equalTo(self).offset(-10)
			make.width.height.equalTo(self.titleLabel.snp.height)
		}
	}

	@objc func clickRightBtn() -> Void {
		if let block = self.rightBtnClick {
			block()
		}
	}
}
