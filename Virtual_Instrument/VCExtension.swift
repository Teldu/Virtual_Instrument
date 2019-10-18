//
//  VCExtension.swift
//  Virtual_Instrument
//
//  Created by Sean on 8/16/19.
//  Copyright © 2019 Sean. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation
import AudioToolbox

extension ViewController{
    
    func setUpPlayback(fn: String) -> playerStruct{
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
        playerInstance.delayNode.delayTime = TimeInterval(DelayTime.floatValue)
        playerInstance.delayNode.feedback = DelayFeedback.floatValue
        playerInstance.delayNode.wetDryMix = DelayRatio.floatValue
        playerInstance.reverbNode.wetDryMix = ReverbRatio.floatValue
        
        //Reverb Type Setup
        if(ReverbMenu.selectedItem == ReverbMenu.item(withTitle: "Small")){
            playerInstance.reverbNode.loadFactoryPreset(AVAudioUnitReverbPreset.smallRoom)
        }
        else if(ReverbMenu.selectedItem == ReverbMenu.item(withTitle: "Medium")){
            playerInstance.reverbNode.loadFactoryPreset(AVAudioUnitReverbPreset.mediumRoom)
        }
        else if(ReverbMenu.selectedItem == ReverbMenu.item(withTitle: "Large")){
            playerInstance.reverbNode.loadFactoryPreset(AVAudioUnitReverbPreset.largeHall)
        }
        
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
    
    func getDisplayName(_ obj: MIDIObjectRef) -> String
    {
        var param: Unmanaged<CFString>?
        var name: String = "Error"
        
        let err: OSStatus = MIDIObjectGetStringProperty(obj, kMIDIPropertyDisplayName, &param)
        if err == OSStatus(noErr)
        {
            name =  param!.takeRetainedValue() as String
        }
        
        return name
    }

    
    func startRecording(output: AVAudioEngine) {
        //recordingEngine.attach(output.mainMixerNode)
        //recordingEngine.connect(output.mainMixerNode, to: recordingEngine.inputNode, format: nil)
        let bus = 0
        let inputFormat = curPlayer2.engine.mainMixerNode.outputFormat(forBus: bus)
                
        let urlstring = NSHomeDirectory() + "/Desktop/Virtual_Instrument/Recordings/out.wav"
        let outputURL = NSURL(string: urlstring)
        print("writing to \(String(describing: outputURL))")

        outputFile = try! AVAudioFile(forWriting: outputURL as! URL, settings: inputFormat.settings, commonFormat: inputFormat.commonFormat, interleaved: inputFormat.isInterleaved)
        
        curPlayer2.engine.mainMixerNode.installTap(onBus: bus, bufferSize: 512, format: inputFormat) { (buffer, time) in
            try! outputFile?.write(from: buffer)
        }

        try! curPlayer2.engine.start()
    }
    
    func stopRecording() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            curPlayer2.engine.stop()
            curPlayer2.engine.mainMixerNode.removeTap(onBus: 0)
            print("Recording Finished")
            outputFile = nil
        }
    }
    
}
