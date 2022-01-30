#Persistent

#include HotVoice\Lib\HotVoice.ahk

colorDict := { "yellow": "0xF4CF68", "blue": "0xAFF3FF", "red": "0xFA9391", "default": "0x4D2C10" }

hv := new HotVoice()
hv.Initialize(0)

tfate := hv.newGrammar()
tfate.AppendString("magic")
colorChoices := hv.NewChoices("yellow, blue, red")
tfate.AppendChoices(colorChoices)

hv.LoadGrammar(tfate, "magic", Func("CardSelector"))

hv.StartRecognizer(0)

return

CheckColor(castState, targetColor) {
    global colorDict
    cardSelected := 0

    If (castState = 1) {
        Loop {
            PixelGetColor, CardColor, 858, 1014, RGB
            if (CardColor = targetColor) {
                cardSelected := 1
                SoundBeep, 750
                break
            }
        }
    }

    If (castState != 1) {
        Loop {
            PixelGetColor, CardColor, 858, 1014, RGB
            if (CardColor = targetColor) {
                cardSelected := 1
                SoundBeep, 750
                break
            }

            if (CardColor = colorDict["default"]) {
                cardSelected := 0 ; W shuffle ran out before card could be selected
                break
            }
        }
    }

    return cardSelected
}

CardSelector(grammarName, words) {
    if (WinActive("League of Legends (TM) Client")) {
        global colorDict
        PixelGetColor, CardColor, 858, 1014, RGB
        voiceCasted := 0
        
        ; Start card rotation if not on cooldown or in use
        if (CardColor = colorDict["default"]) {
            voiceCasted := 1
            SendInput, W
        }

        if (CheckColor(voiceCasted, colorDict[words[2]]) = 1) {
            SendInput, W
        } else {
             return
        }

    }
}