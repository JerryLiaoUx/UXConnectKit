//
//  Oauth2AuthResponse.swift
//  ASAP
//
//  Created by uitox_macbook on 2015/11/30.
//  Copyright © 2015年 uitox. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

// 取得授權碼、取得Access Token、利用Refresh Token取得Access Token
public class Oauth2AuthResponse : BaseResponse
{
	/*
	code
	*/
	public var code: String?
	public var accessToken: String?
	public var expiresIn: String?
	public var tokenType: String?
	public var scope: String?
	public var refreshToken: String?
	public var errorDescription: String?
	
	public override func mapping(map: Map) {
		super.mapping(map)
		
		code			<- map["code"]
		accessToken		<- map["access_token"]
		expiresIn		<- map["expires_in"]
		tokenType		<- map["token_type"]
		scope			<- map["scope"]
		refreshToken	<- map["refresh_token"]
		errorDescription <- map["error_description"]
	}
	
}

// Oauth2 Code
public class OauthCode : Object
{
	public dynamic var oauthCode: String = ""
}

// Oauth2 accessToken
public class OauthAccessToken : Object
{
	public dynamic var accessToken: String = ""
}

// Oauth2 refreshToken
public class OauthRefreshToken : Object
{
	public dynamic var refreshToken: String = ""
}
