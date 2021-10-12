//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Jean-Baptiste VOILLEMIN on 15/09/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var QuestionView: QuestionView!
    
    
    //On crée une variable game
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
        
        //On lance une partie tout de suite
        startNewGame()
        
        
        //On crée un UIGestureRecognizer qui a besoin de 3 choses:
            //1-Besoin de la cible (qui est responsable de gérer le geste, generalement le controleur)
            //2-Besoin de l'action: quelle action qd le geste est reconnue
            //3- La vue: QUelle vue doit détecter le geste
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView))
        
        //Quelle vue doit détecter le geste, ici QuestionVue !
        QuestionView.addGestureRecognizer(panGestureRecognizer)
    }

    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
    private func startNewGame() {
        //On montre l'icone de chargement
        activityIndicator.isHidden = false
        //On cache le bouton
        newGameButton.isHidden = true
        
        //On affiche le message "Loading..."
        QuestionView.title = "Loading..."
        //On charge le style .standard
        QuestionView.style = .standard
        
        //On affiche le score à 0
        scoreLabel.text = "0 / 10"
        
        game.refresh()
    }
    
    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        
        //On modifie le titre de notre vue
        QuestionView.title = game.currentQuestion.title
        
    }
    
    //On crée une fonction qui va gérer le geste de deplacement
    //sender est un paramètre qui va être le geste
    @objc func dragQuestionView(_ sender : UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, . changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
        
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        
        //deplacement de la vue QuestionView
        let translation = gesture.translation(in: QuestionView)
        
        //On vrée une transformation de translation
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        
        let screenWidth = UIScreen.main.bounds.width
        
        //On calcule où on en est par rapport au bord de  l'écran de -100% à +100%!
        let translationPercent = translation.x/(screenWidth/2)
        
        //On utilise ce pourcentage pour trouver l'angle entre -pi/6 et +pi/6
        let rotationAngle = (CGFloat.pi / 6) * translationPercent
        
        //On crée une transformation de rotation
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        //On combine les 2 transformations
        let transformFinal = translationTransform.concatenating(rotationTransform)
        
        //On affecte  cette transformation finale à la transformation de questionView
        QuestionView.transform = transformFinal
        
        
        //On applique le style différent si droite ou gauche donc si positif oou negatif donc si > 0
        if translation.x > 0 {
            QuestionView.style = .correct
        } else {
            QuestionView.style = .incorrect
        }
    }
    
    private func answerQuestion() {
        switch  QuestionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }
        
        //On affiiche le score
        scoreLabel.text = "\(game.score) / 10"
        
       
        
        //On récupère la largeur de l'écran
        let screenWidth = UIScreen.main.bounds.width
        
        var translationTransform: CGAffineTransform
        
        if QuestionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.QuestionView.transform = translationTransform
        } completion: { success in
            if success {
                self.showQuestionView()
            }
        }

        
    }
    
    private func showQuestionView() {
        //On remet la transformation de QuestioView à son point de départ avec .identity
        QuestionView.transform = .identity
        
        //On vezut réduire la taille
        QuestionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        //On remet également le style de QuesitonView sur standard
        QuestionView.style = .standard
        
        
        switch game.state {
        case .ongoing:
            //On charge la nouvelle question
            QuestionView.title = game.currentQuestion.title
        case .over:
            QuestionView.title = "Game Over"
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.QuestionView.transform = .identity
        }, completion: nil)
        }
        
    }


