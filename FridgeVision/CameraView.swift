//
//  CameraView.swift
//  FridgeVision
//
//  Created by Melanie Herbert on 7/29/23.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    private var captureSession: AVCaptureSession

    init() {
        captureSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice)

        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }

        captureSession.startRunning()
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        DispatchQueue.main.async {
            previewLayer.frame = view.bounds
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?[0] as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
}
