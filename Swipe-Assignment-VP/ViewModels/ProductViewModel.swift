//
//  ProductViewModel.swift
//  Swipe-Assignment-VP
//
//  Created by Vishwas Sharma on 11/11/24.
//

import SwiftUI

class ProductViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var errorDescription: String?
    @Published var isLoading: Bool = false
    
    let baseEndpoint = "https://app.getswipe.in/api/public/get"
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        isLoading = true
        
        NetworkManagerSingleton.shared.fetchData(with: baseEndpoint) { productArray in
            
            DispatchQueue.main.async{ [weak self] in
                self?.isLoading = false
                switch productArray {
                    case .success(let success):
                        self?.products = success
                    case .failure(let failure):
                        self?.errorDescription = failure.localizedDescription
                }
            }

        }
    }
    
    func returnErrorDescription(_ error: NetworkManagerSingleton.NetworkError) -> String? {
        switch error {
            case .invalidURL:
                return "Invalid URL, Please check the URL"
            case .requestFailed(let error):
                return "Failed to make request, \(error.localizedDescription)"
            case .invalidResponse:
                return "Invalid Response. Please check the response"
            case .decodingFailed:
                return "Failed to decode the data"
        }
    }
    
}
