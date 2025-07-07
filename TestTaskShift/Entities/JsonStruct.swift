//
//  JsonStruct.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

struct Book: Decodable {
    let title: String
    let author: String
}


struct Books: Decodable {
    let status: String
    let code: Int
    let total: Int
    let data: [Book]
}
