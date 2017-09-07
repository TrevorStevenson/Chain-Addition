//
//  GameViewController.swift
//  Chain Addition
//
//  Created by Trevor Stevenson on 12/20/14.
//  Copyright (c) 2014 NCUnited. All rights reserved.
//

import UIKit
import GameKit

class GameViewController: UIViewController, UIAlertViewDelegate, AdColonyAdDelegate {
    
    var speed: TimeInterval = 5
    var level: Int = 1
    var answerText: String = ""
    var runningTotal: Int = 0
    var continues: Int = 0
    var lives: Int = 3
    var adTimer = Timer()
    
    var isGameRunning: Bool = false
    var isButtonShowing: Bool = false
    
    var startButton: UIButton = UIButton()
    var freeButton: UIButton = UIButton()

    var levelLabel = UILabel()
    
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var life1: UILabel!
    @IBOutlet weak var life2: UILabel!
    @IBOutlet weak var life3: UILabel!
    

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button0: UIButton!
    
    var buttonsArray: [UIButton] = []
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        continues = UserDefaults.standard.integer(forKey: "continues")
        
        buttonsArray = [button1, button2, button3, button4, button5, button6, button7, button8, button9, button0]
        
        for button in buttonsArray
        {
            button.isUserInteractionEnabled = false
        }
        
        clearButton.isUserInteractionEnabled = false
        enterButton.isUserInteractionEnabled = false
        
        let defaults = UserDefaults.standard
        
        level = defaults.integer(forKey: "level")
        lives = defaults.integer(forKey: "lives")
        
        if (defaults.bool(forKey: "addLevels"))
        {
            level += 5
            
            defaults.set(false, forKey: "addLevels")
            
        }
        
        if lives == 0
        {
            level = 1
            lives = 3
        }
        else if lives == 1
        {
            life1.isHidden = true
            life2.isHidden = true
        }
        else if lives == 2
        {
            life1.isHidden = true
        }
        
        if (!isButtonShowing)
        {
            showStartButton()
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func newLevel()
    {
        isGameRunning = true
        
        isButtonShowing = false
        
        startButton.isHidden = true
        
        freeButton.isHidden = true
        adTimer.invalidate()
        
        updateLevelLabel()
        levelLabel.isHidden = true
        
        for button in buttonsArray
        {
            button.isUserInteractionEnabled = false
        }
        
        clearButton.isUserInteractionEnabled = false
        enterButton.isUserInteractionEnabled = false
        
        answerText = "Add the numbers"
        updateAnswerLabel()
        
        runningTotal = 0
        
        for i in 0 ..< level + 4
        {
            if i < level + 3
            {
                createNumber(TimeInterval(i), isLast: false)

            }
            else
            {
                createNumber(TimeInterval(i), isLast: true)
            }
        }

    }
    
    func createNumber(_ withDelay: TimeInterval, isLast: Bool)
    {        
        let randomNumber = arc4random_uniform(10) + 1
        
        runningTotal += Int(randomNumber)
        
        var y: UInt32 = 0
        
        if self.view.frame.size.height == 480
        {
            y = 101
        }
        else if self.view.frame.size.height == 568
        {
            y = 161
        }
        else if self.view.frame.size.height == 667
        {
            y = 251
        }
        else
        {
            y = 351
        }
        
        let label = UILabel(frame: CGRect(x: self.view.frame.size.width, y: CGFloat(arc4random_uniform(y)) + 60, width: 100, height: 100))
        
        label.text = String(randomNumber)
        label.font = UIFont(name: "Verdana-Bold", size: 70)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(label)
        
        UIView.animate(withDuration: 10 / speed, delay: withDelay, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            
            label.frame.origin.x = -60
            
            }) { (completed: Bool) -> Void in
            
            if isLast
            {
                for button in self.buttonsArray
                {
                    button.isUserInteractionEnabled = true
                }
                
                self.clearButton.isUserInteractionEnabled = true
                self.enterButton.isUserInteractionEnabled = true
                
                self.answerText = ""
                self.updateAnswerLabel()
            }
                
            label.removeFromSuperview()
                
        }
    }
    
    func isAdAvailable()
    {
        if (AdColony.isVirtualCurrencyRewardAvailableForZone("vz14d49337fdb14d4990"))
        {
            freeButton.isHidden = false
        }
        else
        {
            freeButton.isHidden = true
        }
    }
    
