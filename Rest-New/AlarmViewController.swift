//
//  ViewController.swift
//  Alarm
//
//  Created by Patrick Li on 7/3/17.
//  Copyright © 2017 Dali Labs, Inc. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    var alarmDelegate: AlarmApplicationDelegate = AppDelegate()
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarmModel: Alarms = Alarms()


    override func viewDidLoad() {
        super.viewDidLoad()
        alarmModel=Alarms()
        alarmScheduler.checkNotification()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func startPressed(_ sender: Any) {
        let date = Scheduler.correctSecondComponent(date: datePicker.date)
        var tempAlarm = Alarm()
        tempAlarm.date = date
        tempAlarm.label = "label"
        tempAlarm.enabled = true
        tempAlarm.mediaLabel = "bell"
        tempAlarm.mediaID = "id"
        tempAlarm.snoozeEnabled = false
        tempAlarm.repeatWeekdays = []
        tempAlarm.uuid = UUID().uuidString
        if(alarmModel.count == 0){
            alarmModel.alarms.append(tempAlarm)
        }
        else{
            alarmModel.alarms[0] = tempAlarm
        }
        alarmScheduler.setNotificationWithDate(alarmModel.alarms[0].date, onWeekdaysForNotify: alarmModel.alarms[0].repeatWeekdays, snoozeEnabled: alarmModel.alarms[0].snoozeEnabled, onSnooze: false, soundName: alarmModel.alarms[0].mediaLabel, index: 0)
        print(alarmModel.alarms[0])
        let userDefaults = UserDefaults.standard
        userDefaults.set(Date(), forKey: "startTime")
        
    }
    
    
}

















