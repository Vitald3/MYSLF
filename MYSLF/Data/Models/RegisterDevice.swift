//
//  RegisterDevice.swift
//  MYSLF
//
//  Created by Vitald3 on 18.10.2025.
//

struct RegisterDeviceResponse: Codable {
    let user: User
    let device: Device
    let token: String
}
