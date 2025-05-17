//
//  CircularIconButton.swift
//  DailyHabitList
//
//  Created by Damian Jardim on 5/16/25.
//

import SwiftUI

struct CircularIconButton: View {
    var systemIconName: String
    var action: () -> Void
    var size: CGFloat = 70
    var backgroundColor: Color = .blue
    var iconColor: Color = .white
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemIconName)
                .font(.system(size: size / 2))
                .foregroundColor(iconColor)
                .frame(width: size, height: size)
                .background(Circle().fill(backgroundColor).opacity(0.50))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CircularIconButton(systemIconName: "plus", action: {})
}
