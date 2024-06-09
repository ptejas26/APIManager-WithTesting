//
//  ServiceManager.swift
//  APIManager
//
//  Created by Tejas Patelia on 14/01/23.
//

import Foundation
import UIKit


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
}

protocol NetworkEngine {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    func performRequest(url: URL, completionHandler: @escaping Handler)
}

extension URLSession: NetworkEngine {
    typealias Handler = NetworkEngine.Handler
    
    func performRequest(url: URL, completionHandler: @escaping Handler) {
        let task = dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }
}


class DataLoader {
    enum Result {
        case error(Error)
        case success(Data)
    }
    
    private let networkEngine: NetworkEngine
    
    init(networkEngine: NetworkEngine = URLSession.shared) {
        self.networkEngine = networkEngine
    }
    
    func load(from url: URL, completionHandler: @escaping (Result) -> Void) {
        
//        let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
//            if let error {
//                completionHandler(.error(error))
//            } else if let data {
//                completionHandler(.success(data))
//            }
//        }
//        task.resume()
        
        networkEngine.performRequest(url: url) { data, urlResponse, error in
            if let error {
                completionHandler(.error(error))
            } else if let data {
                completionHandler(.success(data))
            }
        }
    }
}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataLoader = DataLoader()
        dataLoader.load(from: URL(string: "https://picsum.photos/200")!) { result in
            switch result {
            case .error(let error):
                print(error.localizedDescription)
            case .success(let data):
                print(String(data: data, encoding: .utf8))
            }
        }
        
    }
}
