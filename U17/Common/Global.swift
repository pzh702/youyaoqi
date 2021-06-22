//
//  Global.swift
//  U17
//
//  Created by PT iOS Mac on 2020/8/21.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import Foundation
import UIKit

func RGB(r:CGFloat , g:CGFloat, b:CGFloat) ->UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

extension UIColor{
	class var backGround:UIColor{
		return RGB(r: 242, g: 242, b: 242)
	}
}

extension String {
    static let searchHistoryKey = "searchHistoryKey"
    static let sexTypeKey = "sexTypeKey"
} 

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

//MARK:Url
let baseUrl = "http://app.u17.com/v3/appV3_3/ios/phone/"
let searchHotApi = baseUrl+"search/hotkeywordsnew"
let searchRelativeApi = baseUrl+"search/relative"
let searchResultApi = baseUrl+"search/searchResult"
let boutiqueListApi = baseUrl+"comic/boutiqueListNew"
let specialApi = baseUrl+"comic/special"
let vipListApi = baseUrl+"list/vipList"
let subscribeListApi = baseUrl+"list/newSubscribeList"
let rankListApi = baseUrl+"rank/list"
let cateListApi = baseUrl+"sort/mobileCateList"
let comicListApi = baseUrl+"list/commonComicList"
let guessLikeApi = baseUrl+"comic/guessLike"
let detailStaticApi = baseUrl+"comic/detail_static_new"
let detailRealtimeApi = baseUrl+"comic/detail_realtime"
let commentListApi = baseUrl+"comment/list"
let chapterApi = baseUrl+"comic/chapterNew"


var isIphoneX: Bool {
    return UI_USER_INTERFACE_IDIOM() == .phone
        && (max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 812
        || max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 896)
}





//MARK:存储方法

//获取沙盒中Documents的目录路径
func documentsDir() -> URL {
	return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

//创建文件夹
func createFolder(name:String,baseUrl:URL?){
    let manager = FileManager.default
	let folder = baseUrl?.appendingPathComponent(name, isDirectory: true)
	print("文件夹: \(String(describing: folder))")
	let exist = manager.fileExists(atPath: folder!.path)
    if !exist {
		try! manager.createDirectory(at: folder!, withIntermediateDirectories: true,
                                     attributes: nil)
    }
}

//创建document下的文件夹
func folderInDocument(folder name:String) {
	createFolder(name: name, baseUrl: documentsDir())
}
