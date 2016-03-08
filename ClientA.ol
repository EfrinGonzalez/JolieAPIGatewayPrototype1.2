// Client.ol works with only one instance because of the hardcoded callback port (4002)

include "console.iol"
include "time.iol"
include "ui/swing_ui.iol"
include "/Dynamic_Embedding_Counter/embedderInterface.iol"
include "/Dynamic_Embedding_Counter/clientInterface.iol"
include "/profileC_service/twiceInterface.iol"
include "authenticator.iol"
include "/db_service/user_iface.iol"

outputPort Gateway{
	Location: "socket://localhost:2000"
	Protocol: sodep
	Interfaces: Users
}

outputPort ProfileA {
	Location: "socket://localhost:2001/"
	Protocol: sodep
	Interfaces: AuthenticatorInterface	
}

inputPort ClientA{
	Location: "socket://localhost:4002"
	Protocol: sodep
	Interfaces: Users
}



main
{
	user.email = args[0];
	println@Console(user.mail)();
	user.name = args[1];
	user.profile = args[2];
	
	 //Saying wich profile is loaded
	 start@Gateway(user)|
	 loadingMessage@ProfileA("ProfileA")
	 
	




//new part
//	sleep@Time(2000)(response);
	
/*	 
	 keepRunning = true;
	while( keepRunning ){	
			 opMessage.sid = csets.sid = new;
	 println@Console("opMessage.sid: "+opMessage.sid)();
	 opMessage.message = "logout";
	 println@Console("opMessage.message: "+ opMessage.message)();
	 stop@Gateway(OpMessage)
	
			}
	 */
	 
	 
}