//
//  OTPModel.swift
//  User Registration OTP
//
//  Created by Aaseem Mhaskar on 27/01/25.
//

import Foundation

struct OTPResponse: Decodable {
    let success: Bool
    let status: Int
    let message: String
    let data: UserData?
}

struct UserData: Decodable {
    let id: String
    let first_name: String
    let last_name: String
    let email: String
    let phone: String
}
