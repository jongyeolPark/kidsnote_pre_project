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
        
        initialState = State(thumbnail: book.volumeInfo?.imageLinks?.thumbnail,
                             title: book.volumeInfo?.title,
                             authors: book.volumeInfo?.authors?.joined(separator: ","),
                             ebookPageCount: ebookPageCount,
                             description: description,
                             publishInfo: publishInfo
        )
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var thumbnail: String?
        var title: String?
        var authors: String?
        var ebookPageCount: String?
        var description: String?
        var publishInfo: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
