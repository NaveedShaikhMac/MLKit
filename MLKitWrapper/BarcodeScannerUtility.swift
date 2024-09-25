//
//  MLKitManager.swift
//  MLKitWrapper
//
//  Created by Naveed Shaikh on 25/09/24.
//

import Foundation
import MLKitBarcodeScanning
import MLKitVision
import UIKit

public class BarcodeScannerUtility { // Renamed class
    private let barcodeScanner: MLKitBarcodeScanning.BarcodeScanner

    public init() {
        // Initialize with BarcodeScannerOptions
        let options = BarcodeScannerOptions(formats: .all)
        barcodeScanner = BarcodeScanner.barcodeScanner(options: options)
    }

    public func scanBarcode(from image: UIImage, completion: @escaping (String?) -> Void) {
        let visionImage = VisionImage(image: image)

        // Use the barcodeScanner instance to process the image
        barcodeScanner.process(visionImage) { barcodes, error in
            if let error = error {
                print("Barcode scanning failed: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let barcodes = barcodes, !barcodes.isEmpty {
                completion(barcodes.first?.displayValue) // Get the first barcode value
            } else {
                completion(nil)
            }
        }
    }
}




