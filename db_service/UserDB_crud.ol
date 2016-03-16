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
	Protocol: http { .format = "json";
	                 .headers.iv_user = "ivUser";
	                 .debug = true;
                     .debug.showContent = true
                    }
	Interfaces: Users, ShutdownInterface, ConnectionPool
}


outputPort DB_Connector {
	Location: "socket://localhost:1000/"
	Protocol: sodep
	Interfaces: ConnectionPool
}

init
{	message = "User is not authorized for this operation.";
    connectionConfigInfo@DB_Connector()(connectionInfo);
	connect@Database(connectionInfo)()
}



main
{
        	//Example: http://localhost:8002/retrieveAll
        	[ retrieveAll(request)(response) {
        		 if((request.ivUser=="g47257") ||
        		    (request.ivUser=="g47258") ||
        		    (request.ivUser=="g47259"))
        		 {
                        query@Database(
                            "select * from users"
                        )(sqlResponse);
                        response.values -> sqlResponse.row
                          //valueToPrettyString@StringUtils()(response.values);

                        //Use to see for debugging purposes.
        		      /*println@Console( "user_id: " + response.values[0].user_id)();
                		println@Console( "password: " + response.values[0].password)();
                		println@Console( "name: " + response.values[0].name)();
                		println@Console( "email: " + response.values[0].email)();

                		println@Console( "user_id: " + response.values[1].user_id)();
                        println@Console( "password: " + response.values[1].password)();
                        println@Console( "name: " + response.values[1].name)();
                        println@Console( "email: " + response.values[1].email)()*/
                 }else{
                        response -> message
                        }

        	} ]

            //Example: http://localhost:8002/retrieve?id=1
             [ retrieve(request)(response) {
                    if((request.ivUser=="g47257") ||
                       (request.ivUser=="g47258") ||
                       (request.ivUser=="g47259")){
                         query@Database("select * from users where user_id=:id" {
                                                .id = request.id
                                            }
                                        )(sqlResponse);
                                        println@Console( "You have requested the user_id: " + request.id)();
                                        println@Console( "iv-user: " + request.ivUser)();

                                        if (#sqlResponse.row == 1) {
                                            response -> sqlResponse.row[0]
                                        }
                    }else{
                       response -> message
                        }


                    } ]


        	//Example: http://localhost:8002/create?email=test@test.com&name=test&password=test
        	[ create(request)(response) {

        	 if(request.ivUser=="g47258"){
        		update@Database(
        			"insert into users(email, name, password) values (:email, :name, :password)" {
        				.email = request.email,
        				.name = request.name,
        				.password = request.password
        			}
        		)(response.status)
        	}else{
                response -> message
                }

        	} ]





        	//Example: http://localhost:8002/update?id=5&name=Magda2
        	[ update(request)(response) {
        		if(request.ivUser=="g47258"){
        		update@Database(
        			"update users set name=:name where user_id=:id" {
        				.id = request.id,
        				.name = request.name

        			}
        		)(response.status)
        	}else{
        		     response -> message
        		}
        	} ]

        	//Example: http://localhost:8002/delete?id=3
        	[ delete(request)(response) {
        	if(request.ivUser=="g47258"){
        		update@Database(
        			"delete from users where user_id=:id" {
        				.id = request.id
        			}
        		)(response.status)
        	}else{
        	     response -> message
        	}
        	} ]





}
