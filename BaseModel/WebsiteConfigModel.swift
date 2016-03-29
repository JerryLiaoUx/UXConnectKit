//
//  WebsiteConfigModel.swift
//  ASAP
//
//  Created by uitox_macbook on 2015/11/19.
//  Copyright © 2015年 uitox. All rights reserved.
//

import Foundation
import RealmSwift

public class WebsiteConfigModel
{
	public typealias completedHandler = (resp: WebsiteConfigResponse?, errorMessage: String?) -> Void
	var platformId: String = ApiManager.sharedInstance.platformId
	var websiteConfigData:WebsiteConfigData?
	
	var configData: WebsiteConfigData? {
		get {
			let realm = try! Realm()
			
			let results = realm.objects(WebsiteConfigData)

			if results.count == 0 {
				if self.websiteConfigData != nil {
					return self.websiteConfigData
				}
				return nil
			}
			
			return results[0]
		}
	}

	
	/**
	呼叫平台設定
	- parameter completionHandler:  回呼之後的處理
	
	- returns:
	*/
	public func callApiGetWebConfig(queue: dispatch_queue_t = dispatch_get_main_queue(), completionHandler: completedHandler) {
		let urlPath = DomainPath.MviewPmadmin.rawValue
		
		let data = [
			"ws_seq":platformId
		]
		
		let requestDic = PmadminRequest()
		requestDic.content["action"] = "website_config_api/get_website_config_app"
		requestDic.content["data"] = data
		
		ApiManager.sharedInstance.postDictionary(urlPath, queue: queue, params: requestDic) {
			(resp: WebsiteConfigResponse?, error: String?) -> Void in
			
			if resp == nil || resp?.wcSeq == nil {
				completionHandler(resp: nil, errorMessage: error)
				return
			}
						
			let data = WebsiteConfigData()
			data.wcSeq = resp!.wcSeq
			data.logoPath = resp!.logoPath
			data.iconPath = resp!.iconPath
			data.deliveryNoCharge = resp!.deliveryNoCharge
			data.deliveryShipFee = resp!.deliveryShipFee
			data.cvsNoCharge = resp!.cvsNoCharge
			data.cvsShipFee = resp!.cvsShipFee
			data.menuRoot = resp!.menuRoot
			
			let realm = try! Realm()
			
			let results = realm.objects(WebsiteConfigData)
			if results.count > 0 {
				try! realm.write {
					realm.delete(results[0])
				}
			}

			try! realm.write({ () -> Void in
				realm.create(WebsiteConfigData.self, value: data, update: false)
				self.websiteConfigData = data
			})
			completionHandler(resp: resp, errorMessage: nil)
		}
		
	}

}