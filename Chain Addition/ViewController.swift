//
//  ViewController.swift
//  Chain Addition
//
//  Created by Trevor Stevenson on 12/20/14.
//  Copyright (c) 2014 NCUnited. All rights reserved.
//

import UIKit
import iAd
import GameKit

class ViewController: UIViewController, ADBannerViewDelegate, GKGameCenterControllerDelegate {

    var localPlayer = GKLocalPlayer()
    var gameCenterEnabled: Bool = false
    var leaderBoardIdentifier: String = "highScore"
    var adTimer = Timer()
    
    @IBOutlet weak var freePointsButton: UIButton!
    
    @IBOutlet weak var adBanner: ADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        freePointsButton.isHidden = true
        
        isAdAvailable()
        
        adTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.isAdAvailable), userInfo: nil, repeats: true)
        
        authenticateLocalPlayer()

        if (UserDefaults.standard.bool(forKey: "showAds") == false)
        {
            adBanner.removeFromSuperview()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        adTimer.invalidate()
        
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
    
    func isAdAvailable()
    {
        if (AdColony.isVirtualCurrencyRewardAvailableForZone("vz14d49337fdb14d4990"))
        {
            freePointsButton.isHidden = false
        }
        else
        {
            freePointsButton.isHidden = true
        }
    }
    
    
    func authenticateLocalPlayer()
    {
        localPlayer.authenticateHandler = {(viewController: UIViewController!, error: NSError?) in
            
            if (viewController != nil)
            {
                self.present(viewController, animated: true, completion: nil)
            }
            else
            {
                if (GKLocalPlayer.localPlayer().isAuthenticated)
                {
                    self.gameCenterEnabled = true
                    
                    GKLocalPlayer.localPlayer().loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifier:String!, error:NSError!) -> Void in
                        
                        if (error != nil)
                        {
                            println(error.localizedDescription)
                        }
                        else
                        {
                            self.leaderBoardIdentifier = leaderboardIdentifier
                        }
                        
                        } as! (String?, Error?) -> Void)
                    
                }
                else
                {
                    self.gameCenterEnabled = false
                }
            }
            
        } as! (UIViewController?, Error?) -> Void

    }
    
    func showLeaderboard(_ identifier: NSString)
    {
        let GKVC = GKGameCenterViewController()
        
        GKVC.gameCenterDelegate = self
        
        GKVC.viewState = GKGameCenterViewControllerState.leaderboards
        
        GKVC.leaderboardIdentifier = identifier as String
        
        present(GKVC, animated: true, completion: nil)
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController!) {
        
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func leaderboard(_ sender: AnyObject)
    {
        showLeaderboard(leaderBoardIdentifier as NSString)
    }

    @IBAction func twitter(_ sender: AnyObject)
    {
        let twitterURL = URL(string: "twitter://user?screen_name=NCUnitedApps")
        
        if (UIApplication.shared.canOpenURL(twitterURL!))
        {
            UIApplication.shared.openURL(twitterURL!)
        }
        else
        {
            UIApplication.shared.openURL(URL(fileURLWithPath: "www.twitter.com/NCUnitedApps"))
        }
    }
   
    @IBAction func freePoints(_ sender: AnyObject) {
        
        if (AdColony.isVirtualCurrencyRewardAvailableForZone("vz14d49337fdb14d4990"))
        {
            println("yes")
            AdColony.playVideoAdForZone("vz14d49337fdb14d4990", withDelegate: nil, withV4VCPrePopup: true, andV4VCPostPopup: true)
            
        }
        else
        {
            println("no")
            let alert = UIAlertView(title: "Sorry", message: "Ad currently unavailable.", delegate: self, cancelButtonTitle: "Ok")
            
            alert.show()
        }

    }
}

