import SwiftUI
import UIKit

internal class ImageSnapper {
    
    private func getRenderedImageOfView(_ view: UIView, size: CGSize, drawInHierarchy: Bool = true) -> UIImage {
        view.bounds.size = size
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
    
    internal func snapView<T: View>(_ view: T, size: (CGSize, UIView?), drawInHierarchy: Bool = true, completion: @escaping (UIImage) -> Void) {
        if let renderView = size.1 {
            let window = UIWindow(frame: CGRect(origin: .zero, size: size.0))
            window.addSubview(renderView)
            window.makeKeyAndVisible()
            
            completion(self.getRenderedImageOfView(renderView, size: size.0, drawInHierarchy: drawInHierarchy))
        } else {
            let window = UIWindow(frame: CGRect(origin: .zero, size: size.0))
            let hosting = RichHostingController(rootView: view)
            
            hosting.onLayoutFinished = {
                hosting.onLayoutFinished = nil
                completion(self.getRenderedImageOfView(hosting.view, size: size.0, drawInHierarchy: drawInHierarchy))
            }
            
            hosting.view.frame = window.frame
            window.addSubview(hosting.view)
            window.makeKeyAndVisible()
            hosting.view.setNeedsDisplay()
            hosting.view.setNeedsLayout()
            hosting.view.layoutIfNeeded()
        }
    }
}
