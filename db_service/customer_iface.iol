type Customer:void {
	.email:string
	.name:string
}

interface Customers {
RequestResponse:
	retrieveAll(undefined)(undefined),
	create(undefined)(undefined),
	retrieve(undefined)(undefined),
	update(undefined)(undefined),
	delete(undefined)(undefined),
	shutdown(undefined)(undefined),
	twice( int )( int ) 
}

//Just in case
/*interface MyInterface {
RequestResponse:
	sayHello( Customer )( string )
}*/
