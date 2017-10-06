//
//  InitialViewController.swift
//  Rest-New
//
//  Created by Patrick Li on 7/8/17.
//  Copyright © 2017 Dali Labs, Inc. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var paging: UIPageControl!
    
    
    var PageViewController: PageViewController? {
        didSet {
            PageViewController?.pageDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let screenHeight = UIScreen.main.bounds.height

        if(screenHeight == 736 ){
            self.container.frame = CGRect(x: 0, y: 0, width: 414, height: 736)
            self.paging.frame = CGRect(x: 188, y: 679, width: 39, height: 37)
            print("iphone 7+")
        }
        else if (screenHeight == 568){
            self.paging.frame = CGRect(x: 141, y: 521, width: 39, height: 37)
            self.container.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
            print("iphone 5")
        }
        

        paging.addTarget(self, action: #selector(InitialViewController.didChangePageControlValue), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? PageViewController {
            self.PageViewController = tutorialPageViewController
        }
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        PageViewController?.scrollToNextViewController()
    }
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    func didChangePageControlValue() {
        PageViewController?.scrollToViewController(index: paging.currentPage)
    }
}

extension InitialViewController: PageViewControllerDelegate {
    
    func PageViewController(_ PageViewController: PageViewController,
                                    didUpdatePageCount count: Int) {
        paging.numberOfPages = count
    }
    
    func PageViewController(_ PageViewController: PageViewController,
                                    didUpdatePageIndex index: Int) {
        paging.currentPage = index
    }
    
}
