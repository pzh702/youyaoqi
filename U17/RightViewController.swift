//
//  RightViewController.swift
//  测试1
//
//  Created by PT iOS Mac on 2020/8/14.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import JXSegmentedView

class RightViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor(red: CGFloat(arc4random()%255)/255, green: CGFloat(arc4random()%255)/255, blue: CGFloat(arc4random()%255)/255, alpha: 1)
        // Do any additional setup after loading the view.
    }
    



}

extension RightViewController:JXSegmentedListContainerViewListDelegate{
	func listView() -> UIView {
		return self.view
	}
	func listDidAppear() {

	}
	func listWillAppear(){
		
	}
}
