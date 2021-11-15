import SwiftUI
import UIKit

internal class ImageSnapper {
    
    private func getRenderedImageOfView(_ view: UIView, drawInHierarchy: Bool = true) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        
        view.frame.origin = .init(x: 0, y: view.safeAreaInsets.top)
        view.backgroundColor = .clear
        
        return renderer.image { ctx in
            if drawInHierarchy {
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            } else {
                view.layer.render(in: ctx.cgContext)
            }
        }
    }
    
    internal func snapView<T: View>(_ view: T, size: CGSize, drawInHierarchy: Bool = true) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        let hosting = UIHostingController(rootView: view)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return getRenderedImageOfView(hosting.view, drawInHierarchy: drawInHierarchy)
    }
}
