//
//  GameViewController.swift
//  Chain Addition
//
//  Created by Trevor Stevenson on 12/20/14.
//  Copyright (c) 2014 NCUnited. All rights reserved.
//

import UIKit
import GameKit

class GameViewController: UIViewController, UIAlertViewDelegate {
    
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
        if answerText.characters.count < 10
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
                
                submitScore()
                
                let defaults = UserDefaults.standard
                
                defaults.set(1, forKey: "level")
                defaults.set(3, forKey: "lives")
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        isGameRunning = false
    }
    
    func submitScore()
    {
        let id = "highScore"
        let highScore = GKScore(leaderboardIdentifier:id)
        
        highScore.value = Int64(level)
        
        GKScore.report([highScore], withCompletionHandler: { (error: Error!) -> Void in
            
            if error != nil
            {
                print(error.localizedDescription)
            }
        })
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
    
}
