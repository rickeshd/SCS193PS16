//
//  ViewController.swift
//  Calculator
//
//  Created by Scott Moen on 5/11/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    private var userIsTyping = false
    private var brain = CalculatorBrain()
    private lazy var formatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        formatter.minimumIntegerDigits = 1
        return formatter
    }()
    
    private var displayValue: Double? {
        get { return Double(display.text!) }
        set {            
            if newValue == nil {
                display.text = ""
                history.text = ""
            } else {
                display.text = formatter.stringFromNumber(newValue!)
                history.text = brain.description + (brain.isPartialResult ? "…" : "=")
            }
        }
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var display: UILabel!
    @IBOutlet weak private var history: UILabel!
    
    // MARK: - IBAction
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsTyping {
            // make sure we aren't adding a second period
            if digit != "." || display.text!.rangeOfString(".") == nil {
                display.text = display.text! + digit
            }
        } else {
            display.text = (digit == "." ? "0" : "") + digit
            userIsTyping = true
        }
    }

    @IBAction private func touchOperation(sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue!)
            userIsTyping = false
        }
        
        brain.performOperation(sender.currentTitle!)
        displayValue = brain.result
    }
    
    @IBAction func randomNumber() {
        if userIsTyping {
            brain.setOperand(displayValue!)
        }

        display.text = formatter.stringFromNumber(drand48())
        userIsTyping = true
    }
    
    @IBAction func memoryStore() {
        userIsTyping = false
        brain.varialbeValues["M"] = displayValue
        displayValue = brain.result
    }
    
    @IBAction func memoryPush() {
        brain.setOperand("M")
        displayValue = brain.result
    }

    @IBAction private func clear() {
        brain.clear()
        displayValue = brain.result
    }
    
    @IBAction private func backspace() {
        if userIsTyping {
            display.text!.removeAtIndex(display.text!.startIndex)
            
            if display.text!.isEmpty {
                displayValue = nil
                userIsTyping = false
            }
        }
    }
    
}
