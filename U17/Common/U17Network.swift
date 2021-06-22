//
//  BetaNetwork.swift
//  BetaSDK_Swift
//
//  Created by PT iOS Mac on 2020/8/5.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//
//网络封装
import Foundation
import Alamofire
import SwiftyJSON

//enum MethodType {
//	case get
//	case post
//}

enum LoadType {
	case none
	case load
}

class U17Network {
	class func request(type:LoadType,url:String,params:[String:Any]?,timeout:TimeInterval = 30,success:@escaping(JSON?)->Void,failure:@escaping(String?)->Void) -> Void {
		if type == .load {
			U17BeginLoading()
		}
		AF.request(url, method: .get, parameters: params) { (urlRequest) in
			urlRequest.timeoutInterval = timeout
		}.responseData { (response) in
			if type == .load{
				U17EndLoading()
			}
			guard let data = response.data else{
				failure("请求失败")
				return
			}
			switch response.result{
			case .success(_):
				let json = JSON(data)
				if json["code"].int == 1 {
					success(json)
				} else {
					failure("返回错误")
				}
			case let .failure(error):
				failure(error.localizedDescription)
			}
		}
	}
}

extension U17Network{
	class func Get(type:LoadType,url:String,params:[String:Any]?,success:@escaping(JSON?)->Void,failure:@escaping (String?)->Void) -> Void {
		U17Network.request(type: type, url: url, params: params, timeout: 30, success: success, failure: failure)
	}

	class func Get(url:String,params:[String:Any]?,success:@escaping(JSON?)->Void,failure:@escaping (String?)->Void) -> Void {
		U17Network.request(type: .load, url: url, params: params, timeout: 30, success: success, failure: failure)
	}

//	class func Post(url:String,params:[String:Any]?,success:@escaping(JSON?)->Void,failure:@escaping (String?)->Void) -> Void {
//		U17Network.request(type: .post, url: url, params: params, timeout: 30, success: success, failure: failure)
//	}
}
