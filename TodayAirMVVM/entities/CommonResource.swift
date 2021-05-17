//
//  CommonResource.swift
//  TodayAirMVVM
//
//  Created by 김동준 on 2020/10/22.
//

import Foundation
import UIKit
struct CommonResource {
    public enum LocationBehaivor{
        case alreadyHave
        case getPermissionScreen
        case moveSetting
        case errorPrint
    }
}

struct StateValue{
    var backGroundColor: UIColor = UIColor.gray
    var stateText: String = ""
    var commentText: String = ""
    var emoticon = UIImage()
    
    init(grade: String){
        switch grade {
        case "1":
            backGroundColor = UIColor(displayP3Red: 0/255, green: 102/255, blue: 255/255, alpha: 1)
            stateText = "좋음"
            commentText = "오늘 공기 최고 좋아요!"
            emoticon = UIImage(named: "emoticon_1")!
            break
        case "2":
            backGroundColor = UIColor(displayP3Red: 8/255, green: 232/255, blue: 0/255, alpha: 1)
            stateText = "보통"
            commentText = "오늘 공기 보통이에요!"
            emoticon = UIImage(named: "emoticon_2")!
            break
        case "3":
            backGroundColor = UIColor(displayP3Red: 255/255, green: 187/255, blue: 0/255, alpha: 1)
            stateText = "나쁨"
            commentText = "오늘 공기 나빠요!"
            emoticon = UIImage(named: "emoticon_3")!
            break
        case "4":
            backGroundColor = UIColor(displayP3Red: 255/255, green: 51/255, blue: 51/255, alpha: 1)
            stateText = "매우 나쁨"
            commentText = "오늘 공기 최악이에요!"
            emoticon = UIImage(named: "emoticon_4")!
            break
            
        default:
            backGroundColor = UIColor.gray
        }
    }
}

struct ConvertData{
    public func convertDate(date:String) -> [String]{
        var dateArray : [String] = ["","","",""]
        var i: Int = 0
        for str in date {
            if(str == "-" || str == " "){
                i+=1
            }else{
                dateArray[i] += String(str)
            }
        }
        return dateArray
    }
    
    public func convertTime(time: String)->String{
        var timeText: String = ""
        var hmArray: [String] = ["",""]
        var i: Int = 0
        for str in time {
            if(str == ":"){
                i+=1
            }else{
                hmArray[i] += String(str)
            }
        }
        var hour: Int = Int(hmArray[0]) ?? 0
        
        if(hour > 12){
            hour -= 12
            
            if(hour < 10){
                timeText = "오후 0\(hour)시 기준"
            }else{
                timeText = "오후 \(hour)시 기준"
                }
            }else{
            timeText = "오전 \(hour)시 기준"
        }
        
        return timeText
    }
}
