//
//  UModel.swift
//  U17
//
//  Created by PT iOS Mac on 2020/8/20.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CateListModel {
	var sortId : Int?
	var sortName : String?
	var isLike : Bool?
	var cover : String?
	var canEdit : Bool?
	var argName : String?
	var argValue : Int?
	var argCon : Int?


	init(json:JSON) {
		sortId = json["sortId"].intValue
		sortName = json["sortName"].stringValue
		isLike = json["isLike"].boolValue
		cover = json["cover"].stringValue
		canEdit = json["canEdit"].boolValue
		argName = json["argName"].stringValue
		argValue = json["argValue"].intValue
		argCon = json["argCon"].intValue
	}
}

struct ComicModel {
	var tags :[String] = []
	var author :String?
	var flag :Int?
	var comicId : Int?
	var is_vip :Int?
	var cover :String?
	var short_description :String?
	var description :String?
	var name :String?

	init(json:JSON) {
		let arr = json["tags"].arrayValue
		for jsonTag in arr {
			tags.append(jsonTag.stringValue)
		}
		author = json["author"].stringValue
		flag = json["flag"].intValue
		comicId = json["comicId"].intValue
		is_vip = json["is_vip"].intValue
		cover = json["cover"].stringValue
		short_description = json["short_description"].stringValue
		description = json["description"].stringValue
		name = json["name"].stringValue
	}

}

struct SearchHotModel {
	var comic_id :String?
	var name :String?
	var bgColor :String?

	init(json:JSON) {
		comic_id = json["comic_id"].stringValue
		name = json["name"].stringValue
		bgColor = json["bgColor"].stringValue
	}

	init(name_:String?,comic_id_:String?,bgColor_:String?) {
		comic_id = comic_id_
		name = name_
		bgColor = bgColor_
	}
}

struct ComicStaticModel {
	var cover :String?
	var thread_id :Int?
	var comic_id :Int?
	var cate_id :String?
	var description :String?
	var type :Int?
	var short_description :String?
	var series_status :Int?	//连载状态,0已完结
	var author :AuthorModel?
	var name :String?
	var last_update_time :Double?
	var theme_ids :[String] = []

	init(json:JSON) {
		cover = json["cover"].stringValue
		thread_id = json["thread_id"].intValue
		comic_id = json["comic_id"].intValue
		cate_id = json["cate_id"].stringValue
		description = json["description"].stringValue
		type = json["type"].intValue
		short_description = json["short_description"].stringValue
		series_status = json["series_status"].intValue
		author = AuthorModel.init(json: json["author"])
		name = json["name"].stringValue
		last_update_time = json["last_update_time"].doubleValue
		let arr = json["theme_ids"].arrayValue
		for jsonTheme in arr {
			theme_ids.append(jsonTheme.stringValue)
		}
	}
}

struct ComicRealtimeModel {
	var click_total :String?
	var favorite_total :String?
	var total_ticket: String?
	var monthly_ticket: String?

	init(json:JSON) {
		click_total = json["click_total"].stringValue
		favorite_total = json["favorite_total"].stringValue
		total_ticket = json["total_ticket"].stringValue
		monthly_ticket = json["monthly_ticket"].stringValue
	}
}

struct AuthorModel {
	var avatar :String?
	var id :Int?
	var name :String?

	init(json:JSON) {
		avatar = json["avatar"].stringValue
		id = json["id"].intValue
		name = json["name"].stringValue
	}
}

struct OtherWorkModel {
	var name :String?
	var passChapterNum :Int?
	var coverUrl :String?
	var comicId :Int?

	init(json:JSON) {
		name = json["name"].stringValue
		passChapterNum = json["passChapterNum"].intValue
		coverUrl = json["coverUrl"].stringValue
		comicId = json["comicId"].intValue
	}
}

struct ChapterListModel {
	var price :Int?
	var has_locked_image :Bool?
	var countImHightArr :Int?
	var pass_time :Double?
	var is_new :Int?
	var chapter_id :Int?
	var size :Int?
	var type :Int?
	var image_total :Int?
	var name :String?

	init(json:JSON) {
		price = json["price"].intValue
		has_locked_image = json["has_locked_image"].boolValue
		countImHightArr = json["countImHightArr"].intValue
		pass_time = json["pass_time"].doubleValue
		is_new = json["is_new"].intValue
		chapter_id = json["chapter_id"].intValue
		size = json["size"].intValue
		type = json["type"].intValue
		image_total = json["image_total"].intValue
		name = json["name"].stringValue
	}
}

struct ImageModel {
	var type :Int?
	var image_id :Int?
	var location :String?
	var total_tucao :Int?
	var img50 :String?
	var img05 :String?
	var width :Int = 1
	var height :Int = 1

	init(json:JSON) {
		type = json["type"].intValue
		image_id = json["image_id"].intValue
		location = json["location"].stringValue
		total_tucao = json["total_tucao"].intValue
		img50 = json["img50"].stringValue
		img05 = json["img05"].stringValue
		width = json["width"].intValue
		height = json["height"].intValue
	}
}


