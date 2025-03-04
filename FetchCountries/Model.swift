//
//  Model.swift
//  FetchCountries
//
//  Created by Monali on 2/27/25.
//

import Foundation
struct Country : Codable {
    let name: String
    let region: String
    let code: String
    let capital: String
}
