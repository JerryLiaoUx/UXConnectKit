//
//  ApiManager.swift
//
//  Created by uitox_macbook on 2015/8/11.
//  Copyright (c) 2015年 uitox. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift
import AlamofireObjectMapper

public enum DomainPath: String {
	#if BETA
		case Uxapi			= "https://uxapi.uitoxbeta.com"
		case Mview			= "https://mview.uitoxbeta.com/A"
		case MviewPmadmin	= "https://mview.uitoxbeta.com/A/call_api/pmadmin"
		case MviewWww		= "https://mview.uitoxbeta.com/A/call_api/www"
		case MviewShop		= "https://mview.uitoxbeta.com/A/call_api/shop"
		case MviewMember	= "https://mview.uitoxbeta.com/A/call_api/member"
		case MviewEdm       = "https://mview.uitoxbeta.com/A/call_api/edm"
		case MemberTw1		= "https://member-tw1.uitoxbeta.com/AW000001"
		case MviewTool		= "https://mview.uitoxbeta.com/A/tool_api/set_log/ios"
		case MviewOauth		= "https://mview.uitoxbeta.com/A/oauth2/Authorize"
		case MviewOauthAt	= "https://mview.uitoxbeta.com/A/oauth2/Authorize/token"
		case MviewOauthRt	= "https://mview.uitoxbeta.com/A/oauth2/RefreshToken"
        case Privacy        = "https://shop-tw1.uitox.com/AW000001/member/privacy_page"
        case Terms          = "https://shop-tw1.uitox.com/AW000001/member/terms_page"
	#else
		case Uxapi			= "https://uxapi.uitox.com"
		case Mview			= "https://mview.uitox.com/A"
		case MviewPmadmin	= "https://mview.uitox.com/A/call_api/pmadmin"
		case MviewWww		= "https://mview.uitox.com/A/call_api/www"
		case MviewShop		= "https://mview.uitox.com/A/call_api/shop"
        case MviewMember	= "https://mview.uitox.com/A/call_api/member"
        case MviewEdm       = "https://mview.uitox.com/A/call_api/edm"
		#if DEBUG
			case MemberTw1	= "https://member-tw1.uitox.com/AW000001"
		#else
			case MemberTw1	= "https://member-tw1.uitox.com/AW000001"
		#endif
		case MviewTool		= "https://mview.uitox.com/A/tool_api/set_log/ios"
		case MviewOauth		= "https://mview.uitox.com/A/oauth2/Authorize"
		case MviewOauthAt	= "https://mview.uitox.com/A/oauth2/Authorize/token"
        case MviewOauthRt	= "https://mview.uitox.com/A/oauth2/RefreshToken"
        case Privacy        = "https://shop-tw1.uitox.com/AW000001/member/privacy_page"
        case Terms          = "https://shop-tw1.uitox.com/AW000001/member/terms_page"
	#endif
}

public let highPriorityDispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

public class ApiManager
{
	public static let sharedInstance: ApiManager = {
		return ApiManager()
	}()

	#if DEBUG
		let platformId: String = "AW000001"
	#else
		let platformId: String = "AW000001"
	#endif
	
	private var manager: Manager
	private let setlogModel = SetlogModel()
	private let oauth = Oauth2AuthModel()

	init() {
		let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
		configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
		configuration.timeoutIntervalForRequest = 40
		let serverTrustPolicy = ServerTrustPolicy.PinCertificates(
			certificates: ServerTrustPolicy.certificatesInBundle(),
			validateCertificateChain: true,
			validateHost: true
		)

		let serverTrustPolicies: [String: ServerTrustPolicy] = [
			"uxapi.uitoxbeta.com2"									: serverTrustPolicy,
			NSURL(string: DomainPath.Uxapi.rawValue)!.host!			: .DisableEvaluation,
			NSURL(string: DomainPath.MviewPmadmin.rawValue)!.host!	: .DisableEvaluation,
			NSURL(string: DomainPath.MemberTw1.rawValue)!.host!		: .DisableEvaluation
		]
		
		
		configuration.URLCache = NSURLCache.sharedURLCache()
		configuration.requestCachePolicy = .UseProtocolCachePolicy

		manager = Alamofire.Manager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
	}
	
	//使用加密json做為parameter encoding
	let encryptJsonEncoding: (URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?) = {
		(URLRequest,parameters) in

		var mutableURLRequest = URLRequest.URLRequest
		
		guard let parameters = parameters else {
			return (mutableURLRequest, nil)
		}
		
		var encodingError: NSError? = nil

		do {
			let options = NSJSONWritingOptions()
			let data = try NSJSONSerialization.dataWithJSONObject(parameters, options: options)
			
			//加密request
			func encryptRequest(input:NSData) -> NSData {
				do {
					let key:[UInt8] = "i-love-you-uitox".dataUsingEncoding(NSUTF8StringEncoding)!.arrayOfBytes().sha256()
					let iv:[UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
					let aes = try! AES(key:key, iv:iv, blockMode: .CBC)
					
					let input: [UInt8] = input.arrayOfBytes()
					let encrypted:[UInt8] = try aes.encrypt(input, padding: PKCS7())
					let encryptedData = NSData(bytes: encrypted)
					let base64 = encryptedData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength)
					
					return base64.dataUsingEncoding(NSUTF8StringEncoding)!
				} catch {
					return NSData()
				}
			}

			let encryptedData = encryptRequest(data)
			
			mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
			mutableURLRequest.HTTPBody = encryptedData
		} catch {
			encodingError = error as NSError
		}

		return (mutableURLRequest, encodingError)
	}
	
