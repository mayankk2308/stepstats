//
//  File.swift
//  StepStats
//
//  Created by Mayank Kumar on 4/15/16.
//  Copyright © 2016 Mayank Kumar. All rights reserved.
//

import HealthKit

class HealthManager {

    let kit = HKHealthStore()

    func checkAuth() -> Bool {
        var success = true
        if HKHealthStore.isHealthDataAvailable() {
            let stepCounter = NSSet(object: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!)
            kit.requestAuthorizationToShareTypes(nil, readTypes: stepCounter as? Set<HKObjectType>) { bool, error in
                success = bool
            }
        }
        else {
            return false
        }
        return success
    }

    func fetchStepCount(completionHandler: (Double, Bool) -> Void) {

        let today = NSDate()
        let previousDay = today.dateByAddingTimeInterval(NSTimeInterval(-82400))
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let predicate = HKQuery.predicateForSamplesWithStartDate(previousDay, endDate: today, options: .None)
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { _, results, error in
            var steps: Double = 0
            if results?.count > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    steps += result.quantity.doubleValueForUnit(HKUnit.countUnit())
                }
                completionHandler(steps, true)
            }
            else {
                completionHandler(steps, false)
            }
        }
        kit.executeQuery(query)
    }

}
