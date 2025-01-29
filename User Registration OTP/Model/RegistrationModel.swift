//
//  RegistrationModel.swift
//  User Registration OTP
//
//  Created by Aaseem Mhaskar on 27/01/25.
//

import Foundation

struct RegistrationResponse: Codable {
    let success: Bool
    let status: Int
    let message: String
    let data: RegistrationData
}

struct RegistrationData: Codable {
    let id: Int
    let first_name: String
    let last_name: String
    let gender: String
    let dob: String
    let email: String
    let image: String
    let phone_code: String
    let phone: String
    let code: String
    let is_phone_verified: Int
    let is_email_verified: Int
    let is_social_register: Int
    let social_register_type: String
    let device_token: String
    let device_type: String
    let device_model: String
    let app_version: String
    let os_version: String
    let push_enabled: String
    let newsletter_subscribed: Int
    let create_date: String
}

