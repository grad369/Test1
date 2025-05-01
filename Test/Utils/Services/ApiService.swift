//
//  ApiService.swift
//  Test
//
//  Created by vaskov on 29.04.2025.
//
import Foundation


class ApiService {
    @UserDefault(key: "com.Test.ApiService.lastAccessRequest", defaultValue: "https://rickandmortyapi.com/api/character")
    private var nextRequest: String
    
    @UserDefault(key: "com.Test.ApiService.allDownload", defaultValue: false)
    private var allDownload: Bool
        
    func next<T: Decodable>(url: String? = nil, type: T.Type) async throws -> [T] {
        guard !allDownload else { throw TestError.allDownload }
        guard let url = URL(string: url ?? nextRequest) else { throw TestError.wrongUrl }
        
        guard let (data, response) = try? await URLSession.shared.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TestError.badServer
        }
        
        guard let parsedResponse = try? JSONDecoder().decode(Response<T>.self, from: data) else { throw TestError.badParser }
        
        if let next = parsedResponse.info.next {
            nextRequest = next
        } else {
            allDownload = true
        }
        
        return parsedResponse.results
    }
    
    func clear() {
        nextRequest = "https://rickandmortyapi.com/api/character"
        allDownload = false
    }
}
