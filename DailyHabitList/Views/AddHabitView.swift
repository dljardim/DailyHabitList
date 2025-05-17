////
////  NewHabitView.swift
////  DailyHabitList
////
////  Created by Damian Jardim on 5/16/25.
////
//
//import SwiftUI
//
//struct AddHabitView: View {
//    @Environment(\.dismiss) var dismiss
//    @Binding var habits: [Habit]
//    
//    @State private var title: String = ""
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section(header: Text("New Habit")) {
//                    TextField("Enter habit name", text: $title)
//                }
//            }
//            .navigationTitle("Add Habit")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Save") {
//                        let newHabit = Habit(title: title)
//                        habits.append(newHabit)
//                        dismiss()
//                    }
//                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
//                }
//            }
//        }
//    }
//}
