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
        print("title is",data.title)
        self.dismiss(animated: true) {
            if let topController = UIApplication.topViewController() {
                DispatchQueue.main.async {
                    let story = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc = story.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
                    vc.SummaryData = data
                    vc.modalPresentationStyle = .fullScreen
                    topController.present(vc, animated: true)
                }
            }
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
