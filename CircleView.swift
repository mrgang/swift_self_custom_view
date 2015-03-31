//
//  CircleView.swift
//  CustomViewLG
//
//  Created by ligang on 15/3/31.
//  Copyright (c) 2015年 ligang. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    let pip = CGFloat(3.141592653/100.000)
    var rect:CGRect?
    var label = UILabel()
    var labelX: CGFloat = 0.0
    var labelY: CGFloat = 0.0
    var changeable = false
    var touchBX: CGFloat = 0
    var touchBY: CGFloat = 0
    @IBInspectable var nowTemp: Int = 16 {
        didSet{
            
        }
    }
    @IBInspectable var goalTemp:Int = 35 {
        didSet{
            if goalTemp > 100 {
                goalTemp = 100
            }
            if goalTemp < 0 {
                goalTemp = 0
            }
            self.setNeedsDisplay()
            label.removeFromSuperview()
        }
        
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.rect = rect
        let context = UIGraphicsGetCurrentContext()
        let midX = rect.midX //中心x
        let midY = rect.midY //中心y
        let size = rect.size //view的大小
        let radio = (3/8) * min(size.height, size.width)
        
        CGContextSetLineWidth(context, radio/2)
        CGContextSetStrokeColorWithColor(context, UIColor(red: 255, green: 255, blue: 255, alpha: 0.2).CGColor)
        CGContextAddArc(context, midX, midY, radio, 0, 6.3, 0)
        CGContextStrokePath(context)
        
        CGContextSetLineWidth(context, radio/4)
        for i in 1...100 {
            if 2*i > nowTemp && 2*i+2 < goalTemp{
                CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
            } else {
                CGContextSetStrokeColorWithColor(context, UIColor(red: 255, green: 255, blue: 255, alpha: 0.3).CGColor)
            }
            var j = CGFloat(2*i)
            var k = CGFloat(2*i+1)
            CGContextAddArc(context, midX, midY, radio, j * pip, k * pip, 0)
            CGContextStrokePath(context)
        }
        //白色指示条
        CGContextSetLineWidth(context, radio/2)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextAddArc(context, midX, midY, radio, CGFloat(nowTemp) * pip, CGFloat(nowTemp+1)*pip, 0)
        CGContextStrokePath(context)
        
        CGContextSetLineWidth(context, 1)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        var x = cos(CGFloat(nowTemp) * pip) *  5*radio/4
        var y = sin(CGFloat(nowTemp) * pip) *  5*radio/4
        CGContextAddArc(context, midX + x, midY + y, 6, 0, 7, 0)
        CGContextFillPath(context)
        
        //橘黄色指示条
        CGContextSetLineWidth(context, radio/2)
        CGContextSetStrokeColorWithColor(context, UIColor.orangeColor().CGColor)
        CGContextAddArc(context, midX, midY, radio, CGFloat(goalTemp-1) * pip, CGFloat(goalTemp)*pip, 0)
        CGContextStrokePath(context)
        
        CGContextSetLineWidth(context, 1)
        CGContextSetFillColorWithColor(context, UIColor.orangeColor().CGColor)
        labelX = cos(CGFloat(goalTemp) * pip) *  5*radio/4
        labelY = sin(CGFloat(goalTemp) * pip) *  5*radio/4
        CGContextAddArc(context, midX + labelX, midY + labelY, 6, 0, 7, 0)
        CGContextFillPath(context)
        label.text = "\(goalTemp)"
        label.textColor = UIColor.orangeColor()
        var ss = CGRectMake(midX + labelX, midY + labelY, 30,  30)
        label.frame = ss
        self.addSubview(label)
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        touchBX = touch.locationInView(self).x - rect!.midX
        touchBY = touch.locationInView(self).y - rect!.midY
        
        if touchBX > labelX - 10 && touchBX < labelX + 10 && touchBY > labelY - 10 && touchBY < labelY + 10 {
            changeable = true
        }
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if changeable {
            let touch = touches.first as! UITouch
            var tbx = touch.locationInView(self).x - rect!.midX
            var tby = touch.locationInView(self).y - rect!.midY
            var tx = touchBX - tbx
            touchBX = tbx
            touchBY = tby
            if tx <= 0 && tby <= 0 || tx > 0 && tby > 0{
                goalTemp++
            }else {
                goalTemp--
            }
        }
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        changeable = false
    }
    
}
