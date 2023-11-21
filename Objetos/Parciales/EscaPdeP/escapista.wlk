class Escapista{
	var maestria
	const salasEscapadas = []
	var saldo
	var contadorPartidas
	
	method saldoDisponible() = saldo
	
	method puedeSalir(sala) = maestria.salir(sala, self)
	
	method descontar(importe) = saldo - importe
	
	method condicionesDefault() = salasEscapadas.size() > 20
	
	method condicionesGanadasSeguidas() = contadorPartidas >= 5
	
	method puedoSubirDeNivel() = self.condicionesDefault() || self.condicionesGanadasSeguidas()
	
	method subirNivel(){
		if (self.puedoSubirDeNivel()){
			maestria.subirNivel(self)
		}
	}
	method bajarNivel(){
		if (contadorPartidas == 3){
			maestria.bajarNivel(self)
		}
	}
	method agregarSala(sala) = salasEscapadas.add(sala)
	
	method salasQueSalio() = salasEscapadas.asSet()
}

object amateur{
	method salir(sala, persona) = !sala.esSalaDificil() && persona.salasEscapadas().size() > 6
	
	method subirNivel(persona){
		persona.maestria(profesional)
	}
	
	method bajarNivel(persona){} // no se puede bajar más
}

object profesional{
	method salir(sala, persona) = true
	
	method subirNivel(persona){} // no se puede subir más
	
	method bajarNivel(persona){
		persona.maestria(amateur)
	}
}
