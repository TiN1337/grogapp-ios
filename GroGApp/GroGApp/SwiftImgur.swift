//
//  SwiftImgur.swift
//  GroGApp
//
//  Created by Justin Daigle on 3/28/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//
// Swift port of https://github.com/perlmunger/IMGURUploader/blob/master/IMGURUploader/MLIMGURUploader.m

// numbers in comments correspond to the matching line number from the original source file, as of March 28, 2015

import Foundation

class SwiftImgur {
    class func uploadImage(imageData:NSData) -> String {
        var clientID = "9d4bfb76c6cd73b"
        
        var urlString:String = "https://api.imgur.com/3/upload.json"
        var request = NSMutableURLRequest()
        request.URL = NSURL(string: urlString)
        request.HTTPMethod = "POST"
        
        var requestBody = NSMutableData()
        
        var boundary = "---------------------------0983745982375409872438752038475287"
        
        var contentType = "multipart/form-data; boundary=\(boundary)"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        request.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        // 51
        var extendedBoundary = "--\(boundary)\r\n"
        requestBody.appendData(extendedBoundary.dataUsingEncoding(NSUTF8StringEncoding)!)
        var contentDisposition = "Content-Disposition: attachment; name=\"image\"; filename=\".tiff\"\r\n"
        requestBody.appendData(contentDisposition.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // 54
        var secondContentType = "Content-Type: application/octet-stream\r\n\r\n"
        requestBody.appendData(secondContentType.dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBody.appendData(NSData(data: imageData))
        var closingString = "\r\n"
        requestBody.appendData(closingString.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // 74
        var someMoreData = "--\(boundary)--\r\n"
        requestBody.appendData(someMoreData.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = requestBody
        
        // 78
        // making this synchronous, to fit with the rest of the app
        var res:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var err:AutoreleasingUnsafeMutablePointer<NSError?> = nil
        var responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: res, error: err) as NSData!
        // var responseDictionary:NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var jsonJSON = JSON(data: responseData, options: nil, error: nil)
        println(jsonJSON)
        var responseString = jsonJSON["data"]["link"].stringValue
        responseString = responseString.stringByReplacingOccurrencesOfString("\\", withString: "", options: nil, range: nil)
        return responseString
    }
}