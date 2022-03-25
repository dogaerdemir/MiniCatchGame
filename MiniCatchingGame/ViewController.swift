import UIKit

class ViewController: UIViewController {
    
    var score = 0
    var highscore = 0
    var timer = Timer()
    var timer2 = Timer()
    var counter = 0
    var diff = 0.80
    var imgArray = [UIImageView]()
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var g1: UIImageView!
    @IBOutlet weak var g2: UIImageView!
    @IBOutlet weak var g3: UIImageView!
    @IBOutlet weak var g4: UIImageView!
    @IBOutlet weak var g5: UIImageView!
    @IBOutlet weak var g6: UIImageView!
    @IBOutlet weak var g7: UIImageView!
    @IBOutlet weak var g8: UIImageView!
    @IBOutlet weak var g9: UIImageView!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var difficultSlider: UISegmentedControl!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var startButton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scoreLabel.text = "Score: \(score)"
        
        let storedHighscore = UserDefaults.standard.object(forKey: "highscore")
        
        if storedHighscore == nil{
            highscore = 0
            highscoreLabel.text = "Highscore: \(highscore)"
        }
        
        if let newScore = storedHighscore as? Int{
            highscore = newScore
            highscoreLabel.text = "Highscore: \(highscore)"
        }
        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        
        g1.addGestureRecognizer(recognizer1)
        g2.addGestureRecognizer(recognizer2)
        g3.addGestureRecognizer(recognizer3)
        g4.addGestureRecognizer(recognizer4)
        g5.addGestureRecognizer(recognizer5)
        g6.addGestureRecognizer(recognizer6)
        g7.addGestureRecognizer(recognizer7)
        g8.addGestureRecognizer(recognizer8)
        g9.addGestureRecognizer(recognizer9)
        
        imgArray = [g1,g2,g3,g4,g5,g6,g7,g8,g9]
        
        for i in imgArray
        {
            i.isHidden = true
        }
        
        sliderLabel.text = "Time: 5"
        timeLabel.text = "Remaining: \(counter)"
    }
    
    
    @objc func hideAndPlay()
    {
        for i in imgArray
        {
            i.isHidden = true
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(imgArray.count - 1)))
        imgArray[randomIndex].isHidden = false
    }

    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(timeSlider.value)
        sliderLabel.text = String("Time: \(currentValue)")
    }
    
    @objc func increaseScore(){
        score += 1
        scoreLabel.text = "Score: \(score)"
        
        for img in imgArray {
            img.isHidden = true
        }
    }
    
    
    @objc func countDown()
    {
        counter -= 1
        timeLabel.text = "Time Left: \(counter)"
        
        if counter == 0
        {
            difficultSlider.isEnabled = true
            timeSlider.isEnabled = true
            startButton.isEnabled = true
            for i in imgArray
            {
                i.isHidden = true
            }
            timer.invalidate()
            timer2.invalidate()
            
            if self.score > self.highscore
            {
                self.highscore = self.score
                highscoreLabel.text = "Highscore: \(self.highscore)"
                UserDefaults.standard.set(self.highscore, forKey: "highscore")
            }
            
            let alert = UIAlertController(title: "Game ended", message: "", preferredStyle: UIAlertController.Style.alert)
            let quitButton = UIAlertAction(title: "Quit", style: UIAlertAction.Style.destructive) {UIAlertAction in
                exit(-1)
            }
            let hideButton = UIAlertAction(title: "Return to Homescreen", style: UIAlertAction.Style.default){ UIAlertAction in
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
            }
            let replayButton = UIAlertAction(title: "Play Again", style: UIAlertAction.Style.cancel) { UIAlertAction in
                //replay
                self.difficultSlider.isEnabled = false
                self.timeSlider.isEnabled = false
                self.startButton.isEnabled = false
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
                self.counter = Int(self.timeSlider.value)
                self.timeLabel.text = "Time Left: \(self.counter)"
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                self.timer2 = Timer.scheduledTimer(timeInterval: self.diff, target: self, selector: #selector(self.hideAndPlay), userInfo: nil, repeats: true)
            }
            
            
            alert.addAction(quitButton)
            alert.addAction(hideButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch difficultSlider.selectedSegmentIndex
            {
            case 0:
                diff = 0.80
            case 1:
                diff = 0.65
            case 2:
                diff = 0.50
            
            default:
                break
            }
    }
    
    @IBAction func start(_ sender: Any)
    {
        counter = Int(timeSlider.value)
        timeSlider.isEnabled = false
        difficultSlider.isEnabled = false
        startButton.isEnabled = false
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: diff, target: self, selector: #selector(hideAndPlay), userInfo: nil, repeats: true)
        
        hideAndPlay()
    }
}
