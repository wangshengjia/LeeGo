//
//  TwitterFeedViewController.swift
//  LeeGo
//
//  Created by Victor WANG on 29/02/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import UIKit
import LeeGo

class TwitterFeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var elements = [Tweet]()

    override func awakeFromNib() {
        super.awakeFromNib()

        for reuseId in Twitter.reuseIdentifiers {
            collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        (collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, 280)

        if let path = NSBundle.mainBundle().pathForResource("twitter_sample", ofType: "json"),
            let data = NSData(contentsOfFile: path),
            let optionalValue = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>,
            let value = optionalValue,
            let elementDictionaries = value["statuses"] as? [[String: AnyObject]] where elements.isEmpty {
                elements = Tweet.tweets(elementDictionaries)
        }
    }

    // MARK: Collection View DataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let configuration = Twitter.tweet.configuration()//indexPath.row % 2 == 0 ? Twitter.tweetText.container() : Twitter.toolbarFooter.configuration()

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(configuration.name, forIndexPath: indexPath)

        cell.configure(configuration, dataSource: elements[indexPath.item])

        return cell
    }

    // MARK: Collection View Layout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 180)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }

    // MARK: size
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, 280)
            self.collectionView?.reloadData()
            }, completion: nil)

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
}
