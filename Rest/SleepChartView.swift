//
//  SleepChartView.swift
//  Rest
//
//  Created by Patrick Li on 5/13/17.
//  Copyright © 2017 Dali Labs, Inc. All rights reserved.
//

import UIKit
import ChameleonFramework


class SleepChartView: UIViewController {

    @IBOutlet var graphView: ScrollableGraphView!
    var currentGraphType = GraphType.dark
    var graphConstraints = [NSLayoutConstraint]()
    var gradientLayer: CAGradientLayer!

    @IBOutlet weak var suggestedNext: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    var label = UILabel()
    var labelConstraints = [NSLayoutConstraint]()

    // Data
    let numberOfDataItems = 29

    var data: [Double] = [Double]()
    var labels: [String] = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()

        var color1 = UIColor(hexString: "#fd7b56")!
        var color2 = UIColor(hexString: "#f85c59")!
        self.view.backgroundColor = GradientColor(UIGradientStyle.init(rawValue: 3)!, frame: self.view.frame, colors: [color1, color2])
        


        //addLabel(withText: "Switch View")
        graphView = createBarGraph(graphView.frame)
        graphView.set(data: data, withLabels: labels)
        self.view.insertSubview(graphView, belowSubview: label)
        
        // plist
        let dict = generateRandomData()
        if var plistFile = PlistFile(named: "SleepData") {
            plistFile.dictionary = dict
            var retrievedData : [String : Double] = (PlistFile(named: "SleepData")?.dictionary) as! [String : Double]
            for index in 1...10 {
                data.append(retrievedData["May " + String(index)]!)
                labels.append("May " + String(index))
            }
            graphView.set(data: data, withLabels: labels)
            //averageLabel.text = String(getAverage(dict: dict))
            //suggestedNext.text = String(getSuggested(dict: dict))
        }
    }
    
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

    }

    private func createBarGraph(_ frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame:frame)

        graphView.dataPointType = ScrollableGraphViewDataPointType.circle
        graphView.shouldDrawBarLayer = true
        graphView.shouldDrawDataPoint = false

        graphView.lineColor = UIColor.clear
        graphView.barWidth = 25
        graphView.barLineWidth = 1
        graphView.barLineColor = UIColor.white.withAlphaComponent(1)
        graphView.barColor = UIColor.white.withAlphaComponent(0.5)

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
    }



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
    }

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

}
