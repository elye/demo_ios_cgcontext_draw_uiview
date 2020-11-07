import UIKit

public let deviceBounds = UIScreen.main.bounds
public let deviceWidth = deviceBounds.size.width
public let deviceHeight = deviceBounds.size.height
public let frameHeight = CGFloat(300)
public let frameWidth = CGFloat(300)
public let ellipseShrink = CGFloat(20)
public let ellipseWidth = frameWidth - ellipseShrink
public let ellipseHeight = frameHeight - ellipseShrink
public let deviceFrame = CGRect(x:0, y:0, width: deviceWidth, height: deviceHeight)

public extension CGContext {
    func customDrawing() {
        let frame = deviceFrame
        let ellipsePos = CGRect(
            x: (frame.width - ellipseWidth)/2,
            y: (frame.height - ellipseHeight)/2,
            width: ellipseWidth,
            height: ellipseHeight)
        
        let imagePos = CGRect(
            x: (frame.width - frameWidth)/2,
            y: (frame.height - frameHeight)/2,
            width: frameWidth,
            height: frameHeight)
        
        guard let image = UIImage(named: "star"), let cgImage = image.cgImage
        else { return }
        
        setLineWidth(ellipseShrink)
        addEllipse(in: ellipsePos)
        addRect(frame)
        move(to: CGPoint(x: 0, y: 0))
        addLine(to: CGPoint(x: deviceWidth/3, y: deviceHeight/3))
        setStrokeColor(CGColor.init(srgbRed: 0.5, green: 0.0, blue: 0.5, alpha: 0.5))
        strokePath()
        draw(cgImage, in: imagePos)
    }
}

public extension UIView {
    func addToLayer(cgImage: CGImage?) {
        guard let cgImage = cgImage else { return }
        self.layer.sublayers = nil
        let myLayer = CALayer()
        myLayer.frame = deviceFrame
        myLayer.contents = cgImage
        self.layer.addSublayer(myLayer)
    }
}

extension CGAffineTransform {
    static func flippingVerticaly(_ height: CGFloat) -> CGAffineTransform {
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -height)
        return transform
    }
}
