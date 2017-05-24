//
//  SlideshowVC.swift
//  Photo Zen
//
//  Created by Taylor Hansen on 19/05/2017.
//  Copyright © 2017 Taylor Hansen. All rights reserved.
//



import UIKit
import AVFoundation

class SlideshowVC: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    var imageArray = [UIImage]()
    var slideShow = UIImageView()
    var slideShow2 = UIImageView()
    var onImage = 0
    
    var click = true
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideShow.frame = self.view.frame
        slideShow2.frame = self.view.frame
        slideShow.clipsToBounds = true
        slideShow2.clipsToBounds = true
        slideShow2.alpha = 0
        slideShow2.contentMode = .scaleAspectFill
        slideShow.contentMode = .scaleAspectFill
        self.view.addSubview(slideShow)
        self.view.addSubview(slideShow2)
        if imageArray.count > 0 {
            slideShow.image = imageArray[0]
            slideShow2.image = imageArray[1%imageArray.count]
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickView))
            self.view.addGestureRecognizer(tap)
            playSound(soundName: "calmSound", audioPlayer: &audioPlayer)
            audioPlayer.numberOfLoops = -1
            self.navigationController?.navigationBar.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if imageArray.count > 0 {
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    
    
    func changeImage() {
        if onImage % 2 == 0 {
            slideShow.image = imageArray[onImage%imageArray.count]
            slideShow2.image = imageArray[(onImage+1)%imageArray.count]
            UIView.animate(withDuration: 1.0, animations: {
                self.slideShow.alpha = 0
                self.slideShow2.alpha = 1
            })
            
        } else {
            slideShow2.image = imageArray[onImage%imageArray.count]
            slideShow.image = imageArray[(onImage+1)%imageArray.count]
            UIView.animate(withDuration: 1.0, animations: {
                self.slideShow.alpha = 1
                self.slideShow2.alpha = 0
            })
        }
        onImage += 1
    }
    
    func clickView() {
        if !click {
            click = true
        } else {
            click = false
        }
        self.navigationController?.navigationBar.isHidden = click
    }
    
    func playSound(soundName: String, audioPlayer: inout AVAudioPlayer) {
        if let sound = NSDataAsset(name: soundName) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("ERROR: Data from \(soundName) could not be played as an audio file")
            }
        } else {
            print("ERROR: Could not load data from file \(soundName)")
        }
    }
    
    @IBAction func soundButtonPressed(_ sender: UISwitch) {
        if soundSwitch.isOn == true {
            playSound(soundName: "calmSound", audioPlayer: &audioPlayer)
            audioPlayer.numberOfLoops = -1
        } else {
            audioPlayer.pause()
            
        }
        
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        if imageArray.count > 0 {
            audioPlayer.stop()
        }
        self.performSegue(withIdentifier: "goHome", sender: self)
    }
    
}
