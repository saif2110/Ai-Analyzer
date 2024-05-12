//
//  Loading.swift
//  Ai Analyzer
//
//  Created by Saif Mukadam on 12/05/24.
//

import UIKit
import Lottie

class Loading: UIViewController,GetDataProtocall {
    
    func getData(data: SummaryData) {
        self.dismiss(animated: true) {
            
        }
    }

    @IBOutlet weak var lottie: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        APIModels.shared.PlantDetailsDelegate = self
        
        lottie.loopMode = .loop
        lottie.play()
        
    }
    
}
