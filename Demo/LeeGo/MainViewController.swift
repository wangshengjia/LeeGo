//
//  ViewController.swift
//  PlaygroundProject
//
//  Created by Victor WANG on 12/11/15.
//  Copyright © 2015 Le Monde. All rights reserved.
//

import UIKit
import LeeGo

class MainViewController: UITableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Le Monde"
        case 1:
            cell.textLabel?.text = "Twitter"
        case 2:
            cell.textLabel?.text = "New York Times"
        default:
            break
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("LeMondeNewsFeedViewController") as? LeMondeNewsFeedViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        case 1:
            if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("TwitterFeedViewController") as? TwitterFeedViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
}





