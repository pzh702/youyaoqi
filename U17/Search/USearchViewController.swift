//
//  USearchViewController.swift
//  U17
//
//  Created by PT iOS Mac on 2020/8/27.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit

class USearchViewController: UIViewController {

	private lazy var searchField: UITextField = {
		let field = UITextField.init()
		field.textColor = .black
		field.backgroundColor = RGB(r: 230, g: 230, b: 230)
		field.font = .systemFont(ofSize: 15)
//		field.clearsOnBeginEditing = true
		field.placeholder = "输入漫画名称/作者"
		field.clearButtonMode = .always
		field.returnKeyType = .search
		field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
		field.leftViewMode = .always
		field.delegate = self
		NotificationCenter.default.addObserver(self, selector: #selector(textFiledTextDidChange(noti:)), name: UITextField.textDidChangeNotification, object: field)
		return field
	}()

	private var cancelBtn: UIButton = {
		let cancelBtn = UIButton.init()
		cancelBtn.setTitle("取消", for: .normal)
		cancelBtn.setTitleColor(.black, for: .normal)
		cancelBtn.titleLabel?.font = .systemFont(ofSize: 15)
		cancelBtn.sizeToFit()

		return cancelBtn
	}()

	var searchHotArr :[SearchHotModel] = []
	var searchStrArr :[String] = {
		return (UserDefaults.standard.array(forKey: String.searchHistoryKey) as? [String] ?? [])
	}()
	var searchHistoryArr :[SearchHotModel]{
		get{
			var arr:[SearchHotModel] = []
			for str in searchStrArr {
				arr.append(SearchHotModel.init(name_: str, comic_id_: nil, bgColor_: nil))
			}
			return arr
		}
	}
	var collectionArr :[[SearchHotModel]] {
		get{
			return [searchHotArr,searchHistoryArr]
		}
	}
	var searchResultArr :[ComicModel] = []


	private lazy var collectionView: UICollectionView = {
		let lt = UICollectionViewFlowLayout.init()
		lt.scrollDirection = .vertical
		lt.minimumLineSpacing = 10
		lt.minimumInteritemSpacing = 10
		lt.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		lt.estimatedItemSize = CGSize(width: 100, height: 40)
		lt.headerReferenceSize = CGSize.init(width: screenWidth, height: 40)
		lt.footerReferenceSize = CGSize.init(width: screenWidth, height: 0.01)
		let cv = UICollectionView.init(frame: .zero, collectionViewLayout: lt)
		cv.backgroundColor = .white
		cv.delegate = self
		cv.dataSource = self
		cv.register(USearchCell.self, forCellWithReuseIdentifier: "USearchCell")
		cv.register(USearchHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "USearchHeadView")
		cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
		return cv
	}()

	private lazy var searchTW: UITableView = {
		let tw = UITableView.init(frame: .zero, style: .plain)
		tw.delegate = self
		tw.dataSource = self
		tw.backgroundColor = .white
		tw.isHidden = true
		tw.separatorStyle = .none
		tw.bounces = false
		tw.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
		return tw
	}()

	private lazy var searchResultTW: UITableView = {
		let tw = UITableView.init(frame: .zero, style: .plain)
		tw.delegate = self
		tw.dataSource = self
		tw.backgroundColor = .white
		tw.isHidden = true
		tw.separatorStyle = .none
		tw.bounces = false
		tw.register(UCommicCell.self, forCellReuseIdentifier: "UCommicCell")
		return tw
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.addSubview(collectionView)
		collectionView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}
		self.view.addSubview(searchTW)
		searchTW.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}
		self.view.addSubview(searchResultTW)
		searchResultTW.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}

		self.loadSearchHotData()

		searchField.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 30)
		searchField.layer.cornerRadius = 15
		navigationItem.titleView = searchField
		cancelBtn.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
		navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: cancelBtn)
		navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: nil, style: .plain, target: nil, action: nil)
		self.navigationController?.navigationBar.backgroundColor = .white
		//去除navigationBar分割线
		self.navigationController?.navigationBar.shadowImage = UIImage.init()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = false
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.searchField.becomeFirstResponder()
	}

	func loadSearchHotData() -> Void {
		U17Network.Get(type: .none,url: searchHotApi, params: nil, success: { (json) in
			if let searchHots = json?["data"]["returnData"]["hotItems"].arrayValue{
				for jsonModel in searchHots {
					self.searchHotArr.append(SearchHotModel.init(json: jsonModel))
				}
				self.collectionView.reloadData()
			}
			if let defaultSearch = json?["data"]["returnData"]["defaultSearch"].stringValue{
				self.searchField.placeholder = defaultSearch
			}
		}) { (msg) in
			U17Inform(msg)
		}
	}

	func loadSearchResultData(text:String) {
		self.searchResultArr.removeAll()
		self.searchTW.reloadData()
		self.searchResultTW.reloadData()

		if text.count>0 {
			self.searchResultTW.isHidden = true
			self.searchTW.isHidden = false
			var params:[String:Any] = [:]
			params["argCon"] = 0
			params["q"] = text

			U17Network.Get(type:.none,url: searchResultApi, params: params, success: { (json) in
				if let comics = json?["data"]["returnData"]["comics"].arrayValue{
					for jsonModel in comics {
						self.searchResultArr.append(ComicModel.init(json: jsonModel))
					}
					self.searchTW.reloadData()
					self.searchResultTW.reloadData()
				}
			}) { (msg) in

			}
		} else {
			self.searchResultTW.isHidden = true
			self.searchTW.isHidden = true
		}
	}

	@objc func cancelSearch() -> Void {
		self.navigationController?.popViewController(animated: true)
	}

	deinit {
        NotificationCenter.default.removeObserver(self)
    }

	func saveSearchResult(_ searchStr:String) {
		if searchStr == "" {
			return
		}
		if searchStrArr.contains(searchStr) {
			if let index = searchStrArr.firstIndex(of: searchStr){
				searchStrArr.remove(at: index)
			}
		}
		searchStrArr.insert(searchStr, at: searchStrArr.startIndex)
		UserDefaults.standard.setValue(searchStrArr, forKey: String.searchHistoryKey)
		UserDefaults.standard.synchronize()
		self.collectionView.reloadData()
	}

}

