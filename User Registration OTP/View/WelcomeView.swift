//
//  WelcomeView.swift
//  User Registration OTP
//
//  Created by Aaseem Mhaskar on 27/01/25.
//

import SwiftUI

struct WelcomeView: View {
    let firstName: String
    let lastName: String
    @Environment(\.dismiss) private var dismiss
    @State private var showConfetti = false
    
    private let gradient = LinearGradient(
        colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        VStack(spacing: 32) {
            // Success Icon
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(gradient)
                }
                .padding(.top, 60)
                
                VStack(spacing: 12) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("\(firstName) \(lastName)")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            
            // Success Message
            VStack(spacing: 16) {
                Text("Registration Successful!")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("Thank you for joining us. Your account has been successfully created.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Continue Button
            Button(action: {
                
            }) {
                HStack {
                    Text("Continue to App")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(gradient)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: .blue.opacity(0.3), radius: 5, y: 3)
            }
            .padding(.bottom, 40)
        }
        .padding()
        .background(
            ZStack {
                // Background circles for visual interest
                Circle()
                    .fill(gradient)
                    .opacity(0.1)
                    .offset(x: -100, y: -400)
                    .frame(width: 300)
                
                Circle()
                    .fill(gradient)
                    .opacity(0.1)
                    .offset(x: 150, y: 400)
                    .frame(width: 300)
            }
                .ignoresSafeArea()
        )
        .onAppear {
            showConfetti = true
        }
        // Add confetti animation
        .displayConfetti(isActive: $showConfetti)
    }
}



#Preview {
    WelcomeView(firstName: "John", lastName: "Doe")
}
