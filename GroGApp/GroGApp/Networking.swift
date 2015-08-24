//
//  Networking.swift
//  GroGApp
//
//  Created by Justin Daigle on 2/25/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import Foundation


class Networking {
    
    /*
    This function is a lot more complicated than what I was hoping for.
    What it does: Takes a JSON-formatted string (assuming it has a bunch of "pretty" formated newlines in it that need to be stripped out).
    Appends that onto the API URL. Escapes it into "acceptable" URL format.
    Converts that to an NSURL. Sends it to the server. Gets a response (as NSData).
    Converts that NSData to a string so it can be manipulated like a string. Removes quote padding, escaping, and other stuff to make it back into "pure" JSON.
    Turns it back into NSData, since that's what SwiftyJSON works with.
    FINALLY turns it into a SwiftyJSON JSON object and returns it.
    */
    
    class func MakeTransaction(reqDataJson:JSON) -> JSON {
        // based on an example here
        // http://blogs.shephertz.com/2014/06/20/making-http-requests-in-swift/
        
        
        // prepare request url
        var reqData = reqDataJson.rawString()!
        
        // THIS right here took about five hours to figure out... then only a couple of minutes to actually fix
        // apparently stuff like JSON data has to be passed in a query string, or common characters just give trouble
        // let apiUrlString = "https://home.justindaigle.com:6707/api/grog?content="
        let apiUrlString = "https://api.getgrog.com:6707/api/grog?content="
        
        var reqDataString = reqData.stringByReplacingOccurrencesOfString("\n", withString: "") // clean newlines out of json
        
        let requestUrlString = apiUrlString + reqDataString
        var escapedUrlString = requestUrlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) // NSURL is very picky about escaping
        

        println(escapedUrlString)
        
        // prepare the NSURL and other request parts
        var requestUrl = NSURL(string:escapedUrlString!)
        var req = NSURLRequest(URL: requestUrl!)
        var res:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var err:AutoreleasingUnsafeMutablePointer<NSError?> = nil
        
        // send the request; get a response
        var responseData = NSURLConnection.sendSynchronousRequest(req, returningResponse: res, error: err) as NSData!
        var interimString = NSString(data:responseData, encoding:NSUTF8StringEncoding)! as String // we need NSData, but we have to tweak the string first
        
        println(interimString) // debug
        
        println("first char of interim string:")
        println(interimString.substringToIndex(advance(interimString.startIndex, 1)))
        
        if (interimString.substringToIndex(advance(interimString.startIndex, 1)) == "\"") {
            println("old api in use")
            // server pads the entire JSON with quotes; remove these
            interimString = interimString.substringFromIndex(advance(interimString.startIndex, 1))
            interimString = interimString.substringToIndex(advance(interimString.endIndex, -1))
            
            // quotes are escaped coming from the server; unescape them
            interimString = interimString.stringByReplacingOccurrencesOfString("\\\"", withString: "\"") // this is confusing
            interimString = interimString.stringByReplacingOccurrencesOfString("\\\\\"", withString: "\\\"")
            // interimString = interimString.stringByReplacingOccurrencesOfString("\\", withString: "")
        }
        else {
            println("new api in use")
        }
        
        println(interimString) // debug
        
        // turn it BACK into NSData, since that's what SwiftyJSON expects
        let almostFinalResponseData = (interimString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        // return a JSON
        let finalResponseJSON = JSON(data: almostFinalResponseData!)
        return finalResponseJSON
    }
}