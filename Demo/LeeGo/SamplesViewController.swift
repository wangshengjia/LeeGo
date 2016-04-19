//
//  SamplesViewController.swift
//  LeeGo
//
//  Created by Victor WANG on 31/03/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import UIKit
import LeeGo

class SamplesViewController: UITableViewController {

    private var elements = [SampleItem]()

    override func awakeFromNib() {
        super.awakeFromNib()

        tableView.allowsSelection = false
        tableView?.estimatedRowHeight = 44.0
        tableView?.rowHeight = UITableViewAutomaticDimension

        LeeGoShowcase.reuseIdentifiers.forEach { (identifier) in
            tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0...30 {
            elements.append(SampleItem())
        }
    }

    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated)
        tableView.reloadData()
    }



    // MARK: Datasource

//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let brick = {_ -> Brick in
            switch indexPath.row {
            case 0: return LeeGoShowcase.showcase1.brick()
            case 1: return LeeGoShowcase.showcase2.brick()
            case 2: return LeeGoShowcase.showcase3.brick()
            case 3: return LeeGoShowcase.showcase4.brick()
            case 4: return LeeGoShowcase.showcase5.brick()
            case 5: return LeeGoShowcase.showcase6.brick()
            case 6: return LeeGoShowcase.showcase7.brick()
            case 7: return LeeGoShowcase.showcase8.brick()
            case 8: return LeeGoShowcase.showcase9.brick()
            case 9: return LeeGoShowcase.showcase10.brick()
            case 10: return LeeGoShowcase.showcase11.brick()
            case 11: return LeeGoShowcase.showcase12.brick()
            default: return LeeGoShowcase.showcase1.brick()
            }
        }()

        let cell = tableView.dequeueReusableCellWithIdentifier(brick.name, forIndexPath: indexPath)

        cell.configure(brick, dataSource: nil, updatingStrategy: .Always)

        return cell
    }
}


