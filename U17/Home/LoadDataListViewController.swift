//
//  LoadDataListViewController.swift
//  测试1
//
//  Created by PT iOS Mac on 2020/8/15.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import JXSegmentedView
import MJRefresh

class LoadDataListViewController: UIViewController {

	var argCon: Int?
	var argName: String?
	var argValue: Int?
	var page: Int = 1
	var dataLoaded = false

	private var comicList:[ComicModel] = []
	private var spinnerName: String?

	private lazy var tableView: UITableView = {
		let tableView = UITableView.init(frame: self.view.frame, style: .plain)
		tableView.backgroundColor = .backGround
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UCommicCell.self, forCellReuseIdentifier: "UCommicCell")
		tableView.mj_header = U17RefreshHeader.init(refreshingBlock: {
			self.loadData(more: false)
		})
		tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
			self.loadData(more: true)
		})
		return tableView
	}()

	private lazy var emptyView: U17EmptyView = {
		let ev = U17EmptyView.init(frame: self.view.frame)
		ev.isHidden = true
		return ev
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(reloadPage), name: NSNotification.Name(rawValue: "ReloadPage"), object: nil)
		self.view.addSubview(tableView)
		tableView.snp.makeConstraints { (make) in
			make.top.left.bottom.right.equalTo(self.view)
		}

		self.view.addSubview(emptyView)
		emptyView.reloadBlock = { [weak self] in
			self?.loadData(more: false)
		}
		emptyView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		if dataLoaded == false {
//			self.loadData(more: false)
//		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.reloadPage()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	func loadData(more:Bool) {
		self.page = more ?(page+1):1
		var parmeters :[String:Any] = [:]
        parmeters["argCon"] = argCon
		parmeters["argValue"] = argValue
		parmeters["page"] = max(1, page)
		if let argName = argName,argName.count>0 {
			parmeters["argName"] = argName
		}
		U17Network.Get(url: comicListApi, params: parmeters, success: { (json) in
			print(json ?? "")
			self.tableView.mj_header?.endRefreshing()
			self.dataLoaded = true
			if json?["data"]["returnData"]["hasMore"].boolValue == false{
				self.tableView.mj_footer?.endRefreshingWithNoMoreData()
			}else{
				self.tableView.mj_footer?.endRefreshing()
			}
			if !more{
				self.comicList.removeAll()
			}
			if let comics = json?["data"]["returnData"]["comics"].arrayValue{
				for jsonModel in comics {
					self.comicList.append(ComicModel.init(json: jsonModel))
				}
				self.tableView.reloadData()
			}
			self.argCon = json?["data"]["returnData"]["defaultParameters"]["defaultArgCon"].intValue
			self.spinnerName = json?["data"]["returnData"]["defaultParameters"]["defaultConTagType"].stringValue
			if self.comicList.count != 0{
				self.emptyView.isHidden = true
			}
		}) { (msg) in
			if self.comicList.count == 0{
				self.emptyView.isHidden = false
			}
			self.tableView.mj_header?.endRefreshing()
			U17Inform(msg)
		}
	}

	@objc func reloadPage() {
		page = 1
		if dataLoaded == false {
			self.loadData(more: false)
		}
	}
}

extension LoadDataListViewController:JXSegmentedListContainerViewListDelegate{
	func listView() -> UIView {
		return self.view
	}
	func listDidAppear() {

	}
	func listWillAppear(){

	}
}

extension LoadDataListViewController:UITableViewDelegate,UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.comicList.count
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let cell = UCommicCell.init()
		cell.show()
	}

	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let cell = UCommicCell.init()
		cell.hide()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "UCommicCell", for: indexPath) as! UCommicCell
		cell.indexPath = indexPath
		cell.model = self.comicList[indexPath.row]
		cell.spinnerName = spinnerName

		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 180
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let comicId = self.comicList[indexPath.row].comicId else { return }
		//跳转漫画详情页
		let vc = ComicDetailViewController.init(comicid: comicId)
		self.navigationController?.pushViewController(vc, animated: true)
	}
}
