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
            )
        )
        
        try! snapper.snap(
            PreviewSnap(
                preview: Test_Landscape._allPreviews,
                filename: "Test_Landscape"
            ).setOrientation(.landscape)
        )
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Rectangle()
                .fill(Color.red)
                .frame(width: 50, height: 50)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("_sizeToFit")
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 50, height: 50)
                    Spacer()
                }
                Spacer()
            }
            .background(Color.white)
            .previewLayout(.device)
            .previewDisplayName("_matchDevice")
        }
    }
}

struct Test_Landscape: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 50, height: 80)
                Spacer()
            }
            Spacer()
        }
        .background(Color.white)
    }
}
