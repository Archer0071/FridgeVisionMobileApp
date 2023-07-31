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
    @State private var detectedObjects: [String] = []
    
    
    init() {
        // Set up the camera session configuration here
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIView {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return UIView() }
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            return UIView()
        }
        
        // Video data output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
        
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.main.async {
            previewLayer.frame = view.bounds
        }
        
        // Store the previewLayer in the coordinator
        context.coordinator.previewLayer = previewLayer
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = context.coordinator.previewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: CameraView
        var previewLayer: AVCaptureVideoPreviewLayer?
        let model = try! VNCoreMLModel(for: ObjectDetector(configuration: MLModelConfiguration()).model)
        init(_ parent: CameraView) {
            self.parent = parent
            
            super.init()
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
                if let error = err {
                    print("Core ML error: \(error)")
                    return
                }
                
                guard let results = finishedReq.results as? [VNRecognizedObjectObservation] else { return }
                    for observation in results {
                        DispatchQueue.main.async {
//                            its showing labels
                            print(observation.labels)
                        }
                    }
                
            }
            
            if let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
            }
        }
        
        struct CameraView_Previews: PreviewProvider {
            static var previews: some View {
                CameraView()
            }
        }
    }
}
