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

    
}

func MyMIDIReadProc(pktList: UnsafePointer<MIDIPacketList>,
                    readProcRefCon: UnsafeMutableRawPointer?, srcConnRefCon: UnsafeMutableRawPointer?) -> Void
{
        let packetList:MIDIPacketList = pktList.pointee
        let srcRef:MIDIEndpointRef = srcConnRefCon!.load(as: MIDIEndpointRef.self)
            
    if(doubleTap == false){
        doubleTap = true
    }
    else if(doubleTap == true){
        doubleTap = false
    }
    
        // print("MIDI Received From Source: \(getDisplayName(srcRef))")
        
    if(doubleTap == false){
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

                   if(midiVal%12 == 0 && (midiVal/12)-3 <= 4 && (midiVal/12)-3 >= 0){
                       midiVal/=12
                       noteNum = 0
                       if(midiVal-3 >= 0 && midiVal-3 <= 4){
                        midiVal2 = midiVal-3
                           if(inst == 0){
                            curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.F[midiVal-3])
                           }
                           else if(inst == 1){
                               curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FStrings[midiVal-3])
                           }else if(inst == 2){
                               curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FHorns[midiVal-3])
                           }else if(inst == 3){
                               curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FSynth1[midiVal-3])
                           }else if(inst == 4){
                               curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FSynth2[midiVal-3])
                           }else if(inst == 5){
                               curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FPad1[midiVal-3])
                           }else if(inst == 6){
                               curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FPad2[midiVal-3])
                           }
                       }
                   }
                   else if(midiVal%12 == 1 && (midiVal/12)-3 <= 4 && (midiVal/12)-3 >= 0){
                       midiVal/=12
                       noteNum = 1
                           if(midiVal-3 >= 0 && midiVal-3 <= 4){
                            midiVal2 = midiVal-3
                               if(inst == 0){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FS[midiVal-3])
                               }
                               else if(inst == 1){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FSStrings[midiVal-3])
                               }else if(inst == 2){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FSHorns[midiVal-3])
                               }else if(inst == 3){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FSSynth1[midiVal-3])
                               }else if(inst == 4){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FSSynth2[midiVal-3])
                               }else if(inst == 5){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FSPad1[midiVal-3])
                               }else if(inst == 6){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.FSPad2[midiVal-3])
                               }
                           }
                       
                   }
                   else if(midiVal%12 == 2 && (midiVal/12)-3 <= 4 && (midiVal/12)-3 >= 0){
                       midiVal/=12
                       noteNum = 2
                           if(midiVal-3 >= 0 && midiVal-3 <= 4){
                            midiVal2 = midiVal-3
                               if(inst == 0){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.G[midiVal-3])
                               }
                               else if(inst == 1){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GStrings[midiVal-3])
                               }else if(inst == 2){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GHorns[midiVal-3])
                               }else if(inst == 3){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GSynth1[midiVal-3])
                               }else if(inst == 4){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GSynth2[midiVal-3])
                               }else if(inst == 5){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GPad1[midiVal-3])
                               }else if(inst == 6){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GPad2[midiVal-3])
                               }
                           }
                   }
                   else if(midiVal%12 == 3 && (midiVal/12)-3 <= 4 && (midiVal/12)-3 >= 0){
                       midiVal/=12
                       noteNum = 3
                            if(midiVal-3 >= 0 && midiVal-3 <= 4){
                            midiVal2 = midiVal-3
                               if(inst == 0){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GS[midiVal-3])
                               }
                               else if(inst == 1){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GSStrings[midiVal-3])
                               }else if(inst == 2){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GSHorns[midiVal-3])
                               }else if(inst == 3){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GSSynth1[midiVal-3])
                               }else if(inst == 4){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GSSynth2[midiVal-3])
                               }else if(inst == 5){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GSPad1[midiVal-3])
                               }else if(inst == 6){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.GSPad2[midiVal-3])
                               }
                           }
                   }
                   else if(midiVal%12 == 4 && (midiVal/12)-3 <= 4 && (midiVal/12)-3 >= 0){
                       midiVal/=12
                       noteNum = 4
                           if(midiVal-3 >= 0 && midiVal-3 <= 4){
                            midiVal2 = midiVal-3
                               if(inst == 0){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.A[midiVal-3])
                               }
                               else if(inst == 1){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.AStrings[midiVal-3])
                               }else if(inst == 2){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.AHorns[midiVal-3])
                               }else if(inst == 3){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.ASynth1[midiVal-3])
                               }else if(inst == 4){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.ASynth2[midiVal-3])
                               }else if(inst == 5){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.APad1[midiVal-3])
                               }else if(inst == 6){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.APad2[midiVal-3])
                               }
                           }
                   }
                   else if(midiVal%12 == 5 && (midiVal/12)-3 <= 4 && (midiVal/12)-3 >= 0){
                       midiVal/=12
                       noteNum = 5
                           if(midiVal-3 >= 0 && midiVal-3 <= 4){
                            midiVal2 = midiVal-3
                               if(inst == 0){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.AS[midiVal-3])
                               }
                               else if(inst == 1){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.ASStrings[midiVal-3])
                               }else if(inst == 2){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.ASHorns[midiVal-3])
                               }else if(inst == 3){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.ASSynth1[midiVal-3])
                               }else if(inst == 4){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.ASSynth2[midiVal-3])
                               }else if(inst == 5){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.ASPad1[midiVal-3])
                               }else if(inst == 6){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.ASPad2[midiVal-3])
                               }
                           }
                   }
                   else if(midiVal%12 == 6 && (midiVal/12)-3 <= 4 && (midiVal/12)-3 >= 0){
                       midiVal/=12
                       noteNum = 6
                           if(midiVal-3 >= 0 && midiVal-3 <= 4){
                            midiVal2 = midiVal-3
                               if(inst == 0){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.B[midiVal-3])
                               }
                               else if(inst == 1){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.BStrings[midiVal-3])
                               }else if(inst == 2){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.BHorns[midiVal-3])
                               }else if(inst == 3){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.BSynth1[midiVal-3])
                               }else if(inst == 4){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.BSynth2[midiVal-3])
                               }else if(inst == 5){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.BPad1[midiVal-3])
                               }else if(inst == 6){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.BPad2[midiVal-3])
                               }
                           }
                   }
                   else if(midiVal%12 == 7 && (midiVal/12)-2 <= 4 && (midiVal/12)-2 >= 0){
                       midiVal/=12
                       noteNum = 7
                           if(midiVal-2 >= 0 && midiVal-2 <= 4){
                            midiVal2 = midiVal-2
                               if(inst == 0){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.C[midiVal-2])
                               }
                               else if(inst == 1){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CStrings[midiVal-2])
                               }else if(inst == 2){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CHorns[midiVal-2])
                               }else if(inst == 3){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CSynth1[midiVal-2])
                               }else if(inst == 4){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CSynth2[midiVal-2])
                               }else if(inst == 5){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CPad1[midiVal-2])
                               }else if(inst == 6){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 8 && (midiVal/12)-2 <= 4 && (midiVal/12)-2 >= 0){
                       midiVal/=12
                       noteNum = 8
                           if(midiVal-2 >= 0 && midiVal-2 <= 4){
                            midiVal2 = midiVal-2
                               if(inst == 0){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CS[midiVal-2])
                               }
                               else if(inst == 1){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CSStrings[midiVal-2])
                               }else if(inst == 2){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CSHorns[midiVal-2])
                               }else if(inst == 3){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CSSynth1[midiVal-2])
                               }else if(inst == 4){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CSSynth2[midiVal-2])
                               }else if(inst == 5){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CSPad1[midiVal-2])
                               }else if(inst == 6){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.CSPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 9 && (midiVal/12)-2 <= 4 && (midiVal/12)-2 >= 0){
                       midiVal/=12
                       noteNum = 9
                           if(midiVal-2 >= 0 && midiVal-2 <= 4){
                            midiVal2 = midiVal-2
                               if(inst == 0){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.D[midiVal-2])
                               }
                               else if(inst == 1){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DStrings[midiVal-2])
                               }else if(inst == 2){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DHorns[midiVal-2])
                               }else if(inst == 3){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DSynth1[midiVal-2])
                               }else if(inst == 4){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DSynth2[midiVal-2])
                               }else if(inst == 5){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DPad1[midiVal-2])
                               }else if(inst == 6){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 10 && (midiVal/12)-2 <= 4 && (midiVal/12)-2 >= 0){
                       midiVal/=12
                       noteNum = 10
                           if(midiVal-2 >= 0 && midiVal-2 <= 4){
                            midiVal2 = midiVal-2
                               if(inst == 0){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DS[midiVal-2])
                               }
                               else if(inst == 1){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DSStrings[midiVal-2])
                               }else if(inst == 2){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DSHorns[midiVal-2])
                               }else if(inst == 3){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DSSynth1[midiVal-2])
                               }else if(inst == 4){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DSSynth2[midiVal-2])
                               }else if(inst == 5){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DSPad1[midiVal-2])
                               }else if(inst == 6){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.DSPad2[midiVal-2])
                               }
                           }
                   }
                   else if(midiVal%12 == 11 && (midiVal/12)-2 <= 4 && (midiVal/12)-2 >= 0){
                       midiVal/=12
                       noteNum = 11
                           if(midiVal-2 >= 0 && midiVal-2 <= 4){
                            midiVal2 = midiVal-2
                               if(inst == 0){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.E[midiVal-2])
                               }
                               else if(inst == 1){
                                curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.EStrings[midiVal-2])
                               }else if(inst == 2){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.EHorns[midiVal-2])
                               }else if(inst == 3){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.ESynth1[midiVal-2])
                               }else if(inst == 4){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.ESynth2[midiVal-2])
                               }else if(inst == 5){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.EPad1[midiVal-2])
                               }else if(inst == 6){
                                   curPlayer[noteNum] = setUpPlayback (DT:delTime, FB: delFB, dWetDry: delRatio, rWetDry: reverbRatio,fn: myVar.EPad2[midiVal-2])
                               }
                           }
                   }
                   if(midiVal2 >= 0 && midiVal2 <= 4){
                    if(isRecording == true){
                        startRecording(eng: curPlayer[noteNum].engine)
                        setTemp(eng: curPlayer[noteNum].engine)
                    }
                    curPlayer[noteNum].mixerNode.outputVolume = vol
                    curPlayer[noteNum].mixerNode.pan = LR * -1.0
                    eqSetup(player: curPlayer[noteNum], freq1: f1, freq2: f2, freq3: f3, bw1: bw1, bw2: bw2, bw3: bw3, g1: g1, g2: g2, g3: g3)
                    playFile(player: curPlayer[noteNum])
                   }
                   else{
                    print("Out of bounds")
                }
            }
            
            // print(dumpStr)
            packet = MIDIPacketNext(&packet).pointee
        }
}
