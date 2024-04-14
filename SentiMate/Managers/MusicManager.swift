//
//  MusicManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/13.
//

import Foundation

class MusicManager {
    
    var songs: [StoreItem] = []
    
    func getAPIData(for emotion: String, completion: @escaping (Result<[StoreItem], Error>) -> Void) {

        let artist: String
            switch emotion {
            case "Fear":
                artist = fearSinger.randomElement() ?? ""
            case "Sad":
                artist = sadSinger.randomElement() ?? ""
            case "Neutral":
                artist = neutralSinger.randomElement() ?? ""
            case "Happy":
                artist = happySinger.randomElement() ?? ""
            case "Surprise":
                artist = surpriseSinger.randomElement() ?? ""
            case "Angry":
                artist = angrySinger.randomElement() ?? ""
                // ... handle other cases for 'sad', 'neutral', 'happy', 'surprise'
            default:
                artist = disgustSinger.randomElement() ?? ""
            }

        let value = artist
        guard let encodeUrlString = value.addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed) else {
            return
        }
        
        let urlString: String = "https://itunes.apple.com/search?term=\(encodeUrlString)&media=music&country=tw"
        
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                        if let error = error {
                            // Pass the error to the completion handler
                            completion(.failure(error))
                            return
                        }
                        
                        guard let data = data else {
                            // No data error
                            completion(.failure(URLError(.badServerResponse)))
                            return
                        }
                        
                        do {
                            let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                            // Pass the fetched songs back using the completion handler
                            completion(.success(searchResponse.results))
                        } catch {
                            // Pass the error to the completion handler
                            completion(.failure(error))
                        }
                    }.resume()
        }
    }
}


