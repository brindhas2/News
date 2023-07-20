//
//  NewsListViewModel.swift
//  RoboSoftNews
//
//  Created by Brindha S on 18/07/23.
//

import Foundation

class NewsListViewModel: NSObject {
    
    private var apiService : NetworkManager!
   
    var articles:[NewsDataModel] = [NewsDataModel]()
    var selectedItem:NewsDataModel?
    override init() {
        super.init()
        self.apiService =  NetworkManager.sharedApiManager
    }
    
    func getArticles(_ articles: @escaping (_ list: [NewsDataModel]?, _ error: ErrorDetail?) -> Void) {
        self.apiService.call(type: RequestBuilder.news) {(news: News?, message: ErrorDetail?) in
            if (news != nil) && message == nil {
                /*var list = [NewsDataModel]()
                for article in news?.articles {
                    let data =  NewsDataModel(title: news.title, content: news.content, newsDescription: news.description, author: news.author ?? "", publishedDate: news.publishedAt, imageUrl: news.urlToImage ?? "")
                }*/
                let list = news?.articles.map { news in
                   
                    NewsDataModel(news.title, news.content, news.description,  (news.author ?? ""), RSDateFormatter.dateFromString( news.publishedAt, DateFormatterString.kUTCDateFormat), false, (news.urlToImage ?? ""))
                    
                }
                articles(list, nil)
            } else {
                articles(nil, message)
            }
        }
        
    }
}

class NewsDataModel {
    var title: String
    var content: String
    var newsDescription: String
    var author: String
    var publishedDate: Date
    var isFavorite: Bool = false
    var imageUrl: String
    init(_ title: String, _ content: String, _ newsDescription: String, _ author: String, _ publishedDate: Date, _ isFavorite: Bool = false, _ imageUrl: String) {
        self.title = title
        self.content = content
        self.newsDescription = newsDescription
        self.author = author
        
        self.publishedDate = publishedDate
        self.isFavorite = isFavorite
        self.imageUrl = imageUrl
    }
   
}
