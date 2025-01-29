//
//  RegistrationViewmodel.swift
//  User Registration OTP
//
//  Created by Aaseem Mhaskar on 27/01/25.
//

import Foundation

@MainActor
class RegistrationViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var showOTPView = false
    @Published var userId = 0
    @Published var otp = ""
    @Published var onSuccess = false
    
    var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && email.contains("@") && phone.count == 10 && !password.isEmpty
    }
    
    func registerUser() async {
        guard isFormValid else {
            errorMessage = "Please fill out all fields correctly."
            return
        }
        
        let url = URL(string: "https://admin-cp.rimashaar.com/api/v1/register-new?lang=en")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "phone": phone,
            "password": password,
            "app_version": "1.0",
            "device_model": "",
            "device_token": "",
            "device_type": "I",
            "dob": "",
            "gender": "",
            "newsletter_subscribed": 0,
            "os_version": "",
            "phone_code": "965"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
                
                do {
                    let response = try JSONDecoder().decode(RegistrationResponse.self, from: data)
                    
                    if response.success {
                        // Success case
                        print("Registration successful!")
                        print("OTP Code received: \(response.data.code)")
                        self.errorMessage = nil
                        self.userId = response.data.id
                        self.showOTPView = true
                    } else {
                        self.errorMessage = response.message
                    }
                } catch {
                    print("Decoding error: \(error)")
                    self.errorMessage = "Invalid server response. Please try again."
                }
            }
        }.resume()
    }
    
    func verifyOTP() {
        guard let url = URL(string: "https://admin-cp.rimashaar.com/api/v1/verify-code?lang=en") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "otp": otp,
            "user_id": userId
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error serializing JSON: \(error)")
            self.errorMessage = "Failed to create request body."
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Network Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📥 HTTP Status Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        self.errorMessage = "Server returned status code \(httpResponse.statusCode)."
                        return
                    }
                }
                
                guard let data = data else {
                    print("No data received.")
                    self.errorMessage = "No data received from the server."
                    return
                }
                
                print("Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid UTF-8 data")")
                
                do {
                    let responseObj = try JSONDecoder().decode(OTPResponse.self, from: data)
                    if responseObj.success {
                        print(" OTP verified successfully!")
                        print("User Info: \(responseObj.data?.first_name ?? "") \(responseObj.data?.last_name ?? "")")
                        self.firstName = responseObj.data?.first_name ?? ""
                        self.lastName = responseObj.data?.last_name ?? ""
                        self.onSuccess = true
                    } else {
                        self.errorMessage = responseObj.message
                        print("Invalid OTP: \(self.errorMessage ?? "Unknown error")")
                    }
                } catch {
                    print("JSON Decoding Error: \(error.localizedDescription)")
                    self.errorMessage = "Failed to parse server response."
                }
            }
        }.resume()
    }
}
