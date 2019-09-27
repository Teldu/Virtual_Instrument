//
//  ViewController.swift
//  Virtual_Instrument
//
//  Created by Sean on 7/24/19.
//  Copyright © 2019 Sean. All rights reserved.
//

import Cocoa
import AVFoundation
import AudioToolbox
import CoreMIDI
import MIKMIDI

class ViewController: NSViewController {
    private let operationQueue: OperationQueue = OperationQueue()
    
    var myVar = vari()
    var curPlayer = [playerStruct?](repeating: nil, count: 13)
    var reverbStatus: Bool = false
    var delayStatus: Bool = false
    var eqStatus: Bool = false
    var noteNum = 0
    var oct = 2
    
    var ae:AVAudioEngine?
    var player:AVAudioPlayerNode?
    var mixer:AVAudioMixerNode?
    var buffer:AVAudioPCMBuffer?
    
    @IBOutlet weak var EQFreq1: NSSliderCell!
    @IBOutlet weak var EQF1T: NSTextFieldCell!
    @IBOutlet weak var EQFreq2: NSSliderCell!
    @IBOutlet weak var EQF2T: NSTextFieldCell!
    @IBOutlet weak var EQFreq3: NSSliderCell!
    @IBOutlet weak var EQF3T: NSTextFieldCell!
    
    
    @IBOutlet weak var EQGain1: NSSliderCell!
    @IBOutlet weak var EQG1T: NSTextFieldCell!
    @IBOutlet weak var EQGain2: NSSliderCell!
    @IBOutlet weak var EQG2T: NSTextFieldCell!
    @IBOutlet weak var EQGain3: NSSliderCell!
    @IBOutlet weak var EQG3T: NSTextFieldCell!
    
    @IBOutlet weak var EQBand1: NSSliderCell!
    @IBOutlet weak var EQBW1T: NSTextFieldCell!
    @IBOutlet weak var EQBand2: NSSliderCell!
    @IBOutlet weak var EQBW2T: NSTextFieldCell!
    @IBOutlet weak var EQBand3: NSSliderCell!
    @IBOutlet weak var EQBW3T: NSTextFieldCell!
    
    @IBOutlet weak var DelayTime: NSSliderCell!
    @IBOutlet weak var DTText: NSTextFieldCell!
    @IBOutlet weak var DelayRatio: NSSliderCell!
    @IBOutlet weak var DRText: NSTextFieldCell!
    @IBOutlet weak var DelayFeedback: NSSliderCell!
    @IBOutlet weak var DFBT: NSTextFieldCell!
    
    @IBOutlet weak var ReverbRatio: NSSliderCell!
    @IBOutlet weak var VerbText: NSTextFieldCell!
    
    @IBOutlet weak var EQButton: NSButtonCell!
    @IBOutlet weak var DelayButton: NSButtonCell!
    @IBOutlet weak var ReverbButton: NSButtonCell!
    
    @IBOutlet weak var InstrumentMenu: NSPopUpButton!
    @IBOutlet weak var ReverbMenu: NSPopUpButtonCell!
    @IBOutlet weak var OctaveSelect: NSPopUpButtonCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //EQ Variable Setup
        EQFreq1.isContinuous = true
        EQFreq1.doubleValue = 100 //in Hz
        EQFreq1.minValue = 20
        EQFreq1.maxValue = 500
        EQFreq2.isContinuous = true
        EQFreq2.doubleValue = 500
        EQFreq2.minValue = 250
        EQFreq2.maxValue = 4000
        EQFreq3.isContinuous = true
        EQFreq3.doubleValue = 4000
        EQFreq3.minValue = 2000
        EQFreq3.maxValue = 20000
        
        EQGain1.isContinuous = true
        EQGain1.minValue = -24
        EQGain1.maxValue = 24
        EQGain1.doubleValue = 0
        EQGain2.isContinuous = true
        EQGain2.minValue = -24
        EQGain2.maxValue = 24
        EQGain2.doubleValue = 0
        EQGain3.isContinuous = true
        EQGain3.minValue = -24
        EQGain3.maxValue = 24
        EQGain3.doubleValue = 0
        
        EQBand1.isContinuous = true
        EQBand1.minValue = 0.05
        EQBand1.maxValue = 5
        EQBand1.doubleValue = 1
        EQBand2.isContinuous = true
        EQBand2.minValue = 0.05
        EQBand2.maxValue = 5
        EQBand2.doubleValue = 1
        EQBand3.isContinuous = true
        EQBand3.minValue = 0.05
        EQBand3.maxValue = 5
        EQBand3.doubleValue = 1
        
