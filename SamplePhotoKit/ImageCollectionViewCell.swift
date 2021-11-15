//
//  ImageCollectionViewCell.swift
//  SamplePhotoKit
//
//  Created by 岩本康孝 on 2021/11/13.
//

import UIKit
import Photos

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(asset: PHAsset?) {
        guard let asset = asset else { return }

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 320), contentMode: .aspectFit, options: options) { [weak self] image, _ in
            guard let self = self,
                  let image = image else { return }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                self.imageView.image = image
            }

        }
    }
}
