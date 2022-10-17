import XCTest
import SwiftUI
@testable import PITPreviewSnapper

final class PITPreviewSnapperTests: XCTestCase {
    let snapper = PreviewSnapper(storageFolderRelativePath: "Tests/output/snaps", drawInHierarchy: false)
    
    func testWithoutHierarchyDevice() throws {
        try! snapper.snap(
            PreviewSnap(
                preview: Test_Device._allPreviews,
                filename: "Test"
            )
        )
    }
    
    func testWithoutHierarchySizeFits() {
        try! snapper.snap(
            PreviewSnap(
                preview: Test_SizeFits._allPreviews,
                filename: "Test"
            )
        )
    }
    
    func testWithoutHierarchyLandscape() {
        try! snapper.snap(
            PreviewSnap(
                preview: Test_Landscape._allPreviews,
                filename: "Test"
            )
        )
    }
}

struct Test_Device: PreviewProvider {
    static var previews: some View {
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

struct Test_SizeFits: PreviewProvider {
    static var previews: some View {
        Group {
            Rectangle()
                .fill(Color.red)
                .frame(width: 50, height: 50)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("_sizeToFit")
            
            Rectangle()
                .fill(Color.red)
                .frame(width: 50, height: 100)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("_sizeToFit2")
        }
    }
}

struct Test_Landscape: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
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
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("_landscape")
        }
    }
}
