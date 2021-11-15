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
    public func setFrame(_ frame: PreviewSnapFrame) -> Self {
        self.frame = frame
        return self
    }
    
    @discardableResult
    public func setOrientation(_ orientation: PreviewSnapOrientation) -> Self {
        self.orientation = orientation
        return self
    }
}
