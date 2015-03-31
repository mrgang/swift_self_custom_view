//
//  WavesView.swift
//  CustomViewLG
//
//  Created by ligang on 15/3/31.
//  Copyright (c) 2015年 ligang. All rights reserved.
//

import UIKit

class WavesView: UIView {
    var rect: CGRect?
    var _currentWaterColor:UIColor! = UIColor.whiteColor()
    var persent: Int = 10 {
        didSet{
            if persent > 100 {
                persent = 100
            }
            if persent < 0 {
                persent = 0
            }
            label.removeFromSuperview()
            self.setNeedsDisplay()
        }
    }
    
    var a:Float! = 1.5
    var b:Float! = 0
    var jia:Bool! = false
    var label = UILabel()
    func animateWave() {
        if jia! {
            a = a + 0.01
        }else {
            a = a - 0.01
        }
        
        if a <= 1 {
            self.jia = true
        }
        if a >= 1.5 {
            jia = false
        }
        
        b = b + 0.1
        self.setNeedsDisplay()
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.rect = rect
        self.backgroundColor = UIColor.blueColor()
        var context = UIGraphicsGetCurrentContext()
        var path = CGPathCreateMutable()
        var view_width = Int(rect.width)
        //water
        CGContextSetLineWidth(context, 1)
        CGContextSetStrokeColorWithColor(context, _currentWaterColor.CGColor)
        var y = rect.height - rect.height * 0.01 * CGFloat(persent)
        
        CGPathMoveToPoint(path, nil, 0, CGFloat(y))
        for x in 1 ..< view_width {
            var tx = Float(view_width - x)
            var pi = Float(M_PI)
            var tempY = a * sin( tx/180*pi + 4*b/pi) * 6 + Float(y)
            CGPathAddLineToPoint(path, nil, CGFloat(x), CGFloat(tempY))
        }
        CGPathAddLineToPoint(path, nil, rect.height, rect.height)
        CGPathAddLineToPoint(path, nil, 0, rect.height)
        CGPathAddLineToPoint(path, nil, 0, CGFloat(y))
        
        CGContextAddPath(context, path)
        CGContextSetFillColorWithColor(context, UIColor(red: 255, green: 255, blue: 255, alpha: 0.35).CGColor)
        CGContextFillPath(context)
        
        CGPathMoveToPoint(path, nil, 0, CGFloat(y))
        for x in 1 ..< view_width {
            var tx = Float(view_width-x)
            var pi = Float(M_PI)
            var ty = a * sin( tx/180*pi + 4*b/pi + pi) * 6 + Float(y)
            CGPathAddLineToPoint(path, nil, CGFloat(x), CGFloat(ty))
        }
        CGPathAddLineToPoint(path, nil, rect.width, rect.height)
        CGPathAddLineToPoint(path, nil, 0, rect.height)
        CGPathAddLineToPoint(path, nil, 0, CGFloat(y))
        
        CGContextAddPath(context, path)
        CGContextSetFillColorWithColor(context, UIColor(red: 255, green: 255, blue: 255, alpha: 0.35).CGColor)
        CGContextFillPath(context)
        
        label.text = "\(persent)"
        label.textColor = UIColor.orangeColor()
        var ss = CGRectMake(rect.width/2 ,y - 15 , 30,  30)
        label.frame = ss
        self.addSubview(label)
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "animateWave", userInfo: nil, repeats: false)
    }
    
}
