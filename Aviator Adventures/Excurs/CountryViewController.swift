//
//  CountryViewController.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 28.08.2024.
//

import UIKit

protocol CountryViewControllerDelegate: AnyObject {
    func reload(elements: [Excursion])
}

class CountryViewController: UIViewController {
    
    var elements: (String, [Excursion])?
    weak var delegate: ExcurseViewControllerDelegate?
    
    var arrButtons: [UIButton] = []
    var selectedType = ""
    var collection: UICollectionView?
    var sortedArr: [Excursion]?
    
    var isOld = false
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.reloadData()
        delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavigationBar()
        settingsNav()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        sortedArr = elements?.1
        fillButtons()
        createInterface()
        checkIsOld()
    }
    
    func settingsNav() {
        self.title = elements?.0
        navigationController?.navigationBar.tintColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func checkIsOld() {
        
        if isOld == true {
            let label = UILabel()
            label.textColor = .white
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.numberOfLines = 0
            label.text = "Add your photos and\nimpressions to the\nexcursions you visit"
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(arrButtons[4].snp.bottom).inset(-15)
            }
            
            collection?.snp.remakeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.bottom.equalToSuperview()
                make.top.equalTo(label.snp.bottom).inset(-15)
            })
        }
        
    }
    
    func fillButtons() {
        arrButtons.removeAll()
        let arr = ["Individual", "Group", "Сhildrens", "Tourist", "Urban", "Museum", "Suburban", "Extreme"]
        var tag = 0
        for i in arr {
            let button = UIButton(type: .system)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 10
            button.setTitle(i, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
            button.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            button.layer.borderWidth = 1
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
            button.tag = tag
            button.addTarget(self, action: #selector(butTapped(sender:)), for: .touchUpInside)
            arrButtons.append(button)
            tag += 1
        }
    }
    
    func createInterface() {
        let stackViewTop: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [arrButtons[0], arrButtons[1], arrButtons[2], arrButtons[3]])
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.distribution = .fillProportionally
            return stackView
        }()
        view.addSubview(stackViewTop)
        stackViewTop.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(60)
            make.height.equalTo(48)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        let stackViewBot: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [arrButtons[4], arrButtons[5], arrButtons[6], arrButtons[7]])
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.distribution = .fillProportionally
            return stackView
        }()
        view.addSubview(stackViewBot)
        stackViewBot.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(60)
            make.height.equalTo(48)
            make.top.equalTo(stackViewTop.snp.bottom).inset(-10)
        }
        
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.backgroundColor = .clear
            layout.scrollDirection = .vertical
            collection.delegate = self
            collection.dataSource = self
            collection.showsVerticalScrollIndicator = false
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(stackViewBot.snp.bottom).inset(-15)
            make.bottom.equalToSuperview()
        })
        
        collection?.reloadData()
    }
    
    func openEditEditEsc(index:  Int, exc: Excursion, oldIndex: Int) {
       let vc = NewAndEditExcViewController()
        vc.isNew = false
        vc.threeDelegate = self
        vc.showCountry = false
        vc.index = index
        vc.excurseEdit = exc
        vc.excurseRedd = elements?.1
        vc.oldIndex = oldIndex
        self.present(vc, animated: true)
    }
    

    @objc func butTapped(sender: UIButton) {
        for i in arrButtons {
            i.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
            i.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        }
        selectedType = sender.currentTitle ?? ""
        sender.setTitleColor(UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1), for: .normal)
        sender.layer.borderColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1).cgColor
        
        sortedArr?.removeAll()
        
        for i in 0..<(elements?.1.count ?? 0) {
            print(elements?.1[i].name)
            if elements?.1[i].type == selectedType {
                let a = (elements?.1[i])!
                sortedArr?.append(a)
            }
        }
        
        collection?.reloadData()
        
    }
    
    @objc func menuButtonTapped(sender: UIButton) {
        let firstAction = UIAction(title: "Edit", image: nil) { [self] _ in
            var index = 0
            let item = self.sortedArr?[sender.tag]
            for _ in 0..<excursions.count {
                if excursions[index].isActive == item?.isActive, excursions[index].name == item?.name, excursions[index].country == item?.country {
                    var oldIndex = 0
                    for _ in 0..<(elements?.1.count)! {
                        if item?.name == elements?.1[oldIndex].name, item?.country == elements?.1[oldIndex].country, item?.image == elements?.1[oldIndex].image {
                            print("sdf")
                            self.openEditEditEsc(index: index, exc: item!, oldIndex: oldIndex)
                        } else {
                            oldIndex += 1
                        }
                    }
                } else {
                    index += 1
                }
            }
        }
        
        let secondAction = UIAction(title: "Delete", image: nil) { [self] _ in
            
            let item = self.sortedArr?[sender.tag]
            
            var index = 0
            
            for _ in 0..<(elements?.1.count ?? 0)  {
                
                if item?.isActive == elements?.1[index].isActive , item?.country == elements?.1[index].country , item?.image == elements?.1[index].image , item?.name == elements?.1[index].name  {
                    elements?.1.remove(at:index)
                    butTapped(sender: self.arrButtons[0])
                } else {
                    index += 1
                }
            }
            
            index = 0
            
            for _ in 0..<excursions.count {
                if excursions[index].isActive == item?.isActive, excursions[index].name == item?.name, excursions[index].country == item?.country {
                    excursions.remove(at: index)
                    do {
                        let data = try JSONEncoder().encode(excursions) //тут мкассив конвертируем в дату
                        try saveAthleteArrToFile(data: data)
                    } catch {
                        print("Failed to encode or save athleteArr: \(error)")
                    }
                } else {
                    index += 1
                }
            }
            

        }
        
        let menu = UIMenu(title: "", children: [firstAction, secondAction])
        
        if #available(iOS 14.0, *) {
            sender.menu = menu
            sender.showsMenuAsPrimaryAction = true
        }
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
}


