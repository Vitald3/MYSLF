//
//  TakedRepository.swift
//  MYSLF
//
//  Created by Vitald3 on 20.10.2025.
//

import Foundation

protocol TakedRepositoryProtocol {
    func getClosest(_ image: Data) async -> Result<String, NetworkError>
}