    func showStartButton()
    {
        isButtonShowing = true
        
        var y: CGFloat = 0
        
        if self.view.frame.size.height == 480
        {
            y = 110.0
        }
        else if self.view.frame.size.height == 568
        {
            y = 170.0
        }
        else if self.view.frame.size.height == 667
        {
            y = 230.0
        }
        else
        {
            y = 260.0
        }
        startButton = UIButton(frame: CGRect(x: self.view.frame.size.width / 2 - 50, y: y, width: 100, height: 50))
        
        startButton.setTitle("Begin", for: UIControlState())
        startButton.addTarget(self, action: #selector(GameViewController.newLevel), for: UIControlEvents.touchUpInside)
        startButton.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 30)
        
        self.view.addSubview(startButton)
        
        freeButton = UIButton(frame: CGRect(x: startButton.frame.origin.x - 25, y: startButton.frame.origin.y - 50, width: 150, height: 50))
        
        freeButton.setTitle("5 Free Levels", for: UIControlState())
        freeButton.addTarget(self, action: #selector(GameViewController.freePoints), for: UIControlEvents.touchUpInside)
        freeButton.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 20)
        
        self.view.addSubview(freeButton)
        
        isAdAvailable()
        
        adTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.isAdAvailable), userInfo: nil, repeats: true)
        
        
        levelLabel = UILabel(frame: CGRect(x: startButton.frame.origin.x, y: startButton.frame.origin.y + startButton.frame.size.height, width: startButton.frame.size.width, height: startButton.frame.size.height))
        
        levelLabel.text = "Level: " + String(level)
        levelLabel.textColor = UIColor.white
        levelLabel.textAlignment = .center
        levelLabel.font = UIFont(name: "Verdana-Bold", size: 17)
        
        self.view.addSubview(levelLabel)
        
    }
    
    func updateLevelLabel()
    {
        levelLabel.text = "Level: " + String(level)
    }
    
    func updateAnswerLabel()
    {
        answerLabel.text = answerText
    }
    
    @IBAction func quit(_ sender: AnyObject)
    {
        if isGameRunning
        {
            cheatersNeverWin()
        }
        else
        {
            saveAndQuit()
        }
    }

    @IBAction func keypadEntry(_ sender: UIButton)
    {
        if count(answerText) < 10
        {
            answerText =  answerText + String(sender.title(for: UIControlState())!)
            updateAnswerLabel()
        }
       
    }
    
    @IBAction func clearEntry(_ sender: AnyObject)
    {
        answerText = ""
        updateAnswerLabel()
    }
    
    @IBAction func enter(_ sender: AnyObject)
    {
        if answerText == String(runningTotal)
        {
            answerText = "Correct"
            updateAnswerLabel()
            
            level += 1
            
            startButton.isHidden = false
            
            updateLevelLabel()
            levelLabel.isHidden = false
        }
        else
        {
            answerText = "Incorrect"
            updateAnswerLabel()
            
            lives -= 1
            
            if lives == 2
            {
                life1.isHidden = true
                
                level += 1
                
                startButton.isHidden = false
                
                updateLevelLabel()
                levelLabel.isHidden = false
                
            }
            else if lives == 1
            {
                life2.isHidden = true
                
                startButton.isHidden = false
                
                level += 1
                
                updateLevelLabel()
                levelLabel.isHidden = false
                
            }
            else if lives == 0
            {
                life3.isHidden = true
                
                let alert = UIAlertView(title: "Continue?", message: "Would you like to use a continue to keep playing? You have \(continues) continues remaining.", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "No", "Yes")
                
                alert.tag = 1
                
                alert.show()
            }
           
        }
        
        isGameRunning = false
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if alertView.tag == 1
        {
            if buttonIndex == 0
            {
                submitScore()
                
                var defaults = UserDefaults.standard
                
                defaults.set(1, forKey: "level")
                defaults.set(3, forKey: "lives")
                
                self.navigationController?.popToRootViewController(animated: true)
            
                AdColony.playVideoAdForZone("vz99a4e1c37edc48c492", withDelegate: self)

                
            }
            else if buttonIndex == 1
            {
                if continues == 0
                {
                    let alert2 = UIAlertView(title: "No Continues Remaining", message: "You are out of continues.", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Ok")
                    
                    alert2.tag = 2
                    
                    alert2.show()
                    
                    submitScore()
                    
                }
                else
                {
                    continues -= 1
                    
                    UserDefaults.standard.set(continues, forKey: "continues")
                    
                    life1.isHidden = false
                    life2.isHidden = false
                    life3.isHidden = false
                    
                    lives = 3
                    
                    level += 1
                    
                    startButton.isHidden = false
                    
                    updateLevelLabel()
                    levelLabel.isHidden = false
                    
                }
               
            }
        }
        else if alertView.tag == 2
        {
            if buttonIndex == 0
            {
                var SVC = storyboard?.instantiateViewController(withIdentifier: "SVC") as! StoreViewController
                SVC.isPresentedModally = true
                
                self.navigationController?.present(SVC, animated: true, completion: nil)
            }
        }
        
    }
    
    func submitScore()
    {
        var id: String = "highScore"
        
        var highScore = GKScore(leaderboardIdentifier:id)
        
        highScore.value = Int64(level)
        
        GKScore.report([highScore], withCompletionHandler: { (error:NSError!) -> Void in
            
            if (error != nil)
            {
                println(error.localizedDescription)
            }
        } as! (Error?) -> Void)
        
    }
    
    func saveAndQuit()
    {
        let defaults = UserDefaults.standard
        
        defaults.set(level, forKey: "level")
        
        defaults.set(lives, forKey: "lives")
        
        startButton.removeFromSuperview()
        levelLabel.removeFromSuperview()
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func cheatersNeverWin()
    {
        let defaults = UserDefaults.standard
        
        defaults.set(level, forKey: "level")
        
        lives -= 1
        
        if lives == 0
        {
            submitScore()
        }
        
        defaults.set(lives, forKey: "lives")
        
        startButton.removeFromSuperview()
        levelLabel.removeFromSuperview()
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func freePoints() {
        
        if (AdColony.isVirtualCurrencyRewardAvailableForZone("vz14d49337fdb14d4990"))
        {
            println("yes")
            AdColony.playVideoAdForZone("vz14d49337fdb14d4990", withDelegate: nil, withV4VCPrePopup: true, andV4VCPostPopup: true)
            
            level += 5
            
            updateLevelLabel()
            
        }
        else
        {
            println("no")
            let alert = UIAlertView(title: "Sorry", message: "Ad currently unavailable.", delegate: self, cancelButtonTitle: "Ok")
            
            alert.show()
        }
        
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
