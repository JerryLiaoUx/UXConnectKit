//
//  BaseResponse.swift
//  ASAP
//
//  Created by uitox_macbook on 2015/12/1.
//  Copyright © 2015年 uitox. All rights reserved.
//

import Foundation
import ObjectMapper



public class BaseResponse:Mappable {
	public var statusCode: String = ""
	
	required public init?(_ map: Map) {
		
	}

	public func mapping(map: Map) {
		statusCode <- map["status_code"]
	}

}

