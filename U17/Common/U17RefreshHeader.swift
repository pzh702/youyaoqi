//
//  U17RefreshHeader.swift
//  U17
//
//  Created by PT iOS Mac on 2020/8/21.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import MJRefresh

class U17RefreshHeader: MJRefreshHeader {

    var loadingView:UIActivityIndicatorView?
    var arrowImage:UIImageView?
//	var stateLabel :UILabel?

	override var state:MJRefreshState{
        didSet{
            switch state {
            case .idle:
//				self.stateLabel?.text = "下拉刷新"
				if oldValue == .refreshing {
					self.arrowImage?.transform = .identity
					UIView.animate(withDuration: 0.4, animations: {
						self.loadingView?.alpha = 0
					}) { (finish) in
						self.loadingView?.alpha = 1
						self.loadingView?.stopAnimating()
						self.arrowImage?.isHidden = false
					}
				} else {
					self.loadingView?.stopAnimating()
					self.arrowImage?.isHidden = false
					UIView.animate(withDuration: 0.25) {
						self.arrowImage?.transform = .identity
					}
				}
            case .pulling:
//				self.stateLabel?.text = "松开刷新"
				self.loadingView?.stopAnimating()
				self.arrowImage?.isHidden = false
				UIView.animate(withDuration: 0.25) {
					self.arrowImage?.transform = CGAffineTransform.init(rotationAngle: CGFloat(0.00001-Double.pi))
				}
            case .refreshing:
//				self.stateLabel?.text = "正在刷新"
				self.loadingView?.alpha = 1
				self.loadingView?.startAnimating()
				self.arrowImage?.isHidden = true
            default:
                NSLog("")
            }
        }
    }

	override func prepare() {
		super.prepare()
		//初始化文字
//		self.setTitle("下拉刷新", for: .idle)
//		self.setTitle("释放刷新", for: .pulling)
//		self.setTitle("正在刷新", for: .refreshing)

		self.mj_h = 50
		if #available(iOS 13.0, *) {
			self.loadingView = UIActivityIndicatorView(style: .medium)
		} else {
			// Fallback on earlier versions
			self.loadingView = UIActivityIndicatorView(style: .gray)
		}
		self.loadingView?.style = .gray
		self.loadingView?.hidesWhenStopped = true
        self.addSubview(self.loadingView!)

		self.arrowImage = UIImageView(image: UIImage.init(named: "ic_arrow_downward"))
		self.arrowImage?.tintColor = .gray
        self.addSubview(self.arrowImage!)
	}

	/**
     在这里设置子控件的位置和尺寸
     */
    override func placeSubviews(){
        super.placeSubviews()
//		guard let stateLabel = self.stateLabel else { return }
        self.loadingView!.center = CGPoint(x: self.mj_w/2, y: self.mj_h/2);
//		self.stateLabel?.center = CGPoint(x: self.mj_w/2, y: self.mj_h/2);
		self.arrowImage?.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24)
		self.arrowImage?.center = self.loadingView!.center
    }




}
