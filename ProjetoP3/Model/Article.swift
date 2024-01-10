//
//  Article.swift
//  ProjetoP3
//
//  Created by user243107 on 1/4/24.
//

import Foundation

struct Article: Identifiable, Codable {
    let id: String
    let trackId: String
    let title: String
    let author: String
    let summary: String
//    let day: String
//    let hours: String
//    let pdfPath: String
}
