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

//    @IBOutlet weak var searchBar: UISearchBar!
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

        self.collectionView.reloadData()
        let URLRequest =  NSURLRequest(URL: NSURL(string: "http://api-cdn.lemonde.fr/ws/5/mobile/www/ios-phone/en_continu/index.json")!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(URLRequest) {data, response, error in
            if let data = data,
                let optionalValue = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>,
                let value = optionalValue,
                let elementDictionaries = value["elements"] as? Array<Dictionary<String, AnyObject>> {
                    self.elements = ElementViewModel.elementViewModelsWithElements(Element.elementsFromDictionaries(elementDictionaries))
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.collectionView.reloadData()
                    })
            }
        }

        task.resume()

        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 180)
    }

    // MARK: Collection View DataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let configurationType = ConfigurationTarget.Article
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(configurationType.rawValue, forIndexPath: indexPath)

        cell.configure(with: elements[indexPath.item], configuration: configurationType.configuration())

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

extension ViewController: ConfiguratorDelegate {

    func willApply<Component: UIView>(with style: StyleType, toComponent component: Component, withItem item: ItemType, atIndexPath indexPath: NSIndexPath?) -> StyleType {
        

        return style
    }

    func willComposite<Component: UIView>(with components: [ComponentTarget], toComponent component: Component, using layout: Layout, withItem item: ItemType, atIndexPath indexPath: NSIndexPath?) {

    }

    func willApply<Component: UIView>(with configuration: Configuration, toComponent component: Component, withItem item: ItemType, atIndexPath indexPath: NSIndexPath?) -> Configuration {
        guard let indexPath = indexPath else {
            return configuration
        }

        if (item is ElementViewModel && indexPath.item > 5) {
            return configuration
        }

        return configuration
    }

    func didApply<Component: UIView>(with configuration: Configuration, toComponent component: Component, withItem item: ItemType, atIndexPath indexPath: NSIndexPath?) {

    }
}




