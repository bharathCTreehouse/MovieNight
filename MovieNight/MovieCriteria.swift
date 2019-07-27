//
//  MovieCriteria.swift
//  MovieNight
//
//  Created by Bharath on 05/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation

enum Person {
    case first
    case second
    case unknown
}

enum MovieCriteriaSelectionStatus {
    case unInitiated
    case inProgress
    case completed
    
    var imageName: String {
        switch self {
            case .completed: return "bubble-selected"
            default: return "bubble-empty"
        }
    }
}


class MovieCriteria {
    
    typealias CriteriaCompletionCount = Int
    
    private(set) var genres: Set<String>
    private(set) var actors: Set<String>?
    private(set) var certifications: Set<Certification>?
    private(set) var criteriaSelectionStatus: MovieCriteriaSelectionStatus {
        didSet {
            if criteriaSelectionStatus == .completed {
                completionCount = completionCount + 1
            }
        }
    }
    private(set) var completionCount: CriteriaCompletionCount = 0
    private (set) var currentPerson: Person = .unknown
    
    
    init(withGenres genres: Set<String>, actors: Set<String>?, certifications: Set<Certification>?, selectionStatus status: MovieCriteriaSelectionStatus = .unInitiated) {
        
        self.genres = genres
        self.actors = actors
        self.certifications = certifications
        criteriaSelectionStatus = status
    }
    
    
    func addActors(withIDs actorsToBeAdded: [String]) {
        if actors == nil {
            actors = []
        }
        actors = actors!.union(actorsToBeAdded)
    }
    func removeAllActors() {
        actors?.removeAll()
    }
    
    
    
    func addGenres(withIDs genresToBeAdded: [String]) {
        genres = genres.union(genresToBeAdded)
    }
    func removeAllGenres() {
        genres.removeAll()
    }
    
    
    func addCertification(_ certification: Certification) {
        if certifications == nil {
            certifications = []
        }
        certifications!.insert(certification)
    }
    func removeAllCertifications() {
        certifications?.removeAll()
    }
    
    
    func reset() {
        self.removeAllGenres()
        self.removeAllActors()
        self.removeAllCertifications()
        self.currentPerson = .unknown
        self.completionCount = 0
        self.criteriaSelectionStatus = .unInitiated
    }
    
    
    
    deinit {
        actors = nil
        certifications = nil
    }
    
}



extension MovieCriteria {
    
    func changeSelectionStatus(to status: MovieCriteriaSelectionStatus) {
        self.criteriaSelectionStatus = status
    }
}


extension MovieCriteria {
    
    func updateCurrentPerson(with person: Person) {
        currentPerson = person
    }
}
