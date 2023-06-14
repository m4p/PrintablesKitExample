import SwiftUI
import PrintablesKit
import SceneKit

// Works only on Device, not Simulator

struct STLView: View {
    @State public var print: Print
    @State private var scene: SCNScene?
    @State private var loadingText: String = "Loading"

    var body: some View {
        VStack {
            if let scene {
                SceneView (
                    scene: {
                        scene.background.contents = UIColor.systemBackground
                        return scene
                    }(),
                    options: [.allowsCameraControl, .autoenablesDefaultLighting]
                )
                
            } else {
                ProgressView()
                Text(loadingText)
            }
        }
        .onAppear(perform: loadSTL)
    }
    
    func loadSTL() {
        
        Task {
            loadingText = "Start Conversion"
            guard let file = print.stls?.first else {
                loadingText = "No file"
                return
            }
            
            guard let stlNode = try await file.sceneNode() else {
                loadingText = "Conversion failed"
                return
            }
            
            let newScene = SCNScene()
            loadingText = "Adding Child"
            await newScene.rootNode.addChildNode(stlNode)
            scene = newScene
            
        }
    }
}

struct STLView_Previews: PreviewProvider {
    static var previews: some View {
        STLView(print: Print.preview(0))
    }
}
