//
//  CameraViewModel.swift
//  MYSLF
//
//  Created by Vitald3 on 20.10.2025.
//

import Foundation
import Combine
import AVFoundation

final class CameraViewModel: NSObject, ObservableObject {
    private let router: NavigationRouter
    private let useCase: CameraUseCaseProtocol
    
    @Published var isCameraAccess: Bool = false
    
    init(router: NavigationRouter, useCase: CameraUseCaseProtocol) {
        self.router = router
        self.useCase = useCase
    }
    
    deinit {
        useCase.stopSession()
    }
    
    var session: AVCaptureSession {
        useCase.session
    }
    
    func capturePhoto() {
        useCase.capturePhoto { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.router.pop(popData: image)
            } else {
                self.router.pop()
            }
        }
    }
    
    func configure() async {
        self.isCameraAccess = await useCase.requestCameraAccess()
        
        if isCameraAccess {
            useCase.configure()
        }
    }
}
