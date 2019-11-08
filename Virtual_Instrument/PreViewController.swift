//
//  PreViewController.swift
//  Virtual_Instrument
//
//  Created by Sean on 11/1/19.
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
var loop = false

let operationQueue: OperationQueue = OperationQueue()

var myVar = vari()
var noteNum = 0
var oct = 2
var inst = 0
var doubleTap = false

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
var curPlayer2 = playerStruct(engine: mainEngine, playerNode: mainPlayer, mixerNode: mainMixer, reverbNode: mainVerb, delayNode: mainDelay, eqNode: mainEQ)
var testPlayer = [outputStruct]()

func testPlayerSetup(){
    for n in 0...12 {
        testPlayer.append(outputStruct(engine: testEngine, playerNode: testP, mixerNode: testMix))
    }
}
