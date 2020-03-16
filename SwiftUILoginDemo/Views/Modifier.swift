//
//  Modifier.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/20.
//

import Foundation
import SwiftUI

struct LoadingModifier: ViewModifier {
    
    @Binding var isLoading: Bool
    func body(content: Content) -> some View {
        ZStack {
            content.allowsHitTesting(!isLoading)
            if isLoading {
                LoadingSwiftUIView()
                    .frame(width: 100, height: 100, alignment: .center)
            }
        }
    }
}

struct LoadingSwiftUIView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<LoadingSwiftUIView>) -> UIView {
        return LoadingView()
    }
    
    func updateUIView(_ uiView: LoadingSwiftUIView.UIViewType, context: UIViewRepresentableContext<LoadingSwiftUIView>) {
    }
}

class LoadingView: UIView {
    
    private var circleLayer = CAShapeLayer()
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        layer.cornerRadius = 10.0
        clipsToBounds = true
        
        //必需放到主线程，延迟0.1秒，不然swift ui不更新
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.addBlurView()
            self.drawCircle()
            self.startAnimation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16.0
        clipsToBounds = true
        addBlurView()
        drawCircle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addBlurView()  {
        let effect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = bounds
        addSubview(blurView)
    }
    
    private func drawCircle() {
           
        circleLayer.frame = bounds
           
        let path = UIBezierPath(arcCenter: CGPoint(x: circleLayer.frame.width / 2, y: circleLayer.frame.height / 2),
                                radius: 30,
                                startAngle: 0,
                                endAngle: CGFloat(Double.pi * 2),
                                clockwise: true)
        circleLayer.path = path.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.darkGray.cgColor
        circleLayer.lineJoin = .round
        circleLayer.lineWidth = 2
           
        layer.addSublayer(circleLayer)
    }
    
    private func startAnimation() {
        
        circleLayer.removeAllAnimations()
        
        //Animations
        let duration: Double = 1.5
           
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.duration = duration * 2
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isRemovedOnCompletion = false
        circleLayer.add(rotationAnimation, forKey: "rotation")
           
        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.fromValue = 0.0
        headAnimation.toValue = 0.3
        headAnimation.duration = duration / 2
           
        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.fromValue = 0.0
        tailAnimation.toValue = 1.0
        tailAnimation.duration = duration / 2
           
        let endHeadAnimation = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnimation.duration = duration / 2
        endHeadAnimation.beginTime = duration - headAnimation.duration
        endHeadAnimation.fromValue = headAnimation.toValue
        endHeadAnimation.toValue = 1.0
           
        let endTailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnimation.beginTime = duration - tailAnimation.duration
        endTailAnimation.duration = duration / 2
        endTailAnimation.fromValue = tailAnimation.toValue
        endTailAnimation.toValue = 1.0
           
        let ani = CAAnimationGroup()
        ani.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        ani.duration = duration
        ani.repeatCount = .infinity
        circleLayer.add(ani, forKey: "stroke")
    }
}

