//
//  CameraView.swift
//  MLKitWrapper
//
//  Created by Naveed Shaikh on 25/09/24.
//

import UIKit
import AVFoundation

public class CameraView: UIView {
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var currentDevice: AVCaptureDevice?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCamera()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCamera()
    }

    public func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        currentDevice = videoCaptureDevice

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession?.canAddInput(videoInput) == true) {
            captureSession?.addInput(videoInput)
        } else {
            return
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.frame = layer.bounds
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        layer.addSublayer(videoPreviewLayer!)

        captureSession?.startRunning()
    }

    public func zoomIn() {
        guard let device = currentDevice else { return }
        let newZoomFactor = min(device.videoZoomFactor + 1.0, device.activeFormat.videoMaxZoomFactor)
        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = newZoomFactor
            device.unlockForConfiguration()
        } catch {
            print("Error locking configuration: \(error)")
        }
    }

    public func zoomOut() {
        guard let device = currentDevice else { return }
        let newZoomFactor = max(device.videoZoomFactor - 1.0, 1.0)
        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = newZoomFactor
            device.unlockForConfiguration()
        } catch {
            print("Error locking configuration: \(error)")
        }
    }

    public func toggleTorch() {
        guard let device = currentDevice, device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = device.torchMode == .on ? .off : .on
            device.unlockForConfiguration()
        } catch {
            print("Error locking configuration: \(error)")
        }
    }
}