        //Delay Variable Setup
        DelayTime.isContinuous = true //range is 0-2 sec
        DelayTime.minValue = 0
        DelayTime.maxValue = 2
        DelayTime.floatValue = 0
        DelayRatio.isContinuous = true //range is 0-100, default is 100
        DelayRatio.floatValue = 50
        DelayFeedback.isContinuous = true //range is -100 to 100, default 50
        DelayFeedback.floatValue = 0
        
        //Reverb Variable Setup
        ReverbRatio.isContinuous = true
        ReverbRatio.minValue = 0
        ReverbRatio.maxValue = 100
        
        //Defaults for checkboxes & text boxes
        ReverbButton.state = .off
        DelayButton.state = .off
        EQButton.state = .off
        
        //InstrumentMenu.addItem(withTitle: "Sawtooth Wave")
        //InstrumentMenu.addItem(withTitle: "Square Wave")
        //InstrumentMenu.addItem(withTitle: "Triangle Wave")
        ReverbMenu.addItem(withTitle: "Large")
        OctaveSelect.addItem(withTitle: "3")
        OctaveSelect.addItem(withTitle: "4")
        OctaveSelect.selectItem(at: 2)
        curPlayer[0] = setUpPlayback (fn: myVar.C[oct])
        
        EQF1T.title = String(format: "%.2f", EQFreq1.doubleValue)
        EQF2T.title = String(format: "%.2f", EQFreq2.doubleValue)
        EQF3T.title = String(format: "%.2f", EQFreq3.doubleValue)
        EQG1T.title = String(format: "%.2f", EQGain1.doubleValue)
        EQG2T.title = String(format: "%.2f", EQGain2.doubleValue)
        EQG3T.title = String(format: "%.2f", EQGain3.doubleValue)
        EQBW1T.title = String(format: "%.2f", EQBand1.doubleValue)
        EQBW2T.title = String(format: "%.2f", EQBand2.doubleValue)
        EQBW3T.title = String(format: "%.2f", EQBand3.doubleValue)
        DTText.title = String(format: "%.2f", DelayTime.doubleValue)
        DRText.title = String(format: "%.2f", DelayRatio.doubleValue)
        DFBT.title = String(format: "%.2f", DelayFeedback.doubleValue)
        VerbText.title = String(format: "%.2f", ReverbRatio.doubleValue)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    //EQ Functions
    @IBAction func EQFreq1Slide(_ sender: Any) {
        EQF1T.title = String(format: "%.2f", EQFreq1.doubleValue)
        curPlayer[noteNum]!.eqNode.bands[0].frequency = EQFreq1.floatValue
    }
    @IBAction func EQFreq2Slide(_ sender: Any) {
        EQF2T.title = String(format: "%.2f", EQFreq2.doubleValue)
        curPlayer[noteNum]!.eqNode.bands[1].frequency = EQFreq2.floatValue
    }
    @IBAction func EQFreq3Slide(_ sender: Any) {
        EQF3T.title = String(format: "%.2f", EQFreq3.doubleValue)
        curPlayer[noteNum]!.eqNode.bands[2].frequency = EQFreq3.floatValue
    }
    
    @IBAction func EQGain1Slide(_ sender: Any) {
        EQG1T.title = String(format: "%.2f", EQGain1.doubleValue)
        curPlayer[noteNum]!.eqNode.bands[0].gain = EQGain1.floatValue
    }
    @IBAction func EQGain2Slide(_ sender: Any) {
        EQG2T.title = String(format: "%.2f", EQGain2.doubleValue)
        curPlayer[noteNum]!.eqNode.bands[1].gain = EQGain2.floatValue
    }
    @IBAction func EQGain3Slide(_ sender: Any) {
        EQG3T.title = String(format: "%.2f", EQGain3.doubleValue)
        curPlayer[noteNum]!.eqNode.bands[2].gain = EQGain3.floatValue
    }
    
