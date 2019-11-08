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
    
    func loop(player : playerStruct, outLocation: String){
        do{
            try player.engine.start()
            player.playerNode.play()
            let url = URL(fileURLWithPath: outLocation)
            let file = try AVAudioFile(forReading: url)
            let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: file.fileFormat, frameCapacity: AVAudioFrameCount(file.length))
            player.playerNode.scheduleBuffer(audioFileBuffer!, at: nil, options:.loops, completionHandler: nil)
        }catch{
            print("Failed to start engine: \(error.localizedDescription)")
        }

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

func MyMIDIReadProc(pktList: UnsafePointer<MIDIPacketList>,
                    readProcRefCon: UnsafeMutableRawPointer?, srcConnRefCon: UnsafeMutableRawPointer?) -> Void
{
    if(doubleTap == true){
        doubleTap = false
    }
    else{doubleTap = true}
    if(doubleTap == true){
        let packetList:MIDIPacketList = pktList.pointee
        let srcRef:MIDIEndpointRef = srcConnRefCon!.load(as: MIDIEndpointRef.self)
        
        // print("MIDI Received From Source: \(getDisplayName(srcRef))")
        
        var packet:MIDIPacket = packetList.packet
        operationQueue.addOperation {
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

                   if(midiVal%12 == 0 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 0
                       if(midiVal-2 >= 0){
                           if(inst == 0){
                               testPlayer[noteNum] = setUpPlaybacks (fn: myVar.C[midiVal-2])
                           }
                           else if(inst == 1){
                               testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CStrings[midiVal-2])
                           }else if(inst == 2){
                               testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CHorns[midiVal-2])
                           }else if(inst == 3){
                               testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CSynth1[midiVal-2])
                           }else if(inst == 4){
                               testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CSynth2[midiVal-2])
                           }else if(inst == 5){
                               testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CPad1[midiVal-2])
                           }else if(inst == 6){
                               testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CPad2[midiVal-2])
                           }
                       }
                   }
                   else if(midiVal%12 == 1 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 1
                           if(midiVal-2 >= 0){
                               if(inst == 0){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CS[midiVal-2])
                               }
                               else if(inst == 1){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CSStrings[midiVal-2])
                               }else if(inst == 2){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CSHorns[midiVal-2])
                               }else if(inst == 3){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CSSynth1[midiVal-2])
                               }else if(inst == 4){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CSSynth2[midiVal-2])
                               }else if(inst == 5){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CSPad1[midiVal-2])
                               }else if(inst == 6){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.CSPad2[midiVal-2])
                               }
                           }
                       
                   }
                   else if(midiVal%12 == 2 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 2
                           if(midiVal-2 >= 0){
                               if(inst == 0){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DS[midiVal-2])
                               }
                               else if(inst == 1){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DStrings[midiVal-2])
                               }else if(inst == 2){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DHorns[midiVal-2])
                               }else if(inst == 3){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DSynth1[midiVal-2])
                               }else if(inst == 4){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DSynth2[midiVal-2])
                               }else if(inst == 5){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DPad1[midiVal-2])
                               }else if(inst == 6){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 3 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 3
                            if(midiVal-2 >= 0){
                               if(inst == 0){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DS[midiVal-2])
                               }
                               else if(inst == 1){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DSStrings[midiVal-2])
                               }else if(inst == 2){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DSHorns[midiVal-2])
                               }else if(inst == 3){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DSSynth1[midiVal-2])
                               }else if(inst == 4){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DSSynth2[midiVal-2])
                               }else if(inst == 5){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DSPad1[midiVal-2])
                               }else if(inst == 6){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.DSPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 4 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 4
                           if(midiVal-2 >= 0){
                               if(inst == 0){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.E[midiVal-2])
                               }
                               else if(inst == 1){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.EStrings[midiVal-2])
                               }else if(inst == 2){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.EHorns[midiVal-2])
                               }else if(inst == 3){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.ESynth1[midiVal-2])
                               }else if(inst == 4){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.ESynth2[midiVal-2])
                               }else if(inst == 5){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.EPad1[midiVal-2])
                               }else if(inst == 6){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.EPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 5 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 5
                           if(midiVal-2 >= 0){
                               if(inst == 0){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.F[midiVal-2])
                               }
                               else if(inst == 1){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FStrings[midiVal-2])
                               }else if(inst == 2){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FHorns[midiVal-2])
                               }else if(inst == 3){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FSynth1[midiVal-2])
                               }else if(inst == 4){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FSynth2[midiVal-2])
                               }else if(inst == 5){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FPad1[midiVal-2])
                               }else if(inst == 6){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 6 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 6
                           if(midiVal-2 >= 0){
                               if(inst == 0){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FS[midiVal-2])
                               }
                               else if(inst == 1){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FSStrings[midiVal-2])
                               }else if(inst == 2){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FSHorns[midiVal-2])
                               }else if(inst == 3){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FSSynth1[midiVal-2])
                               }else if(inst == 4){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FSSynth2[midiVal-2])
                               }else if(inst == 5){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FSPad1[midiVal-2])
                               }else if(inst == 6){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.FSPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 7 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 7
                           if(midiVal-2 >= 0){
                               if(inst == 0){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.G[midiVal-2])
                               }
                               else if(inst == 1){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GStrings[midiVal-2])
                               }else if(inst == 2){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GHorns[midiVal-2])
                               }else if(inst == 3){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GSynth1[midiVal-2])
                               }else if(inst == 4){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GSynth2[midiVal-2])
                               }else if(inst == 5){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GPad1[midiVal-2])
                               }else if(inst == 6){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 8 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 8
                           if(midiVal-2 >= 0){
                               if(inst == 0){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GS[midiVal-2])
                               }
                               else if(inst == 1){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GSStrings[midiVal-2])
                               }else if(inst == 2){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GSHorns[midiVal-2])
                               }else if(inst == 3){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GSSynth1[midiVal-2])
                               }else if(inst == 4){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GSSynth2[midiVal-2])
                               }else if(inst == 5){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GSPad1[midiVal-2])
                               }else if(inst == 6){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.GSPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 9 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 9
                           if(midiVal-2 >= 0){
                               if(inst == 0){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.A[midiVal-2])
                               }
                               else if(inst == 1){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.AStrings[midiVal-2])
                               }else if(inst == 2){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.AHorns[midiVal-2])
                               }else if(inst == 3){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.ASynth1[midiVal-2])
                               }else if(inst == 4){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.ASynth2[midiVal-2])
                               }else if(inst == 5){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.APad1[midiVal-2])
                               }else if(inst == 6){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.APad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 10 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 10
                           if(midiVal-2 >= 0){
                               if(inst == 0){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.AS[midiVal-2])
                               }
                               else if(inst == 1){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.ASStrings[midiVal-2])
                               }else if(inst == 2){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.ASHorns[midiVal-2])
                               }else if(inst == 3){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.ASSynth1[midiVal-2])
                               }else if(inst == 4){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.ASSynth2[midiVal-2])
                               }else if(inst == 5){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.ASPad1[midiVal-2])
                               }else if(inst == 6){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.ASPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 11 && (midiVal/12)-2 < 5){
                       midiVal/=12
                       noteNum = 11
                           if(midiVal-2 >= 0){
                               if(inst == 0){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.B[midiVal-2])
                               }
                               else if(inst == 1){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.BStrings[midiVal-2])
                               }else if(inst == 2){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.BHorns[midiVal-2])
                               }else if(inst == 3){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.BSynth1[midiVal-2])
                               }else if(inst == 4){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.BSynth2[midiVal-2])
                               }else if(inst == 5){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.BPad1[midiVal-2])
                               }else if(inst == 6){
                                   testPlayer[noteNum] = setUpPlaybacks (fn: myVar.BPad2[midiVal-2])
                               }
                           }
                   }
                   if(midiVal-2>=0){
                       playFiles(player: testPlayer[noteNum])
                   }
            }
            
            
            // print(dumpStr)
            packet = MIDIPacketNext(&packet).pointee
        }
    }
    
}
