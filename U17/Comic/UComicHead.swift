//
//  UComicHead.swift
//  U17
//
//  Created by PT iOS Mac on 2020/9/4.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import SnapKit

class UComicHeadCell: UICollectionViewCell {

	lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.white
        tl.textAlignment = .center
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initSubViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func initSubViews() {
		layer.cornerRadius = 3
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
	}
}

class UComicHead: UIView {

	var backBtnBlock :(()->Void)?

	private lazy var bgView: UIImageView = {
        let bw = UIImageView()
        bw.isUserInteractionEnabled = true
        bw.contentMode = .scaleAspectFill
        bw.blurView.setup(style: .dark, alpha: 1).enable()
        return bw
    }()

    private lazy var coverView: UIImageView = {
        let cw = UIImageView()
        cw.contentMode = .scaleAspectFill
        cw.layer.cornerRadius = 3
        cw.layer.borderWidth = 1
        cw.layer.borderColor = UIColor.white.cgColor
        return cw
    }()

    private lazy var nameLabel: UILabel = {
        let nl = UILabel()
        nl.textColor = UIColor.white
        nl.font = UIFont.systemFont(ofSize: 16)
        return nl
    }()

    private lazy var authorLabel: UILabel = {
        let al = UILabel()
        al.textColor = UIColor.white
        al.font = UIFont.systemFont(ofSize: 13)
        return al
    }()

    private lazy var totalLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.white
        tl.font = UIFont.systemFont(ofSize: 13)
        return tl
    }()

    private lazy var thmemView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 40, height: 20)
        layout.scrollDirection = .horizontal
        let tw = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        tw.backgroundColor = UIColor.clear
        tw.dataSource = self
        tw.showsHorizontalScrollIndicator = false
		tw.register(UComicHeadCell.self, forCellWithReuseIdentifier: "UComicHeadCell")
        return tw
    }()

	private lazy var backBtn: UIButton = {
		let backBtn = UIButton.init(type: .custom)
		backBtn.setImage(UIImage.init(named: "nav_back_black"), for: .normal)
		backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
		return backBtn
	}()

    private var themes: [String]?

	override init(frame: CGRect) {
        super.init(frame: frame)
		self.initSubViews()
    }

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func initSubViews() {
		self.clipsToBounds = true
		addSubview(bgView)
        bgView.snp.makeConstraints { $0.edges.equalToSuperview() }

        bgView.addSubview(coverView)
        coverView.snp.makeConstraints {
            $0.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0))
            $0.width.equalTo(90)
            $0.height.equalTo(120)
        }

        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(coverView.snp.right).offset(20)
            $0.right.greaterThanOrEqualToSuperview().offset(-20)
            $0.top.equalTo(coverView)
            $0.height.equalTo(20)
        }

        bgView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.left.height.equalTo(nameLabel)
            $0.right.greaterThanOrEqualToSuperview().offset(-20)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }

        bgView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints {
            $0.left.height.equalTo(authorLabel)
            $0.right.greaterThanOrEqualToSuperview().offset(-20)
            $0.top.equalTo(authorLabel.snp.bottom).offset(10)
        }

        bgView.addSubview(thmemView)
        thmemView.snp.makeConstraints {
            $0.left.equalTo(totalLabel)
            $0.height.equalTo(30)
            $0.right.greaterThanOrEqualToSuperview().offset(-20)
            $0.bottom.equalTo(coverView)
        }

		bgView.addSubview(backBtn)
		backBtn.snp.makeConstraints { (make) in
			make.bottom.equalTo(coverView.snp.top).offset(-15)
			make.left.equalTo(coverView.snp.left)
			make.height.width.equalTo(20)
		}
	}

	@objc func clickBackBtn(){
		if let block = self.backBtnBlock {
			block()
		}
	}

	var detailStatic :ComicStaticModel?{
		didSet{
			guard let detailStatic = detailStatic else { return }
			bgView.sd_setImage(with: URL.init(string: detailStatic.cover ?? ""), placeholderImage: UIImage(named: "normal_placeholder_v"))
			coverView.sd_setImage(with: URL.init(string: detailStatic.cover ?? ""), placeholderImage: UIImage(named: "normal_placeholder_v"))
            nameLabel.text = detailStatic.name
            authorLabel.text = detailStatic.author?.name
            themes = detailStatic.theme_ids
            thmemView.reloadData()
		}
	}

	var detailRealtime: ComicRealtimeModel? {
        didSet {
            guard let detailRealtime = detailRealtime else { return }
            let text = NSMutableAttributedString(string: "点击 收藏")

            text.insert(NSAttributedString(string: " \(detailRealtime.click_total ?? "0") ",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]), at: 2)

            text.append(NSAttributedString(string: " \(detailRealtime.favorite_total ?? "0") ",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
            totalLabel.attributedText = text
        }
    }
}

extension UComicHead:UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return themes?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UComicHeadCell", for: indexPath) as!UComicHeadCell
		cell.titleLabel.text = themes?[indexPath.item]
		return cell
	}


}
