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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if (UserDefaults.standard.bool(forKey: "showAds") == false)
        {
            adBanner.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        
        UIView.beginAnimations(nil, context: nil)
    
        UIView.setAnimationDuration(1.0)
    
        banner.alpha = 1.0
    
        UIView.commitAnimations()
  
        
    }
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        
        UIView.beginAnimations(nil, context: nil)
    
        UIView.setAnimationDuration(1.0)
    
        banner.alpha = 0.0
    
        UIView.commitAnimations()
   
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
    
    @IBAction func removeAds(_ sender: AnyObject)
    {
        PFPurchase.buyProduct("removeAds1", block: { (error:NSError?) -> Void in
        
            if error != nil
            {
                let alert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        })
    }
    @IBAction func buy5continues(_ sender: AnyObject)
    {
        PFPurchase.buyProduct("continues5", block: { (error:NSError?) -> Void in
            
            if error != nil
            {
                let alert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        })
    }
    @IBAction func buy20continues(_ sender: AnyObject)
    {
        PFPurchase.buyProduct("continues20", block: { (error:NSError?) -> Void in
            
            if error != nil
            {
                let alert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        })
    }
    @IBAction func buy50continues(_ sender: AnyObject)
    {
        PFPurchase.buyProduct("continues50", block: { (error:NSError?) -> Void in
            
            if error != nil
            {
                let alert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        })
    }
    
    @IBAction func restore(_ sender: AnyObject)
    {
        PFPurchase.restore()
        
        let alert = UIAlertView(title: "Restored", message: "Your purchases have been restored. If you are experiencing issues or you have questions, please contact the developer.", delegate: self, cancelButtonTitle: "Ok")
        
        alert.show()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
