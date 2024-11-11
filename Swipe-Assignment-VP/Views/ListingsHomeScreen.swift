//
//  ContentView.swift
//  Swipe-Assignment-VP
//
//  Created by Vishwas Sharma on 10/11/24.
//

import SwiftUI
import SwiftData
import Network

struct ListingsHomeScreen: View {
    @State private var searchText: String = ""
    @ObservedObject var vm: ProductViewModel
    @State private var sortingOrder: SortingOption = .normal
    @State private var isNavigatingToNewProductEntry = false
    @State private var isConnected = true
    
    
    @Environment(\.modelContext) var context
    
    @Query(sort: \ProductModel.price) var products: [ProductModel]
    
    /// This computed property helps us with filtering options based on various scenarios
    var currentArray: [ProductModel] {
        if searchText.isEmpty {
            switch sortingOrder {
                case .highToLow:
                    return vm.products.sorted { $0.price > $1.price }
                case .lowToHigh:
                    return vm.products.sorted { $0.price < $1.price }
                case .alphabetical:
                    return vm.products.sorted { $0.productName < $1.productName }
                case .images:
                    return vm.products.filter {
                        guard let image = $0.image else { return false }
                        return !image.isEmpty
                    }
                case .normal:
                    return vm.products
            }
        } else {
            return vm.products.filter {
                $0.productName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Title
                    Text("Swipe")
                        .font(.system(size: 50))
                        .bold()
                        .underline()
                        .italic()
                        .foregroundStyle(.black)
                    
                    // Custom Search Field
                    HStack {
                        ZStack {
                            GenericTFView(tfTitle: "Search Products", imageName: "magnifyingglass", textBinding: $searchText, needsFiltering: false, callout: "", keyboardType: .default)
                        }
//                        .padding(.bottom, 25)
                        
                        Menu {
                            Button {
                                sortingOrder = .highToLow
                            } label: {
                                Label("High to Low", systemImage: "arrow.down.right")
                            }
                            Button {
                                sortingOrder = .lowToHigh
                            } label: {
                                Label("Low to High", systemImage: "arrow.up.right")
                            }
                            Button {
                                sortingOrder = .alphabetical
                            } label: {
                                Label("Alphabetical", systemImage: "pencil.and.list.clipboard")
                            }
                            Button {
                                sortingOrder = .normal
                            } label: {
                                Label("All Products", systemImage: "arrowshape.turn.up.backward")
                            }
                            
                            Button {
                                sortingOrder = .images
                            } label: {
                                Label("Images", systemImage: "photo")
                            }

                        } label: {
                            ZStack(alignment: .center) {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(.gray.opacity(0.3))
                                    .frame(width: 60, height: 62)
                                
                                Image(systemName: "line.3.horizontal.decrease")
                                    .foregroundStyle(.black)
                            }
                            .padding(.top, 9)
                        }
                        
                    }
                    .frame(width: 60, height: 55)
                    
                    
                    // Listings
                    let columns = [
                        GridItem(.flexible())
                    ]
                    
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(!products.isEmpty && !isConnected ? products : currentArray) { product in
                                IndividualProductCardView(product: product, vm: vm)
                                    .padding(.top, 15)
                            }
                        }
                    }
                    .overlay(
                        Button(action: {
                            
                            isNavigatingToNewProductEntry = true
                        }) {
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.black)
                                .overlay(
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                )
                        }
                            .padding()
                        , alignment: .bottomTrailing
                    )
                    .frame(width: 390)
                    
                    
                    Spacer()
                    
                }
                .ignoresSafeArea(edges: .bottom)
                
                
                
                
            }
            .onAppear() {
                isInternetAvailable()
            }
            .navigationDestination(isPresented: $isNavigatingToNewProductEntry) {
                NewProductEntryView(isConnected: $isConnected)
            }
            .task {
                
                if products.isEmpty {
                    for product in vm.products {
                        
                        let exists = products.contains { existingProduct in
                            existingProduct.productName == product.productName
                            
                        }
                        
                        if !exists {
                            context.insert(product)
                        }
                        
                        try? context.save()
                    }
                }
            }
        }
    }

    
    /// Simple function to check internet connectivity. 😉
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
        
    
}
enum SortingOption {
    case highToLow
    case lowToHigh
    case alphabetical
    case normal
    case images
}

#Preview {
    ListingsHomeScreen(vm: ProductViewModel())
}
