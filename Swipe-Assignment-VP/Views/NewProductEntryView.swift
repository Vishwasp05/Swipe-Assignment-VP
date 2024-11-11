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
    @State private var productType: String = ""
    @State private var productName: String = ""
    @State private var tax: String = ""
    @State private var price: String = ""
    @State private var selectedImageData: Data?
    @State private var uiImage: UIImage?
    @State private var uploadSucess: Bool = false
    @State private var didNotPassValidation: Bool = false
    @State private var validationError: String = ""
    
    
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
            
            // Product Type
            GenericTFView(tfTitle: "E.g. Farm Produce", imageName: "tray", textBinding: $productType, needsFiltering: false, callout: "Type of Product", keyboardType: .default)
            
            // Price
            GenericTFView(tfTitle: "E.g. ₹100", imageName: "dollarsign.square", textBinding: $price, needsFiltering: false, callout: "Price of Product", keyboardType: .decimalPad)
            
            // Tax
            GenericTFView(tfTitle: "E.g. 12%", imageName: "building.columns", textBinding: $tax, needsFiltering: false, callout: "Tax on Product", keyboardType: .decimalPad)
            
            Button {
                if performValidation() {
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
                    }
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
                        // Load the selected image as UIImage for display
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
        .alert("\(validationError)", isPresented: $didNotPassValidation) {
            Button("Okay", role: .cancel) {
                // reset value
                didNotPassValidation = false
                
            }
        }
    }

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
