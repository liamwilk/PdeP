import Scenes._scenes.*


object sceneManager {
    var currentScene = null

    method load(scene) {
        if(currentScene != null) {
            currentScene.remove()
        }
        scene.load()
        currentScene = scene
    }
}