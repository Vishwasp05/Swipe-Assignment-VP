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
    @State private var uploadSuccess: Bool = false
    @State private var didNotPassValidation: Bool = false
    @State private var validationError: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    @State private var isUploading: Bool = false
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
            .disabled(isUploading)
            
            Spacer()
            
            // Product Name
            GenericTFView(tfTitle: "E.g. Carrot", imageName: "carrot", textBinding: $productName, needsFiltering: false, callout: "Name of Product", keyboardType: .default)
                .disabled(isUploading)
            
            // Product Type Menu
            ZStack {
                Menu {
                    ForEach(["Product", "Phone", "Laptop", "Mobile", "Electronics", "Vehicles", "Grocery", "Fruit", "Home Appliances", "Entertainment", "Service", "Clothing"], id: \.self) { type in
                        Button(type) {
                            productType = type
                        }
                    }
                } label: {
                    HStack {
                        VStack {
                            HStack {
                                Text("Type of Price")
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .foregroundStyle(.gray.opacity(0.3))
                                HStack {
                                    Text(productType)
                                        .padding(.leading, 9)
                                        .foregroundStyle(.gray)
                                    Spacer()
                                }
                            }
                        }
                        .frame(width: 300, height: 75)
                    }
                }
            }
            .disabled(isUploading)
            
            // Price and Tax Fields
            GenericTFView(tfTitle: "E.g. ₹100", imageName: "dollarsign.square", textBinding: $price, needsFiltering: false, callout: "Price of Product", keyboardType: .decimalPad)
                .disabled(isUploading)
            GenericTFView(tfTitle: "E.g. 12%", imageName: "building.columns", textBinding: $tax, needsFiltering: false, callout: "Tax on Product", keyboardType: .decimalPad)
                .disabled(isUploading)
            
            // Add Product Button
            Button {
                if !isConnected {
                    showAlert(title: "No Internet Connection", message: "Please check your Internet Connection and try again")
                    return
                }
                
                if performValidation() {
                    withAnimation {
                        isUploading = true
                    }
                    
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
                                        DispatchQueue.main.async {
                                            withAnimation {
                                                isUploading = false
                                            }
                                            
                                            switch result {
                                            case .success:
                                                showAlert(title: "Success", message: "Product added successfully")
                                            case .failure(let error):
                                                showAlert(title: "Error", message: "Error adding product: \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        isUploading = false
                                    }
                                    showAlert(title: "Error", message: "Error loading image data: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 200, height: 65)
                        .foregroundStyle(isUploading ? .gray : .orange)
                    
                    if isUploading {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                    } else {
                        Text("Add Product")
                            .foregroundStyle(.white)
                            .font(.title)
                            .bold()
                    }
                }
            }
            .disabled(isUploading)
            .padding(.top, 20)
            
            Spacer()
        }
        .onChange(of: selectedImage) { newItem in
            Task {
                if let selectedItem = newItem {
                    do {
                        if let data = try await selectedItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            await MainActor.run {
                                self.uiImage = uiImage
                                self.selectedImageData = data
                            }
                        }
                    } catch {
                        await MainActor.run {
                            showAlert(title: "Error", message: "Error loading image data: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                if alertTitle == "Success" {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
        .disabled(isUploading)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func performValidation() -> Bool {
        if productName.isEmpty || price.isEmpty || tax.isEmpty || productType == "Select a product" {
            showAlert(title: "Validation Error", message: "Empty fields are not allowed ☹️")
            return false
        }
        
        if selectedImageData == nil {
            showAlert(title: "Validation Error", message: "Please select an image 🌅")
            return false
        }
        
        let priceCheck = price.allSatisfy { $0.isNumber }
        let taxCheck = tax.allSatisfy { $0.isNumber }
        
        if !priceCheck || !taxCheck {
            showAlert(title: "Validation Error", message: "Only numbers are allowed in price and tax fields 🫣")
            return false
        }
        
        return true
    }
}

#Preview {
    NewProductEntryView(isConnected: .constant(true))
}
