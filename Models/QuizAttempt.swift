import Foundation
import SwiftData

@Model
final class QuizAttempt {
    var attemptDate: Date
    var correctCount: Int
    var totalCount: Int
    var wasAIGenerated: Bool
    
    var moduleProgress: ModuleProgress?
    
    init(attemptDate: Date = Date(), correctCount: Int, totalCount: Int, wasAIGenerated: Bool) {
        self.attemptDate = attemptDate
        self.correctCount = correctCount
        self.totalCount = totalCount
        self.wasAIGenerated = wasAIGenerated
    }
}
