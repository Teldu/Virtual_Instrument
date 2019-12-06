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

let mainEngine: AVAudioEngine = AVAudioEngine()
let mainPlayer: AVAudioPlayerNode = AVAudioPlayerNode()
let mainEQ: AVAudioUnitEQ = AVAudioUnitEQ()
let mainVerb: AVAudioUnitReverb = AVAudioUnitReverb()
let mainDelay: AVAudioUnitDelay = AVAudioUnitDelay()
let mainMixer: AVAudioMixerNode = AVAudioMixerNode()
var midiVal = 0
var midiVal2 = 0


let operationQueue: OperationQueue = OperationQueue()

var myVar = vari()
var noteNum = 0
var oct = 2
var inst = 0

//checks if finger is pressing down or lifting off the key
var doubleTap = true

//checks if same note is being played twice in a row
var doubleTap2 = [Bool]()
var counter = 0

var midiClient: MIDIClientRef = 0
var inPort:MIDIPortRef = 0
var src:MIDIEndpointRef = MIDIGetSource(0)


var outputFile: AVAudioFile? = nil

let ae: AVAudioEngine = AVAudioEngine()
let player: AVAudioPlayerNode = AVAudioPlayerNode()
let mixer: AVAudioMixerNode = AVAudioMixerNode()
var buffer:AVAudioPCMBuffer?

var tempEngine = AVAudioEngine()

var isRecording = false


//effects values for MIDI
var delTime: Float = 0.0
var delRatio: Float = 50.0
var delFB: Float = 0.0
var reverbRatio: Float = 0.0
var vol : Float = 0.5
var LR : Float = 0.0

//EQ values for MIDI
var f1: Float = 100.0
var f2: Float = 500.0
var f3: Float = 2000.0
var bw1: Float = 1.0
var bw2: Float = 1.0
var bw3: Float = 1.0
var g1: Float = 0.0
var g2: Float = 0.0
var g3: Float = 0.0


var urlString = [String]()
var urlArray = [NSURL]()
var outNum = 0
var curPlayer = [playerStruct]()
var curPlayerRec = playerStruct(engine: mainEngine, playerNode: mainPlayer, mixerNode: mainMixer, reverbNode: mainVerb, delayNode: mainDelay, eqNode: mainEQ)


