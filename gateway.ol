include "console.iol"
include "database.iol"
include "time.iol"
include "../db_service/person_iface.iol"
include "/db_service/user_iface.iol"
include "/db_service/DBConnector_iface.iol"
include "runtime.iol"
include "authenticator.iol"
include "protocols/http.iol"
include "MonitoringTool/LeonardoWebServer/config.iol"


execution{ concurrent }

outputPort DB_Connector {
	Location: "socket://localhost:1000/"
	Protocol: sodep
	Interfaces: ConnectionPool
}

outputPort Auth_Service{
	Location: "socket://localhost:9000"
	Protocol: sodep
	Interfaces: Users
}

//Note: The gateway runs the monitoring service
outputPort Monitor {
	Location: "socket://localhost:8005/"
	//Protocol: http { .format = "json" }
	Interfaces: Persons
}

//Note: the gateway runs the leonardo server to show what it is 
//in the monitoring service.
outputPort HTTPInput {
	Location: Location_Leonardo
	//Protocol: http { .format = "json" }
	//Interfaces: HTTPInterface
}


inputPort Gateway{
	Location: "socket://localhost:2000"
	Protocol: sodep
	Interfaces: Users, ConnectionPool
	Redirects: MonitoringTool => Monitor,	
			   LeonardoWebServer => HTTPInput
}

embedded 
{
		Jolie:  "/MonitoringTool/Monitor.ol" in Monitor,
		        "/MonitoringTool/LeonardoWebServer/leonardo.ol" in HTTPInput,
				"/auth_service/Auth.ol",
				"/db_service/DBConnector.ol"

}
	
init
{
	connectionConfigInfo@DB_Connector()(connectionInfo);
	connect@Database(connectionInfo)();

       q = "select * from service_registry";
            	query@Database(q)(result);

                //instead of a fixed i, there should be something like "result.size" condition
            	for ( i = 0, i < 2, i++ ) {
                	println@Console(         "Service id: "+ result.row[i].service_id +
                    						 "\n"+
                    						 "Service context: "+ result.row[i].context +
                    						 "\n"+
                    						 "Service protocol: "+ result.row[i].protocol +
                    						 "\n"+
                    						 "Service Input port: "+ result.row[i].input_port +
                    						 "\n"+
                    						 "Service Filepath: "+ result.row[i].filepath +
                    						 "\n"+
                    						 "Service Location: "+ result.row[i].location)();
                    	embedInfo.type = "Jolie";
                        //keepRunning = true;
                        embedInfo.filepath = result.row[i].filepath;
                        loadEmbeddedService@Runtime( embedInfo )( result.row[i].context.location )
                }



}			

main
{
	start()



}






