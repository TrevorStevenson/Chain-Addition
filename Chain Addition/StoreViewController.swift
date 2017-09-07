//
//  StoreViewController.swift
//  Chain Addition
//
//  Created by Trevor Stevenson on 12/21/14.
//  Copyright (c) 2014 NCUnited. All rights reserved.
//

import UIKit
import iAd

class StoreViewController: UIViewController, ADBannerViewDelegate {

    var isPresentedModally: Bool = false
    
    @IBOutlet weak var adBanner: ADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: AnyObject)
    {
        if isPresentedModally
        {
            self.dismiss(animated: true, completion: nil)
            isPresentedModally = false
        }
        else
        {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
