//
//  DefaultAPICLient.swift
//  BergmannTest
//
//  Created by Никита Лужбин on 21.02.2024.
//

import Foundation

enum RequestMethod: String {
    case get    = "GET"
    case post   = "POST"
    case update = "UPDATE"
    case delete = "DELETE"
}

final class DefaultAPICLient {

    // MARK: - Private Properties
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)

    // MARK: - Public Methods

    @discardableResult
    func fetchDecodable<T: Decodable>(request: URLRequest,
                                      completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask? {
        
        let task = session.dataTask(with: request) { data, response, error in

            if let error = error as? NSError {
                completion(.failure(ErrorModel.custom(title: "Error", message: error.localizedDescription)))
            }
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                completion(.failure(ErrorModel.badResponse))
                return
            }

            if let data = data {
             
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(ErrorModel.badResponse))
                    }
                    
                case 403:
                    completion(.failure(ErrorModel.authWrong))
                    
                case URLError.Code.notConnectedToInternet.rawValue:
                    completion(.failure(ErrorModel.noConnection))
                    
                default:
                    completion(.failure(ErrorModel.somethingWentWrong))
                }
            } else {
                completion(.failure(ErrorModel.badResponse))
            }
        }
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()) {
            task.resume()
        }
        
        return task
    }
}
