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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Layout Samples"
        case 1:
            cell.textLabel?.text = "Le Monde"
        case 2:
            cell.textLabel?.text = "Twitter"
        case 3:
            cell.textLabel?.text = "Details Page"
        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SamplesViewController") as? SamplesViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        case 1:
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LeMondeNewsFeedViewController") as? LeMondeNewsFeedViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        case 2:
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TwitterFeedViewController") as? TwitterFeedViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        case 3:
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
}





