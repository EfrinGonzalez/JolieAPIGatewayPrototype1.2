include "console.iol"
include "runtime.iol"
include "../authenticator.iol"
include "../db_service/user_iface.iol"


execution{ concurrent }

interface ProfileA_functionallity_Interface {
RequestResponse: getAllUsers(void)(undefined)

OneWay: start(void)
}

outputPort UserDB_Service {
	Location: "socket://localhost:8002/"
	Protocol: http
	Interfaces: Users
}

inputPort ProfileA_Service {
	Location: "socket://localhost:2001/"
	Protocol: http { .format = "json" }
	Interfaces: AuthenticatorInterface, ProfileA_functionallity_Interface
	Redirects: DB => UserDB_Service 
}

	
	
embedded {
		Jolie:  "/db_service/UserDB_crud.ol" in UserDB_Service
		}



main 
{

		//http://localhost:2001/getAllUsers
		[getAllUsers()(responseDB){
			retrieveAll@UserDB_Service()(response)

			//response = responseUserDb;
      //println@Console( "response: " + response.values[0].password)()

			
		}]
	
	
}