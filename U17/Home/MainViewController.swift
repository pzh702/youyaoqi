//
//  MainViewController.swift
//  测试1
//
//  Created by PT iOS Mac on 2020/8/14.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import JXSegmentedView
import SwiftyJSON

class MainViewController: UIViewController {
	var segmentedDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!
    var listContainerView: JXSegmentedListContainerView!
	private var searchStr:String = ""
	private var rankList:[CateListModel] = []

	let searchBtn: UIButton = {
		let sn = UIButton.init(type: .system)
		sn.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        sn.layer.cornerRadius = 15
        sn.setTitleColor(.white, for: .normal)
        sn.setImage(UIImage(named: "nav_search")?.withRenderingMode(.alwaysOriginal), for: .normal)
        sn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        sn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
		return sn
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .white
		self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)

		self.searchBtn.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 30)
		self.searchBtn.addTarget(self, action: #selector(clickSearchBtn(sender:)), for: .touchUpInside)
		navigationItem.titleView = self.searchBtn

		segmentedView = JXSegmentedView.init()
		segmentedView.backgroundColor = .gray
		segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false

		segmentedDataSource = JXSegmentedTitleDataSource.init()
		segmentedDataSource.titles = []
		segmentedDataSource.isTitleColorGradientEnabled = true
		segmentedView.dataSource = segmentedDataSource

		let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthenOffset
        segmentedView.indicators = [indicator]

		segmentedView.delegate = self
		self.view.addSubview(segmentedView)

		listContainerView = JXSegmentedListContainerView(dataSource: self)
		self.view.addSubview(listContainerView)

		segmentedView.listContainer = listContainerView

		U17Network.Get(url: cateListApi, params: nil, success: { (json) in
			if let searchStr = json?["data"]["returnData"]["recommendSearch"].stringValue{
				self.searchStr = searchStr
				self.searchBtn.setTitle(searchStr, for: .normal)
			}
			if let ranklist = json?["data"]["returnData"]["rankingList"].arrayValue{
				for jsonModel in ranklist {
					let catelistModel = CateListModel.init(json: jsonModel)
					self.rankList.append(catelistModel)
				}
			}
			for model in self.rankList{
				self.segmentedDataSource.titles.append(model.sortName ?? "")
			}
			self.segmentedView.reloadData()
		}) { (msg) in
			U17Inform(msg)
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = false
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		segmentedView.frame = CGRect(x: 0, y: self.navigationController?.navigationBar.frame.maxY ?? 0, width: view.bounds.size.width, height: 50)
		listContainerView.frame = CGRect(x: 0, y: segmentedView.frame.maxY, width: view.bounds.size.width, height: view.bounds.size.height - segmentedView.frame.maxY)
	}

	@objc func clickSearchBtn(sender:UIButton) -> Void {
		self.navigationController?.pushViewController(USearchViewController.init(), animated: true)
	}

}

extension MainViewController:JXSegmentedListContainerViewDataSource{
	func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
		return segmentedDataSource.dataSource.count
	}

	func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
		let vc = LoadDataListViewController.init()
		let model = self.rankList[index]
		vc.argCon = model.argCon
		vc.argName = model.argName
		vc.argValue = model.argValue

		return vc
	}
}

extension MainViewController:JXSegmentedViewDelegate{
	func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
//		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadPage"), object: self)
	}
}

extension MainViewController:SlideMenuControllerDelegate{
	func leftWillOpen() {
//        print("SlideMenuControllerDelegate: leftWillOpen")
    }

    func leftDidOpen() {
//        print("SlideMenuControllerDelegate: leftDidOpen")
    }

    func leftWillClose() {
//        print("SlideMenuControllerDelegate: leftWillClose")
    }

    func leftDidClose() {
//        print("SlideMenuControllerDelegate: leftDidClose")
    }
}
