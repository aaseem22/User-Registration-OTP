//
//  OTPView.swift
//  User Registration OTP
//
//  Created by Aaseem Mhaskar on 27/01/25.
//
import SwiftUI

struct OTPView: View {
    @StateObject var viewModel: RegistrationViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoading = false
    @State private var otpText = ""
    @FocusState private var isInputActive: Bool
    
    private let otpLength = 5
    private let gradient = LinearGradient(
        colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        VStack(spacing: 32) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "key.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(gradient)
                
                Text("Verification Code")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Please enter the verification code sent to\n\(viewModel.email)")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            // OTP Field
            VStack(spacing: 24) {
                HStack(spacing: 12) {
                    ForEach(0..<otpLength, id: \.self) { index in
                        OTPTextFieldBox(
                            text: getOTPChar(at: index),
                            isFocused: isInputActive && index == otpText.count
                        )
                    }
                }
                
                // Hidden TextField for input
                TextField("", text: $otpText)
                    .keyboardType(.numberPad)
                    .frame(width: 1, height: 1)
                    .opacity(0.1)
                    .focused($isInputActive)
                    .onChange(of: otpText) { oldValue, newValue in
                        if newValue.count > otpLength {
                            otpText = String(newValue.prefix(otpLength))
                        }
                        viewModel.otp = otpText
                    }
                
                
                
                Button(action: {
                    isInputActive = true
                }) {
                    Text("Click to enter OTP")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                }
                .opacity(otpText.isEmpty ? 1 : 0)
                
            }
            
            // Verify Button
            Button(action: {
                isLoading = true
                viewModel.verifyOTP()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isLoading = false
                }
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Verify Code")
                            .fontWeight(.semibold)
                        Image(systemName: "checkmark.circle.fill")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    otpText.count < otpLength ?
                    LinearGradient(colors: [Color.gray.opacity(0.8)], startPoint: .leading, endPoint: .trailing) :
                        gradient
                )
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: otpText.count < otpLength ? .clear : .blue.opacity(0.3), radius: 5, y: 3)
            }
            .disabled(otpText.count < otpLength || isLoading)
            
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
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .onAppear {
            isInputActive = true
        }
        .fullScreenCover(isPresented: $viewModel.onSuccess) {
            WelcomeView(
                firstName: viewModel.firstName,
                lastName: viewModel.lastName
            )
        }
    }
    
    private func getOTPChar(at index: Int) -> String {
        guard index < otpText.count else { return "" }
        let otpArray = Array(otpText)
        return String(otpArray[index])
    }
}

struct OTPTextFieldBox: View {
    let text: String
    let isFocused: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(width: 50, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? Color.blue : Color(.systemGray4), lineWidth: 1)
                )
            
            Text(text)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    NavigationView {
        OTPView(viewModel: RegistrationViewModel())
    }
}
