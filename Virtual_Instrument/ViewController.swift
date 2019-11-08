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

class ViewController: NSViewController {
    
    
    let recordingEngine = AVAudioEngine()
    
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
    
    @IBOutlet weak var volume: NSSliderCell!
    @IBOutlet weak var pan: NSSliderCell!
    
    
    
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
        
        ReverbMenu.addItem(withTitle: "Large")
        OctaveSelect.addItem(withTitle: "3")
        OctaveSelect.selectItem(at: 2)
        
        InstrumentMenu.addItem(withTitle: "Piano")
        InstrumentMenu.addItem(withTitle: "Strings")
        InstrumentMenu.addItem(withTitle: "Horns")
        InstrumentMenu.addItem(withTitle: "Synth 1")
        InstrumentMenu.addItem(withTitle: "Synth 2")
        InstrumentMenu.addItem(withTitle: "Pad 1")
        InstrumentMenu.addItem(withTitle: "Pad 2")
        
        
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
        
        //volume/pan setup
        volume.isContinuous = true
        volume.minValue = 0.0
        volume.maxValue = 1.0
        volume.floatValue = 0.5
        pan.isContinuous = true
        pan.minValue = -1.0
        pan.maxValue = 1.0
        pan.floatValue = 0.0
        
        
        for n in 0...12 {
            curPlayer.append(playerStruct(engine: mainEngine, playerNode: mainPlayer, mixerNode: mainMixer, reverbNode: mainVerb, delayNode: mainDelay, eqNode: mainEQ))
        }
        curPlayer[noteNum] = setUpPlayback (fn: myVar.C[oct])
        
