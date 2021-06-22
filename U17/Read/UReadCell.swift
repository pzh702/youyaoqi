//
//  UReadCell.swift
//  U17
//
//  Created by PT iOS Mac on 2020/9/8.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import SnapKit

class UReadCell: UICollectionViewCell {

    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFit
        return iw
    }()

	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.addSubview(imageView)
		imageView.snp.makeConstraints { (make) in
			make.edges.equalTo(contentView)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	var model :ImageModel?{
		didSet{
			guard let model = model else { return }
//			let image = UPlaceHolderView.init(frame: self.bounds).makeImg()
			imageView.sd_setImage(with: URL.init(string: model.location ?? ""), placeholderImage: UIImage.init(named: "yaofan"))
		}
	}

}

class UPlaceHolderView: UIView {

	lazy var titleLabel: UILabel = {
		let tl = UILabel.init()
		tl.text = "测试底图"
		tl.textColor = .systemBlue
		tl.font = .systemFont(ofSize: 30)
		return tl
	}()


	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { (make) in
			make.center.equalTo(self)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


}
