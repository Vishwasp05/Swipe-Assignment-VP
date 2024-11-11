//
//  NetworkManagerSingleton.swift
//  Swipe-Assignment-VP
//
//  Created by Vishwas Sharma on 11/11/24.
//





import Foundation
import Network

class NetworkManagerSingleton {
    /// Singleton Creational Design Pattern allows us to access the same, single instance throught the app without creating new ones :)
    static let shared = NetworkManagerSingleton()
    private init() {}
    
    var isConnected = false
    /// This Enumeration helps us make clear dictinctions, and allows us to account for various cases that may happen during a network call
    enum NetworkError: LocalizedError {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
        case decodingFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL provided"
            case .requestFailed(let error):
                return "Request failed: \(error.localizedDescription)"
            case .invalidResponse:
                return "Server returned invalid response code:"
            case .decodingFailed:
                return "Failed to decode server response"
            }
        }
    }
    
    /// Simple function to check if Internet is available or not
    /// - Returns: Returns a Bool value, `True` for "Yes Internet is available" and `False` for "No Internet connection found
    func isInternetAvailable() {
            let monitor = NWPathMonitor()
            
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    self.isConnected = true
                } else {
                    self.isConnected = false
                }
            }
            
            let queue = DispatchQueue(label: "InternetMonitorQueue")
            monitor.start(queue: queue)
        }
    /// Function tasked with performing the actual GET request using URLSession.
    /// - Parameters:
    ///   - endpoint: Base URL where the function is supposed to make the request to. Supplied in the form of a String. ^^
    ///   - completionHandler: CompletionHandler to help us out with dealing with the Async nature of a network call
        func fetchData(with endpoint: String, completionHandler: @escaping (Result<[ProductModel], NetworkError>) -> Void) {
            guard let endpointURL = URL(string: endpoint) else {
                completionHandler(.failure(.invalidURL))
                return
            }
    
            var request = URLRequest(url: endpointURL)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completionHandler(.failure(.requestFailed(error)))
                    return
                }
    
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completionHandler(.failure(.invalidResponse))
                    return
                }
    
                guard let data = data else {
                    completionHandler(.failure(.invalidResponse))
                    return
                }
    
                do {
                    let decodedData = try JSONDecoder().decode([ProductModel].self, from: data)
                    completionHandler(.success(decodedData))
                } catch {
                    completionHandler(.failure(.decodingFailed))
                }
            }
    
            task.resume()
        }
    
    /// Function tasked with making a POST request to the remote server, and uploading a new Product entry
    /// - Parameters:
    ///   - endpoint: Base URL where the function is supposed to make the request to. Supplied in the form of a String. ^^
    ///   - product: Product object that stores the information captured from the user.
    ///   - completion: CompletionHandler to help us out with dealing with the Async nature of a network call
    func uploadProductData(with endpoint: String, product: ProductModel, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        func appendFormField(named name: String, value: String) {
            body.append("\r\n--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.append(value)
        }
        appendFormField(named: "product_name", value: product.productName)
        appendFormField(named: "product_type", value: product.productType)
        appendFormField(named: "price", value: String(format: "%.2f", product.price))
        appendFormField(named: "tax", value: String(format: "%.2f", product.tax))

        if let imageData = product.uploadedImageData {
            body.append("\r\n--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
        }

        body.append("\r\n--\(boundary)--\r\n")
        
        request.httpBody = body

        print("Request URL: \(url)")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let bodyString = String(data: body, encoding: .utf8) {
            print("Request Body: \(bodyString)")
        }
 
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }

                print("Response Status Code: \(httpResponse.statusCode)")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
            
                    print("Response Body: \(responseString)")
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                completion(.success(()))
            }
        }
        
        task.resume()
    }
}

extension Data {
    /// Auxilary function to append string
    /// - Parameter string: the string that has to be appended
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
