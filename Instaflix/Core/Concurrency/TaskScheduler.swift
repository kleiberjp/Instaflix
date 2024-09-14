//
//  TaskScheduler.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Foundation

final class TaskScheduler {
    
    static var backgroundWorkScheduler: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()

    static let mainScheduler = RunLoop.main
    static let mainThread = DispatchQueue.main
}
