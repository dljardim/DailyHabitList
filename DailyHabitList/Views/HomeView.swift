import SwiftUI
import SwiftData

// TODO: add swfitdata

struct Habit: Identifiable, Equatable {
    let id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
}

enum ActiveSheet: Identifiable {
    case add, edit(Habit)
    
    var id: UUID {
        switch self {
            case .add:
                return UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
            case .edit(let habit):
                return habit.id
        }
    }
}
struct HabitRow: View {
    @Binding var habit: Habit
    
    var body: some View {
        HStack {
            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(habit.isCompleted ? .green : .gray)
                .onTapGesture {
                    habit.isCompleted.toggle()
                }
            
            Text(habit.title)
                .strikethrough(habit.isCompleted, color: .gray)
                .foregroundColor(habit.isCompleted ? .gray : .primary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}


struct HomeView: View {
    
    
    @State private var habits: [Habit]
    @State private var activeSheet: ActiveSheet?
    
    init(habits: [Habit] = [
        Habit(title: "Morning walk"),
        Habit(title: "Read 10 pages"),
        Habit(title: "Drink water")
    ]) {
        _habits = State(initialValue: habits)
    }
    
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
                                    activeSheet = .edit(habit)
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
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        activeSheet = .add
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
                case .add:
                    AddHabitView(habits: $habits)
                case .edit(let habit):
                    if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                        EditHabitView(habit: $habits[index])
                    } else {
                        Text("Habit not found")
                    }
            }
        }
    }
    
    struct EditHabitView: View {
        @Binding var habit: Habit
        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            NavigationStack {
                Form {
                    Section(header: Text("Edit Habit")) {
                        TextField("Habit name", text: $habit.title)
                    }
                }
                .navigationTitle("Edit Habit")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    
    
    struct AddHabitView: View {
        @Environment(\.dismiss) var dismiss
        @Binding var habits: [Habit]
        
        @State private var title: String = ""
        
        var body: some View {
            NavigationStack {
                Form {
                    Section(header: Text("New Habit")) {
                        TextField("Enter habit name", text: $title)
                    }
                }
                .navigationTitle("Add Habit")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let newHabit = Habit(title: title)
                            habits.append(newHabit)
                            dismiss()
                        }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
        }
    }
}

#Preview{
    HomeView()
}
