//
//  SearchViewReactor.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import Foundation
import ReactorKit
import FirebaseAuth
import GoogleSignIn
import RxRelay

class SearchViewReactor: Reactor {
    
    var initialState: State
    
    private let bookService: BookServiceProtocol
    
    init(bookService: BookServiceProtocol, user: User) {
        self.bookService = bookService
        self.initialState = State()
    }
    
    enum Action {
        case searchQuery(String)
        case fetchPaging
        case cellSelected(IndexPath)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setSearchList(String, Int, Books)
        case setSelectedIndexPath(IndexPath?)
    }
    
    struct State {
        var loading: Bool = false
        var selectedIndexPath: IndexPath?
        var sections: [SearchBookSectionModel] = []
        
        var query: String = ""
        var pageNum: Int = 1
        var totalItems: Int = 0
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return action.debug("action")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .searchQuery(query):
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                bookService.execute(Books.self, token: .searchList(query: query, pageNum: 1)).flatMap {
                    Observable.just(Mutation.setSearchList(query, 1, $0))
                }
            ])
        case .fetchPaging:
            let query = currentState.query
            var pageNum = currentState.pageNum
            let totalItems = currentState.totalItems
            print("fetchPaging = \(pageNum) / \(currentState.loading)")
            if currentState.loading, SearchQuery.maxResults * pageNum > totalItems {
                return Observable.empty()
            } else {
                pageNum += 1
                return Observable.concat([
                    Observable.just(Mutation.setLoading(true)),
                    bookService.execute(Books.self, token: .searchList(query: query, pageNum: pageNum + 1)).flatMap {
                        Observable.just(Mutation.setSearchList(query, pageNum, $0))
                    }
                ])
            }
        case let .cellSelected(indexPath):
            return Observable.concat([
                Observable.just(Mutation.setSelectedIndexPath(indexPath)),
                Observable.just(Mutation.setSelectedIndexPath(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(loading):
            state.loading = loading
        case let .setSearchList(query, pageNum, result):
            state.query = query
            state.pageNum = pageNum
            state.totalItems = result.totalItems
            state.loading = false
            
            print("################")
            print("query = \(query) / pageNum = \(pageNum) / totalItems = \(result.totalItems)")
            print("################")
            
            if let books = result.items, !books.isEmpty {
                let items = books.map { TableViewCellSections.bookCell(SearchListBookCellReactor(state: $0)) }
                if pageNum == 1 {
                    state.sections = [SearchBookSectionModel(model: (), items: items)]
                } else {
                    if let before = state.sections.first?.items {
                        state.sections = [SearchBookSectionModel(model: (), items: before + items)]
                    }
                }
            } else {
                state.sections = [SearchBookSectionModel(model: (), items: [TableViewCellSections.emptyCell])]
            }
        case let .setSelectedIndexPath(indexPath):
            state.selectedIndexPath = indexPath
        }
        return state
    }
}
