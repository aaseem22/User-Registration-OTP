//
//  RegistrationView.swift
//  User Registration OTP
//
//  Created by Aaseem Mhaskar on 27/01/25.
//
import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @State private var isLoading = false
    @Environment(\.colorScheme) var colorScheme
    
    private let gradient = LinearGradient(
        colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 60))
                        .foregroundStyle(gradient)
                    
                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Please fill in the details below")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 20)
                
                // Form Fields
                Group {
                    HStack {
                        TextField("First Name", text: $viewModel.firstName)
                            .textContentType(.givenName)
                            .autocapitalization(.words)
                            .modifier(CustomTextFieldStyle())
                        Spacer()
                        TextField("Last Name", text: $viewModel.lastName)
                            .textContentType(.familyName)
                            .autocapitalization(.words)
                            .modifier(CustomTextFieldStyle())
                    }
                    
                    
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .modifier(CustomTextFieldStyle())
                    
                    TextField("Phone", text: $viewModel.phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                        .modifier(CustomTextFieldStyle())
                    
                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.newPassword)
                        .modifier(CustomTextFieldStyle())
                }
                
                // Register Button
                Button(action: {
                    Task {
                        isLoading = true
                        await viewModel.registerUser()
                        isLoading = false
                    }
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Create Account")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        viewModel.isFormValid ?
                        gradient :
                            LinearGradient(colors: [Color.gray.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: viewModel.isFormValid ? .blue.opacity(0.3) : .clear, radius: 5, y: 3)
                }
                .disabled(!viewModel.isFormValid || isLoading)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.red.opacity(0.1))
                        )
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .fullScreenCover(isPresented: $viewModel.showOTPView) {
            OTPView(viewModel: viewModel)
        }
    }
}

struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
    }
}

#Preview {
    NavigationView {
        RegistrationView()
    }
}
