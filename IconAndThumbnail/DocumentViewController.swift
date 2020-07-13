//
//  DocumentViewController.swift
//  IconAndPreview
//
//  Created by Mark Alldritt on 2020-07-12.
//  Copyright © 2020 Mark Alldritt. All rights reserved.
//

import UIKit
import QuickLookThumbnailing


class DocumentViewController: UIViewController {
    
    @IBOutlet weak var documentNameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var thumbnailLabel: UILabel!
    
    var document: UIDocument?
    let thumbnailSize = CGSize(width: 320, height: 320)
    let scale = UIScreen.main.scale

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                guard let documentURL = self.document?.fileURL else { return }
                
                // Display the content of the document, e.g.:
                self.documentNameLabel.text = documentURL.lastPathComponent
                
                // Display the thumbnail
                let request1 = QLThumbnailGenerator.Request(fileAt: documentURL,
                                                           size: self.thumbnailSize,
                                                           scale: self.scale,
                                                           representationTypes: .icon)

                QLThumbnailGenerator.shared.generateBestRepresentation(for: request1) { (thumbnail, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            self.iconLabel.text = "type: icon\n\(error.localizedDescription)"
                        }
                    } else if let thumb = thumbnail {
                        let image = thumb.uiImage
                        DispatchQueue.main.async {
                            self.iconImage.image = image
                            self.iconLabel.text = "type: icon\nsize: \(image.size)"
                        }
                    }
                }

                let request2 = QLThumbnailGenerator.Request(fileAt: documentURL,
                                                           size: self.thumbnailSize,
                                                           scale: self.scale,
                                                           representationTypes: .thumbnail)

                QLThumbnailGenerator.shared.generateBestRepresentation(for: request2) { (thumbnail, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            self.thumbnailLabel.text = "type: thumbnail\n\(error.localizedDescription)"
                        }
                    } else if let thumb = thumbnail {
                        let image = thumb.uiImage
                        DispatchQueue.main.async {
                            self.thumbnailImage.image = image
                            self.thumbnailLabel.text = "type: thumbnail\nsize: \(image.size)"
                        }
                    }
                }

            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}
