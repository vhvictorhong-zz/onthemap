//
//  StudentLocation.swift
//  On the Map
//
//  Created by Victor Hong on 3/1/16.
//  Copyright © 2016 Victor Hong. All rights reserved.
//

import Foundation

class StudentArray: NSObject {
    
    var mutableModel = [StudentLocation]()
    
    func addModel(model: StudentLocation) {
        mutableModel.append(model)
    }
    
    func removeModel(model: StudentLocation) {
        if containsObject(model) {
            mutableModel.removeAtIndex(indexOfObject(model))
        }
    }
    
    func objectAtIndex(index: Int) -> StudentLocation {
        return mutableModel[index]
    }
    
    func indexOfObject(model: StudentLocation) -> Int {
        var index = 0
        if containsObject(model) {
            index = mutableModel.indexOf({$0.uniqueKey == model.uniqueKey})!
        }
        
        return index
    }
    
    func containsObject(model: StudentLocation) -> Bool {
        return mutableModel.contains({$0.uniqueKey == model.uniqueKey})
    }
    
    func count() -> Int {
        return mutableModel.count
    }
    
    /*func sort() {
        mutableModel.sortInPlace({$0.updatedDate > $1.updatedDate})
    }*/
}