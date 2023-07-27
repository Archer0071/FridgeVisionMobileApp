//
//  PreferencesView.swift
//  FridgeVision
//
//  Created by Melanie Herbert on 7/27/23.
//

import SwiftUI

struct PreferencesView: View {
    @State private var allergies: [String] = []
    @State private var dislikes: [String] = []
    @State private var isAllergyViewPresented = false
    @State private var isDislikeViewPresented = false
    @State private var isMealViewPresented = false

    let possibleAllergies = ["Peanuts", "Crustacean Shellfish", "Gluten", "Tree nuts"]
    let possibleDislikes = ["Meat", "Dairy", "Raw Meat"]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        isAllergyViewPresented.toggle()
                    }) {
                        Text("Add Allergy")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    .sheet(isPresented: $isAllergyViewPresented) {
                        SelectionView(options: possibleAllergies) { selectedAllergy in
                            allergies.append(selectedAllergy)
                            isAllergyViewPresented = false
                        }
                    }

                    Button(action: {
                        isDislikeViewPresented.toggle()
                    }) {
                        Text("Add Dislikes")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    .sheet(isPresented: $isDislikeViewPresented) {
                        SelectionView(options: possibleDislikes) { selectedDislike in
                            dislikes.append(selectedDislike)
                            isDislikeViewPresented = false
                        }
                    }
                }

                List {
                    Section(header: Text("Allergies")) {
                        ForEach(allergies, id: \.self) { allergy in
                            Text("No \(allergy)")
                        }
                        .onDelete { indexSet in
                            allergies.remove(atOffsets: indexSet)
                        }
                    }

                    Section(header: Text("Dislikes")) {
                        ForEach(dislikes, id: \.self) { dislike in
                            Text("No \(dislike)")
                        }
                        .onDelete { indexSet in
                            dislikes.remove(atOffsets: indexSet)
                        }
                    }
                }

                Spacer()

                Button(action: {
                    isMealViewPresented = true
                }) {
                    Text("Generate")
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .background(
                    NavigationLink(destination: MealView(), isActive: $isMealViewPresented) {
                        EmptyView()
                    }
                )
                .padding()
            }
            .navigationTitle("Preferences")
        }
    }
}


struct SelectionView: View {
    let options: [String]
    let onSelect: (String) -> Void
    
    var body: some View {
        List(options, id: \.self) { option in
            Button(action: {
                onSelect(option)
            }) {
                Text(option)
            }
        }
    }
}
