//
//  ComicDetailViewController.swift
//  U17
//
//  Created by PT iOS Mac on 2020/9/1.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import SnapKit

class ComicDetailViewController: UIViewController {

	private var comicid: Int = 0
	var chapterList :[ChapterListModel] = []


	var navigationBarY: CGFloat {
		return navigationController?.navigationBar.frame.minY ?? 0
	}

	private lazy var tableView: UITableView = {
		let tv = UITableView.init(frame: self.view.bounds, style: .plain)
		tv.backgroundColor = .white
		tv.separatorStyle = .none
		tv.allowsSelection = false
//		tv.bounces = false
		tv.delegate = self
		tv.dataSource = self
		tv.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
		tv.register(UChapterCell.self, forCellReuseIdentifier: "UChapterCell")
		return tv
	}()

	lazy var headView: UComicHead = {
		let hv = UComicHead.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 200))
		hv.backBtnBlock = {
			self.navigationController?.popViewController(animated: true)
		}
		return hv
	}()

	convenience init(comicid: Int) {
        self.init()
        self.comicid = comicid
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		self.initSubViews()
		self.loadData()
        // Do any additional setup after loading the view.
    }

	func initSubViews() {
		self.view.addSubview(tableView)
		self.tableView.tableHeaderView = self.headView
		navigationController?.navigationBar.isHidden = true
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}

	func loadData() {
		let group = DispatchGroup.init()
		group.enter()

		var parmeters :[String:Any] = [:]
		parmeters["comicid"] = comicid

		U17Network.Get(type: .none, url: detailStaticApi, params: parmeters, success: { (json) in
			if let comicModel = json?["data"]["returnData"]["comic"]{
				self.headView.detailStatic = ComicStaticModel.init(json: comicModel)
			}
			if let chapterListModelArr = json?["data"]["returnData"]["chapter_list"].arrayValue{
				for chapterJsonModel in chapterListModelArr {
					self.chapterList.append(ChapterListModel.init(json: chapterJsonModel))
				}
			}
			group.leave()
		}) { (msg) in
			U17Error(msg)
		}
		group.enter()
		U17Network.Get(type: .none, url: detailRealtimeApi, params: parmeters, success: { (json) in
			if let jsonModel = json?["data"]["returnData"]["comic"]{
				self.headView.detailRealtime = ComicRealtimeModel.init(json: jsonModel)
			}
			group.leave()
		}) { (msg) in
			U17Error(msg)
		}

		group.notify(queue: DispatchQueue.main){
			self.tableView.reloadData()
		}
	}


}

extension ComicDetailViewController:UITableViewDelegate,UITableViewDataSource{
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offY = scrollView.contentOffset.y
		if offY>navigationBarY {
//			navigationController?.barStyle(style: .theme)
		} else {
//			navigationController?.barStyle(style: .clear)
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
			cell.textLabel?.numberOfLines = 0
			if let model = self.headView.detailStatic{
				cell.textLabel?.text = "【\(model.cate_id ?? "")】\(model.description ?? "")"
			}
			return cell
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
			if let model = self.headView.detailRealtime {
				let text = NSMutableAttributedString(string: "本月月票       |     累计月票  ",
													 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
																  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
				text.append(NSAttributedString(string: "\(model.total_ticket ?? "")",
					attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
								 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
				text.insert(NSAttributedString(string: "\(model.monthly_ticket ?? "")",
					attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
								 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]),
							at: 6)
				cell.textLabel?.attributedText = text
				cell.textLabel?.textAlignment = .center
			}

			return cell
		case 2:
			let cell = tableView.dequeueReusableCell(withIdentifier: "UChapterCell",for: indexPath) as! UChapterCell
			cell.modelArr = self.chapterList
			cell.leftTitle.text = self.headView.detailStatic?.series_status == 0 ?"已完结":"连载中"
			cell.clickItemBlock = { (arr,index) in
				let vc = ComicReadViewController.init(chapterList: arr, selectIndex: index,name:self.headView.detailStatic?.name)
				self.navigationController?.pushViewController(vc, animated: true)
			}
			cell.rightBtnBlock = {
				let chapterView = UChapterListView.init(frame: self.view.bounds)
				chapterView.modelArr = self.chapterList
				chapterView.clickItemBlock = { (arr,index) in
					let vc = ComicReadViewController.init(chapterList: arr, selectIndex: index,name:self.headView.detailStatic?.name)
					self.navigationController?.pushViewController(vc, animated: true)
				}
				self.view.addSubview(chapterView)
				chapterView.snp.makeConstraints { (make) in
					make.top.equalTo(self.view).offset(self.navigationBarY)
					make.left.right.equalTo(self.view)
					make.bottom.equalTo(self.view)
				}
			}
			return cell
		case 3:
			let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
			cell.textLabel?.text = "第四行"
			return cell
		default:
			let cell = UITableViewCell.init()
			return cell
		}

	}


}
