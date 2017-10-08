//
//  SleepChartView.swift
//  Rest
//
//  Created by Patrick Li on 5/13/17.
//  Copyright © 2017 Dali Labs, Inc. All rights reserved.
//

import UIKit
import iCarousel

class SleepChartView: UIViewController {
    
    
    @IBOutlet weak var sleepChartLabel: UILabel!
    @IBOutlet var graphView: ScrollableGraphView!
    var currentGraphType = GraphType.dark
    var graphConstraints = [NSLayoutConstraint]()
    var items : [String] = []
    
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var suggestedNext: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    var label = UILabel()
    var labelConstraints = [NSLayoutConstraint]()
    
    // Data
    let numberOfDataItems = 29
    
    var data: [Double] = [Double]()
    var labels: [String] = [String]()
    let gradient = CAGradientLayer()
    var currDayGradient = [CGColor]()
    var isSun = true
    var views : [UIView] = []
    
    @IBOutlet weak var noDataAvailableLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let screenHeight = UIScreen.main.bounds.height
        if(screenHeight == 736 ){
            print("iphone 7+")
            self.sleepChartLabel.frame = CGRect(x: 143, y: 64, width: 128, height: 30)
            self.graphView.frame = CGRect(x: 31, y: 161, width: 333, height: 487)
            self.noDataAvailableLabel.frame = CGRect(x: 107, y: 327, width: 200, height: 30)
        }
        else if (screenHeight == 568){
            //set position of everything
            self.sleepChartLabel.frame = CGRect(x: 96, y: 70, width: 128, height: 30)
            self.graphView.frame = CGRect(x: 31, y: 161, width: 258, height: 317)
            self.noDataAvailableLabel.frame = CGRect(x: 60, y: 269, width: 200, height: 30)

            print("iphone 5")
        }
        else if screenHeight == 480{
            self.sleepChartLabel.frame = CGRect(x: 101, y: 10, width: 128, height: 30)
            self.graphView.frame = CGRect(x: 4, y: 99, width: 313, height: 371)
            self.noDataAvailableLabel.frame = CGRect(x: 65, y: 257, width: 200, height: 30)

        }
        
        for var i in 0 ..< 100  {
            self.generateRandomStars()
        }
        
        //addLabel(withText: "Switch View")
        graphView = createBarGraph(graphView.frame)
        graphView.set(data: data, withLabels: labels)
        graphView.fillColor = UIColor(white: 1, alpha: 0.5)
        graphView.backgroundFillColor = UIColor(white: 1, alpha: 0)
        graphView.barColor = UIColor(white: 1, alpha: 0.6)
        graphView.barLineColor = UIColor(white: 1, alpha: 0.6)
        self.view.insertSubview(graphView, belowSubview: label)
        // plist

        var dates: [Date] = []
        if var plistFile = PlistFile(named: "SleepData") {
            if let retrievedData : [String : Int] = (PlistFile(named: "SleepData")?.dictionary) as! [String : Int] {
                for(key, value) in retrievedData {
                    data.append(Double(value/60))


                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMMM dd, yyyy"
                    let date = dateFormatter.date(from: key)
                    dates.append(date!)


                }
                print(retrievedData)

                //sort
                if(dates.count == 0){

                }
                else if(dates.count == 1){
                }
                else{
                    var j = 0
                    var flag = true
                    var temp: Date
                    var temp2: Double
                    while (flag){
                        flag = false
                        print(dates.count)
                        for j in 0...dates.count-2 {
                            if (dates[j] < dates[j+1]) {
                                temp = dates[j]
                                dates[j] = dates[j+1]
                                dates[j+1] = temp
                                flag = true

                                temp2 = Double(data[j])
                                data[j] = data[j+1]
                                data[j+1] = Double(Int(temp2))
                            }
                        }
                    }
                }
                print(dates)
                print(data)

                var numberDates: [String] = []

                for date in dates {
                    let calendar = Calendar.current
                    let day = calendar.component(.day, from: date)
                    let month = calendar.component(.month, from: date)
                    let string = String(month) + "/" + String(day)
                    numberDates.append(string)
                }


                graphView.set(data: data, withLabels: numberDates)
            }
        }


