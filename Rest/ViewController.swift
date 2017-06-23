//
//  ViewController.swift
//  Rest
//
//  Created by Patrick Li on 5/10/17.
//  Copyright © 2017 Dali Labs, Inc. All rights reserved.
//

import UIKit
import ChameleonFramework
import Pastel

class FadeImageView: UIImageView
{
    @IBInspectable
    var fadeDuration: Double = 0.13
    
    override var image: UIImage? {
        get {
            return super.image
        }
        set(newImage) {
            if let img = newImage {
                CATransaction.begin()
                CATransaction.setAnimationDuration(self.fadeDuration)
                
                let transition = CATransition()
                transition.type = kCATransitionFade
                
                super.layer.add(transition, forKey: kCATransition)
                super.image = img
                
                CATransaction.commit()
            } else {
                super.image = nil
            }
        }
    }
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var gradientLayer: CAGradientLayer!
    @IBOutlet var sun: FadeImageView!
    
    var radius: Double = 0
    var circle = UIView()
    var enlarging = true
    var clicked = false
    var isSun = true
    var appear = false
    var invisButton = UIButton()
    var views : [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background
        let pastelView = PastelView(frame: view.bounds)
        // Custom Direction
        pastelView.startPastelPoint = .bottom
        pastelView.endPastelPoint = .top
        pastelView.animationDuration = 3.0
        pastelView.setColors([UIColor(hexString: "#050505")!, UIColor(hexString: "#363756")!])
        
        pastelView.startAnimation()
        for var i in 0 ..< 100  {
            generateRandomStars()
        }
        var color1 = UIColor(hexString: "#050505")!
        var color2 = UIColor(hexString: "#363756")!
        self.view.backgroundColor = GradientColor(UIGradientStyle.init(rawValue: 3)!, frame: self.view.frame, colors: [color1, color2])
        //shadow
        self.radius = 45
        circle = UIView(frame: CGRect(x: Double(sun.frame.midX-CGFloat(radius)), y: Double(sun.frame.midY-CGFloat(radius)), width: radius*2, height: radius*2))
        circle.layer.cornerRadius = CGFloat(radius)
        circle.backgroundColor = UIColor(hexString: "#ffffff", withAlpha: 0.3)
        //circle.layer.zPosition = -3
        //sun.layer.zPosition = -2
        self.view.addSubview(circle)
        //invis button
        invisButton = UIButton()
        invisButton.frame = CGRect(x: sun.frame.origin.x, y: sun.frame.origin.y, width: sun.frame.width, height: sun.frame.height);
        invisButton.addTarget(self, action:
            #selector(ViewController.invisPressed), for: .touchUpInside)
        self.view.addSubview(invisButton)
        
        //nsuserdefaults
        let defaults = UserDefaults.standard
        let exists = defaults.bool(forKey: "sun")
        
        if exists {
            isSun = true
            sun.image = UIImage(named: "sun-icon-base")
            print("sun")
        } else {
            isSun = false
            print("no sun")
            sun.image = UIImage(named: "moon")
        }
        //view.insertSubview(pastelView, at: 0)
        
        // circle time interval
         _ = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.initiateStarFlicker), userInfo: nil, repeats: true)
    }
    
    func invisPressed() {
        invisButton.isEnabled = false
        self.clicked = true
        var currHeight = self.sun.frame.size.height
        print(currHeight)
        UIView.animate(withDuration: 1.5, animations: {
            self.sun.frame = CGRect(x: self.sun.frame.origin.x,
                                    y: self.view.frame.height - 270,
                                    width:  self.sun.frame.size.width,
                                    height:    self.sun.frame.size.height)
            self.sun.alpha = 0
        }, completion: {(copmlete : Bool) in
            UIView.animate(withDuration: 0.9, animations: {
                self.sun.frame = CGRect(x: self.sun.frame.origin.x,
                                        y: 265,
                                        width:  self.sun.frame.size.width,
                                        height:    self.sun.frame.size.height)
                self.sun.alpha = 1
                
            }, completion: {(complete:Bool) in
                self.appear = true
                self.invisButton.isEnabled = false
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.enableButtonBack), userInfo: nil, repeats: false)
            })
            UIView.animate(withDuration: 0.9, animations: {
                if(self.isSun){
                    self.sun.image = UIImage(named: "moon")
                    UserDefaults.standard.set(false, forKey: "sun")
                    self.isSun = false
                }
                else{
                    self.sun.image = UIImage(named: "sun-icon-base")
                    UserDefaults.standard.set(true, forKey: "sun")
                    self.isSun = true
                    
                }
                print("here")
                self.clicked = false
                
                
            })
        })
        
    }
    
    func generateRandomStars() {
        let height = self.view!.frame.height
        let width = self.view!.frame.width
        let randomPosition = CGPoint(x:CGFloat(arc4random()).truncatingRemainder(dividingBy: height),
                                     y: CGFloat(arc4random()).truncatingRemainder(dividingBy: width))
        let randSize = Int(arc4random_uniform(2)) + 1
        let randAlpha = Int(arc4random_uniform(50)) + 50
        let view_ = UIView(frame: CGRect(origin: randomPosition, size: CGSize(width: randSize, height: randSize)))
        view_.backgroundColor = UIColor.white
        view_.alpha = CGFloat(CGFloat(randAlpha) / 100)
        view_.layer.cornerRadius = CGFloat(1)
        self.view.addSubview(view_)
        self.views.append(view_)
    }
    
    func initiateStarFlicker() {
        var rand = Int(arc4random_uniform(UInt32(self.views.count)))
        if(rand < 25) {
            rand += 24
        }
        print(rand)
        for var i in 0..<rand {
            starFlicker(view: self.views[i])
        }
    }
    
    func starFlicker(view: UIView) {
        UIView.animate(withDuration: 1.0, animations: {
            view.alpha -= 0.6
        }, completion: { (complete : Bool) in
            UIView.animate(withDuration: 1.0, animations: {
                view.alpha += 0.6
            })
        })
    }
    
    func enableButtonBack() {
        self.invisButton.isEnabled = true
    }
    
    func update() {
        if(self.clicked){
            let alphaVal = (self.circle.layer.backgroundColor?.alpha)! - 0.05
            self.circle.backgroundColor = UIColor(hexString: "#ffffff", withAlpha: alphaVal)
            if (Double((self.circle.layer.backgroundColor?.alpha)!) < 0.05){
                self.clicked = false
            }
        }
        else if(self.appear){
            let alphaVal = (self.circle.layer.backgroundColor?.alpha)! + 0.05
            self.circle.backgroundColor = UIColor(hexString: "#ffffff", withAlpha: alphaVal)
            if (Double((self.circle.layer.backgroundColor?.alpha)!) >= 0.3){
                print("yo")
                self.appear = false
            }
        }
            
        else if enlarging {
            radius += 0.3
            self.circle.layer.frame = CGRect(x: Double(sun.frame.midX-CGFloat(radius)), y: Double(sun.frame.midY-CGFloat(radius)), width: radius*2, height: radius*2)
            self.circle.layer.cornerRadius = CGFloat(radius)
            if (circle.layer.cornerRadius > self.sun.frame.width-3) {enlarging = false}
        }
        else {
            radius -= 0.3
            self.circle.layer.frame = CGRect(x: Double(sun.frame.midX-CGFloat(radius)), y: Double(sun.frame.midY-CGFloat(radius)), width: radius*2, height: radius*2)
            self.circle.layer.cornerRadius = CGFloat(radius)
            if (circle.layer.cornerRadius < self.sun.frame.width/2 + 15) {enlarging = true}
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

