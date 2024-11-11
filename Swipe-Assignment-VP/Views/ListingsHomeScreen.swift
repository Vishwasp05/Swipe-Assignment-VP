//
//  ContentView.swift
//  Swipe-Assignment-VP
//
//  Created by Vishwas Sharma on 10/11/24.
//

//import SwiftUI
//import SwiftData
//
//struct ListingsHomeScreen: View {
//    @State private var searchText: String = ""
//    @ObservedObject var vm: ProductViewModel
//    @State private var sortingOrder: SortingOption = .normal
//    var body: some View {
//        ZStack {
//            VStack {
//                // Title
//                Text("Swipe")
//                    .font(.system(size: 50))
//                    .bold()
//                    .underline()
//                    .italic()
//                    .foregroundStyle(.black)
//                
//                // Search Field
//                HStack{
//                    GenericTFView(tfTitle: "Search Products", imageName: "magnifyingglass", textBinding: $searchText, needsFiltering: false, callout: "" , keyboardType: .default )
//                    
//          
//                    Menu {
//                        Button {
//                            sortingOrder = .highToLow
//                        } label: {
//                            Label("High to Low", systemImage: "arrow.down.right")
//                            
//                        }
//                        Button {
//                            sortingOrder = .lowToHigh
//                        } label: {
//                            Label("Low to High", systemImage: "arrow.up.right")
//                        }
//                        Button {
//                            sortingOrder = .alphabetical
//                        } label: {
//                            Label("Alphabetical", systemImage: "pencil.and.list.clipboard")
//                        }
//                        
//                        Button {
//                            sortingOrder = .normal
//                        } label: {
//                            Label("Normal", systemImage: "arrowshape.turn.up.backward")
//                        }
//                    } label: {
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 20)
//                                .foregroundStyle(.gray.opacity(0.3))
//                            
//                            Image(systemName: "line.3.horizontal.decrease")
//                                .foregroundStyle(.black)
//                        }
//                        
//                        
//                    }
//                    .frame(width: 60, height: 55)
//                }
//                
//                // Listings
//                let columns = [
//                    GridItem(.flexible()),
//                    
//                ]
//                
//                ScrollView{
//                    LazyVGrid(columns: columns) {
//                        ForEach(/*vm.products*/currentArray) { product in
//                            IndividualProductCardView(product: product, vm: vm)
//                                .padding(.top, 15)
//                        }
//                    }
//                }
//                .overlay(
//                    Button(action: {
//                        print("New entry tapped")
//                    }) {
//                        Circle()
//                            .frame(width: 60, height: 60)
//                            .foregroundColor(.black)
//                            .overlay(
//                                Image(systemName: "plus")
//                                    .foregroundColor(.white)
//                            )
//                    }
//                        .padding()
//                    , alignment: .bottomTrailing
//                )
//                
//                .frame(width: 390)
//                
//                
//                Spacer()
//            }
//            .searchable(text: $searchText)
//            .ignoresSafeArea(edges: .bottom)
//            
//            
//            
//            var currentArray: [ProductModel] {
//                
//
//                if searchText.isEmpty {
//                    switch sortingOrder {
//                        case .highToLow:
//                            return vm.products.sorted { $0.price > $1.price}
//                        case .lowToHigh:
//                            return vm.products.sorted {$0.price < $1.price}
//                        case .alphabetical:
//                            return vm.products.sorted {$0.productName < $1.productName}
//                        case .normal:
//                            return vm.products
//                    }
//                } else {
//                    return vm.products.filter({
//                        $0.productName.lowercased().contains(searchText.lowercased())
//                    })
//                }
//                
//                                
//                
//            }
//            
//            
//            
//            
//            
//        }
//    }
//    
//}
//
//enum SortingOption {
//    case highToLow
//    case lowToHigh
//    case alphabetical
//    case normal
//}
//
//#Preview {
//    ListingsHomeScreen(vm: ProductViewModel())
//}


import SwiftUI
import SwiftData

struct ListingsHomeScreen: View {
    @State private var searchText: String = ""
    @ObservedObject var vm: ProductViewModel
    @State private var sortingOrder: SortingOption = .normal
    @State private var isNavigatingToNewProductEntry = false // State for triggering navigation
    
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
                    
                    // Custom Search Field (no default search bar from SwiftUI)
                    HStack {
                        GenericTFView(tfTitle: "Search Products", imageName: "magnifyingglass", textBinding: $searchText, needsFiltering: false, callout: "", keyboardType: .default)
                        
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
                                Label("Normal", systemImage: "arrowshape.turn.up.backward")
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(.gray.opacity(0.3))
                                
                                Image(systemName: "line.3.horizontal.decrease")
                                    .foregroundStyle(.black)
                            }
                        }
                        .frame(width: 60, height: 55)
                    }
                    
                    // Listings
                    let columns = [
                        GridItem(.flexible())
                    ]
                    
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(currentArray) { product in
                                IndividualProductCardView(product: product, vm: vm)
                                    .padding(.top, 15)
                            }
                        }
                    }
                    .overlay(
                        Button(action: {
                            // Trigger the navigation
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
                
                
                
                var currentArray: [ProductModel] {
                    if searchText.isEmpty {
                        switch sortingOrder {
                            case .highToLow:
                                return vm.products.sorted { $0.price > $1.price }
                            case .lowToHigh:
                                return vm.products.sorted { $0.price < $1.price }
                            case .alphabetical:
                                return vm.products.sorted { $0.productName < $1.productName }
                            case .normal:
                                return vm.products
                        }
                    } else {
                        return vm.products.filter {
                            $0.productName.lowercased().contains(searchText.lowercased())
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $isNavigatingToNewProductEntry) {
                NewProductEntryView() // Navigate to this view when the flag is true
            }
        }
    }
}

enum SortingOption {
    case highToLow
    case lowToHigh
    case alphabetical
    case normal
}

#Preview {
    ListingsHomeScreen(vm: ProductViewModel())
}
