//
//  HomeViewController.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 26.08.2024.
//

import UIKit

var excursions: [Excursion] = []

protocol HomeViewControllerDelegate: AnyObject {
    func reloadProfileButton(user: User)
}

class HomeViewController: UIViewController {
    
    var noExcursLabel: UILabel?
    var addFirstExc: UIView?
    
    var profileButton: UIButton?
    var nameLabel: UILabel?
    var user: User?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        excursions = loadAthleteArrFromFile() ?? []
        user = loaduserFromFile() ?? nil
        view.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        createInterface()
        checkArr()
    }
    
    func checkArr() {
        if excursions.count > 0 {
            noExcursLabel?.alpha = 0
            addFirstExc?.alpha = 0
            //coll.alp = 1
        } else {
            noExcursLabel?.alpha = 1
            addFirstExc?.alpha = 1
            //coll.alp = 0
        }
    }
    
    
    func createInterface() {
        
        profileButton = {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 26.5
            button.clipsToBounds = true
            if user?.image != nil {
                button.setBackgroundImage(UIImage(data: user?.image ?? Data()), for: .normal)
            } else {
                button.setBackgroundImage(.profile, for: .normal)
                button.tintColor = .white
            }
            
            return button
        }()
        view.addSubview(profileButton!)
        profileButton?.snp.makeConstraints({ make in
            make.height.width.equalTo(53)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        })
        profileButton?.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        
        noExcursLabel = {
            let label = UILabel()
            label.text = "You don't have any\nexcursions yet"
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.textColor = .white
            label.textAlignment = .left
            label.numberOfLines = 2
            return label
        }()
        view.addSubview(noExcursLabel!)
        noExcursLabel!.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(profileButton!.snp.bottom).inset(-30)
        }
        
        addFirstExc = {
            let view = UIView()
            view.backgroundColor = .clear
            
            let label = UILabel()
            label.text = "Add first\ncountry for\nexcursion"
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.textColor = .white.withAlphaComponent(0.7)
            label.numberOfLines = 3
            label.textAlignment = .left
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            }
            
            let addNewButton = UIButton(type: .system)
            addNewButton.backgroundColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1)
            addNewButton.setTitle("+", for: .normal)
            addNewButton.setTitleColor(.black, for: .normal)
            addNewButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
            addNewButton.layer.cornerRadius = 34
            view.addSubview(addNewButton)
            addNewButton.snp.makeConstraints { make in
                make.height.width.equalTo(68)
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().offset(30)
            }
            
            return view
        }()
        
        view.addSubview(addFirstExc!)
        addFirstExc?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(102)
        })
        
        nameLabel = UILabel()
        nameLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel?.textColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
        if user == nil {
            nameLabel?.alpha = 0
            
        } else {
            nameLabel?.alpha = 1
            let name: String = user?.name ?? ""
            nameLabel?.text = "Hellow \(name)"
        }
        view.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.bottom.equalTo(profileButton!.snp.bottom)
        })
        
        
    }
    
    @objc func openProfile() {
        let vc = ProfileViewController()
        vc.delegate = self
        vc.user = user
        self.present(vc, animated: true)
    }
    
    
    func loadAthleteArrFromFile() -> [Excursion]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("exc.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode([Excursion].self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    
    func loaduserFromFile() -> User? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("user.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode(User.self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }

   

}



extension HomeViewController: HomeViewControllerDelegate {
    
    func reloadProfileButton(user: User) {
        self.user = user
        profileButton?.setBackgroundImage(UIImage(data: user.image), for: .normal)
        nameLabel?.text = "Hellow \(user.name)"
        nameLabel?.alpha = 1
    }
    
    
}

