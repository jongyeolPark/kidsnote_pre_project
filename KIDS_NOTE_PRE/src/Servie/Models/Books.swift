//
//  Books.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import Foundation

struct Books: Codable {
    let kind: String
    let totalItems: Int
    let items: [Book]?
}

struct Book: Codable {
    
    let id: String
    let kind: String
    let etag: String
    let selfLink: String
    
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    let accessInfo: AccessInfo?
    let searchInfo: SearchInfo?
}

// MARK: -

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let readingModes: ReadingMode?
    let pageCount: Int?
    let printType: String?
    let categories: [String]?
    let maturityRating: String?
    let allowAnonLogging: Bool?
    let contentVersion: String?
    let panelizationSummary: PanelizationSummary?
    let imageLinks: ImageLink?
    let language: String?
    let previewLink: String?
    let infoLink: String?
    let canonicalVolumeLink: String?
}

struct SaleInfo: Codable {
    let country: String?
    let saleability: String?
    let isEbook: Bool?
    let listPrice: Price?
    let retailPrice: Price?
    let buyLink: String?
    let offers: [Offer]?
    
    struct Price: Codable {
        let amount: Int?
        let currencyCode: String?
    }
}

struct AccessInfo: Codable {
    let country: String?
    let viewability: String?
    let embeddable: Bool?
    let publicDomain: Bool?
    let textToSpeechPermission: String?
    let epub: Available?
    let pdf: Available?
    let webReaderLink: String?
    let accessViewStatus: String?
    let quoteSharingAllowed: Bool?
}

struct SearchInfo: Codable {
    let textSnippet: String?
}
// MARK: -

struct IndustryIdentifier: Codable {
    let type: String?
    let identifier: String?
}

struct ReadingMode: Codable {
    let text: Bool?
    let image: Bool?
}

struct PanelizationSummary: Codable {
    let containsEpubBubbles: Bool?
    let containsImageBubbles: Bool?
}

struct ImageLink: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

struct Available: Codable {
    let isAvailable: Bool?
    let acsTokenLink: String?
}

struct Offer: Codable {
    let finskyOfferType: Int?
    let listPrice: Price?
    let retailPrice: Price?
    
    struct Price: Codable {
        let amountInMicros: Int?
        let currencyCode: String?
    }
}
