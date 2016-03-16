type User:void {
	.email:string
	.name:string
	.profile:string
}
type OpMessage: void{
	.sid: string
	.message?: string
}

interface Users {
RequestResponse:
	retrieveAll(undefined)(undefined),
	create(undefined)(undefined),
	retrieve(undefined)(undefined),
	update(undefined)(undefined),
	delete(undefined)(undefined),
	twice( int )( int ),
	login(undefined)(undefined),
	auth(User)(bool)
	
OneWay: 
	start(void),
	stop(void)
}


