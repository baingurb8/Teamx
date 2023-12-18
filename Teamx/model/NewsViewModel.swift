//  NewsViewModel.swift
//  Teamx
//
//  Created by Parth Manchanda on 2023-12-09.
//

import Foundation

class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    
    func fetchNews(query: String) {
        let apiKey = "456dacdefbd84cdfad12fa35be090804"
        let endpoint =
        "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=456dacdefbd84cdfad12fa35be090804"

        
        if let url = URL(string: endpoint) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.articles = result.articles
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else if let error = error {
                    print("Error fetching data: \(error)")
                }
            }.resume()
        }
    }
    
    func healthTips(){
        
    }

}
