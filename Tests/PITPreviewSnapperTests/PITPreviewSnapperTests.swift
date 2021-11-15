import XCTest
import SwiftUI
@testable import PITPreviewSnapper

final class PITPreviewSnapperTests: XCTestCase {
    func testWithoutHierarchy() throws {
        let snapper = PreviewSnapper(drawInHierarchy: false)
        
        try! snapper.snap(
            PreviewSnap(
                preview: Test_Previews._allPreviews,
                filename: "Test"
            ).setFrame(.sizeToFit)
        )
    }
}

private struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: 50, height: 50)
    }
}
