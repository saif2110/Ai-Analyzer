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
        mainTitle.text = "Our Ai experiencing a high volume of requests. Wating time \(String(Int.random(in: 7...15))) minutes."
        
        lottie.loopMode = .loop
        lottie.play()
        
    }
    
    
    @IBAction func upgradetoPRP(_ sender: Any) {
        
        self.dismiss(animated: true) {
            if let topController = UIApplication.topViewController() {
                DispatchQueue.main.async {
                    let vc = IAPViewController()
                    vc.modalPresentationStyle = .fullScreen
                    topController.present(vc, animated: true)
                }
            }
        }
        
    }
    
    
    @IBAction func tryAgain(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
