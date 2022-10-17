import SwiftUI
import UIKit

internal class ImageSnapper {
    func getPreviewAsUIImage(_ preview: _Preview, size: CGSize, drawInHierarchy: Bool) -> UIImage {
        let view = preview.content
        let window = UIWindow(frame: CGRect(origin: .zero, size: UIScreen.main.bounds.size))
        
        let hosting = UIHostingController(rootView: view)
        hosting.view.frame = .init(origin: .init(x: 0, y: 16), size: size)
        
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        
        let imageView = hosting.view!
        let renderer = UIGraphicsImageRenderer(bounds: imageView.frame)
        
        imageView.backgroundColor = .white
            
        let image = renderer.image { ctx in
            if drawInHierarchy {
                imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
            } else {
                imageView.layer.render(in: ctx.cgContext)
            }
        }
        
        return image
    }
}
