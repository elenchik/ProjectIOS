//
//  DishDetails.swift
//  LittleLemonRestaurant
//

import SwiftUI

struct DishDetails: View {
    @ObservedObject private var dish: Dish
    
    init(_ dish:Dish) {
        self.dish = dish
    }
    
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            Color("highlightOne")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    Spacer()
                    Image("littleLemon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 45)
                    
                    Text(dish.title ?? "")
                        .font(.custom("Karla-Bold", size: 40))
                        .foregroundColor(Color("highlightTwo"))
                    
                    Text(dish.explanation ?? "")
                        .font(.custom("Karla-Medium", size: 20))
                        .foregroundColor(Color("primaryOne"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .padding(.horizontal, 35)
                    
                    AsyncImage(url: URL(string: dish.image ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 230, height: 230)
                    
                    // Order button
                    Button("Tap to order") {
                        showAlert.toggle()
                    }
                    .frame(width: 160, height: 40)
                    .font(.custom("Karla-Bold", size: 16))
                    .foregroundColor(Color("highlightTwo"))
                    .background(Color("primaryTwo").cornerRadius(8))
                    .alert("Order placed, thanks!", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                .padding()
            }
        }
    }
}

struct DishDetail_Previews: PreviewProvider {
    //    static var previews: some View {
    //        DishDetails()
    //    }
    static let context = PersistenceController.shared.container.viewContext
    let dish = Dish(context: context)
    static var previews: some View {
        DishDetails(oneDish())
    }
    static func oneDish() -> Dish {
        let dish = Dish(context: context)
        dish.title = "Pasta"
        dish.image = "https://github.com/Meta-Mobile-Developer-PC/Working-With-Data-API/blob/main/images/pasta.jpg?raw=true"
        dish.explanation = "Penne with fried aubergines, cherry tomatoes, tomato sauce, fresh chilli, garlic, basil & salted ricotta cheese."
        return dish
    }
}
