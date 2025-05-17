//
//  HomeView2.swift
//
//  Created by Damian Jardim on 5/16/25.
//

import SwiftUI


struct HomeView: View {
    @State private var habits: [Habit] = [
        Habit(title: "Morning walk"),
        Habit(title: "Read 10 pages"),
        Habit(title: "Drink water"),
    ]
    
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(Date().formatted(.dateTime.weekday().day().month().year()))
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text("Good day! Here are your habits:")
                    .font(.title.bold())
                    .padding(.bottom)
                
                List {
                    ForEach($habits) { $habit in
                        HabitRow(habit: $habit)
                            .swipeActions {
                                Button(role: .destructive) {
                                    if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                                        habits.remove(at: index)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    // Show edit view
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                            }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .padding()
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView(habits: $habits)
        }
    }
}



struct HabitRow: View {
    @Binding var habit: Habit
    
    var body: some View {
        HStack {
            Button {
                habit.isCompleted.toggle()
            } label: {
                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(habit.isCompleted ? .green : .gray)
            }
            
            Text(habit.title)
                .strikethrough(habit.isCompleted, color: .gray)
                .foregroundColor(habit.isCompleted ? .gray : .primary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HomeView()
}
