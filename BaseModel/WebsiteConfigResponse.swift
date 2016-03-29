//
//  WebsiteConfigResponse.swift
//  ASAP
//
//  Created by uitox_macbook on 2015/11/19.
//  Copyright © 2015年 uitox. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

// 平台資料回應
public class WebsiteConfigResponse: BaseResponse
{
	/*
	{
	"WC_SEQ": "AWC000001",
	"LOGO_PATH": "http://img05-tw1.uitoxbeta.com/A/deploy/AWC000001/website/1421050588_AWC000001.jpg",
	"ICON_PATH": "http://img05-tw1.uitoxbeta.com/A/deploy/AWC000001/website/AWC000001_1440745589.ico",
	"DELIVERY_NO_CHARGE": "490",
	"DELIVERY_SHIP_FEE": "80",
	"CVS_NO_CHARGE": "490",
	"CVS_SHIP_FEE": "80",
	"MENU_ROOT" = A14954
	}
	*/
	
	public var wcSeq:			 String?
	public var logoPath:		 String?
	public var iconPath:		 String?
	public var deliveryNoCharge: String?
	public var deliveryShipFee:  String?
	public var cvsNoCharge:		 String?
	public var cvsShipFee:		 String?
	public var menuRoot:		 String?
		
	public override func mapping(map: Map) {
		super.mapping(map)
		
		wcSeq				<- map["WC_SEQ"]
		logoPath			<- map["LOGO_PATH"]
		iconPath			<- map["ICON_PATH"]
		deliveryNoCharge	<- map["DELIVERY_NO_CHARGE"]
		deliveryShipFee     <- map["DELIVERY_SHIP_FEE"]
		cvsNoCharge			<- map["CVS_NO_CHARGE"]
		cvsShipFee			<- map["CVS_SHIP_FEE"]
		menuRoot			<- map["MENU_ROOT"]
	}
}

public class WebsiteConfigData: Object
{
	public dynamic var wcSeq:			 String? = nil
	public dynamic var logoPath:		 String? = nil
	public dynamic var iconPath:		 String? = nil
	public dynamic var deliveryNoCharge: String? = nil
	public dynamic var deliveryShipFee:  String? = nil
	public dynamic var cvsNoCharge:		 String? = nil
	public dynamic var cvsShipFee:		 String? = nil
	public dynamic var menuRoot:		 String? = nil
}

