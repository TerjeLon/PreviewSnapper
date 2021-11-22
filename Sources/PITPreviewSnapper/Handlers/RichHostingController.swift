import Foundation
import SwiftUI

class RichHostingController<Content>: UIHostingController<Content> where Content: View {
    var onLayoutFinished: (() -> Void)?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.onLayoutFinished?()
        }
    }
}
