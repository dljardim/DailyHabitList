import SwiftUI
import SwiftData

@Model
class Habit {
    @Attribute(.unique) var id: UUID
    var title: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
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
    @Bindable var habit: Habit
    
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

struct EditHabitView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var habit: Habit
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Habit name", text: $habit.title)
            }
            .navigationTitle("Edit Habit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
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
                        modelContext.insert(newHabit)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}





struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var habits: [Habit] = []
    
    // State variables stay the same
    @State private var searchText = ""
    @State private var sortAscending = true
    @State private var activeSheet: ActiveSheet?
    
    private func fetchHabits() {
        let descriptor = FetchDescriptor<Habit>(
            predicate: searchText.isEmpty ? nil :
                #Predicate { $0.title.localizedStandardContains(searchText) },
            sortBy: [
                SortDescriptor(\.title, order: sortAscending ? .forward : .reverse)
            ]
        )
        
        do {
            habits = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching habits: \(error.localizedDescription)")
        }
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
                    ForEach(habits) { habit in
                        HabitRow(habit: habit)
                            .swipeActions {
                                Button(role: .destructive) {
                                    modelContext.delete(habit)
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
            .searchable(text: $searchText, prompt: "Search habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(sortAscending ? "Sort Z → A" : "Sort A → Z") {
                            sortAscending.toggle()
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        activeSheet = .add
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onChange(of: searchText) { fetchHabits() }
            .onChange(of: sortAscending) { fetchHabits() }
            
            .onAppear(perform: fetchHabits)
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                    case .add:
                        AddHabitView()
                    case .edit(let habit):
                        EditHabitView(habit: habit)
                }
            }
        }
    }

}
