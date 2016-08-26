//
//  NSMutableData+string.swift
//  MultipartFormRequst
//
//  Created by Matej on 20/07/16.
//  Copyright © 2016 ZEN+. All rights reserved.
//

import Foundation


extension NSMutableData {
	func appendString(string: String) {
		let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
		appendData(data!)
	}
}