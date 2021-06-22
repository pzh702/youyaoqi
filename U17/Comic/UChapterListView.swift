//
//  UChapterListView.swift
//  U17
//
//  Created by PT iOS Mac on 2020/9/7.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import SnapKit

class UChapterListView: UIView {

	private lazy var leftTitle: UILabel = {
		let lt = UILabel.init()
		lt.text = "目录列表"
		lt.font = .systemFont(ofSize: 16)
		lt.textColor = .black
		return lt
	}()

	private lazy var rightBtn: UIButton = {
		let rt = UIButton.init(type: .custom)
		rt.setTitle("正序", for: .normal)
		rt.setTitleColor(.black, for: .normal)
		rt.titleLabel?.font = .systemFont(ofSize: 13)
		rt.addTarget(self, action: #selector(clickRightBtn), for: .touchUpInside)
		return rt
	}()

	var clickItemBlock :(([ChapterListModel],Int)->Void)?

	var reverse = false

	var modelArr :[ChapterListModel]?{
		didSet{
			guard modelArr != nil else { return }
			self.collectionView.reloadData()
		}
	}

	var modelArrReverse: [ChapterListModel]? {
		get{
			return self.modelArr?.reversed()
		}
	}

	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: floor((screenWidth - 30) / 2), height: 40)
		let ct = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
		ct.backgroundColor = .white
		ct.bounces = false
		ct.delegate = self
		ct.dataSource = self
		ct.register(UChapterCollectionCell.self, forCellWithReuseIdentifier: "UChapterCollectionCell")
		return ct
	}()

	private lazy var bottomBtn: UIButton = {
		let rt = UIButton.init(type: .custom)
		rt.setTitle("收起目录", for: .normal)
		rt.setTitleColor(.systemBlue, for: .normal)
		rt.titleLabel?.font = .systemFont(ofSize: 20)
		rt.addTarget(self, action: #selector(clickBottomBtn), for: .touchUpInside)
		return rt
	}()


	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initSubViews()

		var frameA = self.frame
		frameA.origin.y = self.frame.size.height
		self.frame = frameA

		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
			var frameA = self.frame
			frameA.origin.y = 0
			self.frame = frameA
		}, completion: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func initSubViews() {
		self.backgroundColor = .white
		self.addSubview(leftTitle)
		self.addSubview(rightBtn)
		self.addSubview(collectionView)
		self.addSubview(bottomBtn)

		leftTitle.snp.makeConstraints { (make) in
			make.left.equalTo(self).offset(20)
			make.top.equalTo(self).offset(10)
		}
		rightBtn.snp.makeConstraints { (make) in
			make.centerY.equalTo(leftTitle)
			make.right.equalTo(self).offset(-20)
		}
		bottomBtn.snp.makeConstraints { (make) in
			make.bottom.equalTo(self)
			make.height.equalTo(80)
			make.left.right.equalTo(self)
		}
		collectionView.snp.makeConstraints { (make) in
			make.top.equalTo(leftTitle.snp.bottom).offset(10)
			make.bottom.equalTo(bottomBtn.snp.top)
			make.left.right.equalTo(self)
		}
	}

	@objc func clickRightBtn() {
		reverse = !reverse
		rightBtn.setTitle(reverse ?"倒序":"正序", for: .normal)
		collectionView.reloadData()
	}

	@objc func clickBottomBtn() {
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
			var frameA = self.frame
			frameA.origin.y = self.frame.size.height+100
			self.frame = frameA
		}, completion: { (finish) in
			if(finish){
				self.removeFromSuperview()
			}
		})

	}

}

extension UChapterListView:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let modelArr = modelArr else { return 0 }
		return modelArr.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UChapterCollectionCell", for: indexPath) as! UChapterCollectionCell
		if reverse {
			cell.nameLabel.text = modelArrReverse?[indexPath.item].name
		} else {
			cell.nameLabel.text = modelArr?[indexPath.item].name
		}

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let arr = modelArr else { return }
		let selectIndex = reverse ?arr.count-indexPath.item-1:indexPath.item

		if let block = self.clickItemBlock {
			block(arr,selectIndex)
		}
	}


}
