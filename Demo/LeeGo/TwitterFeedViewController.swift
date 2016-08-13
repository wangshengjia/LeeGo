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
            collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

      (collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize(width: self.view.frame.width, height: 280)

        if let path = Bundle.main.path(forResource: "twitter_sample", ofType: "json"),
            let data = NSData(contentsOfFile: path),
            let optionalValue = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>,
            let value = optionalValue,
            let elementDictionaries = value["statuses"] as? [[String: AnyObject]], elements.isEmpty {
                elements = Tweet.tweets(jsonArray: elementDictionaries)
        }
    }

    // MARK: Collection View DataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let tweetBrick = Twitter.tweet.brick()

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetBrick.name, for: indexPath)

        cell.lg_configureAs(tweetBrick, dataSource: elements[indexPath.item])

        return cell
    }

    // MARK: Collection View Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }

    // MARK: size
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
          (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize(width: self.view.frame.width, height: 280)
            self.collectionView?.reloadData()
            }, completion: nil)

        super.viewWillTransition(to: size, with: coordinator)
    }
}
