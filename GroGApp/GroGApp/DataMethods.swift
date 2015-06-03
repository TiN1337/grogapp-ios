//
//  DataMethods.swift
//  GroGApp
//
//  Created by Justin Daigle on 2/7/15.
//  Copyright (c) 2015 Justin Daigle (.com). All rights reserved.
//

import Foundation

class DataMethods {
    class func ValidateUser(username:String, _ password:String) -> Bool
    {
        var json:JSON = ["type":"validateuser", "username":username, "password":password]
        
        var jsonResponse = Networking.MakeTransaction(json)
        
        if let success = jsonResponse["success"].bool {
            if (success) {
                println("true")
                return true
            }
            else {
                println("false")
                return false
            }
        }
        else {
            println("false and couldn't get a value") // I think I fixed this and it shouldn't come up anymore
            return false
        }
    }
    
    class func ChangePassword(username:String, _ password:String, _ newPass:String) -> Bool {
        var json:JSON = ["type":"changepassword", "username":username, "password":password, "content":newPass]
        var resp = Networking.MakeTransaction(json)
        
        if let success = resp["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func ResetPassword(code:String) -> Bool {
        var json:JSON = ["type":"resetpassword", "content":code]
        var resp = Networking.MakeTransaction(json)
        
        if let success = resp["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func ReqPasswordReset(username:String) -> Bool {
        var json:JSON = ["type":"requestpasswordreset", "username":username]
        var resp = Networking.MakeTransaction(json)
        
        if let success = resp["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func CreateAccount(username:String, _ email:String, _ password:String) -> Bool {
        var json:JSON = ["type":"signup", "username":username, "email":email, "password":password]
        var resp = Networking.MakeTransaction(json)
        
        if let success = resp["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func DeleteFriend(username:String, _ password:String, _ requsername:String) -> Bool {
        var json:JSON = ["type":"deletefriend", "username":username, "password":password, "requsername":requsername]
        
        var resp = Networking.MakeTransaction(json)
        
        if let success = resp["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func GetFriends(username:String, _ password:String) -> JSON {
        var json:JSON = ["type":"getfriends", "username":username, "password":password]
        
        var resp = Networking.MakeTransaction(json)
        
        return resp
    }
    
    class func AcceptFriendRequest(username:String, _ password:String, _ requsername:String) -> Bool {
        var json:JSON = ["type":"acceptfriendrequest", "username":username, "password":password, "requsername":requsername]
        
        var resp = Networking.MakeTransaction(json)
        
        if let success = resp["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func DenyFriendRequest(username:String, _ password:String, _ requsername:String) -> Bool {
        var json:JSON = ["type":"denyfriendrequest", "username":username, "password":password, "requsername":requsername]
        
        var resp = Networking.MakeTransaction(json)
        
        if let success = resp["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func GetFriendRequests(username:String, _ password:String) -> JSON {
        var json:JSON = ["type":"getfriendrequests", "username":username, "password":password]
        
        var resp = Networking.MakeTransaction(json)
        
        return resp
    }
    
    class func DeleteUserFromGroup(username:String, _ password:String, _ id:Int, _ userToDelete:String) -> Bool {
        var json:JSON = ["type":"deleteuserfromgroup", "username":username, "password":password, "group":id, "requsername":userToDelete]
        
        var response = Networking.MakeTransaction(json)
        
        if let success = response["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func AddUserToGroup(username:String, _ password:String, _ id:Int, _ userToAdd:String) -> Bool {
        var json:JSON = ["type":"addusertogroup", "username":username, "password":password, "group":id, "requsername":userToAdd]
        
        var response = Networking.MakeTransaction(json)
        
        if let success = response["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func DeleteGroup(username:String, _ password:String, _ id:Int) -> Bool {
        var json:JSON = ["type":"deletegroup", "username":username, "password":password, "group":id]
        
        var response = Networking.MakeTransaction(json)
        
        if let success = response["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func CreateGroup(username:String, _ password:String, _ name:String) -> Bool {
        var json:JSON = ["type":"creategroup", "username":username, "password":password, "content":name]
        
        var response = Networking.MakeTransaction(json)
        
        if let success = response["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func GetGroups(username:String, _ password:String) -> JSON {
        var json:JSON = ["type":"getownedgroups", "username":username, "password":password]
        
        var response = Networking.MakeTransaction(json)
        
        return response
    }
    
    class func UnfollowUser(username:String, _ password:String, _ user:String) -> Bool {
        var json:JSON = ["type":"unfollowuser", "username":username, "password":password, "requsername":user]
        var jsonResponse = Networking.MakeTransaction(json)
        if let success = jsonResponse["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func FollowUser(username:String, _ password:String, _ user:String) -> Bool {
        var json:JSON = ["type":"followuser", "username":username, "password":password, "requsername":user]
        var jsonResponse = Networking.MakeTransaction(json)
        if let success = jsonResponse["success"].bool {
            if (success) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    class func GetProfile(username:String) -> JSON {
        var json:JSON = ["type":"getprofile", "requsername":username]
        
        var jsonResponse = Networking.MakeTransaction(json)
        
        return jsonResponse
    }
    
    class func GetStatus(username:String, _ password:String, _ statusId:Int) ->JSON {
        var json:JSON = ["type":"getstatus", "username":username, "password":password, "reqstatus":statusId]
        
        var jsonResponse = Networking.MakeTransaction(json)
        
        return jsonResponse
    }
    
    class func GetTimeline(username:String, _ password:String, _ min:Int, _ max:Int) -> JSON {
        var json:JSON = ["type":"gettimeline", "username":username, "password":password, "rmin":min, "rmax":max]
        
        var jsonResponse = Networking.MakeTransaction(json)
        
        return jsonResponse
    }
    
    class func GetMentions(username:String, _ password:String) -> JSON {
        var json:JSON = ["type":"getmentions", "username":username, "password":password]
        var jsonResponse = Networking.MakeTransaction(json);
        return jsonResponse
    }
    
    class func PostStatus(username:String, _ password:String, _ content:String, _ group:Int) {
        println("beginning call to PostStatus")
        var json:JSON = ["type":"post", "username":username, "password":password, "content":content, "group":group]
        println("json: \(json.stringValue)")
        var jsonResponse = Networking.MakeTransaction(json)
    }
}

