$PBExportHeader$cookiemgr.sra
$PBExportComments$Generated Application Object
forward
global type cookiemgr from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type cookiemgr from application
string appname = "cookiemgr"
end type
global cookiemgr cookiemgr

on cookiemgr.create
appname="cookiemgr"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on cookiemgr.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;MessageBox("CookieMgr", "Open event")

end event

