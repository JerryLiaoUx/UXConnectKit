//
//  SetlogResponse.swift
//  ASAP
//
//  Created by uitox_macbook on 2015/11/27.
//  Copyright © 2015年 uitox. All rights reserved.
//

import Foundation
import ObjectMapper

public class SetlogResponse : BaseResponse
{
	/*
	status_code 
	100 成功
	200 type is empty
	201 參數錯誤
	*/
	public var isSuccess: Bool?
	
	public override func mapping(map: Map) {
		super.mapping(map)
	}
	
}

