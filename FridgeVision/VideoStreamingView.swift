//
//  VideoStreamingView.swift
//  FridgeVision
//
//  Created by Melanie Herbert on 7/25/23.
//

import SwiftUI
import AVKit

struct VideoStreamingView: View {
    var body: some View {
        VideoPlayerController(url: URL(string: "http://raspberrypi_ip:8080/stream"))
            .edgesIgnoringSafeArea(.all)
    }
}

struct VideoPlayerController: UIViewControllerRepresentable {
    let url: URL?

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()

        if let url = url {
            controller.player = AVPlayer(url: url)
            controller.player?.play()
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