        /*
        if var plistFile = PlistFile(named: "SleepData") {
            if let retrievedData : [String : Int] = (PlistFile(named: "SleepData")?.dictionary) as! [String : Int] {
                for(key, value) in retrievedData {
                    data.append(Double(value/60))
                    labels.append(key)
                }
                print(data)
                print(labels)
                print("here")

                //parse dates

                var dates: [Int] = []
                for word in labels {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMMM dd, yyyy"
                    let date = dateFormatter.date(from: word)

                    let calendar = Calendar.current
                    let day = calendar.component(.day, from: date!)
                    dates.append(day)

                    print(date)
                    print("here")
                }
                graphView.set(data: data, withLabels: newStrings)
            }
        }*/
        self.noDataAvailableLabel.isHidden = true
        if(data.count == 0){
            self.noDataAvailableLabel.isHidden = false
        }
        
    }




    
    override func viewWillAppear(_ animated: Bool) {
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
        
        gradient.startPoint = CGPoint(x:0, y:1)
        gradient.endPoint = CGPoint(x:1, y:0)
        gradient.zPosition = -1
        self.view.layer.addSublayer(gradient)
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
    
    //chart
    
    func generateRandomData() -> [String : Double] {
        var dict : [String : Double] = [:]
        for index in 1...10 {
            var str = "May " + String(index)
            dict[str] = Double(arc4random_uniform(10) + 1)
        }
        return dict
    }
    
    func getAverage(dict : [String : Double]) -> Double {
        var average : Double = 0;
        var counter : Double = 0;
        for(_, key) in dict {
            counter += 1
            average += key
        }
        return (average / counter)
    }
    
    func getSuggested(dict : [String : Double]) -> Double {
        var counter : Double = 0;
        var total : Double = 0;
        for(_, key) in dict {
            counter += 1
            total += key
        }
        return (((counter + 1) * 7) - total)
    }
    
    /*
     
     func didTap(_ gesture: UITapGestureRecognizer) {
     currentGraphType.next()
     switch(currentGraphType) {
     case .dark:
     addLabel(withText: "Switch View")
     graphView = createDarkGraph(graphView.frame)
     case .dot:
     addLabel(withText: "Switch View")
     graphView = createDotGraph(graphView.frame)
     case .bar:
     addLabel(withText: "Switch View")
     graphView = createBarGraph(graphView.frame)
     case .pink:
     addLabel(withText: "Switch View")
     graphView = createPinkMountainGraph(graphView.frame)
     }
     
     graphView.set(data: data, withLabels: labels)
     self.view.insertSubview(graphView, belowSubview: label)
     
     }*/
    
    fileprivate func createDarkGraph(_ frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame)
        
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        graphView.lineWidth = 1
        graphView.lineColor = UIColor.colorFromHex(hexString: "#777777")
        graphView.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        graphView.shouldFill = true
        graphView.fillType = ScrollableGraphViewFillType.gradient
        graphView.fillColor = UIColor.colorFromHex(hexString: "#555555")
        graphView.fillGradientType = ScrollableGraphViewGradientType.linear
        graphView.fillGradientStartColor = UIColor.colorFromHex(hexString: "#555555")
        graphView.fillGradientEndColor = UIColor.colorFromHex(hexString: "#444444")
        
        graphView.dataPointSpacing = 80
        graphView.dataPointSize = 2
        graphView.dataPointFillColor = UIColor.white
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.numberOfIntermediateReferenceLines = 5
        graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        graphView.animationDuration = 1.5
        graphView.rangeMax = 50
        graphView.shouldRangeAlwaysStartAtZero = true
        
        return graphView
    }
    
    private func createBarGraph(_ frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame:frame)
        
        graphView.dataPointType = ScrollableGraphViewDataPointType.circle
        graphView.shouldDrawBarLayer = true
        graphView.shouldDrawDataPoint = false
        
        graphView.lineColor = UIColor.clear
        graphView.barWidth = 25
        graphView.barLineWidth = 1
        graphView.barLineColor = UIColor.colorFromHex(hexString: "#777777")
        graphView.barColor = UIColor.colorFromHex(hexString: "#555555")
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.numberOfIntermediateReferenceLines = 5
        graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        graphView.animationDuration = 1.5
        graphView.rangeMax = 50
        graphView.shouldRangeAlwaysStartAtZero = true
        
        return graphView
    }
    
    /*
     
     private func createDotGraph(_ frame: CGRect) -> ScrollableGraphView {
     
     let graphView = ScrollableGraphView(frame:frame)
     
     graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#00BFFF")
     graphView.lineColor = UIColor.clear
     
     graphView.dataPointSize = 5
     graphView.dataPointSpacing = 80
     graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
     graphView.dataPointLabelColor = UIColor.white
     graphView.dataPointFillColor = UIColor.white
     
     graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
     graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
     graphView.referenceLineLabelColor = UIColor.white
     graphView.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
     
     graphView.numberOfIntermediateReferenceLines = 9
     
     graphView.rangeMax = 50
     
     return graphView
     }
     
     private func createPinkMountainGraph(_ frame: CGRect) -> ScrollableGraphView {
     
     let graphView = ScrollableGraphView(frame:frame)
     
     graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#222222")
     graphView.lineColor = UIColor.clear
     
     graphView.shouldFill = true
     graphView.fillColor = UIColor.colorFromHex(hexString: "#FF0080")
     
     graphView.shouldDrawDataPoint = false
     graphView.dataPointSpacing = 20
     graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
     graphView.dataPointLabelColor = UIColor.white
     
     graphView.dataPointLabelsSparsity = 3
     
     graphView.referenceLineThickness = 1
     graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
     graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
     graphView.referenceLineLabelColor = UIColor.white
     graphView.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
     
     graphView.numberOfIntermediateReferenceLines = 1
     
     graphView.shouldAdaptRange = true
     
     graphView.rangeMax = 50
     
     return graphView
     }*/
    
    
    /*
     // Adding and updating the graph switching label in the top right corner of the screen.
     private func addLabel(withText text: String) {
     
     label.removeFromSuperview()
     label = createLabel(withText: text)
     label.isUserInteractionEnabled = true
     
     let rightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -10)
     
     let topConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10)
     
     let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
     let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: label.frame.width * 1.2)
     
     let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTap))
     label.addGestureRecognizer(tapGestureRecogniser)
     
     self.view.insertSubview(label, aboveSubview: graphView)
     self.view.addConstraints([rightConstraint, topConstraint, heightConstraint, widthConstraint])
     }*/
    
    
    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        label.text = text
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        
        return label
    }
    
    // Data Generation
    private func generateRandomData(_ numberOfItems: Int, max: Double) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(arc4random() % 100 < 10) {
                randomNumber *= 3
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
    private func generateSequentialLabels(_ numberOfItems: Int, text: String) -> [String] {
        var labels = [String]()
        for i in 0 ..< numberOfItems {
            labels.append("\(text) \(i+1)")
        }
        return labels
    }
    
    // The type of the current graph we are showing.
    enum GraphType {
        case dark
        case bar
        case dot
        case pink
        
        mutating func next() {
            switch(self) {
            case .dark:
                self = GraphType.bar
            case .bar:
                self = GraphType.dot
            case .dot:
                self = GraphType.pink
            case .pink:
                self = GraphType.dark
            }
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // carousel
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView
        var theView : StatLabel = UINib(nibName: "StatLabel", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! StatLabel
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            //get a reference to the label in the recycled view
            label = itemView.viewWithTag(1) as! UILabel
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            itemView.contentMode = .center
            label = UILabel(frame: itemView.bounds)
            label.backgroundColor = .clear
            label.textAlignment = .left
            label.font = UIFont(name: "Avenir-Light", size: 20.0)
            label.textColor = UIColor.white
            label.font = label.font.withSize(20)
            label.tag = 1
            if(index == 0) {
                theView.label1.text = "Average Sleep Time"
                theView.label2.text = items[index]
            }
            else if(index == 1) {
                theView.label1.text = "Suggested"
                theView.label2.text = items[index]
            }
            theView.backgroundColor = UIColor(white: 1, alpha: 0)
            theView.center = CGPoint(x: itemView.frame.size.height / 2, y: itemView.frame.size.height / 2)
            itemView.addSubview(theView)
            itemView.addSubview(label)
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        label.text = ""
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 8.0
        }
        return value
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

