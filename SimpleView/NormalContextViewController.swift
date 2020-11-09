import UIKit

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
