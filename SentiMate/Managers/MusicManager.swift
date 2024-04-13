//
//  MusicManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/13.
//

import Foundation

class MusicManager {
    
    var songs: [StoreItem] = []
    
    func getAPIData(for emotion: Emotion){
        //api網址
        let value = ""
        guard let encodeUrlString = value.addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed) else {
            return
        }
        
        let urlString: String = "https://itunes.apple.com/search?term=\(encodeUrlString)&media=music&country=tw"
        
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { data, response , error in
                if let data = data {
                    //解析Json格式
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                        self.songs = searchResponse.results
                        print(self.songs)
                    } catch {
                        print("Error during fetch: \(error)")
                    }
                } else {
                    print("Error during fetch: \(error)")
                }
            }.resume()
        }
    }
}
