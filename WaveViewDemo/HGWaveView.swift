//
//  HGWaveView.swift
//  WaveViewDemo
//
//  Created by Harvey Zhang on 2016/12/6.
//  Copyright © 2016 HappyGuy. All rights reserved.
//

import UIKit

class HGWaveView: UIView {

    var waveFrequency: CGFloat = 1.5
    var waveSpeed: CGFloat = 0.6
    var waveHeight: CGFloat = 5
	
	var floatingView: UIView?				// floating view on the wave
	fileprivate var timer: CADisplayLink?	// control waving timer
	
    fileprivate var realWaveLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var maskWaveLayer: CAShapeLayer = CAShapeLayer()
	
    var realWaveColor: UIColor = UIColor.orange {
        didSet {
            realWaveLayer.fillColor = realWaveColor.cgColor
        }
    }
    var maskWaveColor: UIColor = .orange {
        didSet {
            maskWaveLayer.fillColor = maskWaveColor.cgColor
        }
    }
	
    fileprivate var mFreqOffset: CGFloat = 0
    fileprivate var mFrequency: CGFloat = 0
    fileprivate var mWaveSpeed: CGFloat = 0
    fileprivate var mWaveHeight: CGFloat = 0
    fileprivate var isStarting: Bool = false
    fileprivate var isStopping: Bool = false
	
	// MARK: - Inits
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var f = self.bounds
        f.origin.y = frame.size.height
        f.size.height = 0
        maskWaveLayer.frame = f
        realWaveLayer.frame = f
        self.backgroundColor = .clear
        
        self.layer.addSublayer(realWaveLayer)
        self.layer.addSublayer(maskWaveLayer)
    }
	
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        
        realWaveColor = color
        maskWaveColor = color.withAlphaComponent(0.5)
        
        realWaveLayer.fillColor = realWaveColor.cgColor
        maskWaveLayer.fillColor = maskWaveColor.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	// MARK: - Public APIs
    
    // add floating view
    func addFloatingView(oView: UIView) -> Void
	{
        floatingView = oView
        floatingView?.center = self.center
        floatingView?.frame.origin.y = self.frame.height - (floatingView?.frame.height)!
        self.addSubview(floatingView!)
    }
    
    // start to wave/float the view
    func startWave() -> Void
	{
        if !isStarting {
            stop()	// clean up first
			
            isStarting = true
            isStopping = false
            mWaveHeight = 0
            mFrequency = 0
            mWaveSpeed = 0
			
			/*
			A CADisplayLink object is a timer object that allows your application to synchronize its drawing to the refresh rate of the display.
			Your application initializes a new display link, providing a target object and a selector to be called when the screen is updated. To synchronize your display loop with the display, your application adds it to a run loop using the add(to:forMode:) method.
			*/
			timer = CADisplayLink(target: self, selector: #selector(waveEvent))
			
			/*
			Registers the display link with a run loop.
			You can associate a display link with multiple input modes. While the run loop is executing in a mode you have specified, the display link notifies the target when new frames are required.
			The run loop retains the display link. To remove the display link from all run loops, send an invalidate() message to the display link.
			*/
            timer?.add(to: .current, forMode: .commonModes)
        }
    }
    
    // To remove the display link from all run loops, send an invalidate() message to the display link.
    func stop() -> Void
	{
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    // stop wave the view
    func stopWave() -> Void
	{
        if !isStopping {
            isStarting = false
            isStopping = true
        }
    }
    
    // wave callback
	func waveEvent() -> Void {
        
        if isStarting {
            if mWaveHeight < waveHeight {
                mWaveHeight = mWaveHeight + waveHeight/100.0
                var f = self.bounds
                f.origin.y = f.size.height - mWaveHeight
                f.size.height = mWaveHeight
                maskWaveLayer.frame = f
                realWaveLayer.frame = f
                mFrequency = mFrequency + waveFrequency/100.0
                mWaveSpeed = mWaveSpeed + waveSpeed/100.0
            }
			else {
                isStarting = false
            }
        }
        
        if isStopping {
            if mWaveHeight > 0 {
                mWaveHeight = mWaveHeight - waveHeight / 50.0
                var f = self.bounds
                f.origin.y = f.size.height
                f.size.height = mWaveHeight
                maskWaveLayer.frame = f
                realWaveLayer.frame = f
                mFrequency = mFrequency - waveFrequency / 50.0
                mWaveSpeed = mWaveSpeed - waveSpeed / 50.0
            }
			else {
                isStopping = false
                //stopWave()	// old del
				stop()		// new HZ
            }
        }
        
        mFreqOffset += mWaveSpeed
        
        let width = frame.width
        let height = CGFloat(mWaveHeight)
        
        let wavePath = CGMutablePath()
        wavePath.move(to: CGPoint(x: 0, y: height))
        var y: CGFloat = 0
        
        let maskPath = CGMutablePath()
        maskPath.move(to: CGPoint(x: 0, y: height))
        
        let offset_f = Float(mFreqOffset * 0.045)
        let waveFrequency_f = Float(0.01 * mFrequency)
        
        for x in 0...Int(width) {
            y = height * CGFloat(sinf(waveFrequency_f * Float(x) + offset_f))
            wavePath.addLine(to: CGPoint(x: CGFloat(x), y: y))
            maskPath.addLine(to: CGPoint(x: CGFloat(x), y: -y))
        }
		
        if floatingView != nil {
            let cX = self.bounds.size.width/2
            let cY = height * CGFloat(sinf(waveFrequency_f * Float(cX) + offset_f))
            let center = CGPoint(x: cX , y: cY + self.bounds.size.height - floatingView!.bounds.size.height/2 - mWaveHeight - 1 )
            floatingView?.center = center
        }
        
        wavePath.addLine(to: CGPoint(x: width, y: height))
        wavePath.addLine(to: CGPoint(x: 0, y: height))
        wavePath.closeSubpath()		// Closes and completes a subpath in a mutable graphics path.
        self.realWaveLayer.path = wavePath
        
        maskPath.addLine(to: CGPoint(x: width, y: height))
        maskPath.addLine(to: CGPoint(x: 0, y: height))
        maskPath.closeSubpath()
        self.maskWaveLayer.path = maskPath
    }
	
}//End-Class
