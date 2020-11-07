import UIKit

protocol CustomDrawView: UIView {
    func customDraw()
}

public class DrawUIView: UIView, CustomDrawView {
    public override func draw(_ rect: CGRect){
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext()
        else { return }
        context.customDrawing()
    }
    
    public func customDraw() {
        // Do nothing
    }
}

public class DrawUIViewFlip: UIView, CustomDrawView {
    public override func draw(_ rect: CGRect){
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext()
        else { return }
        context.concatenate(.flippingVerticaly(deviceHeight))
        context.customDrawing()
    }
    
    public func customDraw() {
        // Do nothing
    }
}

public class CurrentContextUIView: UIView, CustomDrawView {
    public func customDraw() {
        UIGraphicsBeginImageContext(CGSize(width: deviceWidth, height: deviceHeight))
        guard let context = UIGraphicsGetCurrentContext()
        else { return }
        
        context.customDrawing()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        addToLayer(cgImage: image.cgImage)
    }
}

public class CurrentContextUIViewFlip: UIView, CustomDrawView {
    public func customDraw() {
        UIGraphicsBeginImageContext(CGSize(width: deviceWidth, height: deviceHeight))
        guard let context = UIGraphicsGetCurrentContext()
        else { return }
        context.concatenate(.flippingVerticaly(deviceHeight))
        context.customDrawing()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        addToLayer(cgImage: image.cgImage)
    }
}

public class CurrentContextUIImageView: UIImageView, CustomDrawView {
    public func customDraw() {
        UIGraphicsBeginImageContext(CGSize(width: deviceWidth, height: deviceHeight))
        guard let context = UIGraphicsGetCurrentContext()
        else { return }
        
        context.customDrawing()
        image = UIGraphicsGetImageFromCurrentImageContext()!
    }
}

public class CurrentContextUIImageViewFlip: UIImageView, CustomDrawView {
    public func customDraw() {
        UIGraphicsBeginImageContext(CGSize(width: deviceWidth, height: deviceHeight))
        guard let context = UIGraphicsGetCurrentContext()
        else { return }
        context.concatenate(.flippingVerticaly(deviceHeight))
        context.customDrawing()
        image = UIGraphicsGetImageFromCurrentImageContext()!
    }
}

public class RendererContextUIView: UIView, CustomDrawView {
    public func customDraw() {
        let size = CGSize(width: deviceWidth, height: deviceHeight)
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderImage = renderer.image { ctx in
            ctx.cgContext.customDrawing()
        }
        addToLayer(cgImage: renderImage.cgImage)
    }
}

public class RendererContextUIViewFlip: UIView, CustomDrawView {
    public func customDraw() {
        let size = CGSize(width: deviceWidth, height: deviceHeight)
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderImage = renderer.image { ctx in
            ctx.cgContext.concatenate(.flippingVerticaly(deviceHeight))
            ctx.cgContext.customDrawing()
        }
        addToLayer(cgImage: renderImage.cgImage)
    }
}

public class RendererContextUIImageView: UIImageView, CustomDrawView {
    public func customDraw() {
        let size = CGSize(width: deviceWidth, height: deviceHeight)
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderImage = renderer.image { ctx in
            ctx.cgContext.customDrawing()
        }
        guard let cgImage = renderImage.cgImage else { return }
        image = UIImage(cgImage: cgImage)
    }
}

public class RendererContextUIImageViewFlip: UIImageView, CustomDrawView {
    public func customDraw() {
        let size = CGSize(width: deviceWidth, height: deviceHeight)
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderImage = renderer.image { ctx in
            ctx.cgContext.concatenate(.flippingVerticaly(deviceHeight))
            ctx.cgContext.customDrawing()
        }
        guard let cgImage = renderImage.cgImage else { return }
        image = UIImage(cgImage: cgImage)
    }
}

public class CoreContextUIView: UIView, CustomDrawView {
    public func customDraw() {
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return }
        guard let context = CGContext(
                        data: nil,
                        width: Int(deviceWidth),
                        height: Int(deviceHeight),
                        bitsPerComponent: 8,
                        bytesPerRow: 0,
                        space: colorSpace,
                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return }
        
        context.customDrawing()
        addToLayer(cgImage: context.makeImage())
    }
}

public class CoreContextUIImageView: UIImageView, CustomDrawView {
    public func customDraw() {
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return }
        guard let context = CGContext(
                        data: nil,
                        width: Int(deviceWidth),
                        height: Int(deviceHeight),
                        bitsPerComponent: 8,
                        bytesPerRow: 0,
                        space: colorSpace,
                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return }
        
        context.customDrawing()
        guard let cgImage = context.makeImage() else { return }
        image = UIImage(cgImage: cgImage)
    }
}
