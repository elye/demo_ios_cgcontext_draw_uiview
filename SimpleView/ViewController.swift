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
