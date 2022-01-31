//
//  SplashScreenViewController.swift
//  Amako
//
//  Created by Khim Chua on 1/2/22.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
            vc.modalPresentationStyle = .fullScreen //try without fullscreen
            self.present(vc, animated: true, completion: nil)
        }
    }

}
