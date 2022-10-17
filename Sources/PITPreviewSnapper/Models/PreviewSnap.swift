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
    
    internal func getCGSize(for preview: _Preview) throws -> CGSize {
        let size = try frame.getCGSize(for: preview)
        
        return orientation == .portrait
            ? size
            : CGSize(width: size.height, height: size.width)
    }
    
    @discardableResult
    internal func setFrame(_ frame: PreviewLayout) -> Self {
        switch frame {
        case .sizeThatFits:
            self.frame = .sizeToFit
        case .fixed(let width, let height):
            self.frame = .fixed(width: .value(width), height: .value(height))
        default:
            self.frame = .matchDevice
        }
        
        return self
    }
    
    @available(iOS 15.0, *)
    @discardableResult
    internal func setOrientation(_ orientation: InterfaceOrientation) -> Self {
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            self.orientation = .landscape
        default:
            self.orientation = .portrait
        }
        
        return self
    }
}
