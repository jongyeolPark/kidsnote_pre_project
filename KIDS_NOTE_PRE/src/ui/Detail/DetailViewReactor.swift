//
//  DetailViewReactor.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import Foundation
import ReactorKit

class DetailViewReactor: Reactor {
    
    var initialState: State
    
    init(book: Book) {
        let ebook: Bool = book.saleInfo?.isEbook ?? false
        let pageCount = book.volumeInfo?.pageCount
        var ebookPageCount: String = ""
        if ebook {
            ebookPageCount = "eBook"
        }
        if let pageCount = pageCount?.decimalComma("페이지") {
            if !ebookPageCount.isEmpty {
                ebookPageCount = "\(ebookPageCount) · \(pageCount)"
            } else {
                ebookPageCount = pageCount
            }
        }
        
        let description = book.volumeInfo?.description
        
        var publishInfo: String?
        if let publisher = book.volumeInfo?.publisher, let publishedDate = book.volumeInfo?.publishedDate?.koDateFormat() {
            publishInfo = "\(publishedDate) · \(publisher)"
        }
        
        initialState = State(book: book,
                             thumbnail: book.volumeInfo?.imageLinks?.thumbnail,
                             title: book.volumeInfo?.title,
                             authors: book.volumeInfo?.authors?.joined(separator: ","),
                             ebookPageCount: ebookPageCount,
                             description: description,
                             publishInfo: publishInfo
        )
    }
    
    enum Action {
        case share
        case ebookInfo
        case readSample
        case toggleWishList
    }
    
    enum Mutation {
        case setShareData([Any])
        case setEbookInfo(VolumeInfo?)
        case setISBN(String)
        case setWishList(Book, Bool)
    }
    
    struct State {
        var book: Book
        var thumbnail: String?
        var title: String?
        var authors: String?
        var ebookPageCount: String?
        var description: String?
        var publishInfo: String?
        
        @Pulse var shareData: [Any]? = nil
        @Pulse var ebookInfo: VolumeInfo? = nil
        @Pulse var ISBN: String = ""
        @Pulse var wishButtonText: String = "위시리스트에 추가"
        var isFavorite: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .share:
            if let shareData = currentState.book.saleInfo?.buyLink {
                return .just(.setShareData([shareData]))
            } else {
                return .empty()
            }
        case .readSample:
            if let isbn = currentState.book.volumeInfo?.industryIdentifiers?.first?.identifier {
                return .just(.setISBN(isbn))
            } else {
                return .empty()
            }
        case .ebookInfo:
            return .just(.setEbookInfo(currentState.book.volumeInfo))
        case .toggleWishList:
            return .just(.setWishList(currentState.book, !currentState.isFavorite))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setShareData(let shareData):
            state.shareData = shareData
        case .setISBN(let isbn):
            state.ISBN = isbn
        case .setEbookInfo(let info):
            state.ebookInfo = info
        case let .setWishList(_, isFavorite):
            state.isFavorite = isFavorite
            if isFavorite {
                state.wishButtonText = "위시리스트에서 삭제"
            } else {
                state.wishButtonText = "위시리스트에 추가"
            }
        }
        return state
    }
}
