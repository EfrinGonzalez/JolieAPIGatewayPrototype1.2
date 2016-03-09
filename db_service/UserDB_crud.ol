include "console.iol"
include "runtime.iol"
include "database.iol"
include "string_utils.iol"
include "customer_iface.iol"
include "math.iol"
include "../authenticator.iol"
include "/db_service/DBConnector_iface.iol"
include "/db_service/user_iface.iol"


execution { concurrent }


interface ShutdownInterface {
OneWay: off(void)
}

inputPort UserDB_Service {
	Location: "socket://localhost:8002/"
	Protocol: http { .format = "json" }
	Interfaces: Users, ShutdownInterface, ConnectionPool
}


outputPort DB_Connector {
	Location: "socket://localhost:1000/"
	Protocol: sodep
	Interfaces: ConnectionPool
}



init
{
    //user.email=="test";
	connectionConfigInfo@DB_Connector()(connectionInfo);
	connect@Database(connectionInfo)()

}

main
{


    /*auth@Auth_Service(user)(response){
         if (response == false ) throw(a_fault)
    };
*/
  //  provide
	//Example: http://localhost:8002/retrieveAll
	[ retrieveAll()(response) {
		query@Database(
			"select * from users"
		)(sqlResponse);
		response.values -> sqlResponse.row


            //debuggin
          //valueToPrettyString@StringUtils()(response.values);

                //Use to see for debugging purposes.
		      /*  println@Console( "user_id: " + response.values[0].user_id)();
        		println@Console( "password: " + response.values[0].password)();
        		println@Console( "name: " + response.values[0].name)();
        		println@Console( "email: " + response.values[0].email)();

        		println@Console( "user_id: " + response.values[1].user_id)();
                println@Console( "password: " + response.values[1].password)();
                println@Console( "name: " + response.values[1].name)();
                println@Console( "email: " + response.values[1].email)()*/

	} ]
	
	//Example: http://localhost:8002/create?email=test@test.com&name=test&password=test
	[ create(request)(response) {
		update@Database(
			"insert into users(email, name, password) values (:email, :name, :password)" {
				.email = request.email,
				.name = request.name,
				.password = request.password
			}
		)(response.status)
	} ]
	
	//Example: http://localhost:8002/retrieve?id=1
	[ retrieve(request)(response) {
		query@Database(
			"select * from users where user_id=:id" {
				.id = request.id
			}
		)(sqlResponse);
		
		println@Console( "You have requested the user_id: " + request.id)();
		
		if (#sqlResponse.row == 1) {
			response -> sqlResponse.row[0]			
		}
		
	} ]	
	
	//Example: http://localhost:8002/update?id=5&name=Magda2
	[ update(request)(response) {
		update@Database(
			"update users set name=:name where user_id=:id" {
				.id = request.id,
				.name = request.name
				
			}
		)(response.status)
	} ]
	
	//Example: http://localhost:8002/delete?id=3
	[ delete(request)(response) {
		update@Database(
			"delete from users where user_id=:id" {
				.id = request.id
			}
		)(response.status)
	} ]

 /*   until
    [stop()]*/
}
