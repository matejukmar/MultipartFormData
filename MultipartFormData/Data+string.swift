//
//  NSMutableData+string.swift
//  MultipartFormData
//
//  Created by Matej on 20/07/16.
//  Copyright © 2016 ZEN+. All rights reserved.
//

import Foundation


extension Data {
	mutating func append(string: String) {
		let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)!
		append(data)
	}
}
