//
//  LeMondeNewsFeedViewController.swift
//  LeeGo
//
//  Created by Victor WANG on 27/02/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import UIKit

class LeMondeNewsFeedViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            for reuseId in LeMonde.cellReuseIdentifiers {
                collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
            }
        }
    }

    private var elements = [ElementViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if elements.isEmpty {
            let URLRequest =  NSURLRequest(url: NSURL(string: "http://api-cdn.lemonde.fr/ws/6/mobile/www/ios-phone/en_continu/index.json")! as URL)
            let task = URLSession.shared.dataTask(with: URLRequest as URLRequest) {data, response, error in
                if let data = data,
                    let optionalValue = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String, Any>,
                    let value = optionalValue,
                    let elementDictionaries = value["elements"] as? Array<Dictionary<String, Any>> {
                        self.elements = ElementViewModel.elementViewModelsWithElements(elements: Element.elementsFromDictionaries(dictionaries: elementDictionaries))
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.collectionView.reloadData()
                        })
                }
            }

            task.resume()
        }

      (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize(width: self.view.frame.width, height: 180)
    }

    // MARK: Collection View DataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var brick = indexPath.row % 2 == 0 ? LeMonde.standard.brick() : LeMonde.featured.brick()

        if elements[indexPath.row].element.type == "live" {
            brick = LeMonde.live.brick()
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: brick.name, for: indexPath)

        cell.lg_configure(as: brick, dataSource: elements[indexPath.item], updatingStrategy: .always)

        return cell
    }

    // MARK: Collection View Layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }

    // MARK: size
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
          (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize(width: self.view.frame.width, height: 180)
            self.collectionView.reloadData()
            }, completion: nil)

        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension UICollectionViewCell {
    override open func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        return lg_fittingHeightLayoutAttributes(layoutAttributes)
    }
}