extension USearchViewController:UITextFieldDelegate{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.searchField.resignFirstResponder()
		guard let searchStr = textField.text else { return true }
		self.searchResultTW.isHidden = false
		self.searchTW.isHidden = true

		self.saveSearchResult(searchStr)

		return true
	}

	@objc func textFiledTextDidChange(noti: Notification) {
		guard let textField = noti.object as? UITextField,
		let text = textField.text else { return }
		//搜索
		self.loadSearchResultData(text: text)
	}
}

extension USearchViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionArr[section].count
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return collectionArr.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "USearchCell", for: indexPath) as! USearchCell
		cell.layer.cornerRadius = cell.bounds.size.height/2
		cell.layer.masksToBounds = true
		let model = collectionArr[indexPath.section][indexPath.row]
		cell.titleLabel.text = model.name
		cell.contentView.backgroundColor = UIColor.init(hexString: model.bgColor ?? "#e0dcdc")
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if indexPath.section == 0 {
			if kind == UICollectionView.elementKindSectionHeader {
				let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "USearchHeadView", for: indexPath) as! USearchHeadView
				head.searchType = .hot
				head.rightBtnClick = {
					print("刷新")
				}
				return head
			} else {
				let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView", for: indexPath)

				return foot
			}
		} else {
			if kind == UICollectionView.elementKindSectionHeader {
				let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "USearchHeadView", for: indexPath) as! USearchHeadView
				head.searchType = .history
				head.rightBtnClick = {
					UserDefaults.standard.removeObject(forKey: String.searchHistoryKey)
					self.searchStrArr.removeAll()
					UserDefaults.standard.synchronize()
					self.collectionView.reloadData()
				}
				return head
			} else {
				let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView", for: indexPath)

				return foot
			}
		}
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let model = collectionArr[indexPath.section][indexPath.row]
		if let name = model.name {
			self.searchField.text = name
			self.loadSearchResultData(text: name)
			self.saveSearchResult(name)
			self.searchResultTW.isHidden = false
			self.searchTW.isHidden = true
		}
	}
}

extension USearchViewController:UITableViewDelegate,UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == searchTW {//搜索列表最多显示10条
			return (searchResultArr.count>10) ?10:searchResultArr.count
		} else {
			return searchResultArr.count
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if tableView == searchTW {
			let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
			cell.textLabel?.text = self.searchResultArr[indexPath.row].name

			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "UCommicCell", for: indexPath) as! UCommicCell
			cell.model = self.searchResultArr[indexPath.row]

			return cell
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if tableView == searchTW {
			return 30
		} else {
			return 180
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//跳转至漫画详情页
		guard let comicId = self.searchResultArr[indexPath.row].comicId else { return }
		let vc = ComicDetailViewController.init(comicid: comicId)
		self.navigationController?.pushViewController(vc, animated: true)

	}


}
