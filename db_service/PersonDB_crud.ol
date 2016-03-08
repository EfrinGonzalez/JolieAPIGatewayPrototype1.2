include "console.iol"
include "database.iol"
include "string_utils.iol"
include "person_iface.iol"
include "math.iol"
include "/db_service/DBConnector_iface.iol"

execution { concurrent }

outputPort DB_Connector {
	Location: "socket://localhost:1000/"
	Protocol: sodep
	Interfaces: ConnectionPool
}
inputPort PersonDB_Service {
	Location: "socket://localhost:8001/"
	Protocol: http { .format = "json" }
	Interfaces: Persons
}



init
{
	connectionConfigInfo@DB_Connector()(connectionInfo);
	connect@Database(connectionInfo)()

}

main
{	
	//Example: http://localhost:8001/retrieveAll
	[ retrieveAll()(response) {
		query@Database(
			"select * from persons"
		)(sqlResponse);
		response.values -> sqlResponse.row
	} ]
	
	//Example: http://localhost:8001/create?id=1&name=Magda
	[ create(request)(response) {
		update@Database(
			"insert into persons(personid, name) values (:id, :name)" {
				.id = request.id,
				.name = request.name
			}
		)(response.status)
	} ]
	
	//Example: http://localhost:8001/retrieve?id=1
	[ retrieve(request)(response) {
		query@Database(
			"select * from persons where personid=:id" {
				.id = request.id
			}
		)(sqlResponse);
		if (#sqlResponse.row == 1) {
			response -> sqlResponse.row[0]
		}
	} ]	
	
	//Example: http://localhost:8001/update?id=5&name=Magda2
	[ update(request)(response) {
		update@Database(
			"update persons set name=:name where personid=:id" {
				.id = request.id,
				.name = request.name
				
			}
		)(response.status)
	} ]
	
	//Example: http://localhost:8001/delete?id=5
	[ delete(request)(response) {
		update@Database(
			"delete from persons where personid=:id" {
				.id = request.id
			}
		)(response.status)
	} ]
}
