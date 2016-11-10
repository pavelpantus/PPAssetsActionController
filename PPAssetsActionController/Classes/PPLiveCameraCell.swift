import UIKit
import AVFoundation

class PPLiveCameraCell: UICollectionViewCell, PPReusableView {

    func set(layer: AVCaptureVideoPreviewLayer) {
        layer.frame = bounds
        self.layer.insertSublayer(layer, at: 0)
    }

    override func layoutSubviews() {
        self.layer.sublayers?[0].frame = bounds
    }
}
