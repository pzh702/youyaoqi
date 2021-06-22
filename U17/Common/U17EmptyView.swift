//
//  U17EmptyView.swift
//  U17
//
//  Created by PT iOS Mac on 2020/9/27.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import SnapKit

class U17EmptyView: UIView {

	var reloadBlock :(()->Void)?

	private lazy var reloadBtn: UIButton = {
		let btn = UIButton.init(type: .custom)
		btn.backgroundColor = .systemBlue
		btn.setTitle("重新加载", for: .normal)
		btn.setTitleColor(.white, for: .normal)
//		btn.titleLabel?.font = .systemFont(ofSize: 18)
		btn.addTarget(self, action: #selector(clickReloadBtn), for: .touchUpInside)
		btn.contentEdgeInsets = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
		return btn
	}()

	private lazy var descripLabel: UILabel = {
		let bl = UILabel.init()
		bl.text = "数据为空"
		bl.textColor = .black
		bl.font = .systemFont(ofSize: 15)
		return bl
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		initSubviews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func initSubviews() {
		self.addSubview(descripLabel)
		self.addSubview(reloadBtn)

		descripLabel.snp.makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.centerY.equalTo(self).offset(-10)
		}
		reloadBtn.snp.makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.top.equalTo(descripLabel.snp.bottom).offset(10)
		}
	}

	@objc func clickReloadBtn() -> Void {
		if let block = self.reloadBlock {
			block()
		}
	}

}
