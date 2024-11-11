//
//  GenericTFView.swift
//  Swipe-Assignment-VP
//
//  Created by Vishwas Sharma on 10/11/24.
//

import SwiftUI

struct GenericTFView: View {
    let tfTitle: String
    let imageName: String
    @Binding var textBinding: String
    
    let needsFiltering: Bool
    let callout: String
    let keyboardType: UIKeyboardType
  
    
    var body: some View {
       
        HStack{
            VStack{
                HStack {
                    Text(callout)
                    Spacer()
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundStyle(.gray.opacity(0.3))
                    HStack{
                        TextField(tfTitle, text: $textBinding)
                            .padding(.leading, 10)
                            .keyboardType(keyboardType)
                    
                        Image(systemName: imageName)
                            .padding(.trailing, 10)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .frame(width: !needsFiltering ? 300 : 350 , height: 85)
            
            if needsFiltering{
                
                    Button {
                        // TODO: Perform filtering here
                        // TODO: Add drop down menu to select various types of filtering!
                        
    
                    } label: {
                        ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.gray.opacity(0.3))
                        
                        Image(systemName: "line.3.horizontal.decrease")
                                .foregroundStyle(.black)
                    }
                    
                }
                .frame(width: 60, height: 35)
            }
        }
        
    }
    
    func highToLow() {
        
    }
    
}

#Preview {
    GenericTFView(tfTitle: "Placeholder Text", imageName: "magnifyingglass", textBinding: .constant("uo"), needsFiltering: false, callout: "Type of Product" , keyboardType: .numberPad)
}
