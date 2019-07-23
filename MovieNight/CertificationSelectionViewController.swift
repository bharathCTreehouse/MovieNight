//
//  CertificationSelectionViewController.swift
//  MovieNight
//
//  Created by Bharath on 22/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class CertificationSelectionViewController: MovieNightViewController {
    
    var countryView: SingleLabelDisplayView? = nil
    var certificationDescriptionView: SingleLabelDisplayView? = nil
    var certificationPickerView: BasicSelectionPickerView? = nil
    var countryChangeButton: UIButton? = nil
    
    var allCertificationData: [String: [Certification]] = [:]
    
    var currentlyDisplayedList: [Certification] = [] {
        
        didSet {
            
            let names: [String] = currentlyDisplayedList.compactMap({ return $0.name })
            certificationPickerView!.update(withDelegate: BasicSelectionPickerViewDelegate(withData: [0: names], changeResponderDelegate: self))
            
            if names.isEmpty == false {
                
                //Update country
                let countryViewModel: CertificationListViewModel = CertificationListViewModel(withCertification: currentlyDisplayedList.first!, attributeType: .country)
                self.countryView!.update(withData: countryViewModel)
                
                //Update meaning
                let meaningViewModel: CertificationListViewModel = CertificationListViewModel(withCertification: currentlyDisplayedList.first!, attributeType: .meaning)
                self.certificationDescriptionView!.update(withData: meaningViewModel)
            }
            else {
                self.countryView!.update(withData: nil)
                self.certificationDescriptionView!.update(withData: nil)

            }
            
            self.countryChangeButton!.isEnabled = true
            self.certificationPickerView!.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    
    
    override init(withMovieCriteria criteria: MovieCriteria) {
        super.init(withMovieCriteria: criteria)
        fetchCertifications()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func loadView() {
        
        self.view = UIView()
        self.view.backgroundColor = UIColor.white

        
        //Certification country view
        countryView = SingleLabelDisplayView(withData: nil)
        view.addSubview(countryView!)
        countryView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        countryView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        countryView!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        
        
        //Certification picker view
        certificationPickerView = BasicSelectionPickerView(withDelegate: BasicSelectionPickerViewDelegate(withData: [0: []], changeResponderDelegate: self))
        certificationPickerView!.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(certificationPickerView!)
        certificationPickerView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        certificationPickerView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        certificationPickerView!.topAnchor.constraint(equalTo: countryView!.bottomAnchor).isActive = true
        
        
        //Certification description view
        certificationDescriptionView = SingleLabelDisplayView(withData: nil)
        view.addSubview(certificationDescriptionView!)
        certificationDescriptionView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        certificationDescriptionView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        certificationDescriptionView!.topAnchor.constraint(equalTo: certificationPickerView!.bottomAnchor).isActive = true
        
        
        //Certification country change button
        countryChangeButton = UIButton(type: .system)
        countryChangeButton!.addTarget(self, action: #selector(changeCountryButtonTapped(_:)), for: .touchUpInside)
        countryChangeButton!.isEnabled = false
        countryChangeButton!.translatesAutoresizingMaskIntoConstraints = false
        countryChangeButton!.setTitle("Change certification country", for: .normal)
        view.addSubview(countryChangeButton!)
        countryChangeButton!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        countryChangeButton!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        countryChangeButton!.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
   deinit {
        countryView = nil
        certificationDescriptionView = nil
        certificationPickerView = nil
        countryChangeButton = nil
    }
}




extension CertificationSelectionViewController {
    
    
    @objc func changeCountryButtonTapped(_ sender: UIButton) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: "Select country", preferredStyle: .actionSheet)
        
        for (country, _) in self.allCertificationData {
            
            let action: UIAlertAction = UIAlertAction(title: country, style: .default, handler: { [unowned self] (action: UIAlertAction) -> Void in
                
                self.currentlyDisplayedList = self.allCertificationData[action.title!]!
                
            })
            
            actionSheetController.addAction(action)
        }
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
}



extension CertificationSelectionViewController {
    
    
    func fetchCertifications() {
        
        MovieNightAPI().fetchAllCertifications(withEndPoint: Endpoint.fetchCertifications, completionHandler: { (certifications: [String: [Certification]]?, error: Error?) -> Void in
            
            if let error = error {
                print("Error: \(error)")
            }
            else {
                if let certifications = certifications {
                    
                    self.allCertificationData = certifications
                    
                    //By default, display certifications for US.
                    let list: [Certification]? = certifications["US"]
                    if let list = list {
                        self.currentlyDisplayedList = list
                    }
                }
            }
        })
    }
    
}



extension CertificationSelectionViewController: BasicSelectionPickerViewChangeResponder {
    
    
    func didSelectRow(_ row: Int, inComponent component: Int) {
        
        //Update meaning
        let meaningViewModel: CertificationListViewModel = CertificationListViewModel(withCertification: currentlyDisplayedList[row], attributeType: .meaning)
        self.certificationDescriptionView!.update(withData: meaningViewModel)
    }
}

