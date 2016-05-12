//
//  V/Users/Derek/Developer/Calculator/Calculator/Base.lproj/Main.storyboardiewController.swift
//  Calculator
//
//  Created by Derek Pacula on 4/19/16.
//  Copyright © 2016 Derek Pacula. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var display: UILabel!
    @IBOutlet var history: UILabel!
    
    var  brain = CalculatorBrain()
    
    private var userIsInTheMiddleOfTyping = false
    
    //Function to determine if the user is touching a digit
    //Variable: userIsInTheMiddleOfTyping, Type: Bool. Checks if the user is typing to not append digit
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if digit == "." && display.text!.rangeOfString(".") != nil {
            return;
        }
        
        if userIsInTheMiddleOfTyping
        {
            
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else
        {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    private var displayValue: Double {
        
        get {
            
            return Double(display.text!)!
        }
        
        set {
            
            display.text = String(newValue)
             history.text = brain.description + (brain.isPartialResult ? " …" : " =")

            
        }
    }
    
    
    //Function to perform mathetmatical operations on the calculator.
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping
        {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle
        {
            brain.performOperation(mathematicalSymbol)

    
        }
        displayValue = brain.result
    }
    

    @IBAction func clearCalculatorDisplay(sender: UIButton) {
        
        display.text = String(0)
        userIsInTheMiddleOfTyping = false
        brain.setOperand(0)
        history.text = String(" ")
    }
    

}