    @IBAction func EQBand1Slide(_ sender: Any) {
        EQBW1T.title = String(format: "%.2f", EQBand1.doubleValue)
        curPlayer[noteNum]!.eqNode.bands[0].bandwidth = EQBand1.floatValue
    }
    @IBAction func EQBand2Slide(_ sender: Any) {
        EQBW2T.title = String(format: "%.2f", EQBand2.doubleValue)
        curPlayer[noteNum]!.eqNode.bands[1].bandwidth = EQBand2.floatValue
    }
    @IBAction func EQBand3Slide(_ sender: Any) {
        EQBW3T.title = String(format: "%.2f", EQBand3.doubleValue)
        curPlayer[noteNum]!.eqNode.bands[2].bandwidth = EQBand3.floatValue
    }
    
    
    //Delay Functions
    @IBAction func DelayPushed(_ sender: Any) {
        if(delayStatus == true){
            delayStatus = false
            for n in 0...12{
                curPlayer[n]!.delayNode.bypass = true
                curPlayer[n]!.delayNode.delayTime = 0.0
            }
        }
        else{
            delayStatus = true
            curPlayer[noteNum]!.delayNode.bypass = false
            curPlayer[noteNum]!.delayNode.delayTime = TimeInterval(DelayTime.floatValue)
        }
    }
    @IBAction func DelayTimeSlide(_ sender: Any) {
        DTText.title = String(format: "%.2f", DelayTime.doubleValue)
        if(delayStatus == true){
            curPlayer[noteNum]!.delayNode.delayTime = TimeInterval(DelayTime.floatValue)
        }
        else{
            curPlayer[noteNum]!.delayNode.delayTime = 0.0
        }
    }
    @IBAction func DelayRatioSlide(_ sender: Any) {
        DRText.title = String(format: "%.2f", DelayRatio.doubleValue)
        if(delayStatus == true){
            curPlayer[noteNum]!.delayNode.wetDryMix = DelayRatio.floatValue
        }
        else{
            curPlayer[noteNum]!.delayNode.wetDryMix = 0.0
        }
    }
    @IBAction func DelayFBSlide(_ sender: Any) {
        DFBT.title = String(format: "%.2f", DelayFeedback.doubleValue)
        if(delayStatus == true){
            curPlayer[noteNum]!.delayNode.feedback = DelayFeedback.floatValue
        }
        else{
            curPlayer[noteNum]!.delayNode.feedback = 0.0
        }
    }
    
    //Reverb Functions
    @IBAction func ReverbPushed(_ sender: Any) {
        if(reverbStatus == true){
            reverbStatus = false
            curPlayer[noteNum]!.reverbNode.bypass = true
            curPlayer[noteNum]!.reverbNode.wetDryMix = 0.0
        }
        else{
            reverbStatus = true
            curPlayer[noteNum]!.reverbNode.bypass = false
            curPlayer[noteNum]!.reverbNode.wetDryMix = ReverbRatio.floatValue
        }
    }
    @IBAction func ReverbRatioSlider(_ sender: Any) {
        VerbText.title = String(format: "%.2f", ReverbRatio.doubleValue)
        if(reverbStatus == true){
            curPlayer[noteNum]!.reverbNode.wetDryMix = ReverbRatio.floatValue
        }
        else{
            curPlayer[noteNum]!.reverbNode.wetDryMix = 0.0
        }
    }

    @IBAction func octaveSelection(_ sender: Any) {
        if(OctaveSelect.selectedItem == OctaveSelect.item(withTitle: "0")){
            oct = 0
        }
        else if(OctaveSelect.selectedItem == OctaveSelect.item(withTitle: "1")){
            oct = 1
        }
        else if(OctaveSelect.selectedItem == OctaveSelect.item(withTitle: "2")){
            oct = 2
        }
        else if(OctaveSelect.selectedItem == OctaveSelect.item(withTitle: "3")){
            oct = 3
        }
        else if(OctaveSelect.selectedItem == OctaveSelect.item(withTitle: "4")){
            oct = 4
        }
    }
    
