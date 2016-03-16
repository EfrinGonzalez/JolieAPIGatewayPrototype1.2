include "console.iol"
include "database.iol"
include "string_utils.iol"
include "product_iface.iol"
include "math.iol"
include "/db_service/DBConnector_iface.iol"

execution { concurrent }

outputPort DB_Connector {
	Location: "socket://localhost:1000/"
	Protocol: sodep
	Interfaces: ConnectionPool
}
inputPort ProductDB_Service {
	Location: "socket://localhost:8003/"
	Protocol: http { .format = "json";
                     .headers.iv_user = "ivUser";
                     .debug = true;
                      .debug.showContent = true
                      }
	Interfaces: Products
}



init
{
    message = "User is not authorized for this operation.";
	connectionConfigInfo@DB_Connector()(connectionInfo);
	connect@Database(connectionInfo)()

}

main
{	
	//Example: http://localhost:8003/retrieveAll
	[ retrieveAll(request)(response) {
		if((request.ivUser=="g47257") ||
           (request.ivUser=="g47258") ||
           (request.ivUser=="g47259"))
        {
            query@Database(
                "select * from product"
            )(sqlResponse);
            response.values -> sqlResponse.row
		}else{
		     response -> message
		}
	} ]


	//Example: http://localhost:8003/retrieve?id=3
    	[ retrieve(request)(response) {
    		if((request.ivUser=="g47257") ||
               (request.ivUser=="g47258") ||
               (request.ivUser=="g47259")){
                    query@Database(
                        "select * from product where product_id=:id" {
                            .id = request.id
                        }
                    )(sqlResponse);
                    if (#sqlResponse.row == 1) {
                        response -> sqlResponse.row[0]
                    }
             }else{
                response -> message
             }
    	} ]


	//Example: http://localhost:8003/create?name=KASDAK&code=1004&owner=NASKAD STOCK MARKET&description=Stocks in NASDAK System
	[ create(request)(response) {

	if(request.ivUser=="g47259"){
            update@Database(
                "insert into product(name, code, owner, description)
                             values (:name,:code,:owner,:description)" {
                    //.id = request.id,
                    .name = request.name,
                    .code = request.code,
                    .owner = request.owner,
                    .description = request.description
                }
            )(response.status)
	}else{
	     response -> message
	}
	} ]
	

	
	//Example: http://localhost:8003/update?id=4&name=NASDAK2
	[ update(request)(response) {
	if(request.ivUser=="g47259"){
            update@Database(
                "update product set name=:name where product_id=:id" {
                    .id = request.id,
                    .name = request.name

                }
            )(response.status)
    }else{
        response -> message
    }
	} ]
	
	//Example: http://localhost:8003/delete?id=4
	[ delete(request)(response) {
	if(request.ivUser=="g47259"){
            update@Database(
                "delete from product where product_id=:id" {
                    .id = request.id
                }
            )(response.status)
    }else{
        response -> message
    }
	} ]
}
