//
//  Game.swift
//  OpenQuizz
//
//  Created by Ambroise COLLON on 13/06/2017.
//  Copyright © 2017 OpenClassrooms. All rights reserved.
//

import Foundation


class Game {
    var score = 0

    private var questions = [Question]()
    private var currentIndex = 0

    var state: State = .ongoing

    enum State {
        case ongoing, over
    }

    var currentQuestion: Question {
        return questions[currentIndex]
    }

    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        
        QuestionManager.shared.get { (questions) in
            self.questions = questions
            self.state = .ongoing
            
            
    //************************LES NOTIFICATIONS ***************************************
            
            //On veut que le modèle émette une notification pour communiquer avec le controleur
            
            //On crée un nom de type Notification
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            //On crée la notification en elle même, on passe name dans son initialmisation
            let notification = Notification(name: name)
            //On envoie la notification avec Notificatiopn center et la méthode post
            NotificationCenter.default.post(notification)
        }
    }

    //On crée une méthode privée receivedQuestions qui prend en paramètre une valeur de type tableau de Question
    //et qui ne renvoie rien
    
    private func receiveQuestions(_ questions: [Question]) {
        //on assigne les questions recues à la propriété questions de notre classe game.
        self.questions = questions
        //Je fais un print pour afficher les questions
        print(questions)
        //J'indique que la partie est prête a démarrer
        state = .ongoing
    }

    func answerCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
        }
        goToNextQuestion()
    }

    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }

    private func finishGame() {
        state = .over
    }

}
