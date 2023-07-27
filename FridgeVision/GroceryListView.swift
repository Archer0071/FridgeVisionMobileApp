//
//  GroceryListView.swift
//  FridgeVision
//
//  Created by Melanie Herbert on 7/27/23.
//

import SwiftUI

struct GroceryListView: View {
    let selectedMeals: [String]
    
    var body: some View {
        VStack {
            Text("Your selected meals:")
            
            List(selectedMeals, id: \.self) { meal in
                Text(meal)
            }
        }
    }
}

struct GroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView(selectedMeals: ["Meal 1", "Meal 2", "Meal 3"])
    }
}
