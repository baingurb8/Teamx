//
//  HealthHelper.swift
//  Teamx
//
//  Created by Arshdeep Singh on 2023-12-11.
//

//API-Key
// 05424e1c919f413cae3af259d1066407

import Foundation

class HealthHelper: ObservableObject{
    
    @Published var healthTips: [Health] = []
    
    init() {
        //fetchHealthTips()
         healthTips = [
            
            Health(id: 1, title: "Drink Plenty of Water", discription: "Staying hydrated is crucial for overall health."),
            Health(id: 2,title: "Get Enough Sleep", discription: "Adequate sleep is essential for physical and mental well-being."),
            Health(id: 3,title: "Eat a Balanced Diet", discription: "Include a variety of nutritious foods in your meals."),
            Health(id: 4,title: "Warm-Up Well ", discription: "Warm up well before any game makes your muscles stronger."),
            Health(id: 5,title: "Evaluate Injuries", discription: "Checks for any signs of injuries to address them properly. ")
        ]
    }
    
    func fetchHealthTips() {
        //            guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=05424e1c919f413cae3af259d1066407")
        //            else {
        //                return
        //            }
        //
        //            URLSession.shared.dataTask(with: url) { data, response, error in
        //                guard let data = data else { return }
        //
        //                    do {
        //                        let result = try JSONDecoder().decode(NewsAPIResponse.self, from: data)
        //                        let tips = result.articles.map { article in
        //                            Health(id: article.url, title: article.title, discription: article.description ?? "")
        //                        }
        //                        DispatchQueue.main.async {
        //                            self.healthTips = tips
        //                        }
        //                        } catch {
        //                            print("Error decoding JSON: \(error)")
        //                        }
        //                }.resume()
        //        }
    }
}


