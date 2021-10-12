//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Jean-Baptiste VOILLEMIN on 16/09/2021.
//

import UIKit

class QuestionView: UIView {

    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    
    //on a 3 choix possible donc utilisation enumération
    enum Style {
        case correct, incorrect, standard
    }
    
    //Variable observable avec didSet, dès qu'il y a changement, le titre se met à jour
    var title = "" {
        didSet {
            label.text = title
        }
    }
    
    //Variable pour le style, observable également, se met à jour qd chgt
    var style: Style = .standard {
        didSet{
            setStyle(style)
        }
    }
    
    //On crée une fonction qui définit le style, en fction du style, on change le background et l'icone
    private func setStyle(_ style: Style) {
        switch style {
            case .correct:
                backgroundColor = UIColor(red: 200/255.0, green: 236/255.0, blue: 160/255.0, alpha: 1)
                icon.image = UIImage(named: "Icon Correct")
                icon.isHidden = false
            case .incorrect:
                backgroundColor = #colorLiteral(red: 0.9556929469, green: 0.5283375978, blue: 0.5803807378, alpha: 1)
                icon.image = #imageLiteral(resourceName: "Icon Error")
                icon.isHidden = false
            case .standard:
                backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                icon.isHidden = true
                
        }
    }
   

}
