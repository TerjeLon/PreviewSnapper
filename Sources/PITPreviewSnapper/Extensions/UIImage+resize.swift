import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let scalingFactor = UIScreen.main.scale
        let scaledSizeWidth = size.width / scalingFactor
        let scaledSizeHeight = size.height / scalingFactor
        let size = CGSize(width: scaledSizeWidth, height: scaledSizeHeight)
        
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
