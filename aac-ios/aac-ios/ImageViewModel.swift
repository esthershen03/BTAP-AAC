//
//  ImageViewModel.swift
//  aac-ios
//
//  Created by Asma on 4/4/24.
//

import Foundation
import SwiftUI
import CoreData

class ImageViewModel: ObservableObject {
    private let imageKey = "imageData"

    func saveImage(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: imageKey)
        }
    }

    func loadImage() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: imageKey) {
            return UIImage(data: imageData)
        }
        return nil
    }
}
