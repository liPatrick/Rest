//
//  AlarmViewController.swift
//  Rest
//
//  Created by Patrick Li on 5/26/17.
//  Copyright © 2017 Dali Labs, Inc. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarmDelegate: AlarmApplicationDelegate = AppDelegate()



    override func viewDidLoad() {
        super.viewDidLoad()
        alarmScheduler.checkNotification()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startPressed(_ sender: Any) {
        let date = Scheduler.correctSecondComponent(date: datePicker.date)
        var alarm = Alarm()
        alarm.date = date
        alarm.enabled = true
        alarm.snoozeEnabled = false
        alarm.repeatWeekdays = [1, 2, 3, 4, 5, 6, 7]
        alarm.uuid = UUID().uuidString
        
        var alarmModel: Alarms = Alarms()
        if(alarmModel.alarms.count >= 1){
            alarmModel.alarms[0] = alarm
        }
        else{
            alarmModel.alarms.append(alarm)
        }
        print(alarmModel.alarms.count)
        print(alarmModel.alarms)
        alarmModel.alarms[0].enabled = true
        alarmScheduler.setNotificationWithDate(alarmModel.alarms[0].date, onWeekdaysForNotify: alarmModel.alarms[0].repeatWeekdays, snoozeEnabled: alarmModel.alarms[0].snoozeEnabled, onSnooze: false, soundName: "bell", index: 0)

        let userDefaults = UserDefaults.standard
        userDefaults.set(Date(), forKey: "startTime")

    }



}
