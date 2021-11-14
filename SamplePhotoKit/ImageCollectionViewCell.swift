//
//  ImageCollectionViewCell.swift
//  SamplePhotoKit
//
//  Created by 岩本康孝 on 2021/11/13.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(image: UIImage?) {
        imageView.image = image
    }
}
