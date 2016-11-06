import Photos

struct PPAssetManager {
    func getImages(offset: Int, count: Int, handler: @escaping ([UIImage]) -> ()) {
        guard authorizationStatus() == .authorized else {
            handler([])
            return
        }

        var assets: [UIImage] = []
        let fetchOptions = PHFetchOptions()
        if #available(iOS 9.0, *) {
            fetchOptions.fetchLimit = offset + count
        }
        fetchOptions.wantsIncrementalChangeDetails = false
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]

        let result = PHAsset.fetchAssets(with: .image,
                                         options: fetchOptions)
        var counter = 0
        result.enumerateObjects(
        { asset, index, stop in
            PHImageManager.default().requestImageData(for: asset,
                                                      options: nil)
            { imageData, dataUTI, orientation, info in
                imageData.map {
                    if let image = UIImage(data: $0) {
                        assets.append(image)
                    }
                    counter += 1
                    if (counter == result.count) {
                        handler(assets)
                    }
                }
            }
        })
    }

    func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                handler(status)
            }
        }
    }

    func authorizationStatus() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
}
