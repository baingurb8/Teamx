//
//  NewsArticle.swift
//  Teamx
//
//  Created by Parth Manchanda on 2023-12-09.
//

struct NewsArticle: Codable, Identifiable {
    var id: String { url }
    let title: String
    let description: String?
    let url: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try? container.decode(String.self, forKey: .description)
        url = try container.decode(String.self, forKey: .url)
    }
}

struct NewsResponse: Codable {
    let articles: [NewsArticle]
}

