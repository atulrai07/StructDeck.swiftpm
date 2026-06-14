import Foundation
import SwiftData

@Model
final class ModuleProgress {
    @Attribute(.unique) var moduleId: String
    var moduleName: String
    var category: String
    var theoryCompleted: Bool
    var visualizerVisited: Bool
    var quizCompleted: Bool
    var bestScore: Int?
    var totalQuestions: Int?
    var lastCardIndex: Int = 0
    var lastStudiedAt: Date?
    
    @Relationship(deleteRule: .cascade, inverse: \QuizAttempt.moduleProgress)
    var quizAttempts: [QuizAttempt] = []
    
    init(moduleId: String, moduleName: String, category: String, theoryCompleted: Bool = false, visualizerVisited: Bool = false, quizCompleted: Bool = false, bestScore: Int? = nil, totalQuestions: Int? = nil, lastCardIndex: Int = 0, lastStudiedAt: Date? = nil) {
        self.moduleId = moduleId
        self.moduleName = moduleName
        self.category = category
        self.theoryCompleted = theoryCompleted
        self.visualizerVisited = visualizerVisited
        self.quizCompleted = quizCompleted
        self.bestScore = bestScore
        self.totalQuestions = totalQuestions
        self.lastCardIndex = lastCardIndex
        self.lastStudiedAt = lastStudiedAt
        self.quizAttempts = []
    }
    
    var completionPercentage: Double {
        var completedSteps = 0.0
        if theoryCompleted { completedSteps += 33.33 }
        if visualizerVisited { completedSteps += 33.33 }
        if quizCompleted { completedSteps += 33.34 }
        return completedSteps
    }
}
