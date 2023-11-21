object utils {
    method getRandomNumberBetween(a, b) {
        return a.randomUpTo(b).round()
    }

    method generateRandomId() {
        return 0.randomUpTo(1000).toString()
    }


    /**
    * @returns a random position in the y component and on the x component is out of the screen in the right
    */
    method getRandomPosOutOfScreenRight() {
        const y = 20.randomUpTo(game.height() - 100)
        return game.at(game.width() + 40, y)
    }

    method getRandomNumberExcluding(min, max, numbersToExclude) {
        const rndNum = min.randomUpTo(max) 
        if(numbersToExclude.contains(rndNum)) 
            return self.getRandomNumberExcluding(min, max, numbersToExclude)
        else 
            return rndNum
    }
}