//
//  ImagePicker.swift
//  aac-ios
//
//  Created by Asma on 11/8/23.
//

import Foundation
import PhotosUI
import SwiftUI

//code for only gallery using phppicker
//struct ImagePicker: UIViewControllerRepresentable {
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            // Tell the picker to go away
//            picker.dismiss(animated: true)
//
//            // Exit if no selection was made
//            guard let provider = results.first?.itemProvider else { return }
//
//            // If this has an image we can use, use it
//            if provider.canLoadObject(ofClass: UIImage.self) {
//                provider.loadObject(ofClass: UIImage.self) { image, _ in
//                    self.parent.image = image as? UIImage
//                }
//            }
//        }
//
//        var parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//    }
//
//    @Binding var image: UIImage?
//
//
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.filter = .images
//
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {    }
//
//    typealias UIViewControllerType = PHPickerViewController
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//}


struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // PHPickerViewControllerDelegate
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }

        // UIImagePickerControllerDelegate for camera
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        // UIImagePickerControllerDelegate for camera cancellation
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    var sourceType: UIImagePickerController.SourceType

    init(image: Binding<UIImage?>, sourceType: UIImagePickerController.SourceType) {
        _image = image
        self.sourceType = sourceType
    }

    func makeUIViewController(context: Context) -> UIViewController {
        if sourceType == .camera && UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = sourceType
            return picker
        } else {
            var config = PHPickerConfiguration()
            config.filter = .images

            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
