//
//  JsonFileReader.swift
//  GitHubUsers
//
//  Created by Thiha the Dev on 2025/06/18.
//

import Foundation

func readJSONFromFile<T: Codable>(fileName: String) throws -> T {
    guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        throw NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found"])
    }

    let data = try Data(contentsOf: fileURL)
    let decoder = JSONDecoder()

    do {
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    } catch {
        throw error
    }
}
