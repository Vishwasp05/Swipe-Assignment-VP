//
//  NetworkManagerSingleton.swift
//  Swipe-Assignment-VP
//
//  Created by Vishwas Sharma on 11/11/24.
//

import Foundation

//class NetworkManagerSingleton {
//    
//    static let shared = NetworkManagerSingleton()
//    var statusDescription = ""
//    var showAlert = false
//    
//    private init() {}
//    
//    enum NetworkError: Error {
//        case invalidURL
//        case requestFailed(Error)
//        case invalidResponse
//        case decodingFailed
//    }
//    
//    func fetchData(with endpoint: String, completionHandler: @escaping (Result<[ProductModel], NetworkError>) -> Void) {
//        guard let endpointURL = URL(string: endpoint) else {
//            completionHandler(.failure(.invalidURL))
//            return
//        }
//        
//        var request = URLRequest(url: endpointURL)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completionHandler(.failure(.requestFailed(error)))
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                completionHandler(.failure(.invalidResponse))
//                return
//            }
//            
//            guard let data = data else {
//                completionHandler(.failure(.invalidResponse))
//                return
//            }
//            
//            do {
//                let decodedData = try JSONDecoder().decode([ProductModel].self, from: data)
//                completionHandler(.success(decodedData))
//            } catch {
//                completionHandler(.failure(.decodingFailed))
//            }
//        }
//        
//        task.resume()
//    }
//    
//    //    func uploadProductData(with endpoint: String, product: ProductModel, completion: @escaping (Bool, Error?)->(Void)) {
//    //        guard let url = URL(string: endpoint) else { return }
//    //
//    //        var request = URLRequest(url: url)
//    //        request.httpMethod = "POST"
//    //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    //
//    //        do {
//    //            let jsonData = try JSONEncoder().encode(product)
//    //            request.httpBody = jsonData
//    //
//    //            URLSession.shared.dataTask(with: request) { data, response, error in
//    //                if let error = error {
//    //                    DispatchQueue.main.async { [weak self] in
//    //                        self?.statusDescription = error.localizedDescription
//    //                        self?.showAlert = true
//    //                    }
//    //                    completion(false, error)
//    //                    return
//    //                }
//    //
//    //                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
//    //                    DispatchQueue.main.async {
//    //                        self.statusDescription = "Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)"
//    //                        self.showAlert = true
//    //                    }
//    //                    completion(false, error)
//    //                    return
//    //                }
//    //
//    //                DispatchQueue.main.async { [weak self] in
//    //                    self?.statusDescription = "Product uploaded successfully"
//    //                    self?.showAlert = true
//    //                }
//    //                completion(true, nil)
//    //
//    //            }.resume()
//    //        }catch {
//    //            self.statusDescription = error.localizedDescription
//    //            self.showAlert = true
//    //        }
//    //    }
//    
//    func uploadProductData(with endpoint: String, product: ProductModel, completion: @escaping (Bool, Error?) -> Void) {
//        guard let url = URL(string: endpoint) else {
//            completion(false, NSError(domain: "Invalid URL", code: 400, userInfo: nil))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        // Prepare the multipart form-data
//        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        var body = Data()
//        
//        // Add text fields
//        func addTextField(name: String, value: String) {
//            body.append("--\(boundary)\r\n")
//            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
//            body.append("\(value)\r\n")
//        }
//        
//        // Add the required fields to the request
//        addTextField(name: "product_name", value: product.productName)
//        addTextField(name: "product_type", value: product.productType)
//        addTextField(name: "price", value: "\(product.price)")
//        addTextField(name: "tax", value: "\(product.tax)")
//        
//        // Add the image file if available
//        if let imageData = product.uploadedImageData {
//            body.append("--\(boundary)\r\n")
//            body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpg\"\r\n")
//            body.append("Content-Type: image/jpeg\r\n\r\n")
//            body.append(imageData)
//            body.append("\r\n")
//        }
//        
//        body.append("--\(boundary)--\r\n")
//        
//        request.httpBody = body
//        
//        // Perform the network request
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    completion(false, error)
//                }
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
//                DispatchQueue.main.async {
//                    let responseError = NSError(domain: "Server Error", code: 500, userInfo: nil)
//                    completion(false, responseError)
//                }
//                return
//            }
//            
//            DispatchQueue.main.async {
//                completion(true, nil)
//            }
//        }
//        
//        task.resume()
//    }
//    
//    
//}
//
//extension Data {
//    mutating func append(_ string: String) {
//        if let data = string.data(using: .utf8) {
//            append(data)
//        }
//    }
//}



import Foundation

class NetworkManagerSingleton {
    static let shared = NetworkManagerSingleton()
    private init() {}
    
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
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
