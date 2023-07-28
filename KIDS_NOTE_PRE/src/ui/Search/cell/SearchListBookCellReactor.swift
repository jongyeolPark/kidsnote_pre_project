//
//  SearchListBookCellReactor.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import ReactorKit
import RxDataSources

typealias SearchBookSectionModel = SectionModel<Void, TableViewCellSections>

enum TableViewCellSections {
    case bookCell(SearchListBookCellReactor)
    case emptyCell
}

class SearchListBookCellReactor: Reactor {
    
    typealias Action = NoAction
    
    let initialState: Book
        
    init(state: Book) {
        self.initialState = state
    }
}
