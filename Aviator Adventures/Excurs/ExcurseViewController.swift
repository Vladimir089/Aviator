//
//  ExcurseViewController.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 27.08.2024.
//

import UIKit

protocol ExcurseViewControllerDelegate: AnyObject {
    func reloadProfile()
    func reloadData()
}

class ExcurseViewController: UIViewController {
    
    var profileButton: UIButton?
    var nameLabel: UILabel?
    
    var noExcursLabel: UILabel?
    var addFirstExc: UIView?
    
    var sortedArr: [(String, [Excursion])] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        
        if user != nil {
            profileButton?.setBackgroundImage(UIImage(data: user?.image ?? Data()), for: .normal)
            let name: String = user?.name ?? ""
            nameLabel?.text = "Hellow \(name)"
            nameLabel?.alpha = 1
        }
        checkArr()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        createInterface()
        checkArr()
    }
    
    func checkArr() {
        if excursions.count > 0 {
            noExcursLabel?.alpha = 0
            addFirstExc?.alpha = 0
            //wantVisitLabel?.alpha = 1
            //coll.alp = 1
        } else {
            noExcursLabel?.alpha = 1
            addFirstExc?.alpha = 1
            //wantVisitLabel?.alpha = 0
            //coll.alp = 0
        }
        sortArr()
        //coll.reloadData
    }
    
    func sortArr() {
        
        sortedArr.removeAll()
        
        var sortedTimed: [(String, Excursion)] = []
        
        
        for i in excursions {
            sortedTimed.append((i.country, i))
        }
        
        for i in sortedTimed {
            if let index = sortedArr.firstIndex(where: { $0.0 == i.0 }) {
                sortedArr[index].1.append(i.1)
            } else {
                sortedArr.append((i.0, [i.1]))
            }
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
                make.width.equalTo(68)
                make.height.equalTo(102)
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().offset(30)
            }
            addNewButton.addTarget(self, action: #selector(openNewEditEsc), for: .touchUpInside)
            
            return view
        }()
        
        view.addSubview(addFirstExc!)
        addFirstExc?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(102)
        })
        
        
        
    }
    
    @objc func openNewEditEsc() {
       let vc = NewAndEditExcViewController()
        vc.isNew = true
        vc.delegate = self
        vc.showCountry = true
        self.present(vc, animated: true)
    }
    
    @objc func openProfile() {
        let vc = ProfileViewController()
        vc.secDel = self
        vc.userProf = user
        self.present(vc, animated: true)
    }

}


extension ExcurseViewController: ExcurseViewControllerDelegate {
    func reloadProfile() {
        if user != nil {
            profileButton?.setBackgroundImage(UIImage(data: user?.image ?? Data()), for: .normal)
            let name: String = user?.name ?? ""
            nameLabel?.text = "Hellow \(name)"
            nameLabel?.alpha = 1
        }
    }
    
    func reloadData() {
        print(234)
    }
    
}
