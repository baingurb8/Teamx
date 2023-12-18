//
//  SearchBar.swift
//  Teamx
//
//  Created by Parth Manchanda on 2023-12-09.
//


import SwiftUI
struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search News", text: $searchText)
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal, 10)

            Button(action: {
                // Perform search action here
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
            }
            .padding(.trailing, 10)
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""))
    }
}

struct NewsListView: View {
    @State private var searchText: String = ""
    @ObservedObject private var newsViewModel = NewsViewModel()

    var body: some View {
        VStack {
            SearchBar(searchText: $searchText)

            Button(action: {
                withAnimation {
                    newsViewModel.fetchNews(query: searchText)
                }
            }) {
                Text("Search News")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            List(newsViewModel.articles) { article in
                VStack(alignment: .leading) {
                    Text(article.title)
                        .font(.headline)
                    Text(article.description ?? "Description not available")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Link("Read more", destination: URL(string: article.url)!)
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 8)
            }
            .transition(.opacity)
        }
        .padding()
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView()
    }
}
