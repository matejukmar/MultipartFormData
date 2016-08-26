//
//  NSMutbleURLRequest+multipart.swift
//  MultipartFormRequst
//
//  Created by Matej on 13/07/16.
//  Copyright © 2016 ZEN+. All rights reserved.
//

import Foundation


public protocol MultipartParam {}

extension String : MultipartParam {}
extension Int : MultipartParam {}
extension Float : MultipartParam {}
extension Double : MultipartParam {}

struct MultipartData: MultipartParam {
	let fileName: String
	let data: NSData
	let mimetype: String
}


public extension NSMutableURLRequest {

	public convenience init(urlString: String, multipartParams: [String : MultipartParam]) {
		self.init(url: NSURL(string: urlString)!, multipartParams: multipartParams)
	}

	public convenience init(url: NSURL, multipartParams: [String : MultipartParam]) {
		self.init(URL: url)
		
		let boundary = NSUUID().UUIDString.stringByReplacingOccurrencesOfString("-", withString: "")
		
		let bodyData = NSMutableData()
		
		for (key, value) in multipartParams {
			
			if let mdata = value as? MultipartData {
				
				bodyData.appendString("--\(boundary)\r\n")
				bodyData.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(mdata.fileName)\"\r\n")
				bodyData.appendString("Content-Type: \(mdata.mimetype)\r\n\r\n")
				
				bodyData.appendData(mdata.data)
				bodyData.appendString("\r\n")
				
			} else {
				bodyData.appendString("--\(boundary)\r\nContent-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)\r\n")
			}
		}
		
		bodyData.appendString("--\(boundary)--\r\n")


		self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		self.setValue("\(bodyData.length)", forHTTPHeaderField: "Content-Length")
		
		self.HTTPMethod = "POST"
		self.HTTPBody = bodyData
		
	}
	
	
}

