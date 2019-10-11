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
    
    struct outputStruct{
        var engine: AVAudioEngine = AVAudioEngine()
        var mixerNode: AVAudioMixerNode = AVAudioMixerNode()
        
        init(engine: AVAudioEngine, mixerNode: AVAudioMixerNode){
            self.engine = engine
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
    
    func startRecording(output: AVAudioEngine) {
        //recordingEngine.attach(output.mainMixerNode)
        //recordingEngine.connect(output.mainMixerNode, to: recordingEngine.inputNode, format: nil)
        let bus = 0
        let inputFormat = recordingEngine.inputNode.inputFormat(forBus: bus)
                
        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("out.caf")
        print("writing to \(outputURL)")

        outputFile = try! AVAudioFile(forWriting: outputURL, settings: inputFormat.settings, commonFormat: inputFormat.commonFormat, interleaved: inputFormat.isInterleaved)
        
        recordingEngine.inputNode.installTap(onBus: bus, bufferSize: 512, format: inputFormat) { (buffer, time) in
            try! self.outputFile?.write(from: buffer)
        }

        try! recordingEngine.start()
    }
    
    func stopRecording() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            print("Recording Finished")
            self.recordingEngine.stop()
            self.outputFile = nil
        }
    }
    
}
