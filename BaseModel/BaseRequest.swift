//
//  BaseRequest.swift
//  ASAP
//
//  Created by uitox_macbook on 2015/12/2.
//  Copyright © 2015年 uitox. All rights reserved.
//

import Foundation

public class BaseRequest
{
	public lazy var content = [String:AnyObject]()
}

public class MemberRequest:BaseRequest
{
	
	required public override init() {
		super.init()
		
		content = [
			"access_token":MyApp.sharedMember.oauthAccessToken
		]
	}
}


public class OauthRequest:BaseRequest
{
	
	required public override init() {
		super.init()
		
		content = [
			"client_id": MyApp.sharedWebsiteConfigModel.platformId,
			"client_secret":"e4ccf34a44eab72c39d64e2b234f1f2ea27f8120",
			"scope":"cG1hZG1pbiB3d3cgbWVtYmVyIGVkbSBzaG9w",
		]
	}
}

public class PmadminRequest:BaseRequest
{
	required public override init() {
		super.init()
		
		content = [
			"account": "01_uitoxtest",
			"password": "Aa1234%!@#",
			"platform_id": MyApp.sharedWebsiteConfigModel.platformId,
			"version": "1.0.0",
			"access_token":MyApp.sharedMember.oauthAccessToken
		]
	}
}

public class ShopRequest:BaseRequest
{
	
	required public override init() {
		super.init()
		
		content = [
			"platform_id": MyApp.sharedWebsiteConfigModel.platformId,
			"access_token":MyApp.sharedMember.oauthAccessToken
		]
	}
}
