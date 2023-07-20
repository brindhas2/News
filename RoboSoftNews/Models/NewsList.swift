//
//  NewsList.swift
//  RoboSoftNews
//
//  Created by Brindha S on 18/07/23.
//
import Foundation

// MARK: - Welcome
struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsData]
}

// MARK: - Article
struct NewsData: Codable {
    let source: Source
    let author: String?
    let title, description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}

