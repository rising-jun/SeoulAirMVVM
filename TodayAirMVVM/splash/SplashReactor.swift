//
//  SplashReactor.swift
//  TodayAirMVVM
//
//  Created by 김동준 on 2020/10/19.
//

import Foundation
import ReactorKit
import CoreData
class SplashReactor: Reactor{
    private let airDataModel = AirDataModel()
    private let disposeBag = DisposeBag()
    private var airArray: [AirInfo] = []
    
    enum Action {
        case requestGetData(add: String)
        case checkLocPermission(status: CLAuthorizationStatus)
        case requestMyLocation(findlocation: CLLocation)
    }
    
    enum Mutation{
        case conbeyData(AirInfo)
        case getLocPermission(CommonResource.LocationBehaivor)
        case getMyLocation(String)
    }
    
    struct State{
        var airInfo = AirInfo()
        var behaivor: CommonResource.LocationBehaivor = .getPermissionScreen
        var address: String = ""
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        let address = PublishSubject<String>()
        let airInfo = PublishSubject<AirInfo>()
        switch action {
        case let .requestGetData(add):
            airDataModel.getAirData().bind { (airArray) in
                for e in airArray{
                    if e.stationName == add{
                        airInfo.on(.next(e))
                    }
                }
            }.disposed(by: disposeBag)
            
            return airInfo.map{Mutation.conbeyData($0)}
        case let .checkLocPermission(status):
            return Observable.just(Mutation.getLocPermission(checkStatus(status: status)))
        case let .requestMyLocation(findlocation):
            
            let locale = Locale(identifier: "Ko-kr")
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(findlocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                if let add = placeMark?.addressDictionary!["City"] as? String{
                    address.on(.next(add))
                }else{
                    address.on(.next("default"))
                }
            })
            return address.map{
                return Mutation.getMyLocation($0)
            }
            
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .conbeyData(airInfo):
            newState.airInfo = airInfo
        case let .getLocPermission(behavior):
            newState.behaivor = behavior
        case let .getMyLocation(address):
            newState.address = address
        }
        return newState
    }
    
    
    func checkStatus(status: CLAuthorizationStatus) -> CommonResource.LocationBehaivor{
        var behavior: CommonResource.LocationBehaivor
        
        switch status {
        case .authorizedWhenInUse:
            behavior = .alreadyHave
            break
        case .notDetermined:
            behavior = .getPermissionScreen
            break
        case .restricted:
            behavior = .moveSetting
            break
        case .denied:
            behavior = .moveSetting
            break
        case .authorizedAlways:
            behavior = .alreadyHave
            break
        @unknown default:
            behavior = .errorPrint
        }
        print(behavior)
        return behavior
    }
}
