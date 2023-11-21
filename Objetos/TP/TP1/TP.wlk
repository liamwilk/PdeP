object donPonciano {
	const cantidadHectareas = 15
	var hectareasOcupadas = 10
	var tipoCosecha = trigo
	const dinero = cuentaCorriente
	var importe = 0
	
	method fumigar(){
		importe = (10 * cantidadHectareas)
		dinero.retirar(importe)
		importe = 0 // reseteo importe para no arrastrarlo a otra situación
	}
	method aplicarFertilizantes(){
		importe = tipoCosecha.costoTotal(hectareasOcupadas)
		dinero.retirar(importe)
		importe = 0 // reseteo importe para no arrastrarlo a otra situación
		tipoCosecha.fertilizar()
	}
	method granSequia(cultivo){
		tipoCosecha = cultivo
		importe = tipoCosecha.costoTotal(hectareasOcupadas)
		dinero.retirar(importe)
		importe = 0
	}
	method epocasBeneficiosas(){
		const cantidad = cantidadHectareas - hectareasOcupadas
		importe = tipoCosecha.costoTotal(cantidad)
		dinero.retirar(importe)
		hectareasOcupadas = cantidadHectareas
		importe = 0 
	}
	method nuevaTemporada(cultivo, hectareas){
		importe += tipoCosecha.precioDeVenta() * tipoCosecha.rendimientoActual() * hectareasOcupadas
		dinero.depositar(importe)
		hectareasOcupadas = hectareas
		tipoCosecha = cultivo
		importe = 0 // reseteo importe para no arrastrarlo a otra situación
	}
	method tipoDeCosecha(){
		return tipoCosecha
	}
	}
	
object trigo{
	const costoXHectarea = 500
	var rendimiento = 10
	const precioVenta = 1000
	
	method fertilizar(){
		rendimiento += 2
	}
	method costoHectarea(){
		return costoXHectarea
	}
	method costoTotal(cantidadHectareas){
		return costoXHectarea * cantidadHectareas
	}
	method precioDeVenta(){
		return precioVenta
	}
	method rendimientoActual(){
		return rendimiento
	}
}

object soja{
	var rendimiento = 20
	var fertilizado = false
	const precioVenta = (mercadoDeChicago.valorDeSoja() * dolarSoja.dolar()) * 0.65
	const costoXHectarea = (precioVenta / 2)
	
	
	method estaFertilizado(){
		return fertilizado
	}
	method fertilizar(){
		if (!fertilizado){
			fertilizado = true
			rendimiento += 20
		} else {
			rendimiento -= 20
			fertilizado = false
		}
	}
	method precioDeVenta(){
		return precioVenta
	}
	method costoTotal(cantidadHectareas){
		return costoXHectarea * cantidadHectareas
	}
	method rendimientoActual(){
		return rendimiento
	}
}

object maiz{
	const costoXHectarea = 500
	const rendimiento = 15
	const precioVenta = (soja.precioDeVenta() / 2)
	
	method costoTotal(cantidadHectareas){
		if (costoXHectarea * cantidadHectareas <= 5000){
			return costoXHectarea * cantidadHectareas} 
			else {
				return 5000
		} 
	}
	method fertilizar(){
		return rendimiento
	}
	method precioDeVenta(){
		return precioVenta
	}
	method rendimientoActual(){
		return rendimiento
	}
	method costoHectarea(){
		return costoXHectarea
	}
}

object papa{
	const costoXHectarea = 315
	var rendimiento = 25
	const precioVenta = (costoXHectarea * rendimiento) / 2
	
	method fertilizar(){
		rendimiento += 5
	}
	method precioDeVenta(){
		return precioVenta
	}
	method rendimientoActual(){
		return rendimiento
	}
	method costoTotal(cantidadHectareas){
		return costoXHectarea * cantidadHectareas
	}
	method costoHectarea(){
		return costoXHectarea
	}
}

object mercadoDeChicago{
	const valorSoja = 500
	method valorDeSoja(){
		return valorSoja
	}
}

object dolarSoja{
	const valor = 350
	method dolar(){
		return valor
	}
}

object cuentaCorriente{
	 var balance = 5000
	 
	 method verBalance(){
	 	return balance
	 }
	 method depositar(importe){
	 	balance += importe
	 }
	 method retirar(importe){
	 	balance -= importe
	 }
}