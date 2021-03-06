//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 13/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var userInfoChanged: (name: Bool, description: Bool, photo: Bool) = (false, false, false)
    var imagePicker : UIImagePickerController? = UIImagePickerController()
    var gcdDataManager = GCDDataManager()
    var operationDataManager = OperationDataManager()
    var useGCDDataManager: Bool = true
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            editButton.layer.cornerRadius = 8
            editButton.layer.borderWidth = 1
            editButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var gcdSaveButton: UIButton!
    @IBOutlet weak var operationSaveButton: UIButton!
    @IBOutlet weak var savingDataActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func gcdSaveButtonToched(_ sender: UIButton) {
        self.view.endEditing(true)
        useGCDDataManager = true
        saveData()
    }
    @IBAction func operationSaveButtonToched(_ sender: UIButton) {
        self.view.endEditing(true)
        useGCDDataManager = false
        saveData()
    }
    @IBAction func editButtonToched(_ sender: UIButton) {
        putViewIntoEditingMode()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImage.layer.cornerRadius = addPhotoButton.bounds.size.width / 2
        addPhotoButton.layer.cornerRadius = addPhotoButton.bounds.size.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        buttonsHidden(are: true)
        putViewIntoNotEditingMode()
        
        self.savingDataActivityIndicator.hidesWhenStopped = true
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        imagePicker?.delegate = self
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)        
    }
    
    @IBAction func addPhotoButtonDidTap(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Сделать фото", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        let photo = UIAlertAction(title: "Установить из галлереи", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
        
        print("Выбери изображение профиля")
    }
    
    @IBAction func editButtonDidTap(_ sender: Any) {
    }
    
    @IBAction func hideProfileVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    private func printFrame() {
        print(editButton.frame)
    }
    
    func saveData() {
        
        savingDataActivityIndicator.startAnimating()
        buttonsEnabled(are: false)
        addPhotoButton.isEnabled = false
        
        let userInfo = UserInfo()
        
        if (userInfoChanged.name) {
            userInfo.userName = nameTextField.text
        }
        if (userInfoChanged.description) {
            userInfo.userDescription = descriptionTextView.text
        }
        if (userInfoChanged.photo) {
            userInfo.userPhoto = profileImage.image
        }
        
        if useGCDDataManager {
            gcdDataManager.saveData(userInfo: userInfo) { [weak self] (error) in
                self?.processSaving(error: error)
            }
        } else {
            operationDataManager.saveData(userInfo: userInfo) { [weak self] (error) in
                self?.processSaving(error: error)
            }
        }
    }
    
    func processSaving(error: Error?) {
        
        savingDataActivityIndicator.stopAnimating()
        
        if (error != nil) {
            showDataWasNotSavedAlert()
        }
        else {
            showDataSavedAlert()
        }
    }
    
    func loadData() {
        
        savingDataActivityIndicator.startAnimating()
        
        if useGCDDataManager {
            gcdDataManager.loadData { [weak self] (userInfo, _) in
                if let userInfo = userInfo {
                self?.processLoading(userInfo: userInfo)
                }
            }
        } else {
            operationDataManager.loadData { [weak self] (userInfo, _) in
                 if let userInfo = userInfo {
                               self?.processLoading(userInfo: userInfo)
                               }
            }
        }
    }
    
    func processLoading(userInfo: UserInfo) {
        
        savingDataActivityIndicator.stopAnimating()
        
            if let name = userInfo.userName {
                self.nameTextField.text = name
            }
            if let description = userInfo.userDescription {
                self.descriptionTextView.text = description
            }
            if let photo = userInfo.userPhoto {
                self.profileImage.image = photo
            }
    }
    
    func showDataSavedAlert() {
        
        let dataSavedAlert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.putViewIntoNotEditingMode()
            self.loadData()
        }
        
        dataSavedAlert.addAction(okAction)
        self.present(dataSavedAlert, animated: true, completion: nil)
    }
    
    func showDataWasNotSavedAlert() {
        
        let dataWasNotSavedAlert = UIAlertController(title: "Не удалось сохранить данные", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.putViewIntoNotEditingMode()
            self.loadData()
        }
        
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.saveData()
        }
        
        dataWasNotSavedAlert.addAction(okAction)
        dataWasNotSavedAlert.addAction(repeatAction)
        self.present(dataWasNotSavedAlert, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profileImage.image = info[.editedImage] as? UIImage
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        userInfoChanged.photo = true
        buttonsEnabled(are: true)
        dismiss(animated: true)
    }
}

extension ProfileViewController {
    
    func putViewIntoEditingMode(){
        userInfoChanged = (false, false, false)
        editButton.isHidden = true
        buttonsHidden(are: false)
        buttonsEnabled(are: false)
        addPhotoButton.isEnabled = true
    
        descriptionTextView.isEditable = true
        descriptionTextView.layer.cornerRadius = 15
        descriptionTextView.textContainerInset = .init(top: 3, left: 5, bottom: 1, right: 5)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.init(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0).cgColor
        
        nameTextField.isEnabled = true
        nameTextField.borderStyle = .roundedRect
    }
    
    func putViewIntoNotEditingMode(){
        self.view.endEditing(true)
        editButton.isHidden = false
        buttonsHidden(are: true)
        
        
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = .init(top: 3, left: 0, bottom: 1, right: 5)
        descriptionTextView.layer.borderWidth = 0
        descriptionTextView.layer.borderColor = UIColor.clear.cgColor
        descriptionTextView.isEditable = false
        
        nameTextField.borderStyle = .none
        nameTextField.isEnabled = false
    }
    
    func buttonsEnabled(are isEnabled: Bool) {
        
        gcdSaveButton.isEnabled = isEnabled
        operationSaveButton.isEnabled = isEnabled
        
        let color = isEnabled ? UIColor.black : UIColor.gray
        gcdSaveButton.setTitleColor(color, for: .normal)
        operationSaveButton.setTitleColor(color, for: .normal)
    }
    
    func buttonsHidden(are isHidden: Bool) {
        
        gcdSaveButton.isHidden = isHidden
        operationSaveButton.isHidden = isHidden
        addPhotoButton.isHidden = isHidden
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        userInfoChanged.name = true
        buttonsEnabled(are: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        userInfoChanged.description = true
        buttonsEnabled(are: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        if (self.view.frame.origin.y < 0) {
            return
        }
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.5, delay: 0,
                               options: .allowAnimatedContent, animations: {
                                self.view.frame.origin.y -= keyboardSize.height
                }, completion: nil)
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if (self.view.frame.origin.y >= 0) {
            return
        }
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.5, delay: 0,
                               options: .allowAnimatedContent, animations: {
                                self.view.frame.origin.y += keyboardSize.height
                }, completion: nil)
            }
        }
    }
}

