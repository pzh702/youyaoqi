//
//  UChapterCell.swift
//  U17
//
//  Created by PT iOS Mac on 2020/9/7.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import SnapKit

class UChapterCollectionCell: UICollectionViewCell {

	lazy var nameLabel: UILabel = {
        let nl = UILabel()
        nl.font = .systemFont(ofSize: 16)
        return nl
    }()

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initSubViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func initSubViews() {
		contentView.backgroundColor = UIColor.white
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true

        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) }
	}
}

class UChapterCell: UITableViewCell {

	var rightBtnBlock :(()->Void)?

	var clickItemBlock :(([ChapterListModel],Int)->Void)?

	lazy var leftTitle: UILabel = {
		let lt = UILabel.init()
		lt.font = .systemFont(ofSize: 16)
		lt.textColor = .black
		return lt
	}()

	private lazy var rightBtn: UIButton = {
		let rt = UIButton.init(type: .custom)
		rt.setTitle("全部目录", for: .normal)
		rt.setTitleColor(.black, for: .normal)
		rt.titleLabel?.font = .systemFont(ofSize: 13)
		rt.addTarget(self, action: #selector(clickRightBtn), for: .touchUpInside)
		rt.isUserInteractionEnabled = false
		return rt
	}()

	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: floor((screenWidth - 30) / 2), height: 40)
		let ct = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
		ct.backgroundColor = .white
		ct.delegate = self
		ct.dataSource = self
		ct.register(UChapterCollectionCell.self, forCellWithReuseIdentifier: "UChapterCollectionCell")
		return ct
	}()

	var modelArr :[ChapterListModel] = []{
		didSet{
			guard modelArr.count > 0 else { return }
			self.collectionView.reloadData()
			self.rightBtn.isUserInteractionEnabled = true
		}
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.initSubViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func initSubViews() {
		contentView.addSubview(leftTitle)
		contentView.addSubview(rightBtn)
		contentView.addSubview(collectionView)

		leftTitle.snp.makeConstraints { (make) in
			make.left.equalTo(contentView).offset(20)
			make.top.equalTo(contentView).offset(10)
		}
		rightBtn.snp.makeConstraints { (make) in
			make.centerY.equalTo(leftTitle)
			make.right.equalTo(contentView).offset(-20)
		}
		collectionView.snp.makeConstraints { (make) in
			make.top.equalTo(leftTitle.snp.bottom).offset(10)
			make.left.right.equalTo(contentView)
			make.height.equalTo(100)
			make.bottom.equalTo(contentView)
		}
	}

	@objc func clickRightBtn() {
		if let block = self.rightBtnBlock {
			block()
		}
	}

}

extension UChapterCell:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return modelArr.count>4 ?4:modelArr.count
	}

//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: screenWidth, height: 44)
//    }

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UChapterCollectionCell", for: indexPath) as! UChapterCollectionCell
		cell.nameLabel.text = modelArr[indexPath.item].name

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print(modelArr[indexPath.item].name ?? "")
		if let block = self.clickItemBlock {
			block(modelArr,indexPath.item)
		}
	}
}
