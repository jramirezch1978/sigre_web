$PBExportHeader$crypto.sra
$PBExportComments$Generated Application Object
forward
global type crypto from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type crypto from application
string appname = "crypto"
end type
global crypto crypto

on crypto.create
appname="crypto"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on crypto.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

event systemerror;MessageBox( "Crypto Error " + String(Error.Number), &
				Error.Text, StopSign! )

Halt

end event

