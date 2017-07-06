//
//  ViewController.swift
//  Rest
//
//  Created by Patrick Li on 5/10/17.
//  Copyright © 2017 Dali Labs, Inc. All rights reserved.
//

import UIKit
import ChameleonFramework


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

extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}

class ViewController: UIViewController, UIGestureRecognizerDelegate, AlertOnboardingDelegate {
    
    var gradientLayer: CAGradientLayer!
    @IBOutlet var sun: FadeImageView!
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var AMPMLabel: UILabel!
    @IBOutlet weak var invisAlarm: UIButton!
    
    var radius: Double = 0
    var circle = UIView()
    var enlarging = true
    var clicked = false
    var isSun = true
    var appear = false
    var invisButton = UIButton()
    var views : [UIView] = []
    let gradient = CAGradientLayer()
    var gradientArray = [CGColor]()
    var currDayGradient = [CGColor]()

    //alarm attributes
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarmDelegate: AlarmApplicationDelegate = AppDelegate()
    var DatePickerDate = Date()
    var alarmModel: Alarms = Alarms()


    //tutorial screen
    var alertView: AlertOnboarding!

    var arrayOfImage = ["image1", "image2", "image3"]
    var arrayOfTitle = ["CREATE ACCOUNT", "CHOOSE THE PLANET", "DEPARTURE"]
    var arrayOfDescription = ["In your profile, you can view the statistics of its operations and the recommandations of friends",
                              "Purchase tickets on hot tours to your favorite planet and fly to the most comfortable intergalactic spaceships of best companies",
                              "In the process of flight you will be in cryogenic sleep and supply the body with all the necessary things for life"]



    override func viewDidLoad() {
        super.viewDidLoad()
        //tutorial screen
        alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
        alertView.delegate = self


        //generate stars
        for var i in 0 ..< 100  {
            self.generateRandomStars()
        }
        
        var gradientArray = [UIColor(hexString: "F6D296")!.cgColor, UIColor(hexString: "DACEF2")!.cgColor,
                             UIColor(hexString: "FB9EC2")!.cgColor, UIColor(hexString: "C4C6DF")!.cgColor,
                             UIColor(hexString: "F8E1FB")!.cgColor, UIColor(hexString: "84D7D8")!.cgColor,
                             UIColor(hexString: "E79D96")!.cgColor, UIColor(hexString: "CAB6DA")!.cgColor,
                             UIColor(hexString: "FFDEBC")!.cgColor, UIColor(hexString: "8BF3E1")!.cgColor,
                           ]
        
        var randInt = arc4random_uniform(10) + 1
        
        //shadow
        self.radius = 45
        circle = UIView(frame: CGRect(x: Double(sun.frame.midX-CGFloat(radius)), y: Double(sun.frame.midY-CGFloat(radius)), width: radius*2, height: radius*2))
        circle.layer.cornerRadius = CGFloat(radius)
        circle.backgroundColor = UIColor(hexString: "#ffffff", withAlpha: 0.3)
        self.view.addSubview(circle)
        var circleAnnimate = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        
        //invis button
        invisButton = UIButton()
        invisButton.frame = CGRect(x: sun.frame.origin.x, y: sun.frame.origin.y, width: sun.frame.width, height: sun.frame.height);
        invisButton.addTarget(self, action:
            #selector(ViewController.invisPressed), for: .touchUpInside)
        self.view.addSubview(invisButton)
        
        //nsuserdefaults
        if(UserDefaults.isFirstLaunch()){
            UserDefaults.standard.set(true, forKey: "sun")
            let userDefaults = UserDefaults.standard
            
            /*let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let someDateTime = formatter.date(from: "2017/07/05 17:43")
            //let finalTime = formatter.string(from: someDateTime!)*/
            
            var dateComponents = DateComponents()
            dateComponents.hour = 7
            dateComponents.minute = 47
            
            // Create date from components
            let userCalendar = Calendar.current // user calendar
            let someDateTime = userCalendar.date(from: dateComponents)
            
            
            print(someDateTime)
            print("here")
            userDefaults.set(someDateTime, forKey: "alarmDate")
            
        }
        let defaults = UserDefaults.standard
        self.isSun = defaults.bool(forKey: "sun")
        //self.isNight = defaults.bool(forKey: "isNight")
        gradient.frame = self.view.bounds
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.initiateStarFlicker), userInfo: nil, repeats: true)
        if(self.isSun == false) {
            gradient.colors = [
                UIColor(hexString: "050505")!.cgColor,
                UIColor(hexString: "363756")!.cgColor
            ]
            sun.image = UIImage(named: "moon")
        }
        else {
            gradient.colors = [
                UIColor(hexString: "#fd7b56")!.cgColor,
                UIColor(hexString: "#f85c59")!.cgColor
            ]
            sun.image = UIImage(named: "sun-icon-base")
            self.hideStars()
        }
        gradient.startPoint = CGPoint(x:0, y:1)
        gradient.endPoint = CGPoint(x:1, y:0)
        gradient.zPosition = -1
        self.view.layer.addSublayer(gradient)
        //alarm
        alarmScheduler.checkNotification()
        
