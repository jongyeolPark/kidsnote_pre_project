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
        case loadMore
        
        case itemSelected(IndexPath)
        case modelSelected(Book)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setQuery(String)
        case setSearchList(Books, Bool = false)
        case setCurrentPage(Int)

        case setSelectedIndexPath(IndexPath?)
        case setModelSelected(Book?)
    }
    
    struct State {
        var loading: Bool = false
        var query: String = ""
        
        var books: [Book] = []
        var sections: [SearchBookSectionModel] = []
        var currentPage: Int = 1
        var totalItems: Int = 0
        
        var selectedIndexPath: IndexPath?
        var selectedModel: Book?
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return action.debug("action")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .searchQuery(query):
            return bookService.execute(Books.self, token: .searchList(query: query, pageNum: 1))
                .flatMap {
                    Observable.just(Mutation.setSearchList($0, false))
                        .concat(Observable<Mutation>.just(.setLoading(false)))
                        .concat(Observable<Mutation>.just(.setCurrentPage(1)))
                        .concat(Observable<Mutation>.just(.setQuery(query)))
                }
                .startWith(.setLoading(true))
        case .loadMore:
            guard !currentState.loading else {
                return .empty()
            }
            
            guard currentState.books.count < currentState.totalItems else {
                return .empty()
            }

            let nextPage = currentState.currentPage + 1
            let query = currentState.query
            
            return bookService.execute(Books.self, token: .searchList(query: query, pageNum: nextPage))
                .catchAndReturn(Books(kind: "-1", totalItems: 0, items: nil))
                .flatMap {
                    Observable.just(Mutation.setSearchList($0, true))
                        .concat(Observable<Mutation>.just(.setLoading(false)))
                        .concat(Observable<Mutation>.just(.setCurrentPage(nextPage)))
                }
                .startWith(.setLoading(true))
        case let .itemSelected(indexPath):
            return Observable.concat([
                Observable.just(Mutation.setSelectedIndexPath(indexPath)),
                Observable.just(Mutation.setSelectedIndexPath(nil))
            ])
        case let .modelSelected(model):
            return Observable.concat([
                Observable.just(Mutation.setModelSelected(model)),
                Observable.just(Mutation.setModelSelected(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(loading):
            state.loading = loading
        case let .setQuery(query):
            state.query = query
        case let .setSearchList(result, isAppending):
            state.totalItems = result.totalItems
            let list = result.items ?? []
            if isAppending {
                state.books.append(contentsOf: list)
            } else {
                state.books = list
            }

            if !state.books.isEmpty {
                let items = state.books.map { TableViewCellSections.bookCell(SearchListBookCellReactor(state: $0)) }
                state.sections = [SearchBookSectionModel(model: (), items: items)]
            } else {
                state.sections = [SearchBookSectionModel(model: (), items: [TableViewCellSections.emptyCell])]
            }
        case let .setCurrentPage(currentPage):
            state.currentPage = currentPage
        case let .setSelectedIndexPath(indexPath):
            state.selectedIndexPath = indexPath
        case let .setModelSelected(model):
            state.selectedModel = model
        }
        return state
    }
}
