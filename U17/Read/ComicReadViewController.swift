//
//  ComicReadViewController.swift
//  U17
//
//  Created by PT iOS Mac on 2020/9/8.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ComicReadViewController: UIViewController {

	private var selectIndex :Int = 0
	private var modelArr :[ChapterListModel] = []
	private var imageModelArr :[ImageModel] = []
	private var comicName :String?
	private var downloadJson :JSON?

	private lazy var collectionView: UICollectionView = {
		let lt = UICollectionViewFlowLayout()
        lt.sectionInset = .zero
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 10
		lt.scrollDirection = .vertical
        let cw = UICollectionView(frame: .zero, collectionViewLayout: lt)
		cw.backgroundColor = .white
		cw.bounces = false
        cw.delegate = self
        cw.dataSource = self
		cw.register(UReadCell.self, forCellWithReuseIdentifier: "UReadCell")

		return cw
	}()

	private lazy var headView: U17ReadHead = {
		let hv = U17ReadHead.init(title: self.comicName, frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 50))
		hv.isHidden = true
		hv.backBtnBlock = {
			self.navigationController?.popViewController(animated: true)
		}
		return hv
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		initSubViews()
		let fileUrl = documentsDir().appendingPathComponent(self.comicName!, isDirectory: true).appendingPathComponent("\(String(describing: modelArr[selectIndex].chapter_id!))")
		let exit = FileManager.default.fileExists(atPath: fileUrl.path)
		if exit {
			let str = try? String.init(contentsOf: fileUrl)
//			downloadJson = JSON.init(str ?? "")
			downloadJson = JSON.init(parseJSON: str ?? "")
		}

		if downloadJson == nil {
			var paramters :[String:Any] = [:]
			paramters["chapter_id"] = modelArr[selectIndex].chapter_id

			U17Network.Get(type: .none, url: chapterApi, params: paramters, success: { (json) in
				self.downloadJson = json
				if let jsonArr = json?["data"]["returnData"]["image_list"].arrayValue{
					for jsonModel in jsonArr {
						self.imageModelArr.append(ImageModel.init(json: jsonModel))
					}
				}
				self.collectionView.reloadData()
				self.headView.downloadBtnBlock = { [weak self] in
					self?.downloadComic()
				}
			}) { (msg) in

			}
		} else {
			if let jsonArr = downloadJson?["data"]["returnData"]["image_list"].arrayValue{
				for jsonModel in jsonArr {
					self.imageModelArr.append(ImageModel.init(json: jsonModel))
				}
			}
			self.collectionView.reloadData()
			self.headView.downloadBtnBlock = { [weak self] in
				self?.downloadComic()
			}
		}

    }

	func downloadComic() {
		//1、保存图片
//		guard let comicName = comicName else {
//			return
//		}
//		folderInDocument(folder: comicName)
//		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//		let directory = documentsURL.appendingPathComponent(comicName, isDirectory: true)
//		for model in imageModelArr {
//			let destination: DownloadRequest.Destination = { _, _ in
//				let fileURL = directory.appendingPathComponent("\(String(describing: model.image_id!)).png")
//
//				return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//			}
//			AF.download(model.location ?? "", to: destination).downloadProgress { (progress) in
//				print("下载进度：\(progress.fractionCompleted)")
//			}.response{response in
//				if response.error == nil, let imagePath = response.fileURL?.path {
//					let image = UIImage(contentsOfFile: imagePath)
//				}
//			}
//		}

		//2、保存json
		guard let comicName = comicName,let chapterId = modelArr[selectIndex].chapter_id,let json = downloadJson else {
			return
		}
		folderInDocument(folder: comicName)
		let directory = documentsDir().appendingPathComponent(comicName, isDirectory: true)
		let fileUrl = directory.appendingPathComponent("\(chapterId)")//文件路径
		try! json.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.init(rawValue: 0))!.write(to: fileUrl, atomically: true, encoding: .utf8)
	}

	override var prefersStatusBarHidden: Bool {
        return isIphoneX ? false : true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

	func initSubViews() {
		self.view.addSubview(collectionView)
		collectionView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}

		self.view.addSubview(headView)
	}

	convenience init(chapterList:[ChapterListModel],selectIndex:Int,name:String?) {
		self.init()
		self.selectIndex = selectIndex
		self.modelArr = chapterList
		self.comicName = name
	}


}

extension ComicReadViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.imageModelArr.count
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let image = self.imageModelArr[indexPath.item]
		let height = floor(screenWidth / CGFloat(image.width) * CGFloat(image.height))
		return CGSize.init(width: screenWidth, height: height)
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UReadCell", for: indexPath) as! UReadCell
		cell.model = self.imageModelArr[indexPath.item]
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if headView.isHidden {
			headView.show()
		} else {
			headView.hide()
		}
	}


}

extension ComicReadViewController:UIScrollViewDelegate{
//	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		if scrollView.contentOffset.x>screenWidth/2 {
//			scrollView.setContentOffset(CGPoint.init(x: screenWidth, y: 0), animated: true)
//		} else {
//			scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
//		}
//	}
}
