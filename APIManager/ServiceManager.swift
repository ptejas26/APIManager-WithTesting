//
//  ServiceManager.swift
//  APIManager
//
//  Created by Tejas Patelia on 14/01/23.
//

import Foundation


/// Requset type allows all types of requests
enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

public typealias ResultType<T> = Result<T.Type,Error>
public let customError = NSError(domain: "com.dip.launchListing", code: 202020, userInfo: nil)

public typealias CompletionBlockModel = ((Result<(name:String, type: String),Error>) -> Void)
public typealias CompletionBlock<T:Codable> = (T?,Error?) -> ()
public typealias CompletionBlockWithResult<T:Codable> = ((Result<T,Error>) -> Void)

public class ServiceManager: NSObject {
    static let sharedInstance = ServiceManager()

    private override init() {}

    public class func getMethod<T:Codable>(url: String, model T: T.Type, completionHandler: @escaping CompletionBlockWithResult<T>) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        guard
            let url = URL(string: url)
        else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.get.rawValue

        let urlSession = URLSession(configuration: config).dataTask(with: request) { (data, urlResponse, error) in

            if error == nil {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let parseData = try decoder.decode(T.self, from: data)
                        completionHandler(.success(parseData))

                    } catch let error {
                        print(error)
                    }
                }

            } else {
                completionHandler(.failure(error!))
            }
        }
        urlSession.resume()
    }

    public class func postMethod<T:Codable>(url: String, httpBodyDictionay: [String: Any]? = nil, model T: T.Type, completionHandler: @escaping CompletionBlockWithResult<T>) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        guard
            let url = URL(string: url)
        else {return}

        var request = URLRequest(url: url)
        guard
            let dictionary = httpBodyDictionay,
            let httpBody = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return
        }
        request.httpMethod = RequestType.post.rawValue
        //Add headers here
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody

        let urlSession = URLSession(configuration: config).dataTask(with: request) { (data, urlResponse, error) in

            if let data = data, error == nil {
                let decoder = JSONDecoder()
                let parseData = try? decoder.decode(T.self, from: data)
                if let parsedData  = parseData {
                    completionHandler(.success(parsedData))
                } else {
                    completionHandler(.failure(error ?? customError))
                }
            } else {
                completionHandler(.failure(error ?? customError))
            }
        }
        urlSession.resume()
    }

//   public func getMethod(url: String, completionHandler: @escaping CompletionBlockModel) {
//        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = 10
//        config.timeoutIntervalForResource = 10
//        let url = URL(string: url)!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = RequestType.get.rawValue
//
//        let urlSession = URLSession(configuration: config).dataTask(with: request) { (data, urlResponse, error) in
//
//            if error == nil {
//                if let data = data {
//
//                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
//                        guard let name = json["name"] as? String, let type = json["type"] as? String else {return}
//                        completionHandler(.success((name: name, type: type)))
//                    } else {
//                        completionHandler(.failure(error!))
//                    }
//                } else {
//                    completionHandler(.failure(error!))
//                }
//
//            } else {
//                completionHandler(.failure(customError))
//            }
//        }
//        urlSession.resume()
//    }
}
