//
//  Oauth2AuthModel.swift
//  ASAP
//
//  Created by uitox_macbook on 2015/11/30.
//  Copyright © 2015年 uitox. All rights reserved.
//

import Foundation

class Oauth2AuthModel
{
	typealias completedHandler = (response: Oauth2AuthResponse?, errorMessage: String?) -> Void
	
	func handleAuthorize() {
		self.getAuthorizeCodeData { (response, errorMessage) -> Void in
			self.getAuthorizeAccessTokenData({ (response, errorMessage) -> Void in
				
			})
		}
	}
	
	/*
	取得授權碼
	- parameter completionHandler:  回呼之後的處理
	
	- returns:
	*/
	func getAuthorizeCodeData(completionHandler: completedHandler) {
		let urlPath = DomainPath.MviewOauth.rawValue
		
		let requestDic = OauthRequest()
		
		ApiManager.sharedInstance.postDictionary(urlPath, queue: highPriorityDispatchQueue, params: requestDic) {
			(response: Oauth2AuthResponse?, error: String?) -> Void in
			
			if response == nil {
				completionHandler(response: nil, errorMessage: error)
				return
			}

			if response!.code == nil {
				log.warning(response!.errorDescription!)
				completionHandler(response: nil, errorMessage: "getAuthorizeCodeData failed")
				return
			}
			
			MyApp.sharedMember.oauthCode = response!.code!
						
			completionHandler(response: response, errorMessage: nil)
		}
	}
	
	/*
	取得Access Token
	- parameter completionHandler:  回呼之後的處理
	
	- returns:
	*/
	func getAuthorizeAccessTokenData(completionHandler: completedHandler ) {
		let urlPath = DomainPath.MviewOauthAt.rawValue
		
		let requestDic = OauthRequest()
		requestDic.content["grant_type"] = "YXV0aG9yaXphdGlvbl9jb2Rl"
		requestDic.content["code"] = MyApp.sharedMember.oauthCode

		
		ApiManager.sharedInstance.postDictionary(urlPath, queue: highPriorityDispatchQueue, params: requestDic) {
			(response: Oauth2AuthResponse?, error: String?) -> Void in
			
			if response == nil {
				completionHandler(response: nil, errorMessage: error)
				return
			}
			
			if response!.accessToken == nil {
				log.warning(response!.errorDescription!)
				completionHandler(response: nil, errorMessage: "getAuthorizeAccessTokenData failed")
				return
			}

			MyApp.sharedMember.oauthAccessToken = response!.accessToken!
			MyApp.sharedMember.oauthRefreshToken = response!.refreshToken!

			completionHandler(response: response, errorMessage: nil)
		}
	}

	/*
	Access Token 失效，利用 Refresh Token 更新 Access Token
	- parameter completionHandler:  回呼之後的處理
	
	- returns:
	*/
	func getAuthorizeRefreshTokenData(completionHandler: completedHandler ) {
		let urlPath = DomainPath.MviewOauthRt.rawValue
		
		let requestDic = OauthRequest()
		requestDic.content["grant_type"] = "cmVmcmVzaF90b2tlbg=="
		requestDic.content["refresh_token"] = MyApp.sharedMember.oauthRefreshToken
	
		ApiManager.sharedInstance.postDictionary(urlPath, queue: highPriorityDispatchQueue, params: requestDic) {
			(response: Oauth2AuthResponse?, error: String?) -> Void in
			
			if response == nil {
				completionHandler(response: nil, errorMessage: error)
				return
			}
			
			if response!.statusCode.hasSuffix("777") {
				self.getAuthorizeCodeData({ (response, errorMessage) -> Void in
					self.getAuthorizeAccessTokenData({ (response, errorMessage) -> Void in
						completionHandler(response: response, errorMessage: nil)
					})
				})
				return
			}
			
			if response!.refreshToken == nil {
				log.warning(response!.errorDescription!)
				completionHandler(response: nil, errorMessage: "getAuthorizeRefreshTokenData failed")
				return
			}
			
			MyApp.sharedMember.oauthAccessToken  = response!.accessToken!
			MyApp.sharedMember.oauthRefreshToken = response!.refreshToken!
			
			completionHandler(response: response, errorMessage: nil)
		}
	}

}