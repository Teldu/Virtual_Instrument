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
var reverbStatus: Bool = false
var delayStatus: Bool = false
var eqStatus: Bool = false
var noteNum = 0
var oct = 2
var inst = 0

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
                midiVal = Int(attr.value as! UInt8 + 7)
            } else if (i == 1) {
                print(attr.value as! UInt8 / 2)
            } else {
                print(attr.value as! UInt8)
            }
            // print(i)
            dumpStr += String(format:"$%02X ", attr.value as! UInt8)
            i -= 1
            if (i <= 0)
            {
                break
            }
        }

        if(midiVal%12 == 0){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.C[midiVal-2])
        }
        else if(midiVal%12 == 1){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.Db[midiVal-2])
        }
        else if(midiVal%12 == 2){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.D[midiVal-2])
        }
        else if(midiVal%12 == 3){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.Eb[midiVal-2])
        }
        else if(midiVal%12 == 4){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.E[midiVal-2])
        }
        else if(midiVal%12 == 5){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.F[midiVal-2])
        }
        else if(midiVal%12 == 6){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.Gb[midiVal-2])
        }
        else if(midiVal%12 == 7){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.G[midiVal-2])
        }
        else if(midiVal%12 == 8){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.Ab[midiVal-2])
        }
        else if(midiVal%12 == 9){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.A[midiVal-2])
        }
        else if(midiVal%12 == 10){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.Bb[midiVal-2])
        }
        else if(midiVal%12 == 11){
            midiVal/=12
            testPlayer = setUpPlaybacks (fn: myVar.B[midiVal-2])
        }
        playFiles(player: testPlayer)
        // print(dumpStr)
        packet = MIDIPacketNext(&packet).pointee
    }
}