	public func postDictionary<T:BaseResponse>(urlPath: String, queue: dispatch_queue_t = dispatch_get_main_queue(), params:BaseRequest?, completionHandler: (mapperObject: T?, errorMessage:String?) -> Void) {
		
		let requestLog = logRequest(urlPath, params:params?.content)
		
		manager.request(.POST, urlPath, parameters: params?.content, encoding: .Custom(encryptJsonEncoding)).responseObject(queue) {
			(response:Response<T, NSError>) in
			var responseLog = ""
			log.info { () -> String? in
				if let data = response.data {
					let jsonStr : String = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
					responseLog = "\nResponse >>>\n\(jsonStr)\n=========================================\n"
				}
				
				return responseLog
			}
			
			if response.result.isFailure {
				let logMsg = requestLog + responseLog + response.debugDescription
				log.error(response.debugDescription)
				self.setlogModel.setlogToServer(logMsg, completionHandler: { (logResponse, errorMessage) -> Void in })
				completionHandler(mapperObject:nil, errorMessage:"連線錯誤")
			} else if let responseEntity = response.result.value where responseEntity.statusCode.hasSuffix("777") {
				//註冊device token如果失效，則下次啟動再更新
				let action = params!.content["action"] as? String
				if let action = action {
					if action.hasPrefix("push_message_api") {
						return
					}
				}
				
				if urlPath == DomainPath.MviewOauthRt.rawValue {
					completionHandler(mapperObject:responseEntity, errorMessage:nil)
					return
				}
				
				log.info("get access token")
				self.oauth.getAuthorizeRefreshTokenData { (response, errorMessage) -> Void in
					let oldAccessToken = params!.content.updateValue(MyApp.sharedMember.oauthAccessToken, forKey: "access_token")
					log.info("update access token:\(MyApp.sharedMember.oauthAccessToken), old access token:\(oldAccessToken)")
					self.postDictionary(urlPath, queue: queue, params: params, completionHandler: { (mapperObject: T?, errorMessage) -> Void in
						log.info("call api again success")
						completionHandler(mapperObject:mapperObject, errorMessage:nil)
					})
				}
				return
			} else {
				completionHandler(mapperObject:response.result.value, errorMessage:nil)
			}
		}

		
	}
	
	//記錄request
	func logRequest(urlPath:String, params:[String: AnyObject]?) -> String {
		var requestLog = ""
		log.info { () -> String? in
			requestLog = "\nUrl: \(urlPath)\nRequest >>>\n"
			if let params = params {
				for (key,value) in params {
					requestLog += "\(key):\(value) \n"
				}
			}
			return requestLog
		}
		return requestLog
	}
	
//	//測試reflection
//	func postDictionary<T:Mappable>(urlPath:String, params:[String:AnyObject]?, completionHandler: (mapperObject: T?, errorMessage:String?, statusCode:String?) -> Void) {
//		log.info { () -> String? in
//			var output = "\nUrl: \(urlPath)\nRequest >>>\n"
//			if let params = params {
//				for (key,value) in params {
//					output += "\(key):\(value) \n"
//				}
//			}
//			return output
//		}
//		
//		manager.request(.POST, urlPath, parameters: params, encoding: .JSON).responseObject {
//			(req:NSURLRequest, httpUrlResponse:NSHTTPURLResponse?, responseEntity:T?, obj:AnyObject?, error:ErrorType?) in
//			if responseEntity == nil || error != nil {
//				if error != nil {
//					log.error(error.debugDescription)
//				}
//				completionHandler(mapperObject:nil, errorMessage:error.debugDescription, statusCode: "")
//			} else {			
//				let statusCode = self.reflection(responseEntity)			
//				completionHandler(mapperObject:responseEntity, errorMessage:nil, statusCode: statusCode)
//			}
//		}
//	}
//
//	//取得status code
//	func reflection(obj:Any) -> String? {
//		var statusCode:String?
//		let ref = Mirror(reflecting: obj)
//		for child in ref.children {
//			
//			guard let key = child.label else {
//				continue
//			}
//
//			let value = child.value
//			
//			if key == "status_code" {	
//				var temp = ""
//				Mirror(reflecting: value).children.forEach {
//					temp = "\($0.value)"
//					return
//				}		
//				return temp
//			}
//			
////			log.info("key:\(key),value:\(value)")
//			statusCode = reflection(value)
//		}
//		
//		return statusCode
//	}

}