        MIDIClientCreate("MidiTestClient" as CFString, nil, nil, &midiClient)
        MIDIInputPortCreate(midiClient, "MidiTest_InPort" as CFString, MyMIDIReadProc, nil, &inPort)
        MIDIPortConnectSource(inPort, src, &src)
        
    }
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    //EQ Functions
    @IBAction func EQFreq1Slide(_ sender: Any) {
        EQF1T.title = String(format: "%.2f", EQFreq1.doubleValue)
        curPlayer[noteNum].eqNode.bands[0].frequency = EQFreq1.floatValue
    }
    @IBAction func EQFreq2Slide(_ sender: Any) {
        EQF2T.title = String(format: "%.2f", EQFreq2.doubleValue)
        curPlayer[noteNum].eqNode.bands[1].frequency = EQFreq2.floatValue
    }
    @IBAction func EQFreq3Slide(_ sender: Any) {
        EQF3T.title = String(format: "%.2f", EQFreq3.doubleValue)
        curPlayer[noteNum].eqNode.bands[2].frequency = EQFreq3.floatValue
    }
    
    @IBAction func EQGain1Slide(_ sender: Any) {
        EQG1T.title = String(format: "%.2f", EQGain1.doubleValue)
        curPlayer[noteNum].eqNode.bands[0].gain = EQGain1.floatValue
    }
    @IBAction func EQGain2Slide(_ sender: Any) {
        EQG2T.title = String(format: "%.2f", EQGain2.doubleValue)
        curPlayer[noteNum].eqNode.bands[1].gain = EQGain2.floatValue
    }
    @IBAction func EQGain3Slide(_ sender: Any) {
        EQG3T.title = String(format: "%.2f", EQGain3.doubleValue)
        curPlayer[noteNum].eqNode.bands[2].gain = EQGain3.floatValue
    }
    
    @IBAction func EQBand1Slide(_ sender: Any) {
        EQBW1T.title = String(format: "%.2f", EQBand1.doubleValue)
        curPlayer[noteNum].eqNode.bands[0].bandwidth = EQBand1.floatValue
    }
    @IBAction func EQBand2Slide(_ sender: Any) {
        EQBW2T.title = String(format: "%.2f", EQBand2.doubleValue)
        curPlayer[noteNum].eqNode.bands[1].bandwidth = EQBand2.floatValue
    }
    @IBAction func EQBand3Slide(_ sender: Any) {
        EQBW3T.title = String(format: "%.2f", EQBand3.doubleValue)
        curPlayer[noteNum].eqNode.bands[2].bandwidth = EQBand3.floatValue
    }
    
    
    //Delay Functions
    @IBAction func DelayPushed(_ sender: Any) {
        if(delayStatus == true){
            delayStatus = false
            for n in 0...12{
                curPlayer[noteNum].delayNode.bypass = true
                curPlayer[noteNum].delayNode.delayTime = 0.0
            }
        }
        else{
            delayStatus = true
            curPlayer[noteNum].delayNode.bypass = false
            curPlayer[noteNum].delayNode.delayTime = TimeInterval(DelayTime.floatValue)
        }
    }
    @IBAction func DelayTimeSlide(_ sender: Any) {
        DTText.title = String(format: "%.2f", DelayTime.doubleValue)
        if(delayStatus == true){
            curPlayer[noteNum].delayNode.delayTime = TimeInterval(DelayTime.floatValue)
        }
        else{
            curPlayer[noteNum].delayNode.delayTime = 0.0
        }
    }
    @IBAction func DelayRatioSlide(_ sender: Any) {
        DRText.title = String(format: "%.2f", DelayRatio.doubleValue)
        if(delayStatus == true){
            curPlayer[noteNum].delayNode.wetDryMix = DelayRatio.floatValue
        }
        else{
            curPlayer[noteNum].delayNode.wetDryMix = 0.0
        }
    }
    @IBAction func DelayFBSlide(_ sender: Any) {
        DFBT.title = String(format: "%.2f", DelayFeedback.doubleValue)
        if(delayStatus == true){
            curPlayer[noteNum].delayNode.feedback = DelayFeedback.floatValue
        }
        else{
            curPlayer[noteNum].delayNode.feedback = 0.0
        }
    }
    
    //Reverb Functions
    @IBAction func ReverbPushed(_ sender: Any) {
        if(reverbStatus == true){
            reverbStatus = false
            curPlayer[noteNum].reverbNode.bypass = true
            curPlayer[noteNum].reverbNode.wetDryMix = 0.0
        }
        else{
            reverbStatus = true
            curPlayer[noteNum].reverbNode.bypass = false
            curPlayer[noteNum].reverbNode.wetDryMix = ReverbRatio.floatValue
        }
    }
    @IBAction func ReverbRatioSlider(_ sender: Any) {
        VerbText.title = String(format: "%.2f", ReverbRatio.doubleValue)
        if(reverbStatus == true){
            curPlayer[noteNum].reverbNode.wetDryMix = ReverbRatio.floatValue
        }
        else{
            curPlayer[noteNum].reverbNode.wetDryMix = 0.0
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
    }
    
    @IBAction func instrumentSelection(_ sender: Any) {
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){inst = 0}
        else if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Strings")){inst = 1}
        else if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Horns")){inst = 2}
        else if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Synth 1")){inst = 3}
        else if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Synth 2")){inst = 4}
        else if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Pad 1")){inst = 5}
        else if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Pad 2")){inst = 6}
    }
    
    
    //Volume/Pan Functions
    @IBAction func modVolume(_ sender: Any) {
        curPlayer[noteNum].mixerNode.outputVolume = volume.floatValue
    }
    @IBAction func modPan(_ sender: Any) {
        curPlayer[noteNum].mixerNode.pan = pan.floatValue * -1.0
    }
    
    
    @IBAction func recStart(_ sender: Any) {
        curPlayer2 = setUpPlayback (fn: myVar.C[oct])
        startRecording(output: mainEngine)
        playFile(player: curPlayer2)
        
    }
    @IBAction func recStop(_ sender: Any) {
        stopRecording()
    }
    
    @IBAction func playBack(_ sender: Any) {
        curPlayer2 = setUpPlayback(fn: myVar.outLocation)
        playFile(player: curPlayer2)
    }
    
    @IBAction func loopRec(_ sender: Any) {
        curPlayer2 = setUpPlayback(fn: myVar.outLocation)
        loop(player: curPlayer2, outLocation: myVar.outLocation)
    }
    
    //Play Notes
    @IBAction func playC(_ sender: Any) {
        noteNum = 0
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.C[oct])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CStrings[oct])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CHorns[oct])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CSynth1[oct])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CSynth2[oct])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CPad1[oct])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CPad2[oct])
        }
            operationQueue.addOperation{
                self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
                curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
                self.playFile(player: curPlayer[noteNum])
            }
        
    }
    @IBAction func playCS(_ sender: Any) {
        noteNum = 1
            if(inst == 0){
                curPlayer[noteNum] = setUpPlayback (fn: myVar.CS[oct])
            }
            else if(inst == 1){
                curPlayer[noteNum] = setUpPlayback (fn: myVar.CSStrings[oct])
            }else if(inst == 2){
                curPlayer[noteNum] = setUpPlayback (fn: myVar.CSHorns[oct])
            }else if(inst == 3){
                curPlayer[noteNum] = setUpPlayback (fn: myVar.CSSynth1[oct])
            }else if(inst == 4){
                curPlayer[noteNum] = setUpPlayback (fn: myVar.CSSynth2[oct])
            }else if(inst == 5){
                curPlayer[noteNum] = setUpPlayback (fn: myVar.CSPad1[oct])
            }else if(inst == 6){
                curPlayer[noteNum] = setUpPlayback (fn: myVar.CSPad2[oct])
            }
        operationQueue.addOperation{
                self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
                curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
                self.playFile(player: curPlayer[noteNum])
            }
    }
    @IBAction func playD(_ sender: Any) {
        noteNum = 2
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.D[oct])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DStrings[oct])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DHorns[oct])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DSynth1[oct])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DSynth2[oct])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DPad1[oct])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DPad2[oct])
        }
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
    }
    @IBAction func playEF(_ sender: Any) {
        noteNum = 3
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DS[oct])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DSStrings[oct])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DSHorns[oct])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DSSynth1[oct])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DSSynth2[oct])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DSPad1[oct])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.DSPad2[oct])
        }
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
    }
    @IBAction func playE(_ sender: Any) {
        noteNum = 4
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.E[oct])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.EStrings[oct])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.EHorns[oct])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.ESynth1[oct])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.ESynth2[oct])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.EPad1[oct])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.EPad2[oct])
        }
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
    }
    @IBAction func playF(_ sender: Any) {
        noteNum = 5
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.F[oct])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FStrings[oct])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FHorns[oct])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FSynth1[oct])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FSynth2[oct])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FPad1[oct])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FPad2[oct])
        }
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
    }
    @IBAction func playFS(_ sender: Any) {
        noteNum = 6
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FS[oct])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FSStrings[oct])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FSHorns[oct])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FSSynth1[oct])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FSSynth2[oct])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FSPad1[oct])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.FSPad2[oct])
        }
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
    }
    @IBAction func playG(_ sender: Any) {
        noteNum = 7
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.G[oct])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GStrings[oct])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GHorns[oct])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GSynth1[oct])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GSynth2[oct])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GPad1[oct])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GPad2[oct])
        }
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
    }
    @IBAction func playGS(_ sender: Any) {
        noteNum = 8
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GS[oct])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GSStrings[oct])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GSHorns[oct])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GSSynth1[oct])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GSSynth2[oct])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GSPad1[oct])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.GSPad2[oct])
        }
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
    }
    @IBAction func playA(_ sender: Any) {
        noteNum = 9
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.A[oct])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.AStrings[oct])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.AHorns[oct])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.ASynth1[oct])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.ASynth2[oct])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.APad1[oct])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.APad2[oct])
        }
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
    }
    @IBAction func playAS(_ sender: Any) {
        noteNum = 10
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.AS[oct])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.ASStrings[oct])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.ASHorns[oct])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.ASSynth1[oct])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.ASSynth2[oct])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.ASPad1[oct])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.ASPad2[oct])
        }
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
    }
    @IBAction func playB(_ sender: Any) {
        noteNum = 11
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.B[oct])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.BStrings[oct])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.BHorns[oct])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.BSynth1[oct])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.BSynth2[oct])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.BPad1[oct])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.BPad2[oct])
        }
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
    }
    @IBAction func playCH(_ sender: Any) {
        noteNum = 12
        if(inst == 0){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.C[oct + 1])
        }
        else if(inst == 1){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CStrings[oct + 1])
        }else if(inst == 2){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CHorns[oct + 1])
        }else if(inst == 3){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CSynth1[oct + 1])
        }else if(inst == 4){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CSynth2[oct + 1])
        }else if(inst == 5){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CPad1[oct + 1])
        }else if(inst == 6){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.CPad2[oct + 1])
        }
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
    }
    
}
