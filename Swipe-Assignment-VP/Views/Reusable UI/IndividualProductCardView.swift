//
//  IndividualProductCardView.swift
//  Swipe-Assignment-VP
//
//  Created by Vishwas Sharma on 10/11/24.
//

import SwiftUI

struct IndividualProductCardView: View {
    let product: ProductModel
    @ObservedObject var vm: ProductViewModel
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.gray.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(.gray)
                    
                )
                .shadow(color: .gray, radius: 8)
            
            
            
            VStack(alignment: .center){
                HStack{
                    Spacer()
                    
                    Button {
                        //TODO: This controls the `favourite` btn action
                        processFavourite(product: product)
                        print("fav tapped")
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width: 50)
                                .foregroundStyle(.white)
                                .overlay(Circle().stroke(Color.black.opacity(0.4), lineWidth: 2))
                            
                            Image(systemName: "heart")
                                .foregroundStyle(.red.opacity(0.8))
                        }
                    }
                    
                }
                .padding(.trailing, 10)
                .padding(.top, 10)
                
                Spacer()

                AsyncImage(url: URL(string: product.image ?? "https://vx-erp-product-images.s3.ap-south-1.amazonaws.com/9_1619635829_Farm_FreshToAvatar_Logo-01.png")) { img in
                    img
                        .resizable()
                        .scaledToFit()
                    
                } placeholder: {
                    
                    Image(.farm)
                        .resizable()
                        .scaledToFit()
                }
                
                
//                MARK: Note for Vamsi (and others) Below is the code for showing a progress bar but its a bit slow therefore for demonstration purposes I'll be using the above code. But this will be a part of the submission for you to evaluate.
                
//                AsyncImage(url: URL(string: product.image ?? "https://vx-erp-product-images.s3.ap-south-1.amazonaws.com/9_1619635829_Farm_FreshToAvatar_Logo-01.png")) { phase in
//                    switch phase {
//                        case .empty:
//                            ProgressView()
//                                .progressViewStyle(.circular)
//                                .frame(width: 50, height: 50)
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .scaledToFit()
//                        case .failure(let error):
//                            
//                            Image(.farm)
//                                                    .resizable()
//                                                    .scaledToFit()
//                        @unknown default:
//                            EmptyView()
//                    }
//                    
//                }
                
                

                Spacer()
                HStack{
                    VStack(alignment: .leading){
                        Text("Name: "+product.productName)
                            .foregroundStyle(.black.opacity(0.8))
                            .font(.title3)
                            .bold()
                            .padding(.leading, 10)
                        Text("Price: \(product.price.formatted(.currency(code: "INR")))/-")
                            .foregroundStyle(.black.opacity(0.8))
                            .font(.title3)
                            .bold()
                            .padding(.leading, 10)
                        Text("Procduct Type: "+product.productType)
                            .foregroundStyle(.black.opacity(0.8))
                            .font(.title3)
                            .bold()
                            .padding(.leading, 10)
                        Text("Tax Percentage: \(product.tax.formatted(.percent)).")
                            .foregroundStyle(.black.opacity(0.8))
                            .font(.title3)
                            .bold()
                            .padding(.leading, 10)
                        
                    }
                    .padding(.leading, 15)
                    Spacer()
                }
                Spacer()
                
            }
        }
        .frame(width: 350 , height: 300)
    }
    /// Implements the favourite functionality
    ///
    /// Works by creating a temp array -> Removes the particular product that was favourited -> Inserts said object at the front of the temp array
    /// -> and finally updates the `products` array in the ViewModel
    /// - Parameter product: Takes in instance of the `ProductModel`
     func processFavourite(product: ProductModel) {
        var tempProduct = vm.products
        tempProduct.removeAll(where:{ $0 == product})
        tempProduct.insert(product, at: 0)
        DispatchQueue.main.async{
            vm.products = tempProduct
        }
    }
}

#Preview {
    IndividualProductCardView(product: ProductModel(productName: "d", price: 122, productType: "ded", tax: 23), vm: ProductViewModel())
}
