//
//  OpenAIManager.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/18.
//

import Foundation
import Alamofire

class OpenAIManager {
    static let shared = OpenAIManager()
    private var apiKey: String {
            guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist"),
                  let plist = NSDictionary(contentsOfFile: filePath),
                  let value = plist["OPENAI_API_KEY"] as? String else {
                fatalError("Couldn't find key 'OPENAI_API_KEY' in 'APIKey.plist'.")
            }
            return value
        }
    
    private let apiURL = "https://api.openai.com/v1/chat/completions"

    private init() {}

    func analyzeDiaryEntry(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let headers: HTTPHeaders = [
            .authorization(bearerToken: apiKey),
            .contentType("application/json")
        ]

        let parameters: [String: Any] = [
            "model": "gpt-4-turbo",
            "messages": [
                       ["role": "system", "content": "The following prompt is an array of the person's emotion diary. You are a gentle psychological counselor speaking directly to the person. Provide concise suggestions for improvement. Respond in Traditional Chinese, structure your response in paragraphs if needed, conclude your message no more than 200 characters, and must end the whole prompt content in a Chinese period punctuation. The value of category refers to the index of \(buttonTitles)"],
                       ["role": "user", "content": prompt]
                   ],
            "max_tokens": 500
        ]

        AF.request(apiURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }
                do {
                    let result = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                    if let text = result.choices.first?.message.content {
                                    completion(.success(text))
                                } else {
            
                                }
                } catch {
                    print("Error decoding response: \(error)")
                }
            case .failure(let error):
                print("Networking error: \(error.localizedDescription)")
            }
        }

    }
}
