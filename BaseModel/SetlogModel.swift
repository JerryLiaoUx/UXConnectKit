//
//  SetlogModel.swift
//  ASAP
//
//  Created by uitox_macbook on 2015/11/27.
//  Copyright © 2015年 uitox. All rights reserved.
//

import Foundation

class SetlogModel
{
	typealias completedHandler = (logResponse: SetlogResponse?, errorMessage: String?) -> Void
	
	/*
	紀錄log
	- parameter msg:				訊息
	- parameter completionHandler:  回呼之後的處理
	
	- returns:
	*/
	func setlogToServer(msg: String, completionHandler: completedHandler ) {
		let urlPath = DomainPath.MviewTool.rawValue
		
		let requestDic = BaseRequest()
		requestDic.content["msg"] = msg
		
		ApiManager.sharedInstance.postDictionary(urlPath, params: requestDic) {
			(response: SetlogResponse?, error: String?) -> Void in
			
			if response == nil {
				completionHandler(logResponse: nil, errorMessage: error)
				return
			}
			
			if let statusCode = response?.statusCode {
				if !statusCode.hasSuffix("100") {
					log.error("Set log failed")
				}
			}
			
			completionHandler(logResponse: response, errorMessage: nil)
		}
	}

}