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

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            for reuseId in ComponentProvider.cellReuseIdentifiers {
                collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
            }
        }
    }

    private var elements = [ElementViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, 280)

        collectionView.reloadData()

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
    }

    // MARK: Collection View DataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let configurationType = indexPath.row % 2 == 0 ? ComponentProvider.article : .featured
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(configurationType), forIndexPath: indexPath)

        cell.configure(with: elements[indexPath.item], componentTarget: configurationType.componentTarget()!)

        return cell
    }

    // MARK: Collection View Layout

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake(CGRectGetWidth(collectionView.frame), 180)
//    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }

    // MARK: size
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSizeMake(self.view.frame.width, 280)
            self.collectionView.reloadData()
            }, completion: nil)

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.pushViewController(DetailsViewController(), animated: true)
    }
}

//extension ViewController: ConfiguratorDelegate {
//
//    func willApply<Component: UIView>(with style: [Appearance], toComponent component: Component, withItem item: ItemType, atIndexPath indexPath: NSIndexPath?) -> [Appearance] {
//        
//
//        return style
//    }
//
//    func willComposite<Component: UIView>(with components: [ComponentTarget], toComponent component: Component, using layout: Layout, withItem item: ItemType, atIndexPath indexPath: NSIndexPath?) {
//
//    }
//
//    func willApply<Component: UIView>(with componentTarget: ComponentTarget, toComponent component: Component, withItem item: ItemType, atIndexPath indexPath: NSIndexPath?) -> ComponentTarget {
//        guard let indexPath = indexPath else {
//            return componentTarget
//        }
//
//        if (item is ElementViewModel && indexPath.item > 5) {
//            return componentTarget
//        }
//
//        return componentTarget
//    }
//
//    func didApply<Component: UIView>(with componentTarget: ComponentTarget, toComponent component: Component, withItem item: ItemType, atIndexPath indexPath: NSIndexPath?) {
//
//    }
//}




