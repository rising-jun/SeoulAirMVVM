//
//  AirDataModel.swift
//  TodayAirMVVM
//
//  Created by 김동준 on 2020/10/19.
//

import Foundation
import RxSwift
import RxCodable
import CoreData
struct AirDataModel{
    
    func getAirData() -> Observable<[AirInfo]>{
        let key = "1JUx53nAuRK7R7oDRkF%2BQ3B8Aonj3YXBgV0nIQmDoNBl8yb7M4B4IprCD5mRpOuaL%2Fv6j8mgCLeXiaG08tYWaw%3D%3D"
        let urlString: String = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty?ServiceKey=\(key)&numOfRows=50&pageNo=1&sidoName=%EC%84%9C%EC%9A%B8&ver=1.3&_returnType=json"
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        return URLSession.shared.rx.data(request: urlRequest)
            .asObservable()
            .map(AirEncode.self)
            .map{$0.list}
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
        }
        

        
    }
    

