//
//  ViewController.swift
//  PlaygroundProject
//
//  Created by Victor WANG on 12/11/15.
//  Copyright © 2015 Le Monde. All rights reserved.
//

import UIKit
import ReactiveCocoa
import LeeGo

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            for reuseId in ConfigurationTarget.allTypes {
                collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
            }
        }
    }

    private var elements = [ElementViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // a little bit hack, should not ship to production
        guard let textField = searchBar.valueForKey("_searchField") as? UITextField else {
            return
        }

        let searchStrings: SignalProducer = textField.rac_textSignal()
            .toSignalProducer()
            .throttle(2.0, onScheduler: QueueScheduler.mainQueueScheduler)
            .map { text in text as! String }
            .filter {text in text.characters.count > 3}
            .flatMap(.Latest) { (query: String) -> SignalProducer<(NSData, NSURLResponse), NSError> in
                let URLRequest =  NSURLRequest(URL: NSURL(string: "http://api-cdn.lemonde.fr/ws/5/mobile/www/ios-phone/search/index.json?keywords=holland")!)
                return NSURLSession.sharedSession()
                    .rac_dataWithRequest(URLRequest)
                    .flatMapError { error in
                        print("Network error occurred: \(error)")
                        return SignalProducer.empty
                }
            }
            .map { (data, URLResponse) -> AnyObject? in
                return try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            }
            .observeOn(QueueScheduler.mainQueueScheduler)

        searchStrings.start {[weak self] event in
            switch event {
            case let .Next(value):
                if let value = value as? Dictionary<String, AnyObject>,
                    let elementDictionaries = value["elements"] as? Array<Dictionary<String, AnyObject>> {
                        self?.elements = ElementViewModel.elementViewModelsWithElements(Element.elementsFromDictionaries(elementDictionaries))
                        self?.collectionView.reloadData()
                }
            case let .Failed(error):
                print("Failed event: \(error)")

            case .Completed:
                print("Completed event")

            case .Interrupted:
                print("Interrupted event")
            }
        }

        if collectionView.collectionViewLayout.respondsToSelector("estimatedItemSize") {//not available on iOS 7
            (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 180)
        }
    }

    // MARK: Collection View DataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let configurationType = ConfigurationTarget.Article
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(configurationType.rawValue, forIndexPath: indexPath)

        cell.configure(elements[indexPath.item], configuration: configurationType.configuration())

        return cell
    }

    // MARK: Collection View Layout

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake(CGRectGetWidth(collectionView.frame), 180)
//    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }
}

