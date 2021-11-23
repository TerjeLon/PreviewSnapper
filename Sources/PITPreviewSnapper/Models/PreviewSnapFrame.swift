import UIKit
import SwiftUI

internal enum PreviewSnapSize {
    case matchDevice
    case value(_ n: CGFloat)
}

internal enum PreviewSnapFrame {
    /// Matches simulator device bounds running the snapshotter
    case matchDevice
    
    /// Matches the bounds of the view being snapshotted
    case sizeToFit
    
    /// Sets the exact frame provided
    case fixed(width: PreviewSnapSize, height: PreviewSnapSize)
    
    internal func getCGSize(for preview: _Preview) throws -> (CGSize, UIView?) {
        switch self {
        case .matchDevice:
            return (UIScreen.main.bounds.size, nil)
        case .sizeToFit:
            return try calculateSizeToFit(for: preview)
        case .fixed(let width, let height):
            var _width = UIScreen.main.bounds.width
            var _height = UIScreen.main.bounds.height
            
            if case let .value(n) = width {
                _width = n
            }
            
            if case let .value(n) = height {
                _height = n
            }
            
            return (CGSize(width: _width, height: _height), nil)
        }
    }
    
    private func calculateSizeToFit(for preview: _Preview) throws -> (CGSize, UIView?) {
        let window = UIWindow(frame: CGRect(origin: .zero, size: UIScreen.main.bounds.size))
        let hosting = UIHostingController(rootView: preview.content)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        hosting.view.setNeedsLayout()
        hosting.view.layoutIfNeeded()
        
        if let scrollview = getScrollview(inView: hosting.view) {
            // Unsure where the 5 extra units come from, should be found
            return (CGSize(width: scrollview.frame.maxX, height: scrollview.frame.maxY + (hosting.view.safeAreaInsets.top - 5)), hosting.view)
        } else {
            guard let size = hosting.view.subviews.first?.bounds.size else {
                throw PreviewSnapFrameError.sizeToFitNoBoundsFound
            }
            
            return (CGSize(width: size.width, height: size.height), hosting.view)
        }
    }
    
    private func getScrollview(inView view: UIView) -> UIView? {
        return getRecursiveSubviews(fromView: view)
            .filter { $0.description.contains("HostingScrollView22PlatformGroupContainer") }
            .first
    }
    
    private func getRecursiveSubviews(fromView view: UIView) -> [UIView] {
        return view.subviews + view.subviews.flatMap { getRecursiveSubviews(fromView: $0) }
    }
}
