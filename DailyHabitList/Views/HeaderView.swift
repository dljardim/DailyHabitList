////
////  HeaderView.swift
////  DailyHabitList
////
////  Created by Damian Jardim on 5/16/25.
////
//
//import SwiftUI
//
//
//struct CustomHeader: View {
//    var title: String
//    var leftIcon: String = "chevron.left"
//    var rightIcon: String = "gearshape.fill"
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            Color(.systemBackground)
//                .ignoresSafeArea(edges: .top)
//                .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
//            
//            VStack(spacing: 0) {
//                HStack {
//                    Button(action: {
//                        // Back/menu action
//                    }) {
//                        Image(systemName: leftIcon)
//                            .font(.title2)
//                            .foregroundColor(.primary)
//                    }
//                    
//                    Spacer()
//                    
//                    Text(title)
//                        .font(.largeTitle)
//                        .bold()
//                        .foregroundColor(.primary)
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        // Settings/search action
//                    }) {
//                        Image(systemName: rightIcon)
//                            .font(.title2)
//                            .foregroundColor(.primary)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44)
//                .padding(.bottom, 12)
//                
//                // Bottom border
//                Rectangle()
//                    .frame(height: 0.5)
//                    .foregroundColor(Color.gray.opacity(0.3))
//            }
//        }
//        .frame(height: 88)
//    }
//}
//
//
//
//#Preview {
//    CustomHeader(title:"Title")
//}
