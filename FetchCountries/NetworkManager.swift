//
//  NetworkManager.swift
//  FetchCountries
//
//  Created by Monali on 2/27/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        let urlString = "https:/gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                completion(.success(countries))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
