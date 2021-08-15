//
//  SelectCarViewController.swift
//  RacingGameApp
//
//  Created by alexKoro on 8/15/21.
//

import UIKit

class SelectCarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellSize: CGSize {
        var minimumLineSpacing: CGFloat = 0
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            minimumLineSpacing = flowLayout.minimumLineSpacing
        }
        
        let width = (collectionView.frame.width - minimumLineSpacing)
        let height = self.view.frame.height
        return CGSize(width: width, height: height)
    }
    
    let images = [
        UIImage(named: GameImage.playerCar1.rawValue),
        UIImage(named: GameImage.playerCar2.rawValue),
        UIImage(named: GameImage.playerCar3.rawValue)
    ]
    let imagesName = [
        GameImage.playerCar1,
        GameImage.playerCar2,
        GameImage.playerCar3
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "SelectCarCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "SelectCarCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

extension SelectCarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "SelectCarCollectionViewCell",
                for: indexPath
        ) as? SelectCarCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = images[indexPath.item]
        return cell
    }

}

extension SelectCarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return self.cellSize
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        GameSettings.playerCarName = imagesName[indexPath.item].rawValue
        GameSettings.saveSettings()
        self.navigationController?.popViewController(animated: true)
    }
}