extension CountryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        if isOld == false {
            cell.backgroundColor = .black
        } else {
            cell.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        }
       
        
        let imageView = UIImageView(image: UIImage(data: elements?.1[indexPath.row].image ?? Data()))
        imageView.clipsToBounds = true
        
        
        cell.addSubview(imageView)
        if isOld == true {
            imageView.layer.cornerRadius = 20
            imageView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(208)
            }
        } else {
            imageView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(151)
            }
        }
        
        let topLabel = UILabel()
        topLabel.text = sortedArr?[indexPath.row].name
        topLabel.numberOfLines = 2
        topLabel.textAlignment = .left
        topLabel.textColor = .white
        topLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.addSubview(topLabel)
        
        topLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(imageView.snp.bottom)
        }
        
        if isOld == false {
            let botLabel = UILabel()
            botLabel.text = sortedArr?[indexPath.row].cost
            botLabel.font = .systemFont(ofSize: 15, weight: .regular)
            botLabel.textColor = .white
            cell.addSubview(botLabel)
            botLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(10)
                make.left.equalToSuperview().inset(10)
            }
        }
        
        
        if isOld == false {
            let redButton: UIButton = {
                let button = UIButton(type: .system)
                button.setBackgroundImage(.redButton, for: .normal)
                return button
            }()
            cell.addSubview(redButton)
            redButton.snp.makeConstraints { make in
                make.height.width.equalTo(44)
                make.top.right.equalToSuperview().inset(5)
            }
            redButton.tag = indexPath.row
           
            redButton.addTarget(self, action: #selector(menuButtonTapped(sender:)), for: .touchUpInside)
        }
        
        if isOld == true {
            let unUsedButton = UIButton()
            unUsedButton.isEnabled = false
            unUsedButton.layer.cornerRadius = 25
            unUsedButton.backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
            unUsedButton.setTitle("More details", for: .normal)
            unUsedButton.setTitleColor(.black, for: .normal)
            unUsedButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
            cell.addSubview(unUsedButton)
            unUsedButton.snp.makeConstraints { make in
                make.right.top.equalToSuperview().inset(15)
                make.height.equalTo(50)
                make.width.equalTo(103)
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isOld == true {
            return CGSize(width: collectionView.frame.width, height: 237)
        } else {
            return CGSize(width: 169, height: 237)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailExcurseViewController()
        var index = 0
        for _ in 0..<excursions.count {
            if sortedArr?[indexPath.row].isActive == excursions[index].isActive, sortedArr?[indexPath.row].name == excursions[index].name, sortedArr?[indexPath.row].country == excursions[index].country , sortedArr?[indexPath.row].image == excursions[index].image {
                vc.index = index
                vc.item = excursions[index]
                self.navigationItem.backBarButtonItem = UIBarButtonItem(
                    title: "Back",
                    style: .plain,
                    target: nil,
                    action: nil
                )
                self.navigationController?.pushViewController(vc, animated: true)
                break
            } else {
                index += 1
            }
        }
    }
}


extension CountryViewController: CountryViewControllerDelegate {
    func reload(elements: [Excursion]) {
        self.elements?.1 = elements
        butTapped(sender: arrButtons[0])
    }
}
