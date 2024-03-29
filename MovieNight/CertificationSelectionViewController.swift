//
//  CertificationSelectionViewController.swift
//  MovieNight
//
//  Created by Bharath on 22/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class CertificationSelectionViewController: MovieCriteriaViewController {
    
    var countryView: SingleLabelDisplayView? = nil
    var certificationDescriptionView: SingleLabelDisplayView? = nil
    var certificationPickerView: BasicSelectionPickerView? = nil
    var countryChangeButton: UIButton? = nil
    var allCertificationData: [String: [Certification]] = [:]
    var certificationDataTask: URLSessionDataTask? = nil
    
    var currentlyDisplayedList: [Certification] = [] {
        
        didSet {
            
            let names: [String] = currentlyDisplayedList.compactMap({ return $0.name })
            certificationPickerView!.update(withData: [0: names])
            
            if names.isEmpty == false {
                
                //Update country
                let countryViewModel: CertificationListViewModel = CertificationListViewModel(withCertification: currentlyDisplayedList.first!, attributeType: .country)
                countryView!.update(withData: countryViewModel)
                
                //Update meaning
                let meaningViewModel: CertificationListViewModel = CertificationListViewModel(withCertification: currentlyDisplayedList.first!, attributeType: .meaning)
                certificationDescriptionView!.update(withData: meaningViewModel)
            }
            else {
                self.countryView!.update(withData: nil)
                self.certificationDescriptionView!.update(withData: nil)

            }
            
            self.countryChangeButton!.isEnabled = true
            self.certificationPickerView!.selectRow(0, inComponent: 0, animated: false)
            
        }
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
        countryView!.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        
        //Certification picker view
        certificationPickerView = BasicSelectionPickerView(withData: [0: []], completionHandler: { [unowned self] (component: Int, row: Int) -> Void in
            
            //Update meaning
            let meaningViewModel: CertificationListViewModel = CertificationListViewModel(withCertification: self.currentlyDisplayedList[row], attributeType: .meaning)
            self.certificationDescriptionView!.update(withData: meaningViewModel)
        })
        certificationPickerView!.backgroundColor = UIColor.lightGray
        view.addSubview(certificationPickerView!)
        certificationPickerView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        certificationPickerView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        certificationPickerView!.topAnchor.constraint(equalTo: countryView!.bottomAnchor).isActive = true
        
        
        //Certification country change button
        countryChangeButton = UIButton(type: .system)
        countryChangeButton!.addTarget(self, action: #selector(changeCountryButtonTapped(_:)), for: .touchUpInside)
        countryChangeButton!.isEnabled = false
        countryChangeButton!.translatesAutoresizingMaskIntoConstraints = false
        countryChangeButton!.titleLabel?.font = UIFont.systemFont(ofSize: 19.0)
        countryChangeButton!.setTitle("Change certification country", for: .normal)
        view.addSubview(countryChangeButton!)
        countryChangeButton!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        countryChangeButton!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        countryChangeButton!.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        countryChangeButton!.heightAnchor.constraint(equalToConstant: 55.0).isActive = true
        
        
        //Certification description view
        certificationDescriptionView = SingleLabelDisplayView(withData: nil)
        view.addSubview(certificationDescriptionView!)
        certificationDescriptionView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        certificationDescriptionView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        certificationDescriptionView!.topAnchor.constraint(equalTo: certificationPickerView!.bottomAnchor).isActive = true
        certificationDescriptionView!.bottomAnchor.constraint(equalTo: countryChangeButton!.topAnchor).isActive = true
        certificationDescriptionView!.changeMinimumScaleFactor(to: 0.4)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchCertifications()
    }
    
    
    override var titleString: String? {
        return "Select certification"
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
            
            guard let countryString = country.fullCountryString else {
                continue
            }
            
           let countryAction: CountryPickerAlertAction = CountryPickerAlertAction(withIdentifier: country, style: .default, actionTitle: countryString, handler: { [unowned self] (countryCodeString: String) -> Void in
            
                var list: [Certification] = self.allCertificationData[countryCodeString]!
                list.insert(Certification(withCountry: list.first!.country), at: 0)
                self.currentlyDisplayedList = list

            })
            
            actionSheetController.addAction(countryAction.alertAction!)
        }
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
}



extension CertificationSelectionViewController {
    
    
    func fetchCertifications() {
        
        activateNavigationItemTitleView()
        
        certificationDataTask = MovieNightAPI().fetchAllCertifications(withEndPoint: Endpoint.fetchCertifications, completionHandler: { [unowned self] (certifications: [String: [Certification]]?, error: Error?) -> Void in
            
            self.activateNavigationItemTitle()
            
            if let error = error {
                if error.representsTaskCancellation == false {
                    self.showAlertController(withTitle: "Alert", message: error.localizedDescription, actionTitles: ["OK"])
                }
            }
            else {
                if let certifications = certifications {
                    
                    self.allCertificationData = certifications
                    
                    //By default, display certifications for India.
                    let list: [Certification]? = certifications[CountryCodeMapper.Country.India.countryCode]
                    if var list = list {
                        //Inserting the "None" option.
                        list.insert(Certification(withCountry: list.first!.country), at: 0)
                        self.currentlyDisplayedList = list
                    }
                }
            }
        })
    }
    
}



extension CertificationSelectionViewController {
    
    
    @objc override func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        
        movieCriteria.changeSelectionStatus(to: .completed)
        let rowSelected: Int = certificationPickerView!.selectedRow(inComponent: 0)
        if rowSelected != NSNotFound && rowSelected < currentlyDisplayedList.count {
            let certification: Certification = currentlyDisplayedList[rowSelected]
            if certification.order > 0 {
                movieCriteria.addCertification(certification)
            }
        }
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    @objc override func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        
        certificationDataTask?.cancel()
        super.leftBarButtonTapped(sender)
    }
}

