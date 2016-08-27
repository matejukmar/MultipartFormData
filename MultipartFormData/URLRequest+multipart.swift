//
//  NSMutbleURLRequest+multipart.swift
//  MultipartFormData
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

public struct FormMultipartData: MultipartParam {
	let fileName: String
	let data: Data
	let mimetype: String
}


public extension URLRequest {

	public init(urlString: String, multipartParams: [String : MultipartParam]) {
		self.init(url: URL(string: urlString)!, multipartParams: multipartParams)
	}

	
	public init(url: URL, multipartParams: [String : MultipartParam]) {
		self.init(url: url)
		
		let boundary = NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
		
		var bodyData = Data()
		
		for (key, value) in multipartParams {
			
			if let mdata = value as? FormMultipartData {
				
				bodyData.append(string: "--\(boundary)\r\n")
				bodyData.append(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(mdata.fileName)\"\r\n")
				bodyData.append(string: "Content-Type: \(mdata.mimetype)\r\n\r\n")
				bodyData.append(mdata.data)
				bodyData.append(string: "\r\n")
				
			} else {
				bodyData.append(string: "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)\r\n")
			}
		}
		
		bodyData.append(string: "--\(boundary)--\r\n")


		self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		self.setValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
		
		self.httpMethod = "POST"
		self.httpBody = bodyData
		
	}
	
	
}

