
import Player._index.*
import Enemies._index.*
import Scenes._index.*
import _constants.PLAYER
import Engine._scene.*
import Engine._gameLoop.*

object menu inherits Scene {
    override method load() {
        self.setup("intro.png", "himno.mp3", 0.3)
        keyboard.h().onPressDo({sceneManager.load(howToPlay)})
        keyboard.enter().onPressDo({sceneManager.load(selectCharacter)})
    }
    
    // We don't want to stop the audio on this scene. We want it to sound until the user selects a character
    override method remove() {
        self.removeAllVisuals()
    }
}

object howToPlay inherits Scene {
    override method load() {
        self.changeBg("how-to-play.png")
    }

    // Same as above
    override method remove() {
        self.removeAllVisuals()
    }
}


// Here is where the audio gets removed. 
object selectCharacter inherits Scene {
    var index = 0

    override method load() {
        self.changeBg(player.selectedPlayer().name() + "/seleccion.png")
        keyboard.left().onPressDo({if(index != 0) index -= 1 self.changeCharacter()})
        keyboard.right().onPressDo({if(index < PLAYER.players.size() - 1) index += 1 self.changeCharacter()})
        keyboard.a().onPressDo({sceneManager.load(main)})
    }

    method changeCharacter() {
        player.changeCharacter(index)
        self.changeBg(player.selectedPlayer().name() + "/seleccion.png")
    }

}

object main inherits Scene {
    override method load() {
        self.setup("background.png", player.selectedPlayer().name() + "/cancion.mp3", 0.2)
        gameLoop.start()
        player.load()
        waveManager.onStart()
    }

    override method remove() {
        super()
        gameLoop.stop()
    }
}

object win inherits Scene{
    override method load() {
        self.setup(player.selectedPlayer().name() + "/win.png", null, 0)
    }
}

object defeat inherits Scene {
    override method load() {
        self.setup(player.selectedPlayer().name() + "/defeat.png", null, 0)
    }
}
