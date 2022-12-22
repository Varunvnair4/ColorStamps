//
//  ViewController.swift
//  ColorStamps
//
//  Created by Varun V Nair on 17/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var colorButtons: [UIButton]!
    
    private var selectedColor: UIColor = .black
    
    private var colorCount: [UIColor: Int] = [:]
    
    private var undoLabels: [UILabel] = []
    private var redoLabels: [UILabel] = []
    
    @IBOutlet weak var btnUndo: UIBarButtonItem!
    @IBOutlet weak var btnRedo: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))

        
        undoButtonState()
        redoButtonState()
    }
    
}


// MARK: Button Action Methods
private extension ViewController {
    
    @IBAction func colorButtonAction(_ sender: UIButton) {
        
        guard let color = sender.backgroundColor else {
            return
        }
        
        self.selectedColor = color
        updateButtonColors(selectedButton: sender)
        
    }
    
    
    @IBAction func undoButtonAction(_ sender: UIBarButtonItem) {
        
        guard let lastLabel = self.undoLabels.popLast() else {
            return
        }
        
        redoLabels.append(lastLabel)
        
        if let color = lastLabel.backgroundColor, let count = colorCount[color] {
            colorCount[color] = count - 1
        }
        
        
        lastLabel.removeFromSuperview()
        
        undoButtonState()
        redoButtonState()
        
    }
    
    @IBAction func redoButtonAction(sender: UIBarButtonItem) {
        
        guard let lastLabel = self.redoLabels.popLast() else {
            return
        }
        
        undoLabels.append(lastLabel)
        
        if let color = lastLabel.backgroundColor, let count = colorCount[color] {
            colorCount[color] = count + 1
        }
        
        self.view.addSubview(lastLabel)
        
        undoButtonState()
        redoButtonState()
        
    }
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        
        redoLabels.forEach { view in
            UIView.animate(withDuration: 0.5) {
                view.alpha = 0.0
            } completion: { success in
                if success {
                    view.removeFromSuperview()
                    if let color = view.backgroundColor {
                        self.colorCount[color] = 0
                    }
                    self.redoLabels.removeAll()
                    self.redoButtonState()
                }
            }

        }
        
        undoLabels.forEach { view in
                
            UIView.animate(withDuration: 0.5) {
                view.alpha = 0.0
            } completion: { success in
                if success {
                    view.removeFromSuperview()
                    if let color = view.backgroundColor {
                        self.colorCount[color] = 0
                    }
                    self.undoLabels.removeAll()
                    self.undoButtonState()
                }
            }

        }
        
    }
}

// MARK: Other Methods
private extension ViewController {
    
    func updateButtonColors (selectedButton: UIButton) {
        
        //Changing alpha of all bottom buttons
        colorButtons.forEach { $0.alpha = 1.0 }
        
        selectedButton.alpha = 0.8
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        addSquareObject(with: selectedColor, at: sender.location(in: self.view))
    }
    
    func addSquareObject(with color: UIColor, at location: CGPoint) {
        
        let square = UILabel(frame: CGRect(x: location.x, y: location.y, width: 50, height: 50))
        
        square.textColor = .white
        square.textAlignment = .center
        square.backgroundColor = color
        
        if let colorCountExist = self.colorCount[color] {
            self.colorCount[color] = colorCountExist + 1
            square.text = String(colorCountExist + 1)
        } else {
            self.colorCount[color] = 1
            square.text = "1"
        }
        
        undoLabels.append(square)
        undoButtonState()
        
        self.view.addSubview(square)
        
    }
    
    func undoButtonState() {
        
        if undoLabels.isEmpty, btnUndo.isEnabled {
            btnUndo.isEnabled = false
        } else if !undoLabels.isEmpty, !btnUndo.isEnabled {
            btnUndo.isEnabled = true
        }
        
    }
    
    func redoButtonState() {
        
        if redoLabels.isEmpty, btnRedo.isEnabled {
            btnRedo.isEnabled = false
        } else if !redoLabels.isEmpty, !btnRedo.isEnabled {
            btnRedo.isEnabled = true
        }
        
    }
    
}


