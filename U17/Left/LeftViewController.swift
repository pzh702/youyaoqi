//
//  LeftViewController.swift
//  测试1
//
//  Created by PT iOS Mac on 2020/8/14.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit
import SnapKit

class LeftViewController: UIViewController {

	private lazy var myArray: Array = {
        return [[["icon":"mine_vip", "title": "我的VIP"],
                 ["icon":"mine_coin", "title": "充值妖气币"]],

                [["icon":"mine_accout", "title": "消费记录"],
                 ["icon":"mine_subscript", "title": "我的订阅"],
                 ["icon":"mine_seal", "title": "我的封印图"]],

                [["icon":"mine_message", "title": "我的消息/优惠券"],
                 ["icon":"mine_cashew", "title": "妖果商城"],
                 ["icon":"mine_freed", "title": "在线阅读免流量"]],

                [["icon":"mine_feedBack", "title": "帮助中心"],
                 ["icon":"mine_mail", "title": "我要反馈"],
                 ["icon":"mine_judge", "title": "给我们评分"],
                 ["icon":"mine_author", "title": "成为作者"],
                 ["icon":"mine_setting", "title": "设置"]]]
    }()

	private var tableView: UITableView = {
		let tw = UITableView.init(frame: .zero, style: .grouped)
		tw.backgroundColor = .backGround
		tw.isScrollEnabled = false
		tw.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
		return tw
	}()

	lazy var headView: ULeftHeaderView = {
		let head = ULeftHeaderView.init()
		return head
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .backGround
		self.view.addSubview(headView)
		headView.snp.makeConstraints { (make) in
			make.top.left.right.equalTo(self.view)
			make.height.equalTo(150)
		}
		self.view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.snp.makeConstraints { (make) in
			make.top.equalTo(headView.snp.bottom)
			make.left.right.bottom.equalTo(self.view)
		}
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

	}

}

extension LeftViewController:UITableViewDelegate,UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myArray[section].count
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return myArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
		let sectionArr = myArray[indexPath.section]
		cell.textLabel?.text = sectionArr[indexPath.row]["title"]
		cell.imageView?.image = UIImage.init(named: sectionArr[indexPath.row]["icon"] ?? "")

		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return nil
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0.01
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 10
	}
}
