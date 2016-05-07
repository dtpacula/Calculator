//
//  ViewController.swift
//  Calculator
//
//  Created by Derek Pacula on 4/19/16.
//  Copyright © 2016 Derek Pacula. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var display: UILabel!
    @IBOutlet var operationAndOperandHistory: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    //Function to determine if the user is touching a digit
    //Variable: userIsInTheMiddleOfTyping, Type: Bool. Checks if the user is typing to not append digit
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        operationsAndOperand(digit)
        
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

            
        }
    }
    
    private var brain = calculatorBrain()
    
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
            operationsAndOperand(" " + mathematicalSymbol + " ")
            
            if mathematicalSymbol == "="
            {
                operationsAndOperand(String(brain.result) + " ")
            }
            
    

            
        }
        displayValue = brain.result
        
    }
    
    //History description field
    func operationsAndOperand(history: String)
    {
        operationAndOperandHistory.text = operationAndOperandHistory.text! + history
    }
    
    var savedProgram: calculatorBrain.PropertyList?
    @IBAction func save() {
        
        savedProgram = brain.program
    }
    
    
    @IBAction func restore() {
        
        if savedProgram != nil {
            
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    @IBAction func clearCalculatorDisplay(sender: UIButton) {
        
        display.text = String(0)
        userIsInTheMiddleOfTyping = false
        brain.setOperand(0)
        operationAndOperandHistory.text = String(" ")
    }
    
    @IBAction func testVariables() {
        
        print("the amount of items in the dictonary \(brain.variableValues.count) ")
        display.text = String(brain.variableValues.count)

    }

}


