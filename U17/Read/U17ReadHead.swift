//
//  U17ReadHead.swift
//  U17
//
//  Created by PT iOS Mac on 2020/9/28.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit

class U17ReadHead: UIView {

	var backBtnBlock :(()->Void)?
	var downloadBtnBlock :(()->Void)?


	private lazy var backBtn: UIButton = {
		let btn = UIButton.init(type: .custom)
		btn.setImage(UIImage.init(named: "nav_back_black"), for: .normal)
		btn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
		return btn
	}()

	private lazy var titleLabel: UILabel = {
		let tl = UILabel.init()
		tl.font = .systemFont(ofSize: 18)
		tl.textAlignment = .center
		return tl
	}()

	lazy var downloadBtn: UIButton = {
		let btn = UIButton.init(type: .custom)
		btn.backgroundColor = .systemBlue
		btn.setTitle("下载", for: .normal)
		btn.titleLabel?.font = .systemFont(ofSize: 18)
		btn.setTitleColor(.white, for: .normal)
		btn.addTarget(self, action: #selector(clickDownLoadBtn), for: .touchUpInside)
		return btn
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		initSubviews()
	}

	convenience init(title:String?,frame:CGRect) {
		self.init(frame:frame)
		titleLabel.text = title
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc func clickBackBtn() {
		if let block = self.backBtnBlock {
			block();
		}
	}

	@objc func clickDownLoadBtn() {
		if let block = self.downloadBtnBlock {
			block();
		}
	}

	func initSubviews() {
		self.backgroundColor = .white
		self.addSubview(backBtn)
		self.addSubview(titleLabel)
		self.addSubview(downloadBtn)

		backBtn.snp.makeConstraints { (make) in
			make.centerY.equalTo(self)
			make.left.equalTo(self).offset(20)
			make.height.width.equalTo(40)
		}
		titleLabel.snp.makeConstraints { (make) in
			make.center.equalTo(self)
		}
		downloadBtn.snp.makeConstraints { (make) in
			make.centerY.equalTo(self)
			make.right.equalTo(self).offset(-20)
		}
	}

	func show() {
		self.isHidden = false
		
		var frameA = self.frame
		frameA.origin.y = -50
		self.frame = frameA

		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
			var frameA = self.frame
			frameA.origin.y = UIApplication.shared.statusBarFrame.size.height
			self.frame = frameA
		}, completion: nil)
	}

	func hide() {
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
			var frameA = self.frame
			frameA.origin.y = -50
			self.frame = frameA
		}, completion: {(finish) in
			if(finish){
				self.isHidden = true
			}
		})
	}

}
