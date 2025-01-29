//
//  RegistrationViewmodel.swift
//  User Registration OTP
//
//  Created by Aaseem Mhaskar on 27/01/25.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var password = ""
    @Published var errorMessage: String?
    
    var isFormValid: Bool {
        !firstName.isEmpty && lastName.isEmpty && email.contains("@") && phone.count == 10 && !password.isEmpty
    }
    
    func registerUser() {
//        guard isFormValid else {
//            errorMessage = "Please fill out all fields correctly."
//            return
//        }
        
        let url = URL(string: "https://admin-cp.rimashaar.com/api/v1/register-new?lang=en")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "phone": phone,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else if let data = data {
                    do {
                        let responseDict = try JSONDecoder().decode([String: String].self, from: data)
                        if let code = responseDict["code"] {
                            // Navigate to OTP view with the received code
                            print("Code received: \(code)")
                        } else {
                            self.errorMessage = "Registration failed. Please try again."
                        }
                    } catch {
                        self.errorMessage = "Invalid server response."
                    }
                }
            }
        }.resume()
    }
}



