//
//  ConsoleTableViewCell.swift
//  MyGames
//
//  Created by Luiz Gomes on 08/06/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class ConsoleTableViewCell: UITableViewCell {

    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with console: Console) {
        
        lbTitle.text = console.name ?? ""
        if let image = console.cover as? UIImage {
            ivImage.image = image
        } else {
            ivImage.image = UIImage(named: "noImage")
        }
    }

}
