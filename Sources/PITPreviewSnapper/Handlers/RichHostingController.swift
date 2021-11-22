import Foundation
import SwiftUI

class RichHostingController<Content>: UIHostingController<Content> where Content: View {
    var onLayoutFinished: (() -> Void)?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Denne er litt stygg, må finne en måte å faktisk vente på states til å oppdatere seg
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.onLayoutFinished?()
        }
    }
}
