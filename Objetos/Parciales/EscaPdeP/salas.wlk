class SalaDeEscape {
	var nombre
	var dificultad
	
	method valorBase() = 10000
	
	method esSalaDificil() = dificultad > 7
}

class SalaAnime inherits SalaDeEscape {
	method valorFinal() = self.valorBase() + 7000
}

class SalaHistoria inherits SalaDeEscape {
	var esHechoHistorico
	
	method valorFinal() = self.valorBase() + (dificultad * 314)
	
	override method esSalaDificil() = super() && !esHechoHistorico
}

class SalaTerror inherits SalaDeEscape {
	var cantidadSustos
	
	method valorFinal(){		
		if (cantidadSustos > 5){
			return self.valorBase() + (8 ** (cantidadSustos))
		} else {
			return self.valorBase()
		}
	}
	method condicionesDificil() = dificultad > 7 || cantidadSustos > 5
	override method esSalaDificil() = self.condicionesDificil()
}