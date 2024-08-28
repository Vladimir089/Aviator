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
    
    var addNewCountryButton: UIButton?
    var countryCollection: UICollectionView?
    var countryArr = [String]()
    var selectedCountry = "All"
    
    var mainCollection: UICollectionView?
    var indexCollectionNoUsage = 0
    
    
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

    
    // сделать второй блок
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
            addNewCountryButton?.alpha = 1
            countryCollection?.alpha = 1
            mainCollection?.alpha = 1
            //wantVisitLabel?.alpha = 1
            //coll.alp = 1
        } else {
            noExcursLabel?.alpha = 1
            addFirstExc?.alpha = 1
            addNewCountryButton?.alpha = 0
            countryCollection?.alpha = 0
            mainCollection?.alpha = 0
            //wantVisitLabel?.alpha = 0
            //coll.alp = 0
        }
        sortArr()
        selectedCountry = "All"
        countryCollection?.reloadData()
        mainCollection?.reloadData()
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
        
        countryArr.removeAll()
        for i in sortedArr {
            countryArr.append(i.0)
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
        
        addNewCountryButton = {
            let button = UIButton(type: .system)
            button.setTitle("Add new country", for: .normal)
            button.backgroundColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1)
            button.layer.cornerRadius = 20
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
            return button
        }()
        view.addSubview(addNewCountryButton!)
        addNewCountryButton?.snp.makeConstraints({ make in
            make.height.equalTo(40)
            make.width.equalTo(113)
            make.top.equalTo(profileButton!.snp.bottom).inset(-25)
            make.right.equalToSuperview().inset(15)
        })
        addNewCountryButton?.addTarget(self, action: #selector(openNewEditEsc), for: .touchUpInside)
        
        
        countryCollection = {
            let layput = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layput)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.showsHorizontalScrollIndicator = false
            layput.scrollDirection = .horizontal
            collection.backgroundColor = .clear
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(countryCollection!)
        countryCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(22)
            make.top.equalTo(addNewCountryButton!.snp.bottom).inset(-15)
        })
        
        mainCollection = {
            let layput = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layput)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "2")
            collection.showsVerticalScrollIndicator = false
            layput.scrollDirection = .vertical
            collection.backgroundColor = .clear
            collection.delegate = self
            layput.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
            collection.dataSource = self
            return collection
        }()
        view.addSubview(mainCollection!)
        mainCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(countryCollection!.snp.bottom).inset(-15)
        })
        
    }
    
    
    
    @objc func openNewEditEsc() {
       let vc = NewAndEditExcViewController()
        vc.isNew = true
        vc.delegate = self
        vc.showCountry = true
        self.present(vc, animated: true)
    }
    
    func openEditEditEsc(index:  Int, exc: Excursion) {
       let vc = NewAndEditExcViewController()
        vc.isNew = false
        vc.delegate = self
        vc.showCountry = false
        vc.index = index
        vc.excurseEdit = exc
        self.present(vc, animated: true)
    }
    
    @objc func openProfile() {
        let vc = ProfileViewController()
        vc.secDel = self
        vc.userProf = user
        self.present(vc, animated: true)
    }
    
    @objc func createNew(sender: UIButton) {
        let vc = NewAndEditExcViewController()
        vc.delegate = self
        vc.isNew = true
        vc.showCountry = false
        if selectedCountry == "All" {
            vc.country = countryArr[sender.tag]
        } else {
            vc.country = selectedCountry
        }
        self.present(vc, animated: true)
    }
    
    
    @objc func menuButtonTapped(sender: UIButton) {
        
        let associatedString = sender.associatedString
        
        let firstAction = UIAction(title: "Edit", image: nil) { _ in
            var edit = 0
            for i in excursions {
                if excursions[edit].isActive == associatedString?.isActive, excursions[edit].name == associatedString?.name, excursions[edit].country == associatedString?.country, excursions[edit].image == associatedString?.image {
                    self.openEditEditEsc(index: edit, exc: i)
                } else {
                    edit += 1
                }
            }
            
        }
        
        let secondAction = UIAction(title: "Delete card", image: nil) { _ in
         var del = 0
            for _ in excursions {
                if excursions[del].isActive == associatedString?.isActive, excursions[del].name == associatedString?.name, excursions[del].country == associatedString?.country, excursions[del].image == associatedString?.image {
                    excursions.remove(at:del)
                    do {
                        let data = try JSONEncoder().encode(excursions) //тут мкассив конвертируем в дату
                        try self.saveAthleteArrToFile(data: data)
                        self.checkArr()
                    } catch {
                        print("Failed to encode or save athleteArr: \(error)")
                    }
                    
                } else {
                    del += 1
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
        checkArr()
        countryCollection?.reloadData()
        mainCollection?.reloadData()
    }
    
}


extension ExcurseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == countryCollection {
            return countryArr.count + 1
        } else {
            return sortedArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == countryCollection {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            let button = UIButton(type: .system)
            button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
            button.layer.cornerRadius = 11
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            button.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
            button.isUserInteractionEnabled = false
            
            if indexPath.row == 0 {
                button.setTitle("All", for: .normal)
            } else {
                button.setTitle(countryArr[indexPath.row - 1], for: .normal)
            }
            cell.addSubview(button)
            button.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(22)
                make.center.equalToSuperview()
            }
            let a: String = button.titleLabel?.text ?? "All"
            if selectedCountry == a {
                button.setTitleColor(UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1), for: .normal)
                button.layer.borderColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1).cgColor
            }
            
            
            return cell
            
        } else {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "2", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = .clear
            let label = UILabel()
            label.text = sortedArr[indexPath.row].0
            label.textColor = .white
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            cell.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview().inset(15)
            }
            
            let addNewButton: UIButton = {
                let button = UIButton(type: .system)
                button.setTitle("+", for: .normal)
                button.backgroundColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1)
                button.layer.cornerRadius = 20
                button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
                button.setTitleColor(.black, for: .normal)
                button.tag = indexPath.row
                return button
            }()
            cell.addSubview(addNewButton)
            addNewButton.snp.makeConstraints { make in
                make.height.width.equalTo(40)
                make.right.equalToSuperview().inset(15)
                make.top.equalToSuperview()
            }
            addNewButton.addTarget(self, action: #selector(createNew), for: .touchUpInside)
            
            
            let scrollView: UIScrollView = {
                let scroll = UIScrollView()
                scroll.isScrollEnabled = true
                scroll.showsHorizontalScrollIndicator = true
                return scroll
            }()
            cell.addSubview(scrollView)
            scrollView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalTo(addNewButton.snp.bottom).inset(-10)
            }
            
            var previousButton: UIButton? = nil
            
           
            
            for i in 0..<sortedArr[indexPath.row].1.count {
                
                let button: UIButton = {
                    let button = UIButton()
                    button.clipsToBounds = true
                    button.layer.cornerRadius = 20
                    let imageView = UIImageView(image: UIImage(data: sortedArr[indexPath.row].1[i].image))
                    button.addSubview(imageView)
                    imageView.snp.makeConstraints { make in
                        make.left.right.top.equalToSuperview()
                        make.height.equalTo(151)
                    }
                    let topLabel = UILabel()
                    topLabel.text = sortedArr[indexPath.row].1[i].name
                    topLabel.numberOfLines = 2
                    topLabel.textAlignment = .left
                    topLabel.textColor = .white
                    topLabel.font = .systemFont(ofSize: 17, weight: .semibold)
                    button.addSubview(topLabel)
                    topLabel.snp.makeConstraints { make in
                        make.left.right.equalToSuperview().inset(10)
                        make.top.equalTo(imageView.snp.bottom)
                    }
                    
                    let botLabel = UILabel()
                    botLabel.text = sortedArr[indexPath.row].1[i].cost
                    botLabel.font = .systemFont(ofSize: 15, weight: .regular)
                    botLabel.textColor = .white
                    button.addSubview(botLabel)
                    botLabel.snp.makeConstraints { make in
                        make.bottom.equalToSuperview().inset(10)
                        make.left.equalToSuperview().inset(10)
                    }
                    
                    let redButton: UIButton = {
                        let button = UIButton(type: .system)
                        button.setBackgroundImage(.redButton, for: .normal)
                        return button
                    }()
                    button.addSubview(redButton)
                    redButton.snp.makeConstraints { make in
                        make.height.width.equalTo(44)
                        make.top.right.equalToSuperview().inset(5)
                    }
                    redButton.tag = indexPath.row
                    redButton.associatedString = sortedArr[indexPath.row].1[i]
                    redButton.addTarget(self, action: #selector(menuButtonTapped(sender:)), for: .touchUpInside)
                    button.backgroundColor = .black
                    return button
                }()
                scrollView.addSubview(button)
                scrollView.showsHorizontalScrollIndicator = false
                // Устанавливаем constraints для кнопок
                button.snp.makeConstraints { make in
                    make.top.equalTo(scrollView.snp.top)
                    make.width.equalTo(204) // Ширина кнопки
                    make.height.equalTo(229) // Высота кнопки
                    
                    if let previous = previousButton {
                        make.left.equalTo(previous.snp.right).offset(10) // Расстояние между кнопками
                    } else {
                        make.left.equalTo(scrollView.snp.left).offset(10) // Первая кнопка от левого края scrollView
                    }
                }
                
                previousButton = button
            }
            if let lastButton = previousButton {
                scrollView.snp.makeConstraints { make in
                    make.right.equalTo(lastButton.snp.right).offset(10) // ScrollView сдвигается до последней кнопки
                }
            }
            
            
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == countryCollection {
            
            if indexPath.row == 0 {
                selectedCountry = "All"
            } else {
                selectedCountry = countryArr[indexPath.row - 1]
            }
            print(selectedCountry)
            
            sortedArr.removeAll()
            
            var sortedTimed: [(String, Excursion)] = []
            for i in excursions {
                if selectedCountry == "All" {
                    sortedTimed.append((i.country, i))
                } else {
                    if i.country == selectedCountry {
                        sortedTimed.append((i.country, i))
                    }
                }
            }
            
            for i in sortedTimed {
                if let index = sortedArr.firstIndex(where: { $0.0 == i.0 }) {
                    sortedArr[index].1.append(i.1)
                } else {
                    sortedArr.append((i.0, [i.1]))
                }
            }
            
            countryCollection?.reloadData()
            mainCollection?.reloadData()
            
        } else {
            let element = sortedArr[indexPath.row]
            let vc = CountryViewController()
            vc.delegate = self
            vc.elements = element
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == countryCollection {
            return CGSize(width: 61, height: 22)
        } else {
            return CGSize(width: collectionView.frame.width, height: 280)
        }
    }
    
    
}


private var AssociatedKey: UInt8 = 0

extension UIButton {
    var associatedString: Excursion? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey) as? Excursion
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
