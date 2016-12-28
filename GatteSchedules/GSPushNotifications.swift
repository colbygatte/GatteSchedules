//
//  GSPushNotifications.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/27/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

struct GSPushNotifications {
    
    static func sendNotification(teamid: String, message: String) {
        let itemTeamid = URLQueryItem(name: "teamid", value: teamid)
        let itemMessage = URLQueryItem(name: "message", value: message)
        
        var url = URLComponents(string: "http://colbygatte.com/whatever/apn.cgi")
        url?.queryItems = [itemTeamid, itemMessage]
        
        let task = URLSession.shared.dataTask(with: (url?.url)!) { data, response, error in
            if error == nil {
                print("success!")
            } else {
                print(error ?? "error occured")
            }
        }
        task.resume()
    }
}
