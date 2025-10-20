//
//  ApiResponse.swift
//  MYSLF
//
//  Created by Vitald3 on 18.10.2025.
//

struct ApiResponse<T: Decodable>: Decodable {
    let data: T?
    let status: Int
    let error: String?
    
    var isSuccess: Bool {
        status == 200
    }
}
