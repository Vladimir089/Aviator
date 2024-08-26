//
//  OnbUserViewController.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 26.08.2024.
//

import UIKit

class OnbUserViewController: UIViewController {
    
    var imageView: UIImageView?
    var topLabel: UILabel?
    var botLabel: UILabel?
    var arrViews: [UIView] = []
    
    var tap = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 34/255, alpha: 1)
        fillArr()
        createInterface()
    }
    
    func fillArr() {
        for _ in 0..<2 {
            let view = UIView()
            view.backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
            view.layer.cornerRadius = 4
            arrViews.append(view)
        }
    }
    

    func createInterface() {
        imageView = UIImageView(image: .onbUser1)
        imageView?.contentMode = .scaleAspectFill
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(550)
        })
        
        topLabel = UILabel()
        topLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        topLabel?.textColor = .white
        topLabel?.text = "Mark what you want to visit"
        topLabel?.numberOfLines = 2
        topLabel?.textAlignment = .center
        view.addSubview(topLabel!)
        topLabel?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(imageView!.snp.bottom).inset(-15)
        })
        
        botLabel = UILabel()
        botLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        botLabel?.textColor = UIColor(red: 247/255, green: 249/255, blue: 255/255, alpha: 1)
        botLabel?.numberOfLines = 2
        botLabel?.textAlignment = .center
        botLabel?.text = "Sort by country and indicate prices"
        view.addSubview(botLabel!)
        botLabel?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(topLabel!.snp.bottom).inset(-15)
        })
        
        view.addSubview(arrViews[0])
        arrViews[0].snp.makeConstraints { make in
            make.height.width.equalTo(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview().offset(-7.5)
        }
        
        view.addSubview(arrViews[1])
        arrViews[1].backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 0.5)
        arrViews[1].snp.makeConstraints { make in
            make.height.width.equalTo(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview().offset(7.5)
        }
        
        let nextButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
            button.layer.cornerRadius = 25
            return button
        }()
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(arrViews[1].snp.top).inset(-15)
        }
        nextButton.addTarget(self, action: #selector(butTappd), for: .touchUpInside)
        
    }
    
    @objc func butTappd() {
        tap += 1
        
        if tap == 1 {
            imageView?.image = .onbUser2
            topLabel?.text = "Write down your\nimpressions"
            botLabel?.text = "After the excursion, write down your thoughts and\nphotos"
            arrViews[0].backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 0.5)
            arrViews[1].backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
        } else {
            self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
        }
        
       
    }

}
