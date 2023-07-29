//
//  VideoStreamingView.swift
//  FridgeVision
//
//  Created by Melanie Herbert on 7/25/23.
//

import SwiftUI
import AVFoundation

struct VideoStreamingView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 0) // Pushes the camera view towards the top
            CameraView()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Adjusts the size of the camera view
            Spacer(minLength: 0) // Pushes the camera view towards the bottom
        }
        .navigationTitle("Live Stream")
    }
}
