import SwiftUI
import SwiftData

@main
struct DailyHabitListApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Habit.self)
    }
}
