//
//  ProfileViewController.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 23.02.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    let cornerRadiusConstant: CGFloat = 16.0
    let profilePlaceHolder = #imageLiteral(resourceName: "placeholder-user")
    let cameraIcon = #imageLiteral(resourceName: "camera")
    let buttonBackgroundColor = #colorLiteral(red: 0.2470588235, green: 0.4705882353, blue: 0.9411764706, alpha: 1)
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        print(#function ,editButton.frame)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(#function ,editButton.frame)
        
        // Frame отличается из-за того что во viewDidLoad - интерфейс не расчитан autolayout'ом, а в viewDidAppear интерфейс уже расчитан autolayout'ом
    }
    
    func setup() {
        profileImageView.image = profilePlaceHolder
        profileImageView.layer.cornerRadius = cornerRadiusConstant
        profileImageView.contentMode = .scaleAspectFill
        
        changeImageButton.setImage(cameraIcon, for: .normal)
        changeImageButton.setTitle("", for: .normal)
        changeImageButton.tintColor = UIColor.white
        changeImageButton.backgroundColor = buttonBackgroundColor
        changeImageButton.addTarget(self, action: #selector(changeImageButtonAction), for: .touchUpInside)
        
        editButton.layer.cornerRadius = cornerRadiusConstant
        editButton.layer.borderWidth = 1.0
        editButton.layer.borderColor = editButton.titleColor(for: .normal)?.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        changeImageButton.layer.cornerRadius = changeImageButton.frame.width / 2
    }
    
    @objc func changeImageButtonAction() {
        print("Выбери изображение профиля")
        
        let alert = UIAlertController()
        let photoFromMediaAction = UIAlertAction(title: "Установить из галлереи", style: .default, handler: { _ in self.createPhoto(sourceType: .photoLibrary)})
        let photoFromCameraAction = UIAlertAction(title: "Сделать фото", style: .default, handler: { _ in self.createPhoto(sourceType: .camera)})
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(photoFromMediaAction)
        alert.addAction(photoFromCameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func createPhoto(sourceType: UIImagePickerController.SourceType) {
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        profileImageView.image = selectedImage
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //print(editButton.frame)
        //будет ошибка т.к view еще не была загружена из storyboard
    }
    
}
