//
//  MenuBreakdown.swift
//  LittleLemonRestaurant
//

import SwiftUI

struct MenuBreakdown: View {
    
    @Binding var categoryName: String
    @Binding var menuSectionSelection: Bool
    
    private let menuSectionNames = ["starters", "mains", "desserts", "drinks"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ORDER FOR DELIVERY!")
                .font(.custom("Karla-ExtraBold", size: 20))
                .foregroundColor(Color("highlightTwo"))
            
            HStack(spacing: 5) {
                Button("Menu") {
                    categoryName = ""
                    menuSectionSelection = false
                }
                .buttonStyleSix()
                
                ForEach(menuSectionNames, id: \.self) { name in
                    Button(name.capitalized) {
                        categoryName = name
                        menuSectionSelection = true
                    }
                    .buttonStyleSix()
                }
            }
            .font(.custom("Karla-Bold", size: 16))
            .foregroundColor(Color("primaryOne"))
            
            Divider()
        }
        .padding(.horizontal, 10)
    }
}

struct MenuBreakdown_Previews: PreviewProvider {
    static var previews: some View {
        MenuBreakdown(categoryName: .constant("main"), menuSectionSelection: .constant(false))
    }
}