    //Play Notes
    @IBAction func playC(_ sender: Any) {
        noteNum = 0
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
            curPlayer[0] = setUpPlayback (fn: myVar.C[oct])
            operationQueue.addOperation{
                self.eqSetup(player: self.curPlayer[0]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.playFile(player: self.curPlayer[0]!)
            }
        }
        else{
            curPlayer[0] = setUpPlayback (fn: myVar.C[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[0]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[0]!, note: self.myVar.cArray[self.oct])
            }
        }
    }
    @IBAction func playCS(_ sender: Any) {
        noteNum = 1
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
            curPlayer[1] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation{
                self.eqSetup(player: self.curPlayer[1]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.playFile(player: self.curPlayer[1]!)
            }
        }
        else{
            curPlayer[1] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[1]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[1]!, note: self.myVar.csArray[self.oct])
            }
        }
    }
    @IBAction func playD(_ sender: Any) {
        noteNum = 2
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[2] = setUpPlayback (fn: myVar.D[oct])
        operationQueue.addOperation{
            self.eqSetup(player: self.curPlayer[2]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            self.playFile(player: self.curPlayer[2]!)
        }
        }
        else{
            curPlayer[2] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[2]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[2]!, note: self.myVar.dArray[self.oct])
            }
        }
    }
    @IBAction func playEF(_ sender: Any) {
        noteNum = 3
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[3] = setUpPlayback (fn: myVar.Eb[oct])
        operationQueue.addOperation{
            self.eqSetup(player: self.curPlayer[3]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            self.playFile(player: self.curPlayer[3]!)
        }
        }
        else{
            curPlayer[3] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[3]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[3]!, note: self.myVar.efArray[self.oct])
            }
        }
    }
    @IBAction func playE(_ sender: Any) {
        noteNum = 4
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[4] = setUpPlayback (fn: myVar.E[oct])
        operationQueue.addOperation{
            self.eqSetup(player: self.curPlayer[4]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            self.playFile(player: self.curPlayer[4]!)
        }
        }
        else{
            curPlayer[4] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[4]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[4]!, note: self.myVar.eArray[self.oct])
            }
        }
    }
    @IBAction func playF(_ sender: Any) {
        noteNum = 5
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[5] = setUpPlayback (fn: myVar.F[oct])
        operationQueue.addOperation{
            self.eqSetup(player: self.curPlayer[5]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            self.playFile(player: self.curPlayer[5]!)
        }
        }
        else{
            curPlayer[5] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[5]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[5]!, note: self.myVar.fArray[self.oct])
            }
        }
    }
    @IBAction func playFS(_ sender: Any) {
        noteNum = 6
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[6] = setUpPlayback (fn: myVar.Gb[oct])
        operationQueue.addOperation{
            self.eqSetup(player: self.curPlayer[6]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            self.playFile(player: self.curPlayer[6]!)
        }
        }
        else{
            curPlayer[6] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[6]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[6]!, note: self.myVar.fsArray[self.oct])
            }
        }
    }
    @IBAction func playG(_ sender: Any) {
        noteNum = 7
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[7] = setUpPlayback (fn: myVar.G[oct])
        operationQueue.addOperation{
            self.eqSetup(player: self.curPlayer[7]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            self.playFile(player: self.curPlayer[7]!)
        }
        }
        else{
            curPlayer[7] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[7]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[7]!, note: self.myVar.gArray[self.oct])
            }
        }
    }
    @IBAction func playGS(_ sender: Any) {
        noteNum = 8
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[8] = setUpPlayback (fn: myVar.Ab[oct])
        operationQueue.addOperation{
            self.eqSetup(player: self.curPlayer[8]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            self.playFile(player: self.curPlayer[8]!)
        }
        }
        else{
            curPlayer[8] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[8]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[8]!, note: self.myVar.gsArray[self.oct])
            }
        }
    }
    @IBAction func playA(_ sender: Any) {
        noteNum = 9
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[9] = setUpPlayback (fn: myVar.A[oct])
        operationQueue.addOperation{
            self.eqSetup(player: self.curPlayer[9]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            self.playFile(player: self.curPlayer[9]!)
        }
        }
        else{
            curPlayer[9] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[9]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[9]!, note: self.myVar.aArray[self.oct])
            }
        }
    }
    @IBAction func playAS(_ sender: Any) {
        noteNum = 10
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[10] = setUpPlayback (fn: myVar.Bb[oct])
        operationQueue.addOperation{
            self.eqSetup(player: self.curPlayer[10]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            self.playFile(player: self.curPlayer[10]!)
        }
        }
        else{
            curPlayer[10] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[10]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[10]!, note: self.myVar.asArray[self.oct])
            }
        }
    }
    @IBAction func playB(_ sender: Any) {
        noteNum = 11
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[11] = setUpPlayback (fn: myVar.B[oct])
        operationQueue.addOperation{
            self.eqSetup(player: self.curPlayer[11]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            self.playFile(player: self.curPlayer[11]!)
        }
        }
        else{
            curPlayer[11] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[11]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[11]!, note: self.myVar.bArray[self.oct])
            }
        }
    }
    @IBAction func playCH(_ sender: Any) {
        noteNum = 12
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[12] = setUpPlayback (fn: myVar.C[oct + 1])
        operationQueue.addOperation{
            self.eqSetup(player: self.curPlayer[12]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            self.playFile(player: self.curPlayer[12]!)
        }
        }
        else{
            curPlayer[12] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation {
                self.eqSetup(player: self.curPlayer[12]!, freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                self.sineWave(player: self.curPlayer[12]!, note: self.myVar.cArray[self.oct + 1])
            }
        }
    }
}
