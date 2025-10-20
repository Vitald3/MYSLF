//
//  CameraUseCase.swift
//  MYSLF
//
//  Created by Vitald3 on 20.10.2025.
//

import AVFoundation
import UIKit

protocol CameraUseCaseProtocol {
    func configure()
    var session: AVCaptureSession { get }
    func capturePhoto(completion: @escaping (UIImage?) -> Void)
    func requestCameraAccess() async -> Bool
    func stopSession()
}

final class CameraUseCase: NSObject, AVCapturePhotoCaptureDelegate, CameraUseCaseProtocol {
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var photoCompletion: ((UIImage?) -> Void)?
    
    func configure() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .front)
        else {
            session.commitConfiguration()
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(output) { session.addOutput(output) }
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
            }
        } catch {
            session.commitConfiguration()
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
        
        session.beginConfiguration()
        for input in session.inputs {
            session.removeInput(input)
        }
        for output in session.outputs {
            session.removeOutput(output)
        }
        session.commitConfiguration()
    }
    
    func requestCameraAccess() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    continuation.resume(returning: granted)
                }
            }
        default:
            return false
        }
    }
    
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        self.photoCompletion = completion
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            photoCompletion?(nil)
            photoCompletion = nil
            return
        }
        photoCompletion?(image)
        photoCompletion = nil
    }
}
