//
//  GroceryListView.swift
//  FridgeVision
//
//  Created by Melanie Herbert on 7/27/23.
//

import SwiftUI

struct GroceryListView: View {
    @State var selectedMeals: [String]
    @State var checkedMeals: [String] = []
    
    var body: some View {
        VStack {
            Text("Your selected meals:")
            
            List {
                ForEach(selectedMeals, id: \.self) { meal in
                    HStack {
                        Text(meal)
                        Spacer()
                        Image(systemName: checkedMeals.contains(meal) ? "checkmark.square" : "square")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                if let index = checkedMeals.firstIndex(of: meal) {
                                    checkedMeals.remove(at: index)
                                } else {
                                    checkedMeals.append(meal)
                                }
                            }
                    }
                }
                .onDelete(perform: removeMeals)
            }
            
            NavigationLink(destination: CookbookView(selectedMeals: selectedMeals)) {
                Text("Go to Cookbook")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Grocery List")
    }
    
    func removeMeals(at offsets: IndexSet) {
        selectedMeals.remove(atOffsets: offsets)
    }
}

struct GroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView(selectedMeals: ["Meal 1", "Meal 2", "Meal 3"])
    }
}
