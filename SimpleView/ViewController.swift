import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    private var isNormal = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton(title: "DrawUIView", yPos: 100, drawView: DrawUIView())
        setupButton(title: "DrawUIViewFlip", yPos: 150, drawView: DrawUIViewFlip())
        setupButton(title: "CurrentContextUIView", yPos: 200, drawView: CurrentContextUIView())
        setupButton(title: "CurrentContextUIViewFlip", yPos: 250, drawView: CurrentContextUIViewFlip())
        setupButton(title: "CurrentContextUIImageView", yPos: 300, drawView: CurrentContextUIImageView())
        setupButton(title: "CurrentContextUIImageViewFlip", yPos: 350, drawView: CurrentContextUIImageViewFlip())
        setupButton(title: "RendererContextUIView", yPos: 400, drawView: RendererContextUIView())
        setupButton(title: "RendererContextUIViewFlip", yPos: 450, drawView: RendererContextUIViewFlip())
        setupButton(title: "RendererContextUIImageView", yPos: 500, drawView: RendererContextUIImageView())
        setupButton(title: "RendererContextUIImageViewFlip", yPos: 550, drawView: RendererContextUIImageViewFlip())
        setupButton(title: "CoreContextUIView", yPos: 600, drawView: CoreContextUIView())
        setupButton(title: "CoreContextUIImageView", yPos: 650, drawView: CoreContextUIImageView())
        
        setupNormalSwiftUIOptions()
    }
    
    private func setupButton(title: String, yPos: CGFloat, drawView: CustomDrawView) {
        let button = UIButton(frame: CGRect(x: 0, y: yPos, width: deviceWidth, height: 45))
        button.backgroundColor = .gray
        button.setTitle(title, for: .normal)
        button.add(for: .touchUpInside) { [unowned self] in
            
            let newVC = isNormal ?
                NormalContextViewController(drawView: drawView) :
                SwiftUIContextViewController(drawView: drawView)
            
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: true)
        }
        self.view.addSubview(button)
    }
    
    private func setupNormalSwiftUIOptions() {
        // Initialize
        let items = ["Normal", "SwiftUI"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.main.bounds
        customSC.frame = CGRect(
            x: frame.minX + 10,
            y: 700,
            width: frame.width - 20,
            height: 50)

        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = .gray
        customSC.tintColor = .white
        
        // Add target action method
        customSC.addTarget(self, action: #selector(chooseOption), for: .valueChanged)

        // Add this custom Segmented Control to our view
        self.view.addSubview(customSC)
    }
    
    @objc
    private func chooseOption(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            isNormal = false
        default:
            isNormal = true
        }
    }
}


class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func add (for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(ObjectIdentifier(self).hashValue) + String(controlEvents.rawValue), sleeve,
                             objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

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

class NormalContextViewController: UIViewController {

    let drawView: CustomDrawView
    
    init(drawView: CustomDrawView) {
        self.drawView = drawView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.customDraw()
        view = drawView
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        gesture.direction = .down
        view.addGestureRecognizer(gesture)
    }
        
    @objc
    private func dismissVC() {
        dismiss(animated: true)
    }
}
