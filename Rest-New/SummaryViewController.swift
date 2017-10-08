//
//  SummaryViewController.swift
//  Rest-New
//
//  Created by Patrick Li on 7/7/17.
//  Copyright © 2017 Dali Labs, Inc. All rights reserved.
//

import UIKit

func standardDeviation(arr : [Double]) -> Double {
    let length = Double(arr.count)
    let avg = arr.reduce(0, {$0 + $1}) / length
    let sumOfSquaredAvgDiff = arr.map { pow($0 - avg, 2.0)}.reduce(0, {$0 + $1})
    if(sqrt(sumOfSquaredAvgDiff / length) < 100) {
        return sqrt(sumOfSquaredAvgDiff / length)
    }
    else {
        return Double(10)
    }
}

class SummaryViewController: UIViewController {

    var isSun = true
    var gradientLayer: CAGradientLayer!
    let gradient = CAGradientLayer()
    var currDayGradient = [CGColor]()
    var views : [UIView] = []

    //all views in viewcontroller

    @IBOutlet weak var sleepDataLabel: UILabel!
    @IBOutlet weak var sleepCycles: UILabel!
    @IBOutlet weak var sleepCyclesLabel: UILabel!
    @IBOutlet weak var suggestedCycles: UILabel!
    @IBOutlet weak var suggestedCyclesLabel: UILabel!
    @IBOutlet weak var bedTime: UILabel!
    @IBOutlet weak var bedTimeam: UILabel!
    @IBOutlet weak var bedTimeLabel: UILabel!
    @IBOutlet weak var wakeTime: UILabel!
    @IBOutlet weak var wakeTimeam: UILabel!
    @IBOutlet weak var wakeTimeLabel: UILabel!
    @IBOutlet weak var sleepTime: UILabel!
    @IBOutlet weak var sleepTimeLabel: UILabel!
    @IBOutlet weak var sleepQuality: UILabel!
    @IBOutlet weak var sleepQualityLabel: UILabel!
    @IBOutlet weak var horizLine1: UIView!
    @IBOutlet var horizLine2: UIView!
    @IBOutlet weak var vertLine: UIView!


