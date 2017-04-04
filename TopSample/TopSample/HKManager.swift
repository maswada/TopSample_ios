//
//  HKManager.swift
//  TopSample
//
//  Created by wada on 2017/03/08.
//  Copyright © 2017年 mediba inc. All rights reserved.
//

import UIKit
import HealthKit

enum HKPermissionStatus: Int{
    case permitted
    case notAvailable
    case notDetermined
    case needUserPermission
    
    func description() -> String? {
        var message: String?
        switch self {
        case .permitted:
            message = nil
        case .notAvailable:
            message = "ご使用中の端末ではこの機能は利用できません。"
        case .notDetermined:
            message = "おもしろい機能をご使用になりたければ、HealthKitへのアクセスを許可してください。"
        case .needUserPermission:
            message = "無効にしないで。設定を開いてアクセスを許可してくださいよ。"
        }
        return message
    }
}

class HKManager: NSObject {

    let store: HKHealthStore = HKHealthStore()
    let readTypes:Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .stepCount)!]
    
    func permissionStatus() -> HKPermissionStatus {
        if HKHealthStore.isHealthDataAvailable() == false {
            return .notAvailable
        }
        
        let status = self.store.authorizationStatus(for: readTypes.first!)
        if status == .notDetermined {
            return .notDetermined
        }
        return .permitted
    }
    
    
    func requestPermission(completion: @escaping ((_ success: Bool, _ error: Error?) -> Void)) {
        self.store.requestAuthorization(toShare: nil, read: readTypes, completion: {(success: Bool, error: Error?) in
            completion(success, error)
        })
    }
    
    func openHealthKitPrivacy() -> Void {
        if let url = URL(string: "App-Prefs:root=Privacy&path=HEALTH") {
            UIApplication.shared.openURL(url);
        }
    }
    
    func outputSteps(_ atDate: Date, completion: @escaping(_ steps: Double, _ error: Error?) -> Void) {
        let type = HKSampleType.quantityType(forIdentifier: .stepCount)
        
        //For Start Date
        let calendar = Calendar.current
        let dateAtMidnight = calendar.startOfDay(for: atDate)
        let predicate = HKQuery.predicateForSamples(withStart: dateAtMidnight, end: atDate, options: HKQueryOptions())
        
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {query, results, error in
            var steps: Double = 0
            if let error = error {
                completion(steps, error)
            }
            
            if let results = results {
                for result in results as! [HKQuantitySample] {
                    steps += result.quantity.doubleValue(for: HKUnit.count())
                }
            }
            completion(steps, nil)
        })
        self.store.execute(query)
        
    }
    
    func todaySteps(completion: @escaping (_ steps:Double, _ error:Error?) -> Void) {

        let type = HKSampleType.quantityType(forIdentifier: .stepCount)
        
        //For Start and End Date
        let calendar = Calendar.current
        let now = Date()
        let dateAtMidnight = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: dateAtMidnight, end: now, options: HKQueryOptions())
        
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {query, results, error in
            var steps: Double = 0
            if let error = error {
                completion(steps, error)
            }
            
            if let results = results {
                for result in results as! [HKQuantitySample] {
                    steps += result.quantity.doubleValue(for: HKUnit.count())
                }
            }
            completion(steps, nil)
        })
        self.store.execute(query)

    }
    
}
