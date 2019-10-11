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

struct playerStruct{
    var engine: AVAudioEngine = AVAudioEngine()
    var playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    var mixerNode: AVAudioMixerNode = AVAudioMixerNode()
    var delayNode = AVAudioUnitDelay()
    var reverbNode = AVAudioUnitReverb()
    var eqNode = AVAudioUnitEQ(numberOfBands: 3)
    
    init(engine: AVAudioEngine, playerNode: AVAudioPlayerNode, mixerNode: AVAudioMixerNode,
         reverbNode: AVAudioUnitReverb, delayNode: AVAudioUnitDelay, eqNode: AVAudioUnitEQ){
        self.engine = engine
        self.playerNode = playerNode
        self.reverbNode = reverbNode
        self.eqNode = eqNode
    }
}

struct outputStruct{
    var engine: AVAudioEngine = AVAudioEngine()
    var mixerNode: AVAudioMixerNode = AVAudioMixerNode()
    var playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    
    init(engine: AVAudioEngine, playerNode: AVAudioPlayerNode, mixerNode: AVAudioMixerNode){
        self.playerNode = playerNode
        self.engine = engine
    }
}


//Test Versions of VCExtension Functions
func playFiles(player: outputStruct){
    do{
        try player.engine.start()
        print("Engine started")
        player.playerNode.play()
        print("File played")
    }catch{
        print("Failed to start engine: \(error.localizedDescription)")
    }
}

func setUpPlaybacks(fn: String) -> outputStruct{
    let playerInstance = outputStruct(engine: AVAudioEngine(), playerNode: AVAudioPlayerNode(), mixerNode: AVAudioMixerNode())
    
    //Attach the nodes
    playerInstance.engine.attach(playerInstance.playerNode)
    playerInstance.engine.attach(playerInstance.mixerNode)
    
    //Connect the nodes
    playerInstance.engine.connect(playerInstance.playerNode, to: playerInstance.mixerNode, format: nil)
    playerInstance.engine.connect(playerInstance.mixerNode, to: playerInstance.engine.mainMixerNode, format: nil)
    
    //Prepare the engine
    playerInstance.engine.prepare()
    
    
    //schedule the file
    do{
        //local files
        let url = URL(fileURLWithPath: fn)
        let file = try AVAudioFile(forReading: url)
        playerInstance.playerNode.scheduleFile(file, at: nil, completionHandler: nil)
        print("Audio file scheduled")
        
    }catch{
        print("Failed to create file: \(error.localizedDescription)")
    }
    
    return playerInstance
    
    
}

let mainEngine: AVAudioEngine = AVAudioEngine()
let mainPlayer: AVAudioPlayerNode = AVAudioPlayerNode()
let mainEQ: AVAudioUnitEQ = AVAudioUnitEQ()
let mainVerb: AVAudioUnitReverb = AVAudioUnitReverb()
let mainDelay: AVAudioUnitDelay = AVAudioUnitDelay()
let mainMixer: AVAudioMixerNode = AVAudioMixerNode()
var midiVal = 0

private let operationQueue: OperationQueue = OperationQueue()

var myVar = vari()
var reverbStatus: Bool = false
var delayStatus: Bool = false
var eqStatus: Bool = false
var noteNum = 0
var oct = 2

var midiClient: MIDIClientRef = 0
var inPort:MIDIPortRef = 0
var src:MIDIEndpointRef = MIDIGetSource(0)

var outputFile: AVAudioFile? = nil

let ae: AVAudioEngine = AVAudioEngine()
let player: AVAudioPlayerNode = AVAudioPlayerNode()
let mixer: AVAudioMixerNode = AVAudioMixerNode()
var buffer:AVAudioPCMBuffer?

let testEngine: AVAudioEngine = AVAudioEngine()
let testP: AVAudioPlayerNode = AVAudioPlayerNode()
let testMix: AVAudioMixerNode = AVAudioMixerNode()
let testVerb: AVAudioUnitReverb = AVAudioUnitReverb()
let testDelay: AVAudioUnitDelay = AVAudioUnitDelay()
let testEQ: AVAudioUnitEQ = AVAudioUnitEQ()

var curPlayer = [playerStruct]()
var testPlayer = outputStruct(engine: testEngine, playerNode: testP, mixerNode: testMix)

