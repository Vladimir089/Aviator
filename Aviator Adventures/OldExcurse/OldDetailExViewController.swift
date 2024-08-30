//
//  OldDetailExViewController.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 30.08.2024.
//

import UIKit

protocol OldDetailExViewControllerDelegate: AnyObject {
    func realodData(item: Excursion)
}

class OldDetailExViewController: UIViewController {
    
    var exc: Excursion?
    var index = 0
    
    override func viewWillAppear(_ animated: Bool) {
        title = exc?.name
    }
    
    var mainCollection: UICollectionView?
    var secondCollection: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        createInterface()
        
    }
    

    func createInterface() {
        
        mainCollection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            layout.scrollDirection = .vertical
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.backgroundColor = .clear
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(mainCollection!)
        mainCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        })
        
        secondCollection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            layout.scrollDirection = .vertical
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "2")
            collection.backgroundColor = .clear
            collection.delegate = self
            collection.dataSource = self
            collection.isScrollEnabled = false
            collection.clipsToBounds = true
            return collection
        }()
        
    }
   
   
    @objc func adNewImp() {
        let vc = AddNewImpViewController()
        vc.delegate = self
        vc.item = exc
        vc.index = index
        self.present(vc, animated: true)
    }
    
    func saveoldArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("oldExcu.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    
    @objc func del() {
        oldExcursions.remove(at: index)
        
        do {
            let data = try JSONEncoder().encode(oldExcursions) //тут мкассив конвертируем в дату
            try self.saveAthleteArrToFile(data: data)
           
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }

    }
    
    @objc func moveToExc() {
        let alercC = UIAlertController(title: "Do you really want to move the tour? All your photos and descriptions will be deleted", message: "", preferredStyle: .alert)
        let actionOne = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        let actionTwo = UIAlertAction(title: "Move", style: .destructive) { _ in
            self.exc?.impressions.removeAll()
            excursions.append(self.exc!)
            do {
                let data = try JSONEncoder().encode(excursions) //тут мкассив конвертируем в дату
                try self.saveAthleteArrToFile(data: data)
                self.del()
            } catch {
                print("Failed to encode or save athleteArr: \(error)")
            }
        }
        alercC.addAction(actionOne)
        alercC.addAction(actionTwo)
        self.present(alercC, animated: true)
    }
    
    //СОХРАНЕНИЕ В ФАЙЛ
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


extension OldDetailExViewController: OldDetailExViewControllerDelegate {
    func realodData(item: Excursion) {
        self.exc = item
        print(item.impressions.count)
        secondCollection?.reloadData()
        mainCollection?.reloadData()
        self.navigationController?.popToRootViewController(animated: true)
    }
}


extension OldDetailExViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollection {
            return 3
        } else {
            return exc?.impressions.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
            cell.clipsToBounds = true
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
            
            if indexPath.row == 0 {
                let imageView = UIImageView(image: UIImage(data: exc?.image ?? Data()))
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 20
                cell.addSubview(imageView)
                imageView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.equalToSuperview()
                    make.height.equalTo(220)
                }
                
                let labelTop = UILabel()
                labelTop.text = exc?.name
                labelTop.font = .systemFont(ofSize: 22, weight: .bold)
                labelTop.textColor = .white
                cell.addSubview(labelTop)
                labelTop.snp.makeConstraints { make in
                    make.top.equalTo(imageView.snp.bottom).inset(-15)
                    make.left.equalToSuperview().inset(15)
                }
                
                let costLabel = UILabel()
                costLabel.textColor = .white
                costLabel.text = exc?.cost
                costLabel.font = .systemFont(ofSize: 28, weight: .regular)
                cell.addSubview(costLabel)
                costLabel.snp.makeConstraints { make in
                    make.left.equalToSuperview().inset(15)
                    make.top.equalTo(labelTop.snp.bottom).inset(-15)
                }
                
                let typeButton = UIButton()
                typeButton.isUserInteractionEnabled = false
                typeButton.setTitle(exc?.type, for: .normal)
                typeButton.backgroundColor = .clear
                typeButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
                typeButton.layer.cornerRadius = 10
                typeButton.setTitleColor(UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1), for: .normal)
                typeButton.layer.borderColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1).cgColor
                typeButton.layer.borderWidth = 1
                typeButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
                cell.addSubview(typeButton)
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
                    label.text = exc?.desc
                    view.addSubview(label)
                    label.snp.makeConstraints { make in
                        make.top.bottom.equalToSuperview().inset(5)
                        make.left.right.equalToSuperview().inset(15)
                    }
                    
                    return view
                }()
                cell.addSubview(corneredView)
                corneredView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.equalTo(costLabel.snp.bottom).inset(-15)
                    make.height.equalTo(76)
                }
            }
            
            if indexPath.row == 1 {
                if exc?.impressions.count != 0 {
                    cell.backgroundColor = .black
                    cell.layer.cornerRadius = 30
                    let label = UILabel()
                    label.text = "My impressions"
                    label.font = .systemFont(ofSize: 28, weight: .regular)
                    label.textColor = .white
                    cell.addSubview(label)
                    label.snp.makeConstraints { make in
                        make.left.top.equalToSuperview().inset(15)
                    }
                    cell.addSubview(secondCollection!)
                    secondCollection?.snp.makeConstraints({ make in
                        make.left.right.equalToSuperview().inset(15)
                        make.top.equalTo(label.snp.bottom).inset(-15)
                        make.height.equalTo((exc?.impressions.count ?? 1) * 680)
                    })
                    

                } else {
                    let label = UILabel()
                    label.text = "Add your photos and\nimpressions to the\nexcursions you visit"
                    label.textColor = .white
                    label.font = .systemFont(ofSize: 28, weight: .bold)
                    label.numberOfLines = 3
                    cell.addSubview(label)
                    label.snp.makeConstraints { make in
                        make.right.left.equalToSuperview().inset(15)
                        make.top.equalToSuperview()
                        make.bottom.equalToSuperview()
                    }
                }
            }
            
            if indexPath.row == 2 {
                let addImpButton: UIButton = {
                    let button = UIButton(type: .system)
                    button.layer.cornerRadius = 25
                    button.backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
                    button.setTitle("Add my impressions", for: .normal)
                    button.setTitleColor(.black, for: .normal)
                    return button
                }()
                cell.addSubview(addImpButton)
                addImpButton.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.equalToSuperview()
                    make.height.equalTo(50)
                }
                addImpButton.addTarget(self, action: #selector(adNewImp), for: .touchUpInside)
                
                let moveButton: UIButton = {
                    let button = UIButton(type: .system)
                    button.setTitle("Move to excursions", for: .normal)
                    button.backgroundColor = .clear
                    button.layer.cornerRadius = 25
                    button.setTitleColor(.white, for: .normal)
                    button.layer.borderColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1).cgColor
                    button.layer.borderWidth = 1
                    return button
                }()
                cell.addSubview(moveButton)
                moveButton.snp.makeConstraints { make in
                    make.height.equalTo(50)
                    make.bottom.equalToSuperview()
                    make.left.equalToSuperview().inset(15)
                    make.right.equalTo(cell.snp.centerX).offset(-7.5)
                }
                moveButton.addTarget(self, action: #selector(moveToExc), for: .touchUpInside)
                
                
                let delButton: UIButton = {
                    let button = UIButton(type: .system)
                    button.setTitle("Delete", for: .normal)
                    button.backgroundColor = .clear
                    button.layer.cornerRadius = 25
                    button.setTitleColor(.white, for: .normal)
                    button.layer.borderColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1).cgColor
                    button.layer.borderWidth = 1
                    return button
                }()
                cell.addSubview(delButton)
                delButton.snp.makeConstraints { make in
                    make.height.equalTo(50)
                    make.bottom.equalToSuperview()
                    make.right.equalToSuperview().inset(15)
                    make.left.equalTo(cell.snp.centerX).offset(7.5)
                }
                delButton.addTarget(self, action: #selector(del), for: .touchUpInside)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "2", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = .clear
            
            let topLabel = UILabel()
            topLabel.text = exc?.impressions[indexPath.row].header
            topLabel.textColor = .white
            topLabel.font = .systemFont(ofSize: 20, weight: .semibold)
            cell.addSubview(topLabel)
            topLabel.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
            }
            
            let textView = UITextView()
            textView.isEditable = false
            textView.text = exc?.impressions[indexPath.row].text
            textView.textColor = .white
            textView.font = .systemFont(ofSize: 17, weight: .regular)
            textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            textView.layer.cornerRadius = 12
            textView.layer.borderWidth = 1
            textView.backgroundColor = .clear
            textView.layer.borderColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1).cgColor
            cell.addSubview(textView)
            
            let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
            
            textView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(topLabel.snp.bottom).inset(-15)
                if size.height > 340 {
                    make.height.equalTo(340)
                } else {
                    make.height.equalTo(size.height)
                }
            }
            
            switch exc?.impressions[indexPath.row].imagies.count {
            case 1:
                let image = createImageView(image: exc?.impressions[indexPath.row].imagies[0] ?? Data())
                cell.addSubview(image)
                image.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview().inset(75)
                    make.top.equalTo(textView.snp.bottom).inset(-15)
                }
            case 2:
                let image = createImageView(image: exc?.impressions[indexPath.row].imagies[0] ?? Data())
                let imageTwo = createImageView(image: exc?.impressions[indexPath.row].imagies[1] ?? Data())
                cell.addSubview(image)
                image.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.bottom.equalToSuperview().inset(75)
                    make.top.equalTo(textView.snp.bottom).inset(-15)
                    make.right.equalTo(cell.snp.centerX).offset(-7.5)
                }
                cell.addSubview(imageTwo)
                imageTwo.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                    make.bottom.equalToSuperview().inset(75)
                    make.top.equalTo(textView.snp.bottom).inset(-15)
                    make.left.equalTo(cell.snp.centerX).offset(7.5)
                }
            case 3:
                
                let image = createImageView(image: exc?.impressions[indexPath.row].imagies[2] ?? Data())
                cell.addSubview(image)
                image.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview().inset(75)
                    make.top.equalTo(textView.snp.bottom).inset(-15)
                }
            case .none:
                break
            case .some(_):
                break
            }
            
            
            
            return cell
        }
    }
    
    func createImageView(image: Data) -> UIImageView {
        let imageView = UIImageView(image: UIImage(data: image))
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollection {
            if indexPath.row == 0 {
                return CGSize(width: collectionView.frame.width, height: 420)
            } else if indexPath.row == 1 {
                if exc?.impressions.count == 0 {
                    return CGSize(width: collectionView.frame.width, height: 102)
                } else {
                    mainCollection?.reloadData()
                    return CGSize(width: collectionView.frame.width, height: secondCollection?.frame.height ?? 100)
                }
            } else {
                return CGSize(width: collectionView.frame.width, height: 115)
            }
        } else {
            mainCollection?.reloadData()
            return CGSize(width: collectionView.frame.width, height: 660)
        }
    }
    
    
}
