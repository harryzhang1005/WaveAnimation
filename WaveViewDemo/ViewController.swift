//
//  ViewController.swift
//  WaveViewDemo
//
//  Created by Harvey Zhang on 2016/12/6.
//  Copyright © 2016 HappyGuy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var waterView: HGWaveView?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /// Init Avatar for floating
        let avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        avatar.layer.cornerRadius = avatar.bounds.height/2
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor  = UIColor.white.cgColor
        avatar.layer.borderWidth = 3
        avatar.layer.contents = UIImage(named: "harvey")?.cgImage
		
		/// Crate a wave view
        waterView = HGWaveView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 200),
                               color: .white)
        waterView!.addFloatingView(oView: avatar)	// Avatar on the wave
        waterView!.backgroundColor = .orange
        
        /// Add Wave View
        self.view.addSubview(waterView!)
		
        /// Test
        let startBtn = UIButton(type: .custom)
        startBtn.setTitle("Start", for: .normal)
        startBtn.setTitleColor(.red, for: .normal)
        startBtn.frame = CGRect(x: 30, y: 400, width: 50, height: 40)
        startBtn.addTarget(self, action: #selector(startAnimate), for: .touchUpInside)
        self.view.addSubview(startBtn)
		
        let stopBtn = UIButton(type: .custom)
        stopBtn.setTitle("Stop", for: .normal)
        stopBtn.setTitleColor(.red, for: .normal)
        stopBtn.frame = CGRect(x: 150, y: 400, width: 50, height: 40)
        stopBtn.addTarget(self, action: #selector(stopAnimate), for: .touchUpInside)
        self.view.addSubview(stopBtn)
    }
    
    func startAnimate() -> Void {
        waterView!.startWave()
    }
	
    func stopAnimate() -> Void {
        waterView?.stopWave()
    }
	
}