        if let alarmDate = UserDefaults.standard.object(forKey: "alarmDate") {
            self.dateToString(date: alarmDate as! Date)
            self.DatePickerDate = alarmDate as! Date
        }        
    }

    //alert view delegate
    @IBAction func showTutorial(_ sender: Any) {
        self.alertView.show()

    }

    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int) {
        print("Onboarding skipped the \(currentStep) step and the max step he saw was the number \(maxStep)")
    }

    func alertOnboardingCompleted() {
        print("Onboarding completed!")
    }

    func alertOnboardingNext(_ nextStep: Int) {
        print("Next step triggered! \(nextStep)")
    }


    //date picker
    @IBAction func showDatePicker(_ sender: Any) {
        
        if(isSun){
            //blur
            let blurEffect = UIBlurEffect(style: .light)
            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
            blurredEffectView.frame = self.view.bounds
            blurredEffectView.tag = 1
            blurredEffectView.layer.zPosition = -1
            view.addSubview(blurredEffectView)
            
            DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
                (date) -> Void in
                self.view.viewWithTag(1)?.removeFromSuperview()
                
                if let time = date{
                    
                    let timeInterval = floor(time.timeIntervalSinceReferenceDate / 60.0) * 60.0
                    var dateWithoutSeconds = NSDate(timeIntervalSinceReferenceDate: timeInterval)

                    
                    self.dateToString(date: dateWithoutSeconds as Date)
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(dateWithoutSeconds, forKey: "alarmDate")
                    self.DatePickerDate = dateWithoutSeconds as Date
                    print(self.DatePickerDate)
                    
                }
                else {
                    print("canceled")
                }
            }
        }
        else{
            let alert = UIAlertController(title: "", message: "Cannot change time while in sleep mode. Click on the moon to wake up!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    func dateToString(date: Date){
        var hour = Calendar.current.component(.hour, from: date)
        var minute = Calendar.current.component(.minute, from: date)
        var AMorPM = "am"
        if(hour >= 12){
            if(hour > 12){
                hour -= 12
            }
            AMorPM = "pm"
        }
        var minuteString = String(minute)
        if minute < 10 {
            minuteString = "0" + minuteString
        }
        self.alarmTime.text = "" + String(hour) + ":" + minuteString
        self.AMPMLabel.text = AMorPM
    }
    
    // sun pressed
    func invisPressed() {
        invisButton.isEnabled = false
        self.clicked = true
        var currHeight = self.sun.frame.size.height
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
                self.changeSunBackground()

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
                    
                    //if this is wrong check project settings (to fix reset all project settings by creating new project and dragging all existing files to new project.
                    //this is getting next occurence of the specified time (hours and minutes)
                    let date = self.DatePickerDate
                    let calendar = NSCalendar.current
                    let now = Date()
                    let hour = NSCalendar.current.component(.hour, from: date)
                    let minute = NSCalendar.current.component(.minute, from: date)
                    let nextTime = calendar.nextDate(after: now,
                                                     matching: DateComponents(hour: hour, minute: minute),
                                                     matchingPolicy: .nextTime)
                    
                    print(nextTime)
                    
                    var alarm = Alarm()
                    alarm.date = nextTime as! Date
                    alarm.enabled = true
                    alarm.snoozeEnabled = false
                    alarm.repeatWeekdays = []
                    alarm.uuid = UUID().uuidString
                    
                    self.alarmModel.alarms = [alarm]
                    
                    self.alarmScheduler.setNotificationWithDate(self.alarmModel.alarms[0].date, onWeekdaysForNotify: self.alarmModel.alarms[0].repeatWeekdays, snoozeEnabled: self.alarmModel.alarms[0].snoozeEnabled, onSnooze: false, soundName: "bell", index: 0)
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(NSDate(), forKey: "startTime")
                    self.clicked = false

                    
                }
                else{
                    self.sun.image = UIImage(named: "sun-icon-base")
                    UserDefaults.standard.set(true, forKey: "sun")
                    
                    
                    self.alarmModel.alarms[0].enabled = false
                    self.alarmScheduler.reSchedule()
                    print(self.alarmModel.alarms)
                    print("bois")
                    
                    let userDefaults = UserDefaults.standard
                    let startTime = userDefaults.value(forKey: "startTime") as! NSDate
                    let elapsedSeconds = Int(startTime.timeIntervalSinceNow) * -1
                    let elapsedMinutes = elapsedSeconds/60
                    print(String(elapsedMinutes) + "minutes3")
                    self.isSun = true
                    
                }
                
                
            }, completion: {(complete : Bool) in
                if(self.isSun == false) {
                    self.showStars()
                }
                else {
                    print("calling")
                    self.hideStars()
                }
            })
        })
        
    }
    
    func changeSunBackground() {
        if(self.isSun == false){
            self.gradient.colors = [UIColor(hexString: "050505")!.cgColor,
                                    UIColor(hexString: "363756")!.cgColor]
        }
        else{
            self.gradient.colors = [UIColor(hexString: "#514A9D")!.cgColor,
                                    UIColor(hexString: "#24C6DC")!.cgColor]
        }
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 1.6
        if(self.isSun == false) {
            gradientChangeAnimation.toValue = [
                UIColor(hexString: "#514A9D")!.cgColor,
                UIColor(hexString: "#24C6DC")!.cgColor
            ]
        }
        else {
            gradientChangeAnimation.toValue = [
                UIColor(hexString: "050505")!.cgColor,
                UIColor(hexString: "363756")!.cgColor
            ]
        }
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
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
    
    func hideStars() {
        for view in views {
            view.isHidden = true
        }
    }
    
    func showStars() {
        for view in views {
            view.isHidden = false
        }
    }
    
    func initiateStarFlicker() {
        if(self.isSun == false) {
            var rand = Int(arc4random_uniform(UInt32(self.views.count)))
            if(rand < 25) {
                rand += 24
            }
            for var i in 0..<rand {
                starFlicker(view: self.views[i])
            }
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

