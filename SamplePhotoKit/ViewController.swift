//
//  ViewController.swift
//  SamplePhotoKit
//
//  Created by 岩本康孝 on 2021/11/11.
//

import UIKit
import Photos

class ViewController: UIViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!

    private var assets = [PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        indicator.isHidden = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")

//        fetchAssetCollection()
        fetchPhotoLibrary()
        collectionView.reloadData()
    }

//    func fetchAssetCollection() {
//        let smartAlbumData = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
//
//        smartAlbumData.enumerateObjects { (collection, index, _) in
//            let fetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: nil)
//            fetchResult.enumerateObjects({ (asset, index, stop) in
//                // PHAsset -> UIImageへの変換
//                PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 320), contentMode: .aspectFit, options: .none) { [weak self] image, _ in
//                    guard let self = self,
//                        let image = image else { return }
//                    self.images.append(Image(index: index, image: image))
//                }
//            })
//        }
//    }

    func fetchPhotoLibrary() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let options = PHImageRequestOptions()
                options.deliveryMode = .opportunistic
                options.isSynchronous = false
                options.isNetworkAccessAllowed = true
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

                fetchResult.enumerateObjects({ (asset, index, stop) in

                    // PHAsset -> UIImageへの変換
//                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 320), contentMode: .aspectFit, options: options) { [weak self] image, _ in
//                        guard let self = self,
//                            let image = image else { return }
//
//                        DispatchQueue.main.async { [weak self] in
//                            guard let self = self else { return }
//                            self.images.append(image)
//                        }
//
//                    }
//                })
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else { return }
//
//                    self.indicator.stopAnimating()
//                    self.collectionView.reloadData()
                    self.assets.append(asset)
                })

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    self.indicator.stopAnimating()
                    self.collectionView.reloadData()
                }

            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            case .limited:
                print("limited")
            @unknown default:
                break
            }
        }
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.configure(asset: assets[indexPath.row])
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = floor((collectionView.frame.width - 1 * 2) / 3)
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
