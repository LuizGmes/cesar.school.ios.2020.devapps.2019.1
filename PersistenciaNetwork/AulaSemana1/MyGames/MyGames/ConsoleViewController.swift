//
//  ConsoleViewController.swift
//  MyGames
//
//  Created by Luiz Gomes on 08/06/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivImagem: UIImageView!
    
    var console: Console?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        lbTitle.text = console?.name
        if let image = console?.cover as? UIImage {
            ivImagem.image = image
        } else {
            ivImagem.image = UIImage(named: "noCoverFull")
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! AddEditConsoleViewController
        vc.console = console
    }

}
