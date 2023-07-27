//
//  MealView.swift
//  FridgeVision
//
//  Created by Melanie Herbert on 7/27/23.
//

import SwiftUI

struct MealView: View {
    // Dummy data to simulate the meals
    let meals = (1...20).map { "Meal \($0)" }
    
    @State private var selectedMeals: [String] = []
    
    var body: some View {
        VStack {
            Text("Select Your Meals")
                .font(.largeTitle)
                .padding()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(meals, id: \.self) { meal in
                        MealCardView(meal: meal, isSelected: selectedMeals.contains(meal)) {
                            if let index = selectedMeals.firstIndex(of: meal) {
                                selectedMeals.remove(at: index)
                            } else {
                                selectedMeals.append(meal)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Button(action: {
                // Handle checkout action
            }) {
                HStack {
                    Image(systemName: "cart")
                        .font(.title)
                    Text("Checkout (\(selectedMeals.count))")
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }
        }
    }
}

struct MealCardView: View {
    let meal: String
    let isSelected: Bool
    let onToggleSelection: () -> Void
    
    var body: some View {
        VStack {
            // Replace with your actual image
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            
            Text(meal)
                .font(.headline)
            
            Button(action: {
                onToggleSelection()
            }) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.title)
                    .foregroundColor(isSelected ? .green : .gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        MealView()
    }
}
