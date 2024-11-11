//
//  NewProductEntryView.swift
//  Swipe-Assignment-VP
//
//  Created by Vishwas Sharma on 11/11/24.
//

import SwiftUI
import PhotosUI

struct NewProductEntryView: View {
    // State vars
    @State private var selectedImage: PhotosPickerItem?
    @State private var productType: String = "Select a product"
    @State private var productName: String = ""
    @State private var tax: String = ""
    @State private var price: String = ""
    @State private var selectedImageData: Data?
    @State private var uiImage: UIImage?
    @State private var uploadSucess: Bool = false
    @State private var didNotPassValidation: Bool = false
    @State private var validationError: String = ""
    @State private var noInternetErrorAlert = false
    @Binding var isConnected: Bool
    
    // Env Vars
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Image Picker
            PhotosPicker(selection: $selectedImage, preferredItemEncoding: .automatic) {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [15]))
                            .foregroundStyle(.black)
                            .frame(width: 250, height: 250)
                        
                        if let uiImage = uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        } else {
                            Image(systemName: "plus")
                                .font(.system(size: 100))
                                .bold()
                                .foregroundStyle(.yellow)
                        }
                    }
                    
                    Text("Add Image")
                        .foregroundStyle(.black)
                        .font(.title2)
                }
            }
            Spacer()
            
            // Product Name
            GenericTFView(tfTitle: "E.g. Carrot", imageName: "carrot", textBinding: $productName, needsFiltering: false, callout: "Name of Product", keyboardType: .default)

            
            ZStack{
                
                
                Menu {
                    Button("Product", action: {
                        productType = "Product"
                    })
                    Button("Phone", action: {
                        productType = "Phone"
                    })
                    Button("Laptop", action: {
                        productType = "Laptop"
                    })
                    Button("Mobile", action: {
                        productType = "Mobile"
                    })
                    Button("Electronics", action: {
                        productType = "Electronics"
                    })
                    Button("Vehicles", action: {
                        productType = "Vehicles"
                    })
                    Button("Grocery", action: {
                        productType = "Grocery"
                    })
                    Button("Fruit", action: {
                        productType = "Fruit"
                    })
                    Button("Home Appliances", action: {
                        productType = "Home Appliances"
                    })
                    Button("Entertainment", action: {
                        productType = "Entertainment"
                    })
                    Button("Service", action: {
                        productType = "Service"
                    })
                    Button("Clothing", action: {
                        productType = "Clothing"
                    })
                }  label: {
                    HStack{
                        VStack{
                            HStack {
                                Text("Type of Price")
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            ZStack{
                                RoundedRectangle(cornerRadius: 18)
                                    .foregroundStyle(.gray.opacity(0.3))
                                HStack{
                                    Text(productType)
                                        .padding(.leading, 9)
                                        .foregroundStyle(.gray)
                                    Spacer()
                                }
                            }
                        }
                        .frame(width: 300 , height: 75)
                    }
                }
                
                
            }
            
            // Price
            GenericTFView(tfTitle: "E.g. ₹100", imageName: "dollarsign.square", textBinding: $price, needsFiltering: false, callout: "Price of Product", keyboardType: .decimalPad)
            
            // Tax
            GenericTFView(tfTitle: "E.g. 12%", imageName: "building.columns", textBinding: $tax, needsFiltering: false, callout: "Tax on Product", keyboardType: .decimalPad)
            
            Button {
                if performValidation() && NetworkManagerSingleton.shared.isConnected {
                    Task {
                        if let selectedItem = selectedImage {
                            do {
                                if let data = try await selectedItem.loadTransferable(type: Data.self) {
                                    let newProduct = ProductModel(
                                        productName: productName,
                                        price: Double(price) ?? 0,
                                        productType: productType,
                                        tax: Double(tax) ?? 0,
                                        uploadedImageData: data
                                    )
                                    
                                    NetworkManagerSingleton.shared.uploadProductData(
                                        with: "https://app.getswipe.in/api/public/add",
                                        product: newProduct
                                    ) { result in
                                        switch result {
                                        case .success:
                                                // TODO: Add ability to send an alert
                                                uploadSucess = true
                                            print("Product added successfully")
                                        case .failure(let error):
                                            print("Error adding product: \(error.localizedDescription)")
                                        }
                                    }
                                }
                            } catch {
                                print("Error loading image data: \(error)")
                            }
                        }
                        self.productType = ""
                    }
                } else {
                    noInternetErrorAlert = true
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 200, height: 65)
                        .foregroundStyle(.orange)
                    
                    Text("Add Product")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                }
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .onChange(of: selectedImage) { newItem in
            Task {
                if let selectedItem = newItem {
                    do {

                        if let data = try await selectedItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            self.uiImage = uiImage
                            self.selectedImageData = data
                        }
                    } catch {
                        print("Error loading image data: \(error)")
                    }
                }
            }
        }
        .alert("Product added sucessfully", isPresented: $uploadSucess) {
            Button("Okay", role: .cancel) {
                // do nothing as of now
                dismiss()
                
            }
        }
        .alert("Plese check your Internet Connection and try again", isPresented: $isConnected) {
            Button("Okay", role: .cancel) {
                                
            }
        }
        .alert("\(validationError)", isPresented: $didNotPassValidation) {
            Button("Okay", role: .cancel) {
                // reset value
                didNotPassValidation = false
                
            }
        }
    }
    
    /// Function to perform basic form validation, when a user submits a new product request
    /// - Returns: Returns a `Boolean` value, based on which its decided to go ahead with the network call or not. 
    func performValidation() -> Bool {
        // check - all fields filled
        guard !productName.isEmpty, !price.isEmpty, !tax.isEmpty, !productType.isEmpty else  {
            didNotPassValidation = true
            validationError = "Empty fields are not allowed ☹️"
            return false
        }
        
        // check if image selected/not
        
        if selectedImageData == nil {
            validationError = "Please select an image🌅"
            didNotPassValidation = true
            return false
        }
        

        // price / tax field should only have numbers
        let priceCheck = price.allSatisfy { $0.isNumber }
        let taxCheck = tax.allSatisfy { $0.isNumber }

        if !priceCheck || !taxCheck {
            didNotPassValidation = true
            validationError = "Only numbers are allowed in price and tax fields 🫣"
            return false
        }

        didNotPassValidation = false
        return true
    }

}

#Preview {
    NewProductEntryView(isConnected: .constant(false))
    
    
}



