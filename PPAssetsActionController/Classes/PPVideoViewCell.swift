import UIKit
import AVFoundation

/**
 Cell representing video asset in Assets Collection Controller.
 */
class PPVideoViewCell: PPPhotoViewCell {
    var videoLayer: AVPlayerLayer?

    func set(_ image: UIImage, _ videoLayer: AVPlayerLayer) {
        layer.addSublayer(videoLayer)
        videoLayer.frame = bounds
        self.videoLayer = videoLayer

        set(image)
    }

    func startVideo() {
        videoLayer?.player?.play()
    }
    
    func stopVideo() {
        videoLayer?.player?.pause()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let videoLayer = videoLayer {
            videoLayer.removeFromSuperlayer()
            self.videoLayer = nil
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        videoLayer?.frame = bounds
    }
}
