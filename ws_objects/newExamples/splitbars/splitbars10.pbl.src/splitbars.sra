$PBExportHeader$splitbars.sra
forward
global type splitbars from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

end variables

global type splitbars from application
string appname = "splitbars"
end type
global splitbars splitbars

type variables
Boolean ib_loggedon
end variables

on splitbars.create
appname="splitbars"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on splitbars.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;// open main window
Open(w_main)

end event

