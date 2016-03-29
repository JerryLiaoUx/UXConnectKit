//
//  MemberModel.swift
//  ASAP
//
//  Created by uitox_macbook on 2015/10/23.
//  Copyright © 2015年 uitox. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class MemberModel 
{
	var guid: String {
		if let memberData = memberData {
			return memberData.guid
		}		
		return ""
	}
	
	var email: String {
		if let memberData = memberData {
			return memberData.email
		}		
		return ""
	}
	
	var phone: String {
		if let memberData = memberData {
			return memberData.phone
		}		
		return ""
	}
	
	var encodeGuid: String {
		if let memberData = memberData {
			return memberData.encodeGuid
		}		
		return ""
	}
	
	private var memberData: MemberData? {
		get {
			let realm = try! Realm()

			let results = realm.objects(MemberData)
			
			if results.count == 0 {
				return nil
			}
			
			return results[0]
		}
	}
	
	var deviceToken: String {
		get {
			let realm = try! Realm()

			let results = realm.objects(DeviceData)
			
			if results.count == 0 {
				return ""
			}
			
			return results[0].deviceToken
		}
		set {
			let realm = try! Realm()

			let deviceData = DeviceData()
			deviceData.deviceToken = newValue
			realm.beginWrite()
			realm.create(DeviceData.self, value: deviceData, update: false)
			try! realm.commitWrite()
		}
	}
	
	var oauthCode: String {
		get {
			let realm = try! Realm()

			let results = realm.objects(OauthCode)
			
			if results.count == 0 {
				return ""
			}
			
			return results[results.count - 1].oauthCode
		}
		set {
			let realm = try! Realm()

			let oauthCode = OauthCode()
			oauthCode.oauthCode = newValue
			realm.beginWrite()
			realm.create(OauthCode.self, value: oauthCode, update: false)
			try! realm.commitWrite()
		}
	}

	var oauthAccessToken: String {
		get {
			let realm = try! Realm()

			let results = realm.objects(OauthAccessToken)
			
			if results.count == 0 {
				return "defaultAccessToken"
			}
			
			return results[results.count - 1].accessToken
		}
		set {
			let realm = try! Realm()

			let oauthAccessToken = OauthAccessToken()
			oauthAccessToken.accessToken = newValue
			realm.beginWrite()
			realm.create(OauthAccessToken.self, value: oauthAccessToken, update: false)
			try! realm.commitWrite()
		}
	}

	var oauthRefreshToken: String {
		get {
			let realm = try! Realm()

			let results = realm.objects(OauthRefreshToken)
			
			if results.count == 0 {
				return ""
			}
			
			return results[results.count - 1].refreshToken
		}
		set {
			let realm = try! Realm()

			let oauthRefreshToken = OauthRefreshToken()
			oauthRefreshToken.refreshToken = newValue
			realm.beginWrite()
			realm.create(OauthRefreshToken.self, value: oauthRefreshToken, update: false)
			try! realm.commitWrite()
		}
	}
	
	func deleteMemberData() {
		let realm = try! Realm()

		let results = realm.objects(MemberData)
		if results.count > 0 {
			try! realm.write {
				realm.delete(results[0])
			}
		}
	}
	
	func insertMemberDataIntoDisk(memberData: MemberData) {
		let realm = try! Realm()

		realm.beginWrite()
		realm.create(MemberData.self, value: memberData, update: false)
		try! realm.commitWrite()
	}
}

// 登入會員資料
public class MemberData : Object, Mappable
{
	/*  data/MEM_GUID           GUID
	data/MEM_EMAIL          Email
	data/MEM_LOGIN_PHONE    Phone
	data/MEM_STATUS         狀態
	data/WS_SEQ             平台編號
	data/ENCODE_GUID        加密GUID
	data/MEM_INVOICE        Invoice */
	
	public dynamic var guid:        String = ""
	public dynamic var email:       String = ""
	public dynamic var phone:       String = ""
	public dynamic var status:      String = ""
	public dynamic var wsSeq:       String = ""
	public dynamic var encodeGuid:  String = ""
	public dynamic var invoice:     String = ""
	
	required public convenience init?(_ map: Map) {
		self.init()
	}
	
	public func mapping(map: Map) {
		guid        <- map["MEM_GUID"]
		email       <- map["MEM_EMAIL"]
		phone       <- map["MEM_LOGIN_PHONE"]
		status      <- map["MEM_STATUS"]
		wsSeq       <- map["WS_SEQ"]
		encodeGuid  <- map["ENCODE_GUID"]
		invoice     <- map["MEM_INVOICE"]
	}
}

// 登入會員資料
public class DeviceData : Object
{
	public dynamic var deviceToken: String = ""
	
}
