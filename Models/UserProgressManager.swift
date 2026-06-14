import Foundation
import SwiftData
import SwiftUI

@MainActor
final class UserProgressManager {
    static let shared = UserProgressManager()
    
    var container: ModelContainer?
    var context: ModelContext?
    
    private init() {
        do {
            let schema = Schema([
                ModuleProgress.self,
                QuizAttempt.self
            ])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [config])
            self.container = container
            self.context = ModelContext(container)
        } catch {
            print("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    // Helper to get or create module progress
    func getOrCreateProgress(moduleId: String, moduleName: String, category: String) -> ModuleProgress {
        guard let context = context else {
            return ModuleProgress(moduleId: moduleId, moduleName: moduleName, category: category)
        }
        
        let descriptor = FetchDescriptor<ModuleProgress>(
            predicate: #Predicate<ModuleProgress> { $0.moduleId == moduleId }
        )
        
        do {
            let results = try context.fetch(descriptor)
            if let existing = results.first {
                return existing
            }
        } catch {
            print("Fetch error: \(error)")
        }
        
        let newProgress = ModuleProgress(moduleId: moduleId, moduleName: moduleName, category: category)
        context.insert(newProgress)
        try? context.save()
        return newProgress
    }
    
    func markTheoryCompleted(moduleId: String, moduleName: String, category: String) {
        let progress = getOrCreateProgress(moduleId: moduleId, moduleName: moduleName, category: category)
        progress.theoryCompleted = true
        progress.lastStudiedAt = Date()
        try? context?.save()
    }
    
    func markVisualizerVisited(moduleId: String, moduleName: String, category: String) {
        let progress = getOrCreateProgress(moduleId: moduleId, moduleName: moduleName, category: category)
        progress.visualizerVisited = true
        progress.lastStudiedAt = Date()
        try? context?.save()
    }
    
    func recordQuizAttempt(moduleId: String, moduleName: String, category: String, correctCount: Int, totalCount: Int, wasAIGenerated: Bool) {
        let progress = getOrCreateProgress(moduleId: moduleId, moduleName: moduleName, category: category)
        progress.quizCompleted = true
        progress.lastStudiedAt = Date()
        
        // Update best score
        if let currentBest = progress.bestScore {
            if correctCount > currentBest {
                progress.bestScore = correctCount
                progress.totalQuestions = totalCount
            }
        } else {
            progress.bestScore = correctCount
            progress.totalQuestions = totalCount
        }
        
        let attempt = QuizAttempt(correctCount: correctCount, totalCount: totalCount, wasAIGenerated: wasAIGenerated)
        progress.quizAttempts.append(attempt)
        context?.insert(attempt)
        try? context?.save()
    }
    
    func getRecentModules(limit: Int = 3) -> [ModuleProgress] {
        guard let context = context else { return [] }
        var descriptor = FetchDescriptor<ModuleProgress>(
            sortBy: [SortDescriptor(\.lastStudiedAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        
        do {
            let results = try context.fetch(descriptor)
            return results.filter { $0.lastStudiedAt != nil }
        } catch {
            print("Failed to fetch recent modules: \(error)")
            return []
        }
    }
    
    func getModuleProgress(moduleId: String) -> ModuleProgress? {
        guard let context = context else { return nil }
        let descriptor = FetchDescriptor<ModuleProgress>(
            predicate: #Predicate<ModuleProgress> { $0.moduleId == moduleId }
        )
        do {
            let results = try context.fetch(descriptor)
            return results.first
        } catch {
            print("Failed to fetch module progress: \(error)")
            return nil
        }
    }
    
    private func getModuleDetails(for moduleId: String) -> (name: String, category: String) {
        switch moduleId {
        case "binaryTree": return ("Binary Tree", "dataStructure")
        case "linkedList": return ("Linked List", "dataStructure")
        case "queue":      return ("Queue", "dataStructure")
        case "stack":      return ("Stack", "dataStructure")
        case "dijkstra":   return ("Dijkstra", "algorithm")
        case "bfs":        return ("BFS", "algorithm")
        case "dfs":        return ("DFS", "algorithm")
        default:           return (moduleId.capitalized, "unknown")
        }
    }
    
    func updateLastCardIndex(moduleId: String, cardIndex: Int) {
        let details = getModuleDetails(for: moduleId)
        let progress = getOrCreateProgress(moduleId: moduleId, moduleName: details.name, category: details.category)
        progress.lastCardIndex = cardIndex
        progress.lastStudiedAt = Date()
        try? context?.save()
    }
    
    func getLastCardIndex(moduleId: String) -> Int {
        guard let progress = getModuleProgress(moduleId: moduleId) else { return 0 }
        return progress.lastCardIndex
    }
    
    func getAllProgress() -> [ModuleProgress] {
        guard let context = context else { return [] }
        let descriptor = FetchDescriptor<ModuleProgress>()
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch all progress: \(error)")
            return []
        }
    }
    
    func resetAllProgress() {
        guard let context = context else { return }
        do {
            let progressItems = try context.fetch(FetchDescriptor<ModuleProgress>())
            for item in progressItems {
                context.delete(item)
            }
            let attemptItems = try context.fetch(FetchDescriptor<QuizAttempt>())
            for item in attemptItems {
                context.delete(item)
            }
            try context.save()
        } catch {
            print("Failed to reset progress: \(error)")
        }
    }
}
