import SwiftUI
import XCTest

public class PreviewSnapper {
    private let imageSnapper = ImageSnapper()
    private let fileStorage = FileStorage()
    private let storagePath: String
    private let drawInHierarchy: Bool
    
    /// - Parameter path: Base storage path of where to create the "snaps" folder with corresponding snaps added to it.
    /// Defaults to ${PROJECT_ROOT}/output/snaps
    public init(baseStoragePath path: String = #file, drawInHierarchy: Bool = true) {
        let fileUrl = URL(fileURLWithPath: path, isDirectory: true)
        let directory = fileUrl
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("output")
            .appendingPathComponent("snaps")
        
        storagePath = directory.absoluteString
        self.drawInHierarchy = drawInHierarchy
    }
    
    public func snap(_ item: PreviewSnap) throws {
        let previews = item.preview
        
        for (index, preview) in previews.enumerated() {
            let exp = XCTestExpectation(description: "Waiting for snapshot")
            
            imageSnapper.snapView(
                preview.content,
                size: try item.getCGSize(for: preview),
                drawInHierarchy: drawInHierarchy
            ) { image in
                DispatchQueue.main.async {
                    self.fileStorage.storeImage(
                        image,
                        atPath: URL(string: self.storagePath)!,
                        named: self.getFilename(o: item, index: index, preview: preview)
                    )
                }
                
                exp.fulfill()
            }
            
            _ = XCTWaiter.wait(for: [exp], timeout: 3)
        }
    }
    
    private func getFilename(o: PreviewSnap, index: Int, preview: _Preview) -> String {
        if let displayname = preview.displayName {
            return "\(o.filename)\(displayname)"
        }
        
        if o.preview.endIndex > 1 {
            return "\(index)\(o.filename)"
        }
        
        return o.filename
    }
}
