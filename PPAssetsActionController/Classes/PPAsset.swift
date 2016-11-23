import Foundation
import AVFoundation

/**
 Protocol representation of types of media that asset can provide.
 Image assets will return full image as an image and nil video.
 Video assets will return thumbnail as an image and AVAsset as video.
 */
public protocol MediaProvider {
    func image() -> UIImage?
    func video() -> AVAsset?
}

/**
 Protocol representation of an asset.
 */
protocol PPAsset: MediaProvider {
    associatedtype AssetType
    var asset: AssetType { get }
}

/**
 Default implementations of MediaProviding protocol methods.
 */
extension PPAsset {
    public func image() -> UIImage? {
        var result: UIImage?
        
        if let image = asset as? UIImage {
            result = image
        } else if let avasset = asset as? AVAsset {
            let imageGenerator = AVAssetImageGenerator(asset: avasset)
            imageGenerator.appliesPreferredTrackTransform = true
            var time = avasset.duration
            time.value = min(time.value, 1)
            
            if let imageRef = try? imageGenerator.copyCGImage(at: time, actualTime: nil) {
                result = UIImage(cgImage: imageRef)
            }
        }
        
        return result
    }
    
    public func video() -> AVAsset? {
        var result: AVAsset?
        
        if let avasset = asset as? AVAsset {
            result = avasset
        }
        
        return result
    }
}

/**
 Conforming asset types.
 */
extension UIImage: PPAsset {
    internal var asset: UIImage {
        return self
    }
}
extension AVAsset: PPAsset {
    internal var asset: AVAsset {
        return self
    }
}

/**
 Type erasing wrapper around PPAsset.
 Covariance is not supported as of Swift 3.
 */
struct AnyPPAsset<AssetType>: PPAsset {
    let base: AssetType
    
    init<A : PPAsset>(_ base: A) where A.AssetType == AssetType {
        self.base = base.asset
    }
    
    internal var asset: AssetType {
        return base
    }
}
