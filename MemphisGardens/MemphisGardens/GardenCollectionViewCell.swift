//
//  GardenCollectionViewCell.swift
//  MemphisGardens
//
//  Created by Kareem Dasilva on 2/25/23.
//

import UIKit

class GardenCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var previewImage: UIImageView!
    var garden:Garden?
    @IBOutlet var rating: UILabel!
    @IBOutlet var ownerName: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var isOpen: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var name: UILabel!
    
    func configureCell(gardenData:Garden) {
        self.garden = gardenData
        //foodtruckName.text = foodTruckData.foodTruckName
        //foodtruckCategory.text = foodTruckData.foodTruckCategory
    }
}
