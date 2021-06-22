//
//  UCommicTableViewCell.swift
//  U17
//
//  Created by PT iOS Mac on 2020/8/20.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class UCommicCell: UITableViewCell {

    var spinnerName: String?
	var ContentViewFrame: CGRect {
		get{
			return self.contentView.frame
		}
	}

    private  lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()

    private  lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        return tl
    }()

    private lazy var subTitleLabel: UILabel = {
        let sl = UILabel()
        sl.textColor = UIColor.gray
        sl.font = UIFont.systemFont(ofSize: 14)
        return sl
    }()

    private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.numberOfLines = 3
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()

    private lazy var tagLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.orange
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()

    private lazy var orderView: UIImageView = {
        let ow = UIImageView()
        ow.contentMode = .scaleAspectFit
        return ow
    }()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.configUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    func configUI() {
        separatorInset = .zero

        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
            $0.width.equalTo(100)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
            $0.top.equalTo(iconView)
        }

        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }

        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(60)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
        }

        contentView.addSubview(orderView)
        orderView.snp.makeConstraints {
            $0.bottom.equalTo(iconView.snp.bottom)
            $0.height.width.equalTo(30)
            $0.right.equalToSuperview().offset(-10)
        }

        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalTo(orderView.snp.left).offset(-10)
            $0.height.equalTo(20)
            $0.bottom.equalTo(iconView.snp.bottom)
        }
    }

	func show() -> Void {
		UIView.animate(withDuration: 0.5) {
			var frame = self.ContentViewFrame
			frame.origin.y = frame.origin.y + 10
			self.contentView.frame = frame
		}
	}

	func hide() -> Void {
		self.contentView.frame = ContentViewFrame
	}

    var model: ComicModel? {
        didSet {
            guard let model = model else { return }
			iconView.sd_setImage(with: URL.init(string: model.cover ?? ""), placeholderImage: UIImage(named: "normal_placeholder_v"))
			titleLabel.text = model.name
			subTitleLabel.text = "\(model.tags.joined(separator: " ") ) | \(model.author ?? "")"
            descLabel.text = model.description
			tagLabel.text = "\(String(describing: self.spinnerName))"
        }
    }

    var indexPath: IndexPath? {
        didSet {
            guard let indexPath = indexPath else { return }
            if indexPath.row == 0 { orderView.image = UIImage.init(named: "rank_frist") }
            else if indexPath.row == 1 { orderView.image = UIImage.init(named: "rank_second") }
            else if indexPath.row == 2 { orderView.image = UIImage.init(named: "rank_third") }
            else { orderView.image = nil }
        }
    }

}
