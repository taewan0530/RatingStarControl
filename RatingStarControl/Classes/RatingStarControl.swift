//
//  RatingStarControl.swift
//  DevStudy
//
//  Created by wani.kim on 13/04/2019.
//  Copyright © 2019 wani.kim. All rights reserved.
//

import UIKit

@IBDesignable
public class RatingStarControl: UIControl {
    
    @IBInspectable
    public var currentRating: Float = 0 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    public var maxRate: Int = 5
    
    @IBInspectable
    public var spacing: CGFloat = 4
    
    @IBInspectable
    public var emptyImage: UIImage?
    
    @IBInspectable
    public var fillImage: UIImage?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let point = touches.first?.location(in: self) else { return }
        let x = point.x/bounds.width
        
        currentRating = max(0, min(Float(maxRate), Float(x * CGFloat(maxRate))))
        sendActions(for: .valueChanged)
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = emptyImage?.size ?? CGSize(width: 12, height: 12)
        let width = (size.width + spacing) * CGFloat(maxRate)
        return CGSize(width: width, height: size.height)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard let size = emptyImage?.size ?? fillImage?.size else { return }
        
        let originPoint = CGPoint(x: 0, y: rect.midY - size.height/2)
        
        
        // empty 그리기
        (0..<maxRate).forEach { index in
            let x = (size.width + spacing) * CGFloat(index)
            emptyImage?.draw(at: CGPoint(x: x, y: originPoint.y))
        }
        
        // 마스크 영역 설졍
        let maxWidth = size.width * CGFloat(maxRate)
        let spacingGap = CGFloat(floor(currentRating)) * spacing
        let width = maxWidth * CGFloat(currentRating/Float(maxRate)) + spacingGap
        
        context.clip(to: CGRect(origin: originPoint,
                                size: CGSize(width: width, height: size.height)))
        
        // fill 그리기
        (0..<maxRate).forEach { index in
            let x = (size.width + spacing) * CGFloat(index)
            fillImage?.draw(at: CGPoint(x: x, y: originPoint.y))
        }
        context.resetClip()
    }
    
    private func setup() {
        do {
            let image = self.emptyImage
            self.emptyImage = image ?? UIImage(named: "star_empty", in: .ratingStarControl, compatibleWith: nil)
        }
        
        do {
            let image = self.fillImage
            self.fillImage = image ?? UIImage(named: "star_fill", in: .ratingStarControl, compatibleWith: nil)
        }
    }
    
}
