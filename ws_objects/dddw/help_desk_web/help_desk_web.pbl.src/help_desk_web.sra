$PBExportHeader$help_desk_web.sra
$PBExportComments$Generated Application Object
forward
global type help_desk_web from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String  	gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo
String  	gs_sistema, gs_ruc, gs_esquema, gs_lpp, gs_action
Integer 	gi_nivel, gi_control_db, gi_feriado[], gi_user, gi_usr_hou_id
Date    	gd_fecha
String   gs_db
DateTime gdt_ingreso
Boolean	gb_log_objeto

n_cst_app_obj		gnvo_app
n_cst_utilitario 	gnvo_utility
n_cst_encriptor		gnvo_enc
n_cst_controldoc	gnvo_controldoc
end variables

global type help_desk_web from application
string appname = "help_desk_web"
end type
global help_desk_web help_desk_web

type prototypes
FUNCTION long ShellExecute (uint  ihwnd,string  lpszOp,string &
   lpszFile,string  lpszParams, string  lpszDir,int  wShowCmd ) & 
   LIBRARY "Shell32.dll" ALIAS FOR "ShellExecuteA" 
end prototypes
on help_desk_web.create
appname="help_desk_web"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on help_desk_web.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Str_parametros	lstr_param

// Profile profile_sytco
SQLCA.DBMS = "O10 Oracle10g (10.1.0)"
SQLCA.LogPass = "sytco"
SQLCA.ServerName = "horus"
SQLCA.LogId = "sytco"
SQLCA.AutoCommit = False
CONNECT ;

gnvo_app = create n_cst_app_obj

open( w_login)
lstr_param = Message.PowerObjectParm

if lstr_param.b_return then
	open(w_help_desk)
end if
end event

