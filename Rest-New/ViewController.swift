//
//  ViewController.swift
//  Rest
//
//  Created by Patrick Li on 5/10/17.
//  Copyright © 2017 Dali Labs, Inc. All rights reserved.
//

import UIKit
import ChameleonFramework

var globalGradientIndex = 0
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

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
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
    
    @IBOutlet weak var noCycleAvailableLabel: UILabel!
    //alarm attributes
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarmDelegate: AlarmApplicationDelegate = AppDelegate()
    var DatePickerDate = Date()
    var alarmModel: Alarms = Alarms()
    
    @IBOutlet weak var oneTime: UILabel!
    @IBOutlet weak var oneCycle: UILabel!
    @IBOutlet weak var oneCycleText: UILabel!
    
    @IBOutlet weak var twoTime: UILabel!
    @IBOutlet weak var twoCycle: UILabel!
    @IBOutlet weak var twoCycleText: UILabel!
    
    @IBOutlet weak var threeTime: UILabel!
    @IBOutlet weak var threeCycle: UILabel!
    @IBOutlet weak var threeCycleText: UILabel!
    
    //tutorial screen
    var alertView: AlertOnboarding!
    
    var arrayOfImage = ["6sScaledSunScreen"]
    var arrayOfTitle = ["Welcome to Rest"]
    var arrayOfDescription = ["Tap on the Sun to set alarm. Only do this when you are about to go to sleep in order to receive accurate sleep data."]
    
    
    //all outlets for views that need to be repositioned
    
    @IBOutlet weak var help: UIButton!
    @IBOutlet weak var wakeUp: UILabel!
    //invis alarm
    //am pm UILabel
    //sun
    @IBOutlet weak var line: UIView!
    //oneTime
    //oneCycle
    //oneCycleText
    //twoTime
    //twoCycle
    //twoCycleText
    //threeTime
    //threeCycle
    //threeCycleText
    @IBOutlet weak var hiddenText: UILabel!
    var sunYPosition: Int!
    var sunYAnnimatePosition: Int!

    override func viewWillAppear(_ animated: Bool) {
        print("viewappeared")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("viewdidload")
        
        self.sunYPosition = 265
        self.sunYAnnimatePosition = 379
        
        //setting the size of all views
        let screenHeight = UIScreen.main.bounds.height
        print(screenHeight)
        if(screenHeight == 736 ){
            print("iphone 7+")
            self.help.frame = CGRect(x: 369, y: 28, width: 25, height: 25)
            self.wakeUp.frame = CGRect(x: 175, y: 69, width: 74, height: 18)
            self.invisAlarm.frame = CGRect(x: 140, y: 105, width: 118, height: 53)
            self.alarmTime.frame = CGRect(x: 87, y: 95, width: 171, height: 72)
            self.AMPMLabel.frame = CGRect(x: 266, y: 135, width: 42, height: 18)
            self.sun.frame = CGRect(x: 176, y: 298, width: 60, height: 60)
            self.line.frame = CGRect(x: 157, y: 412, width: 100, height: 2)
            
            self.oneTime.frame = CGRect(x: 54, y: 533, width: 67, height: 18)
            self.oneCycle.frame = CGRect(x: 77, y: 559, width: 20, height: 42)
            self.oneCycleText.frame = CGRect(x: 66, y: 609, width: 41, height: 18)
            self.twoTime.frame = CGRect(x: 173, y: 533, width: 67, height: 18)
            self.twoCycle.frame = CGRect(x: 193, y: 559, width: 20, height: 42)
            self.twoCycleText.frame = CGRect(x: 183, y: 609, width: 41, height: 18)
            self.threeTime.frame = CGRect(x: 293, y: 533, width: 67, height: 18)
            self.threeCycle.frame = CGRect(x: 313, y: 559, width: 20, height: 42)
            self.threeCycleText.frame = CGRect(x: 303, y: 609, width: 41, height: 18)
            self.hiddenText.frame = CGRect(x: 87, y: 571, width: 257, height: 18)
            self.sunYPosition = 298
            self.sunYAnnimatePosition = 412
            
            
            
        }
        else if (screenHeight == 568){
            self.help.frame = CGRect(x: 275, y: 28, width: 25, height: 25)
            self.wakeUp.frame = CGRect(x: 128, y: 54, width: 74, height: 18)
            self.invisAlarm.frame = CGRect(x: 91, y: 90, width: 118, height: 53)
            self.alarmTime.frame = CGRect(x: 38, y: 80, width: 171, height: 72)
            self.AMPMLabel.frame = CGRect(x: 217, y: 120, width: 42, height: 18)
            self.sun.frame = CGRect(x: 132, y: 226, width: 60, height: 60)
            self.line.frame = CGRect(x: 113, y: 340, width: 100, height: 2)
            
            self.oneTime.frame = CGRect(x: 16, y: 403, width: 67, height: 18)
            self.oneCycle.frame = CGRect(x: 39, y: 429, width: 20, height: 42)
            self.oneCycleText.frame = CGRect(x: 28, y: 479, width: 41, height: 18)
            self.twoTime.frame = CGRect(x: 129, y: 403, width: 67, height: 18)
            self.twoCycle.frame = CGRect(x: 149, y: 429, width: 20, height: 42)
            self.twoCycleText.frame = CGRect(x: 139, y: 479, width: 41, height: 18)
            self.threeTime.frame = CGRect(x: 237, y: 403, width: 67, height: 18)
            self.threeCycle.frame = CGRect(x: 257, y: 429, width: 20, height: 42)
            self.threeCycleText.frame = CGRect(x: 247, y: 479, width: 41, height: 18)
            self.hiddenText.frame = CGRect(x: 43, y: 441, width: 257, height: 18)
            self.sunYPosition = 226
            self.sunYAnnimatePosition = 340
            
            
            
            print("iphone 5")
        }
        else if screenHeight == 480 {
            print("here")
            self.help.frame = CGRect(x: 285, y: 20, width: 25, height: 25)
            self.wakeUp.frame = CGRect(x: 122, y: 20, width: 74, height: 18)
            self.invisAlarm.frame = CGRect(x: 87, y: 56, width: 118, height: 53)
            self.alarmTime.frame = CGRect(x: 34, y: 46, width: 171, height: 72)
            self.AMPMLabel.frame = CGRect(x: 213, y: 86, width: 42, height: 18)
            self.sun.frame = CGRect(x: 129, y: 176, width: 60, height: 60)
            self.line.frame = CGRect(x: 110, y: 290, width: 100, height: 2)

            self.oneTime.frame = CGRect(x: 14, y: 366, width: 67, height: 18)
            self.oneCycle.frame = CGRect(x: 37, y: 392, width: 20, height: 42)
            self.oneCycleText.frame = CGRect(x: 26, y: 442, width: 41, height: 18)
            self.twoTime.frame = CGRect(x: 133, y: 366, width: 67, height: 18)
            self.twoCycle.frame = CGRect(x: 153, y: 392, width: 20, height: 42)
            self.twoCycleText.frame = CGRect(x: 143, y: 442, width: 41, height: 18)
            self.threeTime.frame = CGRect(x: 253, y: 366, width: 67, height: 18)
            self.threeCycle.frame = CGRect(x: 273, y: 392, width: 20, height: 42)
            self.threeCycleText.frame = CGRect(x: 263, y: 442, width: 41, height: 18)
            self.hiddenText.frame = CGRect(x: 47, y: 404, width: 257, height: 18)
            self.sunYPosition = 176
            self.sunYAnnimatePosition = 290

            print("iphone 4")
        }
        
        
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.myViewController = self
        //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //appDelegate.myViewController = self;
        
        
        
        //setting "sun" to true when reentering app after alarm
        UserDefaults.standard.set(false, forKey: "alreadySetSun")

        /*if let stringDate = UserDefaults.standard.string(forKey: "wakeUpTime") {
            print(stringDate)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let yourDate = formatter.date(from: stringDate)
            
            
            if(Date() >= yourDate!){
                print("setting sun to true")
                UserDefaults.standard.set(true, forKey: "sun")
            }
        }*/
        
        //tutorial screen
        alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
        alertView.delegate = self
        self.noCycleAvailableLabel.isHidden = true
        
        //generate stars
        for var i in 0 ..< 100  {
            self.generateRandomStars()
        }
        
        //set random gradient
        
        var gradientArray = [
            UIColor(hexString: "#fd746c")!.cgColor, UIColor(hexString: "#ff9068")!.cgColor, //orange
            UIColor(hexString: "#c2e59c")!.cgColor, UIColor(hexString: "#64b3f4")!.cgColor, //green
            UIColor(hexString: "#56CCF2")!.cgColor, UIColor(hexString: "#2F80ED")!.cgColor  //blue
            
        ]
        
        var index: Int = Int(arc4random_uniform(UInt32(gradientArray.count)))
        if (index % 2 != 0){
            index -= 1
        }
        globalGradientIndex = index
        self.currDayGradient = [gradientArray[index], gradientArray[index+1]]
        
        
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
            dateComponents.hour = 8
            dateComponents.minute = 0
            
            // Create date from components
            let userCalendar = Calendar.current // user calendar
            let someDateTime = userCalendar.date(from: dateComponents)
            
            userDefaults.set(someDateTime, forKey: "alarmDate")
            UserDefaults.standard.set(false, forKey: "alreadySetSun")
            
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
            gradient.colors = self.currDayGradient
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
        setNeededCycles(wakeUpTime: self.DatePickerDate)
    }
    
    
    
    /*
     func dateToString(date: Date) -> String{
     let formatter = DateFormatter()
     formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
     let myString = formatter.string(from: date)
     return myString
     }
     func stringToDate(string: String) -> Date{
     let formatter = DateFormatter()
     formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
     let yourDate = formatter.date(from: string)
     return yourDate!
     }*/
    
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
                    self.setNeededCycles(wakeUpTime: self.DatePickerDate)
                    
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
    
    func setNeededCycles(wakeUpTime : Date) {
        self.noCycleAvailableLabel.isHidden = true
        var possibleTimesArray : [Date] = []
        var cycleCountArray : [Int] = []
        let currentDate = Date()
        var tempDay = wakeUpTime
        var minutesTill = tempDay.minutes(from: currentDate)
        if(minutesTill < 0) {
            let nextTime = NSCalendar.current.nextDate(after: Date(),
                                                       matching: DateComponents(hour: NSCalendar.current.component(.hour, from: wakeUpTime), minute: NSCalendar.current.component(.minute, from: wakeUpTime)),
                                                       matchingPolicy: .nextTime)!
            tempDay = nextTime
            minutesTill = tempDay.minutes(from: currentDate)
        }
        var maxCycles = (minutesTill / 90)
        var counter = 3
        if(maxCycles < 3) {
            counter = maxCycles
        }
        else if(maxCycles > 7) {
            maxCycles = 7
        }
        while(counter > 0) {
            print(maxCycles)
            print(-60 * Double(5))
            possibleTimesArray.append(tempDay.addingTimeInterval(-60 * Double(maxCycles * 90)))
            cycleCountArray.append(maxCycles)
            maxCycles -= 1
            counter -= 1
        }
        switch(possibleTimesArray.count) {
        case 2:
            self.resetThirdSlot()
        case 1:
            self.resetThirdSlot()
            self.resetSecondSlot()
        default:
            break
        }
        switch(possibleTimesArray.count) {
        case 3:
            self.setThirdSlot(time: returnUsableTime(date: possibleTimesArray[2]), cycle: String(cycleCountArray[2]), cycleText: "cycles")
            fallthrough
        case 2:
            self.setSecondSlot(time: returnUsableTime(date: possibleTimesArray[1]), cycle: String(cycleCountArray[1]), cycleText: "cycles")
            fallthrough
        case 1:
            self.setFirstSlot(time: returnUsableTime(date: possibleTimesArray[0]), cycle: String(cycleCountArray[0]), cycleText: "cycles")
        default:
            self.resetFirstSlot()
            self.resetSecondSlot()
            self.resetThirdSlot()
            self.noCycleAvailableLabel.isHidden = false
            break
        }
    }
    
    func returnUsableTime(date : Date) -> String {
        let currentTzFormatter = DateFormatter()
        currentTzFormatter.timeZone = NSTimeZone.default
        currentTzFormatter.dateFormat = "h:mm a"
        currentTzFormatter.amSymbol = "AM"
        currentTzFormatter.pmSymbol = "PM"
        return currentTzFormatter.string(from: date)
    }
    
    func setFirstSlot(time : String, cycle : String, cycleText : String) {
        self.oneTime.text = time
        self.oneCycle.text = cycle
        self.oneCycleText.text = cycleText
    }
    
    func resetFirstSlot() {
        self.oneTime.text = ""
        self.oneCycle.text = ""
        self.oneCycleText.text = ""
    }
    
    func setSecondSlot(time : String, cycle : String, cycleText : String) {
        self.twoTime.text = time
        self.twoCycle.text = cycle
        self.twoCycleText.text = cycleText
    }
    
    func resetSecondSlot() {
        self.twoTime.text = ""
        self.twoCycle.text = ""
        self.twoCycleText.text = ""
    }
    
    func setThirdSlot(time : String, cycle : String, cycleText : String) {
        self.threeTime.text = time
        self.threeCycle.text = cycle
        self.threeCycleText.text = cycleText
    }
    
    func resetThirdSlot() {
        self.threeTime.text = ""
        self.threeCycle.text = ""
        self.threeCycleText.text = ""
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
        if(hour == 0){
            hour = 12
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
                                    y: CGFloat(self.sunYAnnimatePosition),
                                    width:  self.sun.frame.size.width,
                                    height:    self.sun.frame.size.height)
            self.sun.alpha = 0
        }, completion: {(copmlete : Bool) in
            UIView.animate(withDuration: 0.9, animations: {
                self.sun.frame = CGRect(x: self.sun.frame.origin.x,
                                        y: CGFloat(self.sunYPosition),
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
                    
                    //nsuserdefault for tracking time when phone is closed
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let myString = formatter.string(from: nextTime!)
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(myString, forKey: "wakeUpTime")
                    
                    //set alarm
                    var alarm = Alarm()
                    alarm.date = nextTime as! Date
                    alarm.enabled = true
                    alarm.snoozeEnabled = false
                    alarm.repeatWeekdays = []
                    alarm.uuid = UUID().uuidString
                    
                    self.alarmModel.alarms = [alarm]
                    
                    self.alarmScheduler.setNotificationWithDate(self.alarmModel.alarms[0].date, onWeekdaysForNotify: self.alarmModel.alarms[0].repeatWeekdays, snoozeEnabled: self.alarmModel.alarms[0].snoozeEnabled, onSnooze: false, soundName: "bell", index: 0)
                    
                    //let userDefaults = UserDefaults.standard
                    userDefaults.set(NSDate(), forKey: "startTime")
                    self.clicked = false
                    UserDefaults.standard.synchronize()


                    
                }
                else{
                    
                    //set wakeuptime to nil
                    UserDefaults.standard.set(nil, forKey: "wakeUpTime")
                    
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
                    let sleepTime = startTime as! Date
                    
                    
                    if(elapsedMinutes >= 1){
                        //do danny code
                        if var plistFile = PlistFile(named: "SleepData") {
                            var tempDict : [String : Any] = plistFile.dictionary!
                            tempDict[Date().toString()] = elapsedMinutes
                            plistFile.dictionary = tempDict
                        }

                        if var plistFile = PlistFile(named: "WakeUpTime") {
                            var tempDict : [String : Any] = plistFile.dictionary!
                            tempDict[Date().toString()] = Date()
                            plistFile.dictionary = tempDict
                        }
                        if var plistFile = PlistFile(named: "SleepTime") {
                            var tempDict : [String : Any] = plistFile.dictionary!
                            tempDict[sleepTime.toString()] = sleepTime
                            plistFile.dictionary = tempDict
                        }
                        print("in elpasedMinutes")
                    }

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
            self.gradient.colors = self.currDayGradient
        }
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 1.6
        if(self.isSun == false) {
            gradientChangeAnimation.toValue = self.currDayGradient
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

