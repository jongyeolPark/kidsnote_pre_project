//
//  EbookInfoViewController.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import Foundation
import SnapKit
import Then
import ReactorKit

class EbookInfoViewReactor: Reactor {
    
    var initialState: State
    
    init(info: VolumeInfo) {
        initialState = State(title: info.title,
                             description: info.description)
    }
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var title: String?
        var description: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
