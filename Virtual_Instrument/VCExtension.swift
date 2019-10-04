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
}
