//
//  HomeViewController.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 26.08.2024.
//

import UIKit

var excursions: [Excursion] = []
var user: User?

protocol HomeViewControllerDelegate: AnyObject {
    func reloadProfileButton(userRed: User)
    func reloadData()
}

class HomeViewController: UIViewController {
    
    var noExcursLabel: UILabel?
    var addFirstExc: UIView?
    var wantVisitLabel: UILabel?
    
    var profileButton: UIButton?
    var nameLabel: UILabel?
    
    var collection: UICollectionView?
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
            wantVisitLabel?.alpha = 1
            collection?.alpha = 1
        } else {
            noExcursLabel?.alpha = 1
            addFirstExc?.alpha = 1
            wantVisitLabel?.alpha = 0
            collection?.alpha = 0
        }
        sortArr()
        collection?.reloadData()
    }
    
    @objc func createNew(sender: UIButton) {
        let vc = NewAndEditExcViewController()
        vc.secondDelegate = self
        vc.isNew = true
        vc.showCountry = false
        vc.country = sortedArr[sender.tag].0
        self.present(vc, animated: true)
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
        
        
        wantVisitLabel = {
            let label = UILabel()
            label.text = "I want to visit"
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.textColor = .white
            return label
        }()
        view.addSubview(wantVisitLabel!)
        wantVisitLabel?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(nameLabel!.snp.bottom).inset(-25)
        })
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.backgroundColor = .clear
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
            layout.scrollDirection = .vertical
            collection.delegate = self
            collection.dataSource = self
            layout.minimumLineSpacing = 30
            collection.showsVerticalScrollIndicator = false
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(wantVisitLabel!.snp.bottom).inset(-15)
        })
    }
    //c сделать делегат для коллекци
    
    @objc func openNewEditEsc() {
       let vc = NewAndEditExcViewController()
        vc.isNew = true
        vc.showCountry = true
        vc.secondDelegate = self
        self.present(vc, animated: true)
    }
    
    @objc func openProfile() {
        
        let vc = ProfileViewController()
        vc.delegate = self
        vc.userProf = user
        self.present(vc, animated: true)
    }
    
    
    func loadAthleteArrFromFile() -> [Excursion]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("excu.plist")
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
    
    

}



extension HomeViewController: HomeViewControllerDelegate {
    func reloadData() {
        checkArr()
        collection?.reloadData()
    }
    
    
    func reloadProfileButton(userRed: User) {
        user = userRed
        profileButton?.setBackgroundImage(UIImage(data: userRed.image), for: .normal)
        nameLabel?.text = "Hellow \(userRed.name)"
        nameLabel?.alpha = 1
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sortedArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .clear
        let label = UILabel()
        label.text = sortedArr[indexPath.row].0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        cell.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview()
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
        addNewButton.addTarget(self, action: #selector(createNew(sender:)), for: .touchUpInside)
        
        var oneCard: UIView?
        var twoCard: UIView?
        var threeCard: UIView?
        
        for i in 0..<sortedArr[indexPath.row].1.count {
            switch i {
            case 0:
                oneCard = createCards(exc: sortedArr[indexPath.row].1[i])
            case 1:
                twoCard = createCards(exc: sortedArr[indexPath.row].1[i])
            case 2:
                threeCard = createCards(exc: sortedArr[indexPath.row].1[i])
            default:
                break
            }
        }
        
        if twoCard != nil {
            twoCard?.alpha = 0.6
            cell.addSubview(twoCard!)
            twoCard?.snp.makeConstraints({ make in
                make.height.equalTo(178)
                make.width.equalTo(185)
                make.left.equalToSuperview()
                make.bottom.equalToSuperview().inset(30)
            })
        }
        
        if threeCard != nil {
            threeCard?.alpha = 0.6
            cell.addSubview(threeCard!)
            threeCard?.snp.makeConstraints({ make in
                make.height.equalTo(178)
                make.width.equalTo(185)
                make.right.equalToSuperview()
                make.bottom.equalToSuperview().inset(30)
            })
        }
        
        if oneCard != nil {
            cell.addSubview(oneCard!)
            oneCard?.snp.makeConstraints({ make in
                make.height.equalTo(229)
                make.width.equalTo(241)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
            })
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 290)
    }
    
    func createCards(exc: Excursion) -> UIView {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        let imageView = UIImageView(image: UIImage(data: exc.image))
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        let typeBut = UIButton(type: .system)
        typeBut.setTitle(exc.type, for: .normal)
        typeBut.backgroundColor = .white.withAlphaComponent(0.7)
        typeBut.layer.cornerRadius = 11
        typeBut.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        typeBut.setTitleColor(.black, for: .normal)
        view.addSubview(typeBut)
        typeBut.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(15)
            make.height.equalTo(22)
        }
        
        let countLabel = UILabel()
        countLabel.text = exc.cost
        countLabel.font = .systemFont(ofSize: 16, weight: .regular)
        countLabel.textColor = .white
        view.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(15)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = exc.name
        nameLabel.numberOfLines = 2
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .white
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.bottom.equalTo(countLabel.snp.top).inset(-15)
        }
        
        
        return view
    }
    
    
}

