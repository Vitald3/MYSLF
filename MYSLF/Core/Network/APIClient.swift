//
//  APIClient.swift
//  MYSLF
//
//  Created by Vitald3 on 17.10.2025.
//

import Foundation
import UIKit

protocol APIClientProtocol {
    func request(
        endpoint: URL,
        method: String,
        body: [String: Any]?
    ) async throws -> (Data, Int)
    
    func upload(
        endpoint: URL,
        method: String,
        fields: [String: Any],
        fileData: Data?,
        fileName: String,
        mimeType: String,
        fieldName: String
    ) async throws -> (Data, Int)
}

final class APIClient: APIClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    func request(
        endpoint: URL,
        method: String = "GET",
        body: [String: Any]? = nil
    ) async throws -> (Data, Int) {
        
        let clientId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        let apiTime = String(Int(Date().timeIntervalSince1970))
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = method

        var jsonString = "{}"
        if let body = body, !body.isEmpty {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"
            request.httpBody = jsonData
        }
        
        addHeaders(to: &request, clientId: clientId, apiTime: apiTime, body: jsonString)

        logRequest(request, body: jsonString)
        
        return try await withCheckedThrowingContinuation { continuation in
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: NSError(domain: "EmptyResponse", code: httpResponse.statusCode))
                    return
                }

                if httpResponse.statusCode == 401 {
                    print("Unauthorized (401). Maybe handle refresh token here.")
                }

                APIClient.logRequest(httpResponse, data: data)

                continuation.resume(returning: (data, httpResponse.statusCode))
            }.resume()
        }
    }
    
    func upload(
        endpoint: URL,
        method: String = "POST",
        fields: [String: Any],
        fileData: Data?,
        fileName: String = "upload.jpg",
        mimeType: String = "image/png",
        fieldName: String = "file"
    ) async throws -> (Data, Int) {
        var request = URLRequest(url: endpoint)
        request.httpMethod = method
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        for (key, value) in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        if let fileData = fileData {
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
            
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        }
        
        request.httpBody = body
        
        addHeaders(
            to: &request,
            clientId: UIDevice.current.identifierForVendor?.uuidString ?? "",
            apiTime: String(Int(Date().timeIntervalSince1970)),
            body: "",
            isMultipart: true
        )
        
        logRequest(request, body: "[multipart form-data]")
        
        return try await withCheckedThrowingContinuation { continuation in
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: NSError(domain: "EmptyResponse", code: httpResponse.statusCode))
                    return
                }
                
                APIClient.logRequest(httpResponse, data: data)
                
                continuation.resume(returning: (data, httpResponse.statusCode))
            }.resume()
        }
    }
    
    private static func logRequest(_ response: HTTPURLResponse, data: Data) {
        print("------------------")
        print("[HTTP] Status: \(response.statusCode)")
        if let string = String(data: data, encoding: .utf8) {
            print("Response: \(string)")
        }
        print("------------------")
    }

    private func addHeaders(to request: inout URLRequest, clientId: String, apiTime: String, body: String, isMultipart: Bool? = false) {
        if !(isMultipart ?? false) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.setValue("0.0.1", forHTTPHeaderField: "API-VERSION")
        request
            .setValue(
                Locale.current.language.languageCode?.identifier ?? "en",
                forHTTPHeaderField: "API-LANGUAGE"
            )
        request.setValue(UIDevice.current.model, forHTTPHeaderField: "API-CLIENT-DEVICE-NAME")
    }

    private func logRequest(_ request: URLRequest, body: String) {
        print("------------------")
        print("[HTTP] \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if !body.isEmpty { print("Body: \(body)") }
        print("------------------")
    }

    private func logResponse(_ response: HTTPURLResponse, data: Data) {
        print("------------------")
        print("[HTTP] Status: \(response.statusCode)")
        if let string = String(data: data, encoding: .utf8) {
            print("Response: \(string)")
        }
        print("------------------")
    }
}
