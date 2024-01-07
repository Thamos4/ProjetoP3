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
    let author: String
    let summary: String
    //let title: String
}
