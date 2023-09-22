//
//  CommonImagePicker.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/22.
//

import Foundation
import YPImagePicker
import SwiftUI
import Combine
import UIKit

struct CommonImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    
    var completion: (([UIImage]) -> Void)?
    var maxCount = 1
    
    func makeUIViewController(context: Context) -> some UIViewController {

        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.isScrollToChangeModesEnabled = false
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        config.showsCrop = .none
        config.shouldSaveNewPicturesToAlbum = true
        
        config.wordings.warningMaxItemsLimit = "사진은 최대 \(maxCount)개 까지만 가능합니다."
        
        config.library.onlySquare = false
        config.library.mediaType = .photo
        config.library.maxNumberOfItems = maxCount
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 3
        config.library.skipSelectionsGallery = true
        
        YPImagePickerConfiguration.shared = config
        
        let picker = YPImagePicker(configuration: config)
        picker.delegate = context.coordinator
        
        picker.didFinishPicking { items, cancelled in
            if !cancelled {
                let images: [UIImage] = items.compactMap { item in
                    if case .photo(let photo) = item {
                        return photo.image
                    } else {
                        return nil
                    }
                }
                completion?(images)
                
            }
            presentationMode.wrappedValue.dismiss()
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate {
        
        let parent: CommonImagePicker
        
        init(_ parent: CommonImagePicker) {
            self.parent = parent
        }
    }
}