    override func viewWillAppear(_ animated: Bool) {
        let screenHeight = UIScreen.main.bounds.height
        if(screenHeight == 736 ){
            print("iphone 7+")
            self.sleepDataLabel.frame = CGRect(x: 148, y: 65, width: 118, height: 30)
            self.sleepCycles.frame = CGRect(x: 50, y: 168, width: 72, height: 48)
            self.sleepCyclesLabel.frame = CGRect(x: 55, y: 235, width: 112, height: 18)
            self.suggestedCycles.frame = CGRect(x: 238, y: 168, width: 72, height: 46)
            self.suggestedCyclesLabel.frame = CGRect(x: 243, y: 235, width: 115, height: 18)
            self.bedTime.frame = CGRect(x: 44, y: 343, width: 106, height: 72)
            self.bedTimeam.frame = CGRect(x: 158, y: 378, width: 32, height: 18)
            self.bedTimeLabel.frame = CGRect(x: 65, y: 423, width: 90, height: 18)
            self.wakeTime.frame = CGRect(x: 225, y: 343, width: 106, height: 72)
            self.wakeTimeam.frame = CGRect(x: 339, y: 378, width: 32, height: 18)
            self.wakeTimeLabel.frame = CGRect(x: 246, y: 423, width: 99, height: 18)
            self.sleepTime.frame = CGRect(x: 41, y: 514, width: 126, height: 72)
            self.sleepTimeLabel.frame = CGRect(x: 68, y: 594, width: 99, height: 18)
            self.sleepQuality.frame = CGRect(x: 247, y: 527, width: 103, height: 46)
            self.sleepQualityLabel.frame = CGRect(x: 258, y: 594, width: 82, height: 18)
            self.horizLine1.frame = CGRect(x: 65, y: 311, width: 282, height: 1)
            self.horizLine2.frame = CGRect(x: 65, y: 499, width: 282, height: 1)
            self.vertLine.frame = CGRect(x: 207, y: 179, width: 1, height: 449)
        }
        else if (screenHeight == 568){
            //set position of everything
            self.sleepDataLabel.frame = CGRect(x: 101, y: 58, width: 118, height: 30)
            self.sleepCycles.frame = CGRect(x: 20, y: 127, width: 72, height: 48)
            self.sleepCyclesLabel.frame = CGRect(x: 25, y: 189, width: 112, height: 18)
            self.suggestedCycles.frame = CGRect(x: 173, y: 127, width: 72, height: 46)
            self.suggestedCyclesLabel.frame = CGRect(x: 178, y: 189, width: 115, height: 18)
            self.bedTime.frame = CGRect(x: 14, y: 255, width: 106, height: 72)
            self.bedTimeam.frame = CGRect(x: 128, y: 290, width: 32, height: 18)
            self.bedTimeLabel.frame = CGRect(x: 35, y: 335, width: 90, height: 18)
            self.wakeTime.frame = CGRect(x: 160, y: 255, width: 106, height: 72)
            self.wakeTimeam.frame = CGRect(x: 274, y: 290, width: 32, height: 18)
            self.wakeTimeLabel.frame = CGRect(x: 181, y: 334, width: 99, height: 18)
            self.sleepTime.frame = CGRect(x: 14, y: 398, width: 126, height: 72)
            self.sleepTimeLabel.frame = CGRect(x: 41, y: 478, width: 99, height: 18)
            self.sleepQuality.frame = CGRect(x: 182, y: 411, width: 103, height: 46)
            self.sleepQualityLabel.frame = CGRect(x: 193, y: 478, width: 82, height: 18)
            self.horizLine1.frame = CGRect(x: 32, y: 239, width: 257, height: 1)
            self.horizLine2.frame = CGRect(x: 32, y: 379, width: 257, height: 1)
            self.vertLine.frame = CGRect(x: 160, y: 130, width: 1, height: 366)

            print("iphone 5")
        }
        else if screenHeight == 480{
            self.sleepDataLabel.frame = CGRect(x: 99, y: 0, width: 118, height: 30)
            self.sleepCycles.frame = CGRect(x: 34, y: 51, width: 72, height: 48)
            self.sleepCyclesLabel.frame = CGRect(x: 17, y: 118, width: 112, height: 18)
            self.suggestedCycles.frame = CGRect(x: 200, y: 51, width: 72, height: 46)
            self.suggestedCyclesLabel.frame = CGRect(x: 183, y: 118, width: 115, height: 18)
            self.bedTime.frame = CGRect(x: 5, y: 203, width: 106, height: 72)
            self.bedTimeam.frame = CGRect(x: 118, y: 238, width: 32, height: 18)
            self.bedTimeLabel.frame = CGRect(x: 25, y: 283, width: 90, height: 18)
            self.wakeTime.frame = CGRect(x: 170, y: 203, width: 106, height: 72)
            self.wakeTimeam.frame = CGRect(x: 284, y: 238, width: 32, height: 18)
            self.wakeTimeLabel.frame = CGRect(x: 191, y: 283, width: 99, height: 18)
            self.sleepTime.frame = CGRect(x: 7, y: 366, width: 126, height: 72)
            self.sleepTimeLabel.frame = CGRect(x: 21, y: 446, width: 99, height: 18)
            self.sleepQuality.frame = CGRect(x: 189, y: 379, width: 103, height: 46)
            self.sleepQualityLabel.frame = CGRect(x: 200, y: 446, width: 82, height: 18)
            self.horizLine1.frame = CGRect(x: 17, y: 181, width: 257, height: 1)
            self.horizLine2.frame = CGRect(x: 17, y: 345, width: 257, height: 1)
            self.vertLine.frame = CGRect(x: 158, y: 59, width: 1, height: 366)

        }


        let defaults = UserDefaults.standard
        self.isSun = defaults.bool(forKey: "sun")

        var gradientArray = [
            UIColor(hexString: "#fd746c")!.cgColor, UIColor(hexString: "#ff9068")!.cgColor, //orange
            UIColor(hexString: "#c2e59c")!.cgColor, UIColor(hexString: "#64b3f4")!.cgColor, //green
            UIColor(hexString: "#56CCF2")!.cgColor, UIColor(hexString: "#2F80ED")!.cgColor  //blue

        ]
        self.currDayGradient = [gradientArray[globalGradientIndex], gradientArray[globalGradientIndex+1]]

        gradient.frame = self.view.bounds
        if(self.isSun == false) {
            gradient.colors = [
                UIColor(hexString: "050505")!.cgColor,
                UIColor(hexString: "363756")!.cgColor
            ]
            self.showStars()
        }
        else {
            self.hideStars()
            gradient.colors = self.currDayGradient
        }

        var wakeUpTimesArray : Array<NSDate> = []
        var sleepTimesArray : Array<NSDate> = []

        let wakeUpTimes = PlistFile(named: "WakeUpTime")?.dictionary
        let sleepTimes = PlistFile(named: "SleepTime")?.dictionary

        var totalTime = 0
        let totalSleepTimes = PlistFile(named: "SleepData")?.dictionary
        var totalTimesArray : [Double] = []

        var totalDays = 0

        if let total = totalSleepTimes {
            for(_, value) in total {
                totalTime += value as! Int
                totalTimesArray.append(value as! Double)
                totalDays += 1
            }
        }

        if(totalDays != 0){
            //average sleep cycles
            self.sleepCycles.text = String((totalTime/totalDays)/90)

            //average sleep time label

            var avgHour = (totalTime/totalDays)/60
            var avgMinutes = (totalTime/totalDays) % 60
            self.sleepTime.text = "\(avgHour)h \(avgMinutes)"

            //other stats
            let standardDev = standardDeviation(arr: totalTimesArray)

            self.suggestedCycles.text = String(Int(6 - standardDev))
            self.sleepQuality.text = String(100 - Int(standardDev * 5)) + "%"
        }

        else {
            self.suggestedCycles.text = "N/A"
            self.sleepQuality.text = "N/A"
            self.sleepCycles.text = "N/A"
            self.sleepTime.text = "N/A"
            self.bedTime.text = "N/A"
            self.bedTimeam.text = ""
            self.wakeTime.text = "N/A"
            self.wakeTimeam.text = ""

        }


        if let wakeUp = wakeUpTimes {
            for(_, value) in wakeUp {
                wakeUpTimesArray.append(value as! NSDate)
            }
        }

        if let sleep = sleepTimes {
            for(_, value) in sleep {
                sleepTimesArray.append(value as! NSDate)
            }
        }

        if(wakeUpTimesArray.count > 0) {
            self.getAvgTime(results: wakeUpTimesArray, isWake: true)
        }

        if(sleepTimesArray.count > 0) {
            self.getAvgTime(results: sleepTimesArray, isWake: false)
        }



        gradient.startPoint = CGPoint(x:0, y:1)
        gradient.endPoint = CGPoint(x:1, y:0)
        gradient.zPosition = -1
        self.view.layer.addSublayer(gradient)
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        for var i in 0 ..< 100  {
            self.generateRandomStars()
        }
    }

