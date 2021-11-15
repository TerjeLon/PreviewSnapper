import Foundation
import UIKit

internal class FileStorage {
    internal func storeImage(_ image: UIImage, atPath path: URL, named filename: String) {
        if !FileManager.default.fileExists(atPath: path.path) {
            do {
                try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
            }
            catch {}
        }
        
        var fileUrl = path.appendingPathComponent(filename)
        fileUrl.appendPathExtension("png")
        let data = image.pngData()
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            try? FileManager.default.removeItem(atPath: fileUrl.path)
        }
        
        do {
            try data!.write(to: fileUrl)
        } catch let error {
            print(error)
        }
    }
}
