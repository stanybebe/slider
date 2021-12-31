<Cabbage> bounds(0, 0, 0, 0)
form caption("slider") size(400, 400), guiMode("queue")bundle("/resources") pluginId("slid")


image bounds(0, 0, 400, 400) channel("image1"), file("resources/bg3.png") 
vslider bounds(92, 108, 220, 280) channel("wd") range(0, 1, 0.662, 1, 0.001)  filmstrip("resources/slider.png", 30)popupText(0)
rslider bounds(284, 302, 100, 100), channel("gain"),, range(0, 1, 0.41, 1, 0.01), filmstrip("resources/knob.png", 30)popupText(0)
rslider bounds(290, 18, 70, 70) channel("wdDel") range(0, 1, 0.5, 1, 0.001)filmstrip("resources/knob.png", 30)popupText(0)

rslider bounds(164, 18, 70, 70) channel("wdPhas") range(0, 1, 0.5, 1, 0.001)filmstrip("resources/knob.png", 30)popupText(0)

rslider bounds(34, 18, 70, 70) channel("wdBit") range(0, 1, 0.5, 1, 0.001) filmstrip("resources/knob.png", 30)popupText(0)
nslider bounds(10, 14, 42, 18) channel("d") range(.001,.2, 0, 1, 0.01) active(1) visible(0)
nslider bounds(10, 32, 42, 18) channel("p") range(100,1000, 0, 1, 0.01)  active(1) visible(0)
nslider bounds(10, 50, 42, 18) channel("c") range(.1,10, 0, 1, 0.01) active(1) visible(0)
nslider bounds(10, 70, 42, 18) channel("r") range(.1,20, 0, 1, 0.01) active(1) visible(0)
nslider bounds(10, 90, 42, 18) channel("f") range(0,10, 0, 1, 0.01) active(1) visible(0)


button bounds(32, 290, 80, 80) channel("trigger") text("") imgFile("On", "resources/on.png") imgFile("Off", "resources/off.png")popupText(0)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1




instr 1
chnset 1, "CSOUND_GESTURES" 
kGo init 1
   kval, kTrig cabbageGetValue "trigger"   
    if kTrig == 1 then
        gkBang = 1  
        endif
    
kDel delayk kTrig, .3	
cabbageSet kDel, "trigger" , "value", 0
    

    
    if gkBang == 1 && kGo == 1 then
    printks "Random has been called to update", 0
    gkBang = 0
    gkDelrand random .001,.2
    gkfrand random .1,10
    gkprand random 100,1000
    gkFM random 0,10
    gkrand random .1,20
    cabbageSetValue "d",gkDelrand, kTrig
    cabbageSetValue "c",gkfrand, kTrig
    cabbageSetValue "p",gkprand, kTrig
    cabbageSetValue "r",gkrand, kTrig
    cabbageSetValue "f",gkFM, kTrig
    endif

gkcrash cabbageGetValue "crash"
if gkcrash =1  then
gkrandCrash randh 2,20
gkFloor floor gkrandCrash
else 
gkrandCrash = 0
endif

if gkFloor = 1 then
gkBang =1
gkAmp = 0
else
gkBang = 0
gkFloor = 0
gkAmp = 1

endif

kGain cabbageGetValue "gain"
krand cabbageGetValue "r"
kfm cabbageGetValue "f"
kDelrand cabbageGetValue "d"
kprand cabbageGetValue "p"
kfrand cabbageGetValue "c"
aIn inch 1
kLFO lfo krand, kfm , .1
kLFOb lfo .001, .01 , 1
kPortTime linseg   0, 0.01, 0.1
kinTime    portk  kDelrand+kLFOb  , kPortTime
kfeedback = .5

 aDel delayr 4
 aTapin deltapi a(kinTime)*2
 delayw aIn+(aTapin * kfeedback)
 
 kdFx cabbageGet "wdDel"
 kdFxf  cabbageGet "wdBit"
 kdFxp  cabbageGet "wdPhas"
 kwd  cabbageGet "wd"
 aFold fold aIn, kfrand
 aPhas phaser1 aIn, kprand+kLFO, 20,.5
 aWet =(aTapin*kdFx)+(aFold*kdFxf)+(aPhas*kdFxp)
 amix ntrpol aIn, aWet, kwd
 outs amix*kGain, amix*kGain
 endin



</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>
