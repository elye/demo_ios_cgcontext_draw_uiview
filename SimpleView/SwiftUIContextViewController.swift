import SwiftUI

class SwiftUIContextViewController: UIHostingController<ContentView> {

    var contentView: ContentView
    
    init(drawView: CustomDrawView) {
        self.contentView = ContentView(drawView: drawView)
        super.init(rootView: self.contentView)
        myHostVc = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

var myHostVc: UIHostingController<ContentView>? = nil

struct ContentView : View {
    
    let drawView: CustomDrawViewWrapper
    
    init(drawView: CustomDrawView) {
        self.drawView = CustomDrawViewWrapper(drawView: drawView)
    }
    
    var body: some View {
        drawView
            .edgesIgnoringSafeArea(.all)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.height > 0 {
                                myHostVc?.dismiss(animated: true)
                            }
                        }))
        
        
    }
}

struct CustomDrawViewWrapper : UIViewRepresentable {
    
    let drawView: CustomDrawView
    
    init(drawView: CustomDrawView) {
        self.drawView = drawView
    }
    
    func makeUIView(context: Context) -> UIView {
        return drawView
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        (uiView as? CustomDrawView)?.customDraw()
        uiView.backgroundColor = .white
    }
}
