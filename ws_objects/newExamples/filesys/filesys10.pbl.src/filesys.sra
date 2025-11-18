$PBExportHeader$filesys.sra
$PBExportComments$Generated Application Object
forward
global type filesys from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type filesys from application
string appname = "filesys"
end type
global filesys filesys

on filesys.create
appname="filesys"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on filesys.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_treeview)

end event

