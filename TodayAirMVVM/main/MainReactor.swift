//
//  MainReactor.swift
//  TodayAirMVVM
//
//  Created by 김동준 on 2020/10/22.
//

import Foundation
import ReactorKit

class MainReactor: Reactor{
    enum Action {
        
    }
    
    enum Mutation{
    }
    
    struct State{
        
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
            
        
        }
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
    
}
