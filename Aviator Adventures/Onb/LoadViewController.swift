//
//  LoadViewController.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 26.08.2024.
//

import UIKit
import SnapKit

class LoadViewController: UIViewController {
    
    var timer: Timer?
    var progress = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        createInterface()
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [self] _ in
            progress += 100 //менять на 1.5
            
            if progress >= 100 {
                timer?.invalidate()
                timer = nil
                
                
                if isBet == false {
                    if UserDefaults.standard.value(forKey: "tab") != nil {
                        self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
                    } else {
                        self.navigationController?.setViewControllers([OnbUserViewController()], animated: true)
                    }
                } else {
                    
                }
            }
        })
    }
    

    func createInterface() {
        let imageView = UIImageView(image: .load)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(253)
            make.width.equalTo(257)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        
        let loadIndicator = UIActivityIndicatorView(style: .large)
        loadIndicator.color = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
        loadIndicator.startAnimating()
        view.addSubview(loadIndicator)
        loadIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-70)
        }
    }

}


