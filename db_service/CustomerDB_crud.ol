include "console.iol"
include "database.iol"
include "string_utils.iol"
include "customer_iface.iol"
include "math.iol"
include "/db_service/DBConnector_iface.iol"

execution { concurrent }

outputPort DB_Connector {
	Location: "socket://localhost:1000/"
	Protocol: sodep
	Interfaces: ConnectionPool
}
inputPort CustomerDB_Service {
	Location: "socket://localhost:8001/"
	Protocol: http { .format = "json" }
	Interfaces: Customers
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
			"select * from customer"
		)(sqlResponse);
		response.values -> sqlResponse.row
	} ]
	
	//Example: http://localhost:8001/create?name=Magda&surname=Carlson&address=Guantanamo Beach&email=magda@email.com&mobile_phone=12345678&other_phone=198765432
	[ create(request)(response) {
		update@Database(
			"insert into customer(name, surname, address, email, mobile_phone, other_phone)
			                  values (:name,:surname,:address,:email,:mobile_phone, other_phone )" {
				//.id = request.id,
				.name = request.name,
				.surname = request.surname,
				.address = request.address,
				.email = request.email,
				.mobile_phone = request.mobile_phone,
				.other_phone = request.other_phone
			}
		)(response.status)
	} ]
	
	//Example: http://localhost:8001/retrieve?id=1
	[ retrieve(request)(response) {
		query@Database(
			"select * from customer where customer_id=:id" {
				.id = request.id
			}
		)(sqlResponse);
		if (#sqlResponse.row == 1) {
			response -> sqlResponse.row[0]
		}
	} ]	
	
	//Example: http://localhost:8001/update?id=6&name=Magda2
	[ update(request)(response) {
		update@Database(
			"update customer set name=:name where customer_id=:id" {
				.id = request.id,
				.name = request.name
				
			}
		)(response.status)
	} ]
	
	//Example: http://localhost:8001/delete?id=6
	[ delete(request)(response) {
		update@Database(
			"delete from customer where customer_id=:id" {
				.id = request.id
			}
		)(response.status)
	} ]
}
