import UIKit

class ViewController: UIViewController {

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
    }
    
    private func setupButton(title: String, yPos: CGFloat, drawView: CustomDrawView) {
        let button1 = UIButton(frame: CGRect(x: 0, y: yPos, width: deviceWidth, height: 45))
        button1.backgroundColor = .gray
        button1.setTitle(title, for: .normal)
        button1.add(for: .touchUpInside) { [unowned self] in
            self.present(
                ContextViewController(drawView: drawView), animated: true)
        }
        self.view.addSubview(button1)
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

class ContextViewController: UIViewController {

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
        self.view = drawView

        self.view.backgroundColor = .white
    }
}