func MyMIDIReadProc(pktList: UnsafePointer<MIDIPacketList>,
                    readProcRefCon: UnsafeMutableRawPointer?, srcConnRefCon: UnsafeMutableRawPointer?) -> Void
{
    let packetList:MIDIPacketList = pktList.pointee
    let srcRef:MIDIEndpointRef = srcConnRefCon!.load(as: MIDIEndpointRef.self)
    
    // print("MIDI Received From Source: \(getDisplayName(srcRef))")
    
    var packet:MIDIPacket = packetList.packet
    for _ in 1...packetList.numPackets
    {
        let bytes = Mirror(reflecting: packet.data).children
        var dumpStr = ""
        
        // bytes mirror contains all the zero values in the ridiulous packet data tuple
        // so use the packet length to iterate.
        // data2 data1 status
        var i = packet.length
        for (_, attr) in bytes.enumerated()
        {
            //: Look for the middle message in the packet and transpose it by 7 (P5)
            //: the packets seem to be read from back to front and numbered 1-3
            if (i == 2) {
                print(attr.value as! UInt8 + 7)
            } else if (i == 1) {
                print(attr.value as! UInt8 / 2)
            } else {
                print(attr.value as! UInt8)
                midiVal = Int(attr.value as! UInt8)
                testPlayer = setUpPlaybacks (fn: myVar.C[oct])
                playFiles(player: testPlayer)
            }
            // print(i)
            dumpStr += String(format:"$%02X ", attr.value as! UInt8)
            i -= 1
            if (i <= 0)
            {
                break
            }
        }
        
        // print(dumpStr)
        packet = MIDIPacketNext(&packet).pointee
    }
}

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
        
        //InstrumentMenu.addItem(withTitle: "Sawtooth Wave")
        //InstrumentMenu.addItem(withTitle: "Square Wave")
        //InstrumentMenu.addItem(withTitle: "Triangle Wave")
        ReverbMenu.addItem(withTitle: "Large")
        OctaveSelect.addItem(withTitle: "3")
        OctaveSelect.addItem(withTitle: "4")
        OctaveSelect.selectItem(at: 2)
        
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
        else if(OctaveSelect.selectedItem == OctaveSelect.item(withTitle: "4")){
            oct = 4
        }
    }
    
    //Volume/Pan Functions
    @IBAction func modVolume(_ sender: Any) {
        curPlayer[noteNum].mixerNode.outputVolume = volume.floatValue
    }
    @IBAction func modPan(_ sender: Any) {
        curPlayer[noteNum].mixerNode.pan = pan.floatValue * -1.0
    }
    
    
    @IBAction func recStart(_ sender: Any) {
        startRecording(output: mainEngine)
    }
    @IBAction func recStop(_ sender: Any) {
        stopRecording()
    }
    
    
    
    //Play Notes
    @IBAction func playC(_ sender: Any) {
        noteNum = 0
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.C[oct])
            operationQueue.addOperation{
                self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
                curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
                self.playFile(player: curPlayer[noteNum])
            }
            
        }
        
    }
    @IBAction func playCS(_ sender: Any) {
        noteNum = 1
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
            curPlayer[noteNum] = setUpPlayback (fn: myVar.Db[oct])
            operationQueue.addOperation{
                self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
                curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
                curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
                self.playFile(player: curPlayer[noteNum])
            }
        }
    }
    @IBAction func playD(_ sender: Any) {
        noteNum = 2
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[noteNum] = setUpPlayback (fn: myVar.D[oct])
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
        }
    }
    @IBAction func playEF(_ sender: Any) {
        noteNum = 3
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[noteNum] = setUpPlayback (fn: myVar.Eb[oct])
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
        }
    }
    @IBAction func playE(_ sender: Any) {
        noteNum = 4
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[noteNum] = setUpPlayback (fn: myVar.E[oct])
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
        }
    }
    @IBAction func playF(_ sender: Any) {
        noteNum = 5
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[noteNum] = setUpPlayback (fn: myVar.F[oct])
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
        }
    }
    @IBAction func playFS(_ sender: Any) {
        noteNum = 6
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[noteNum] = setUpPlayback (fn: myVar.Gb[oct])
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
        }
    }
    @IBAction func playG(_ sender: Any) {
        noteNum = 7
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[noteNum] = setUpPlayback (fn: myVar.G[oct])
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
        }
    }
    @IBAction func playGS(_ sender: Any) {
        noteNum = 8
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[noteNum] = setUpPlayback (fn: myVar.Ab[oct])
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
        }
    }
    @IBAction func playA(_ sender: Any) {
        noteNum = 9
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[noteNum] = setUpPlayback (fn: myVar.A[oct])
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }        }
    }
    @IBAction func playAS(_ sender: Any) {
        noteNum = 10
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[noteNum] = setUpPlayback (fn: myVar.Bb[oct])
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
        }
    }
    @IBAction func playB(_ sender: Any) {
        noteNum = 11
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[noteNum] = setUpPlayback (fn: myVar.B[oct])
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
        }
    }
    @IBAction func playCH(_ sender: Any) {
        noteNum = 12
        if(InstrumentMenu.selectedItem == InstrumentMenu.item(withTitle: "Piano")){
        curPlayer[noteNum] = setUpPlayback (fn: myVar.C[oct + 1])
        operationQueue.addOperation{
            self.eqSetup(player: curPlayer[noteNum], freq1: self.EQFreq1.floatValue, freq2: self.EQFreq2.floatValue, freq3: self.EQFreq3.floatValue, bw1: self.EQBand1.floatValue, bw2: self.EQBand2.floatValue, bw3: self.EQBand3.floatValue, g1: self.EQGain1.floatValue, g2: self.EQGain2.floatValue, g3: self.EQGain3.floatValue)
            curPlayer[noteNum].mixerNode.outputVolume = self.volume.floatValue
            curPlayer[noteNum].mixerNode.pan = self.pan.floatValue * -1.0
            self.playFile(player: curPlayer[noteNum])
        }
        }
    }
    
}
