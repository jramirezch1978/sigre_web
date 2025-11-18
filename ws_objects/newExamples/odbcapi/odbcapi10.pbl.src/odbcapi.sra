$PBExportHeader$odbcapi.sra
$PBExportComments$Generated Application Object
forward
global type odbcapi from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type odbcapi from application
string appname = "odbcapi"
end type
global odbcapi odbcapi

on odbcapi.create
appname="odbcapi"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on odbcapi.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;// set connection properties
sqlca.DBMS = "ODBC"
sqlca.AutoCommit = True
sqlca.DBParm = "ConnectString='DSN=EAS Demo DB V9;UID=dba;PWD=sql'"

// connect to database
connect;

// open the main window
If sqlca.SQLCode = 0 Then
	Open(w_main)
Else
	MessageBox("Connect Failed", sqlca.SQLErrText)
End If

end event

event close;// disconnect from database
disconnect;

end event

