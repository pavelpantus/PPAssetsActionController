import Photos

struct PPAssetManager {
    
    /// Returns images only.
    func getImages(offset: Int, count: Int, handler: @escaping ([MediaProvider]) -> ()) {
        guard authorizationStatus() == .authorized else {
            handler([])
            return
        }

        let result = PHAsset.fetchAssets(with: .image, options: getFetchOptions(offset, count))

        /**
         Ok, here goes some magic! ✨🙀👀
         requestImageData is async and can return in random order.
         But I want the order to ALWAYS be preserved so I can screenshot-match it.
         That's why I allocate space in the array for each image returned
         in result by setting placeholder images.
         And once they're loaded I set them using the index from the result.
         By doing this I preserve the order. Screenshots matcher is happy and so am I! 🍻
         */
        let placeholder = UIImage(named: "checked", in: Bundle(for: PPAssetsActionController.classForCoder()), compatibleWith: nil)!
        var assets = Array(repeating: AnyPPAsset(placeholder), count: result.count)

        var counter = 0
        result.enumerateObjects(
        { asset, index, stop in
            PHImageManager.default().requestImageData(for: asset,
                                                      options: nil)
            { imageData, dataUTI, orientation, info in
                imageData.map {
                    if let image = UIImage(data: $0) {
                        assets[index] = AnyPPAsset(image)
                    }
                    counter += 1
                    if (counter == result.count) {
                        handler(assets)
                    }
                }
            }
        })
    }

    /// Returns images and videos.
    func getAssets(offset: Int, count: Int, handler: @escaping ([UIImage]) -> ()) {
    }
    
    func getFetchOptions(_ offset: Int, _ count: Int) -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        if #available(iOS 9.0, *) {
            fetchOptions.fetchLimit = offset + count
        }
        fetchOptions.wantsIncrementalChangeDetails = false
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        return fetchOptions
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
