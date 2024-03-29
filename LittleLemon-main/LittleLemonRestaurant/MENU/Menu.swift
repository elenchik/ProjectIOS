//
//  Menu.swift
//  LittleLemonRestaurant
//
import CoreData
import Foundation
import SwiftUI


struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var searchText = ""
    @State private var categoryName = ""
    @State private var menuSectionSelection = false
    
    var body: some View {
        VStack {
            Header()
            
            Hero(searchText: $searchText)
            
            MenuBreakdown(categoryName: $categoryName, menuSectionSelection: $menuSectionSelection)
            
            dishItemList
        }
        .onAppear {
            do {
                try getMenuData()
            }
            catch { print(error) }
        }
    }
    
    // list view of the fetched menu items
    private var dishItemList: some View {
        NavigationView {
            FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                List {
                    ForEach(dishes, id: \.self) { dish in
                        NavigationLink(destination: DishDetails(dish)) {
                            HStack(alignment: .center, spacing: 15) {
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Text(dish.title ?? "")
                                        .font(.custom("Karla-Bold", size: 18))
                                        .foregroundColor(Color("highlightTwo"))
                                    
                                    Text(dish.explanation ?? "")
                                        .font(.custom("Karla-Regular", size: 16))
                                        .foregroundColor(Color("primaryOne"))
                                        .lineSpacing(3)
                                        .lineLimit(2)
                                    
                                    Text("$\(Double(dish.price ?? "") ?? 0.0, specifier: "%.2f")")
                                        .font(.custom("Karla-Medium", size: 16))
                                        .foregroundColor(Color("primaryOne"))
                                }
                                
                                Spacer()
                                
                                AsyncImage(url: URL(string: dish.image ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 80, height: 80)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding(.top, -8)  // to bring the list up
    }
}

extension Menu {
    private func getMenuData() throws {
        viewContext.reset()
        PersistenceController.shared.clear()
        
        // fetch the menu data from the server
        let menuAddress = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let menuURL = URL(string: menuAddress)
        guard let menuURL = menuURL else {
            throw NSError() // if couldn't find menu address url throws error
        }
        
        let request = URLRequest(url: menuURL)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print(responseString)
                // parse the reponse data by using JSON decoder
                let decoder = JSONDecoder()
                let fullMenu = try? decoder.decode(MenuList.self, from: data) // array of MenuItems
                //print(fullMenu?.menu)
                fullMenu?.menu.forEach { menuItem in
                    let newDish = Dish(context: viewContext)
                    newDish.title = menuItem.title
                    newDish.image = menuItem.image
                    newDish.category = menuItem.category
                    newDish.explanation = menuItem.explanation
                    newDish.price = menuItem.price
                }
                try? viewContext.save()
            }
        }
        task.resume()
    }
    // sorting the menu items
    private func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
    }
    // logic for the search textfield and the menu category buttons
    private func buildPredicate() -> NSPredicate {
        if searchText == "" && menuSectionSelection == false {
            return NSPredicate(value: true)
        }
        if searchText != "" && menuSectionSelection == false {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
        if searchText == "" && menuSectionSelection == true {
            return NSPredicate(format: "category CONTAINS[cd] %@", categoryName)
        }
        return NSPredicate(value: true)
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
