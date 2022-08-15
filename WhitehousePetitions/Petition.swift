//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by newbie on 15.08.2022.
//

import Foundation

struct Petition: Codable {
    let title: String
    let body: String
    let signatureCount: Int
}

struct PetitionResult: Codable {
    let results: [Petition]
}
