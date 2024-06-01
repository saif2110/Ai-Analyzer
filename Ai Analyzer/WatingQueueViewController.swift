//
//  WatingQueueViewController.swift
//  Ai Analyzer
//
//  Created by Saif Mukadam on 01/06/24.
//

import UIKit
import Lottie

class WatingQueueViewController: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var lottie: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTitle.text = "Wating time is \(String(Int.random(in: 7...15))) minutes. With Premium, there's no waiting—you'll get your results instantly."
        
        lottie.loopMode = .loop
        lottie.play()
        
    }

}
