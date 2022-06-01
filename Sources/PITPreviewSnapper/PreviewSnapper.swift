import SwiftUI
import XCTest

public class PreviewSnapper {
    private let imageSnapper = ImageSnapper()
    private let fileStorage = FileStorage()
    private var storagePath: String?
    private let drawInHierarchy: Bool
    
    /**
     - Parameter storageFolderRelativePath: Path to the folder where images should be stored, relative to project root
     
     - Parameter drawInHierarchy: Renders complete view hierarchy if true.
     Only set to false if tests is not run towards a simulator or device.
     Might cause unexpected results when false.
     Defaults to true
     
     - Parameter baseStoragePath: Base storage path of where to locate the folder provided.
     Defaults to ${PROJECT_ROOT}/output/snap
     */
    public init(storageFolderRelativePath: String, drawInHierarchy: Bool = true, baseStoragePath: String = #file) {
        self.drawInHierarchy = drawInHierarchy
        storagePath = getFolderAbsolutePath(basePath: baseStoragePath, relativePath: storageFolderRelativePath)?.absoluteString
    }
    
    public func snap(_ item: PreviewSnap) throws {
        let previews = item.preview
        
        for (index, preview) in previews.enumerated() {
            let exp = XCTestExpectation(description: "Waiting for snapshot")
            
            if #available(iOS 15.0, *) {
                item.setOrientation(preview.interfaceOrientation)
            }
            
            item.setFrame(preview.layout)
            
            imageSnapper.snapView(
                preview.content,
                size: try item.getCGSize(for: preview),
                drawInHierarchy: drawInHierarchy
            ) { image in
                DispatchQueue.main.async {
                    self.fileStorage.storeImage(
                        image,
                        atPath: URL(string: self.storagePath!)!,
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
    
    private func getFolderAbsolutePath(basePath: String, relativePath: String) -> URL? {
        var url = URL(string: basePath)!
        var folderAbsolutePath: URL?
        
        // Prevent searching outside of the projects directory scope
        var foundFolder = false
        
        // Bubble upwards from current directory and search recursively all folders for the
        // assets directory until the assets directory is found, and/or the xcode project is found.
        while folderAbsolutePath == nil && !foundFolder {
            var files = [URL]()
            if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
                for case let fileURL as URL in enumerator {
                    do {
                        let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                        if fileAttributes.isRegularFile! {
                            files.append(fileURL)
                        }
                    } catch { print(error, fileURL) }
                }
                
                foundFolder = files.first { $0.absoluteString.contains(relativePath) } != nil
                folderAbsolutePath = files.first { $0.absoluteString.contains(relativePath) }
                url = url.deletingLastPathComponent()
            }
        }
        
        // assetsDirectoryPath is yielded with full path to files inside it, so strip
        // path components until we are at the actual directory
        if folderAbsolutePath != nil {
            while !folderAbsolutePath!.lastPathComponent.contains(relativePath.split(separator: "/").last!) {
                folderAbsolutePath = folderAbsolutePath?.deletingLastPathComponent()
            }
        }
        
        return folderAbsolutePath
    }
}
