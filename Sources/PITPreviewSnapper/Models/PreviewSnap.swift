import SwiftUI

public class PreviewSnap {
    public let preview: [_Preview]
    public let filename: String
    internal var frame: PreviewSnapFrame = .matchDevice
    internal var orientation: PreviewSnapOrientation = .portrait
    
    public init(preview: [_Preview], filename: String) {
        self.preview = preview
        self.filename = filename
    }
    
    internal func getCGSize(for preview: _Preview) throws -> (CGSize, UIView?) {
        let size = try frame.getCGSize(for: preview)
        
        return orientation == .portrait
            ? size
            : (CGSize(width: size.0.height, height: size.0.width), size.1)
    }
    
    @discardableResult
    internal func setFrame(_ frame: PreviewLayout) -> Self {
        switch frame {
        case .device:
            self.frame = .matchDevice
        case .sizeThatFits:
            self.frame = .sizeToFit
        case .fixed(let width, let height):
            self.frame = .fixed(width: .value(width), height: .value(height))
        }
        
        return self
    }
    
    @discardableResult
    public func setOrientation(_ orientation: PreviewSnapOrientation) -> Self {
        self.orientation = orientation
        return self
    }
}
