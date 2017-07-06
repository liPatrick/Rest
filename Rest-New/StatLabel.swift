//
//  StatLabel.swift
//  Rest-New
//
//  Created by Daniel Bessonov on 7/3/17.
//  Copyright © 2017 Dali Labs, Inc. All rights reserved.
//

import Foundation
import UIKit

class StatLabel : UIView {
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label2: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let subView: UIView = loadViewFromNib()
        subView.frame = self.bounds
        //label1.text = "123" //would cause error
        addSubview(subView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() -> UIView {
        let view: UIView = UINib(nibName: "StatLabel", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        return view
    }
}
