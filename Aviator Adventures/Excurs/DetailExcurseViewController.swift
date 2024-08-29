//
//  DetailExcurseViewController.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 29.08.2024.
//

import UIKit

protocol DetailExcurseViewControllerDelegate: AnyObject {
    func edited()
}

class DetailExcurseViewController: UIViewController {
    
    var index = 0
    var item: Excursion?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsNav()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        createInterface()
    }
    
    func settingsNav() {
        self.title = item?.name
        navigationController?.navigationBar.tintColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func createInterface() {
        
        let imageView = UIImageView(image: UIImage(data: item?.image ?? Data()))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(220)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = item?.name
        nameLabel.textColor = .white
        nameLabel.textAlignment = . left
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(imageView.snp.bottom).inset(-15)
        }
        
        let costLabel = UILabel()
        costLabel.textColor = .white
        costLabel.text = item?.cost
        costLabel.font = .systemFont(ofSize: 28, weight: .regular)
        view.addSubview(costLabel)
        costLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(nameLabel.snp.bottom).inset(-15)
        }
        
        let typeButton = UIButton()
        typeButton.isUserInteractionEnabled = false
        typeButton.setTitle(item?.type, for: .normal)
        typeButton.backgroundColor = .clear
        typeButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        typeButton.layer.cornerRadius = 10
        typeButton.setTitleColor(UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1), for: .normal)
        typeButton.layer.borderColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1).cgColor
        typeButton.layer.borderWidth = 1
        typeButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        view.addSubview(typeButton)
        typeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(48)
            make.bottom.equalTo(costLabel.snp.bottom)
        }
        
        let corneredView: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.layer.cornerRadius = 12
            view.layer.borderColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1).cgColor
            view.layer.borderWidth = 1
            
            let label = UILabel()
            label.textAlignment = .left
            label.textColor = .white
            label.font = .systemFont(ofSize: 17, weight: .regular)
            label.numberOfLines = 2
            label.text = item?.desc
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(5)
                make.left.right.equalToSuperview().inset(15)
            }
            
            return view
        }()
        view.addSubview(corneredView)
        corneredView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(costLabel.snp.bottom).inset(-15)
            make.height.equalTo(76)
        }
        
        let transferButton = UIButton(type: .system)
        transferButton.setTitle("Move to already visited", for: .normal)
        transferButton.layer.cornerRadius = 25
        transferButton.setTitleColor(.black, for: .normal)
        transferButton.backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
        view.addSubview(transferButton)
        transferButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(corneredView.snp.bottom).inset(-15)
        }
        transferButton.addTarget(self, action: #selector(transfer), for: .touchUpInside)
        
        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.layer.borderColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1).cgColor
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = 25
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(transferButton.snp.bottom).inset(-15)
            make.right.equalTo(view.snp.centerX).offset(-7.5)
        }
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        let delButton = UIButton(type: .system)
        delButton.setTitle("Delete", for: .normal)
        delButton.setTitleColor(.white, for: .normal)
        delButton.layer.borderColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1).cgColor
        delButton.layer.borderWidth = 1
        delButton.layer.cornerRadius = 25
        view.addSubview(delButton)
        delButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(transferButton.snp.bottom).inset(-15)
            make.left.equalTo(view.snp.centerX).offset(7.5)
        }
        delButton.addTarget(self, action: #selector(delItem), for: .touchUpInside)
        
        
    }
    
    @objc func transfer() {
        oldExcursions.append(excursions[index])
        excursions.remove(at: index)
        
        do {
            let data = try JSONEncoder().encode(excursions) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
        do {
            let data = try JSONEncoder().encode(oldExcursions) //тут мкассив конвертируем в дату
            try savoldArrToFile(data: data)
            edited()
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    @objc func delItem() {
        excursions.remove(at: index)
        do {
            let data = try JSONEncoder().encode(excursions) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
            edited()
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    @objc func editButtonTapped() {
        let vc = NewAndEditExcViewController()
         vc.isNew = false
         vc.fourDelegate = self
         vc.showCountry = false
         vc.index = index
         vc.excurseEdit = item
         self.present(vc, animated: true)
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("excu.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    func savoldArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("oldExcu.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }

}


extension DetailExcurseViewController: DetailExcurseViewControllerDelegate {
    func edited() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
