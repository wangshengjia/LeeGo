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

        tableView?.estimatedRowHeight = 44.0
        tableView?.rowHeight = UITableViewAutomaticDimension

        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "showcase")
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "showcase1")
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "showcase2")
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "showcase3")
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "showcase4")
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "showcase5")
//        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "showcase2")
//        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "showcase3")
//        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "showcase4")
//        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "showcase5")
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
            switch indexPath.row % 6 {
            case 0: return LeeGoShowcase.showcase.brick()
            case 1: return LeeGoShowcase.showcase1.brick()
            case 2: return LeeGoShowcase.showcase2.brick()
            case 3: return LeeGoShowcase.showcase3.brick()
            case 4: return LeeGoShowcase.showcase4.brick()
            case 5: return LeeGoShowcase.showcase5.brick()
            default: return LeeGoShowcase.showcase.brick()
            }
        }()

        let cell = tableView.dequeueReusableCellWithIdentifier(brick.name, forIndexPath: indexPath)

        cell.configure(brick)

        return cell
    }
}