func setUpPlayback(DT: (Float),FB: (Float),dWetDry: (Float),rWetDry: (Float),fn: String) -> playerStruct{
    let playerInstance = playerStruct(engine: AVAudioEngine(), playerNode: AVAudioPlayerNode(), mixerNode: AVAudioMixerNode(), reverbNode: AVAudioUnitReverb(), delayNode: AVAudioUnitDelay(), eqNode: AVAudioUnitEQ())
    
    //Attach the nodes
    playerInstance.engine.attach(playerInstance.playerNode)
    playerInstance.engine.attach(playerInstance.mixerNode)
    playerInstance.engine.attach(playerInstance.delayNode)
    playerInstance.engine.attach(playerInstance.reverbNode)
    playerInstance.engine.attach(playerInstance.eqNode)
    
    //Connect the nodes
    playerInstance.engine.connect(playerInstance.playerNode, to: playerInstance.eqNode, format: nil)
    playerInstance.engine.connect(playerInstance.eqNode, to: playerInstance.delayNode, format: nil)
    playerInstance.engine.connect(playerInstance.delayNode, to: playerInstance.reverbNode, format: nil)
    playerInstance.engine.connect(playerInstance.reverbNode, to: playerInstance.mixerNode, format: nil)
    playerInstance.engine.connect(playerInstance.mixerNode, to: playerInstance.engine.mainMixerNode, format: nil)
    
    //Set mixer volume to default
    //playerInstance.mixerNode.outputVolume = horizontalSlider.floatValue
    
    //Set delay and reverb parameters
    playerInstance.delayNode.delayTime = TimeInterval(DT)
    playerInstance.delayNode.feedback = FB
    playerInstance.delayNode.wetDryMix = dWetDry
    playerInstance.reverbNode.wetDryMix = rWetDry
    
    //Reverb Type Setup
    playerInstance.reverbNode.loadFactoryPreset(AVAudioUnitReverbPreset.mediumRoom)
    
    playerInstance.eqNode.bands[0].bypass = false
    playerInstance.eqNode.bands[1].bypass = false
    playerInstance.eqNode.bands[2].bypass = false
    
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

func eqSetup(player: playerStruct, freq1: Float, freq2: Float, freq3: Float, bw1: Float, bw2: Float, bw3: Float, g1: Float, g2: Float, g3: Float){
    player.eqNode.bands[0].frequency = freq1
    player.eqNode.bands[1].frequency = freq2
    player.eqNode.bands[2].frequency = freq3
    
    player.eqNode.bands[0].bandwidth = bw1
    player.eqNode.bands[1].bandwidth = bw2
    player.eqNode.bands[2].bandwidth = bw3
    
    player.eqNode.bands[0].gain = g1
    player.eqNode.bands[1].gain = g2
    player.eqNode.bands[2].gain = g3
    
    player.eqNode.bands[0].bypass = false
    player.eqNode.bands[1].bypass = false
    player.eqNode.bands[2].bypass = false
}

func playFile(player: playerStruct){
    do{
        try player.engine.start()
        print("Engine started")
        player.playerNode.play()
        print("File played")
    }catch{
        print("Failed to start engine: \(error.localizedDescription)")
    }
}
func stopPlayback(player: playerStruct){
    player.playerNode.stop()
}
func pausePlayback(player: playerStruct){
    player.playerNode.pause()
}


func setTemp(eng: AVAudioEngine){
    tempEngine = eng
}

func startRecording(eng: AVAudioEngine) {
    
    tempEngine.mainMixerNode.removeTap(onBus: 0)
    
    let bus = 0
    let inputFormat = eng.mainMixerNode.outputFormat(forBus: bus)
    
    urlString.append(NSHomeDirectory() + "/Desktop/Virtual_Instrument/Recordings/Temporary/out" + String(outNum) + ".wav")
    let outputURL = NSURL(string: urlString[outNum])
    //print("writing to \(String(describing: outputURL))")

    outNum+=1
    
    outputFile = try! AVAudioFile(forWriting: outputURL as! URL, settings: inputFormat.settings, commonFormat: inputFormat.commonFormat, interleaved: inputFormat.isInterleaved)
    
    eng.mainMixerNode.installTap(onBus: bus, bufferSize: 8192, format: inputFormat) { (buffer, time) in
        try! outputFile?.write(from: buffer)
    }

    try! eng.start()
}
let CTemp = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C5.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Silence.wav"]
func stopRecording(eng: AVAudioEngine) {
    DispatchQueue.main.asyncAfter(deadline: .now()) {
        eng.stop()
        eng.mainMixerNode.removeTap(onBus: 0)
        outputFile = nil
    }

}

func mergeAfterStop(){
    outNum-=1
    
    for n in 0...outNum{
        urlArray.append(NSURL(fileURLWithPath: urlString[n]))
    }
    mergeAudioFiles(audioFileUrls: urlArray as NSArray)

    urlString.removeAll()
    urlArray.removeAll()
    outNum = 0
}

var mergeAudioURL = NSURL()

func mergeAudioFiles(audioFileUrls: NSArray) {
    let composition = AVMutableComposition()

    for i in 0 ..< audioFileUrls.count {

        let compositionAudioTrack :AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!

        let asset = AVURLAsset(url: (audioFileUrls[i] as! NSURL) as URL)

        let track = asset.tracks(withMediaType: AVMediaType.audio)[0]

        let timeRange = CMTimeRange(start: CMTimeMake(value: 0, timescale: 600), duration: track.timeRange.duration)

        try! compositionAudioTrack.insertTimeRange(timeRange, of: track, at: composition.duration)
    }

    let documentDirectoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first! as NSURL
    mergeAudioURL = documentDirectoryURL.appendingPathComponent("Out.m4a")! as URL as NSURL

    let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
    assetExport?.outputFileType = AVFileType.m4a
    assetExport?.outputURL = mergeAudioURL as URL
    assetExport?.exportAsynchronously(completionHandler:
        {
            switch assetExport!.status
            {
            case AVAssetExportSessionStatus.failed:
                print("failed \(String(describing: assetExport?.error))")
            case AVAssetExportSessionStatus.cancelled:
                print("cancelled \(String(describing: assetExport?.error))")
            case AVAssetExportSessionStatus.unknown:
                print("unknown\(String(describing: assetExport?.error))")
            case AVAssetExportSessionStatus.waiting:
                print("waiting\(String(describing: assetExport?.error))")
            case AVAssetExportSessionStatus.exporting:
                print("exporting\(String(describing: assetExport?.error))")
            default:
                print("Audio Concatenation Complete")
            }
    })
}
