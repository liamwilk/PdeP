import wollok.game.*
import Scenes._index.*
import Scenes._scenes.*

object gameManager {
    method start() {
        game.width(1360)
        game.height(660) 
        game.cellSize(1)
        game.start()
        sceneManager.load(menu)
    }
}