    //stars
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getAvgTime(results: Array<NSDate>, isWake: Bool) {
        var totalHours = 0.0
        var totalMinutes = 0.0
        var avgTime = ""
        // sum all hours & minutes tether
        print(results)
        print(results.count)
        for result in results {
            let hours = Double(NSCalendar.current.component(Calendar.Component.hour, from: result as Date))
            let minutes = Double(NSCalendar.current.component(Calendar.Component.minute, from: result as Date))

            print("log")
            print(hours)

            totalHours = totalHours + hours
            totalMinutes = totalMinutes + minutes
        }
        // calculate avg hours
        var avgHourH : Int = Int(round(totalHours / Double(results.count)))
        // calculate avg minutes based on decimals
        var avgHourM : Int = Int(round(totalMinutes / Double(results.count)))


        //setting text
        var AMorPM = "am"
        if(avgHourH >= 12){
            if(avgHourH > 12){
                avgHourH -= 12
            }
            AMorPM = "pm"
        }
        if(avgHourH == 0){
            avgHourH = 12
        }
        var minuteString = String(avgHourM)
        if avgHourM < 10 {
            minuteString = "0" + minuteString
        }


        if(isWake){
            self.wakeTime.text = "" + String(avgHourH) + ":" + minuteString
            self.wakeTimeam.text = AMorPM
        }
        else{
            self.bedTime.text = "" + String(avgHourH) + ":" + minuteString
            self.bedTimeam.text = AMorPM
        }
        /*
        avgTime = String(format:"%02d:%02d", avgHourH, avgHourM)
        return avgTime
         */
    }



}

