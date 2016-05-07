//
//  calculatorBrain.swift
//  Calculator
//
//  Created by Derek Pacula on 4/26/16.
//  Copyright © 2016 Derek Pacula. All rights reserved.
//

import Foundation

class calculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double) {
        
        accumulator = operand
        internalProgram.append(operand)
    }
    
    func setOperand(variableName: String) {
        
        variableValues[variableName] = accumulator
    }
    
    
    var operations: Dictionary<String, Operation> =  [
        
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan":Operation.UnaryOperation(tan),
        "| x |":Operation.UnaryOperation({abs($0)}),
        "±":Operation.UnaryOperation({ -$0}),
        "×": Operation.BinaryOperation({$0 * $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "-": Operation.BinaryOperation({$0 - $1}),
        "=": Operation.Equals,
        "M": Operation.Variable("M"),
        "AC":Operation.Constant(0)
    
    ]
    
    var variableValues = [String: Double]()
    
    enum Operation {
        
        case Constant(Double)
        case UnaryOperation ((Double) -> Double)
        case BinaryOperation ((Double, Double) -> Double)
        case Equals
        case Variable(String)
    }
    
    func performOperation(symbol: String){
        
        internalProgram.append(symbol)
        
        if let operation = operations[symbol]
        {
            switch operation {
                
            case .Constant (let value): accumulator = value
                print("This is value \(value) and d this is accumlator \(accumulator)")
                //Try priting function
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                print("UnaryOperation")
            case .BinaryOperation (let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                print("Binary Operation")
            case .Variable (let thisVariable): variableValues[thisVariable] = accumulator
                print("Variable is called. thisVariable is \(thisVariable) accumlator is \(accumulator)")
            print("the amount of items in the dictonary \(variableValues.count) ")
            case .Equals: executePendingBinaryOperation()
                print("Equals")
            
            
            
            }
        }
        
    }
    
   
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
            
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            
            pending = nil
        }

    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        
        get {
            return internalProgram
        }
        
        set {
            accumulator = 0.0
            pending = nil
            internalProgram.removeAll()
            
            if let arrayOfOps = newValue as? [AnyObject] {
                
                for op in arrayOfOps {
                    
                    if let operand = op as? Double {
                        
                        setOperand(operand)
                    }
                    else if let operation = op as? String {
                        
                        performOperation(operation)
                    }
                }
            }
            
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        
        get {
            
            return accumulator
        }
    }
}