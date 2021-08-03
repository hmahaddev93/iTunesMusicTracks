//
//  MovieService.swift
//  
//
//  Created by Khatib Mahad H. on 8/3/21.
//

import Foundation

enum iTunesAPI  {
    static let host: String = "itunes.apple.com"
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
    enum EndPoints {
        static let search = "/search"
    }
}

protocol iTunesService_Protocol {
    func search(query: String, completion: @escaping (Result<[MusicItem], Error>) -> Void)
}

class iTunesService: iTunesService_Protocol {
    
    private let httpManager: HTTPManager
    private let jsonDecoder: JSONDecoder
    
    init(httpManager: HTTPManager = HTTPManager.shared) {
        self.httpManager = httpManager
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = iTunesAPI.dateFormat
        self.jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    struct iTunesResponseBody: Codable {
        let results: [MusicItem]
    }
    
    func search(query: String, completion: @escaping (Result<[MusicItem], Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = iTunesAPI.host
        urlComponents.path = iTunesAPI.EndPoints.search

        let queryItemQuery = URLQueryItem(name: "term", value: query)
        urlComponents.queryItems = [queryItemQuery]
        
        httpManager.get(urlString: urlComponents.url!.absoluteString) { result in
                switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            case .success(let data):
                completion(Result(catching: { try self.jsonDecoder.decode(iTunesResponseBody.self, from: data).results }))
            }
        }
    }
    
    
}

