//
//  MyApp.swift
//  ASAP
//
//  Created by uitox_macbook on 2015/10/23.
//  Copyright © 2015年 uitox. All rights reserved.
//

import Foundation
import XCGLogger
import UIKit

public class MyApp
{

	static let sharedMember: MemberModel = {
		return MemberModel()
	}()
//
//	static let sharedShoppingCart: ShoppingCartModel = {
//		return ShoppingCartModel()
//	}()

	public static let sharedWebsiteConfigModel: WebsiteConfigModel = {
		return WebsiteConfigModel()
	}()
	
//    static let sharedSearchKey: SearchModel = {
//        return SearchModel()
//    }()
}

//記錄log
public let log: XCGLogger = {
	// Setup XCGLogger
	let log = XCGLogger.defaultInstance()
	log.xcodeColorsEnabled = false // Or set the XcodeColors environment variable in your scheme to YES
	log.xcodeColors = [
		.Verbose: .lightGrey,
		.Debug: .darkGrey,
		.Info: .darkGreen,
		.Warning: .orange,
		.Error: XCGLogger.XcodeColor(fg: UIColor.redColor(), bg: UIColor.whiteColor()), // Optionally use a UIColor
		.Severe: XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
	]
	
	#if DEBUG || BETA // Set via Build Settings, under Other Swift Flags
		log.setup(.Debug, showThreadName: false, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
	#else
		log.setup(.Verbose, showThreadName: false, showLogLevel: false, showFileNames: false, showLineNumbers: false, writeToFile: nil)
	#endif
	
	return log
}()
