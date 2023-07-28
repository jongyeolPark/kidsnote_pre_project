//
//  SearchQuery.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import Foundation

class SearchQuery {

    static let maxResults = 40
    
    enum Download: String, CaseIterable {
        case epub
    }
    
    enum Filter: String, CaseIterable {
        case partial
        case full
        case free_ebooks = "free-ebooks"
        case paid_ebooks = "paid-ebooks"
    }
    
    enum OrderBy: String, CaseIterable {
        case relevance
        case newest
    }
    
    enum PrintType: String, CaseIterable {
        case all
        case books
        case magazines
    }
    
    enum Projection: String, CaseIterable {
        case full
        case lite
    }
}
