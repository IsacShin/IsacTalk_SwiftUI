//
//  NotificationModel.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/27.
//

import Foundation

struct NotificationModel: Codable {
    var to: String?
    var notification: FcmNotification = FcmNotification()
    var data: FcmData = FcmData()
    var content_available: Bool?
    var mutable_content: Bool?
}

struct FcmNotification: Codable {
    var title: String?
    var body: String?
    var badge: Int?
}

struct FcmData: Codable {
    var title: String?
    var body: String?
    var badge: Int?
}

extension NotificationModel {
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        
        dictionary["to"] = to
        dictionary["notification"] = notification.toDictionary()
        dictionary["data"] = data.toDictionary()
        dictionary["content_available"] = content_available
        dictionary["mutable_content"] = mutable_content
        
        return dictionary
    }
}

extension FcmNotification {
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        
        dictionary["title"] = title
        dictionary["body"] = body
        dictionary["badge"] = badge
        
        return dictionary
    }
}

extension FcmData {
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        
        dictionary["title"] = title
        dictionary["body"] = body
        dictionary["badge"] = badge
        
        return dictionary
    }
}
