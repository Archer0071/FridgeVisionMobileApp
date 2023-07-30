//
//  CameraView.swift
//  FridgeVision
//
//  Created by Melanie Herbert on 7/29/23.
//

import SwiftUI
import AVFoundation
import CoreML
import Vision

struct CameraView: UIViewRepresentable {
    private var captureSession = AVCaptureSession()

    init() {
        // Set up the camera session configuration here
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIView {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return UIView() }
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice)

        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }

        // Video data output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        captureSession.startRunning()

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

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: CameraView
        let model: VNCoreMLModel
        
        init(_ parent: CameraView) {
            self.parent = parent
            self.model = try! VNCoreMLModel(for: SeeFood().model)
            super.init()
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
                if let error = err {
                    print("Core ML error: \(error)")
                    return
                }
                
                guard let results = finishedReq.results as? [VNRecognizedObjectObservation] else { return }
                if let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                    for observation in results {
                        let boundingBox = observation.boundingBox
                        let objectBounds = VNImageRectForNormalizedRect(boundingBox, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))
                        
                        DispatchQueue.main.async {
                            // Handle drawing the bounding boxes and labels here
                        }
                    }
                }
            }
            
            if let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
            }
        }
    }
}
