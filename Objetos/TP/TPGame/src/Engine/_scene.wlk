object audioManager {
    var property audio = null

    method changeAudio(sound, volume) {
        audio = game.sound(sound)
        audio.volume(volume)
        audio.play()
    }

    method removeAudio() {
        if(audio != null)
            audio.pause()
        audio = null
    }
}


class Scene {
    method load() 

    method setup(bgImage, sound, volume) {
        self.changeBg(bgImage)
        if(sound != null) {
            audioManager.changeAudio(sound, volume)
        }
    }

    method changeBg(bgImage) {
        game.boardGround(bgImage)
    }

    method removeAllVisuals() {
        game.allVisuals().forEach({visual => visual.remove()})
    }

    method remove() {
        self.removeAllVisuals()
        audioManager.removeAudio()
    }
}