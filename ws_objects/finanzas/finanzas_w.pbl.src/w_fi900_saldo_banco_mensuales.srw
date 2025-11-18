$PBExportHeader$w_fi900_saldo_banco_mensuales.srw
forward
global type w_fi900_saldo_banco_mensuales from w_prc
end type
type cb_1 from commandbutton within w_fi900_saldo_banco_mensuales
end type
end forward

global type w_fi900_saldo_banco_mensuales from w_prc
integer width = 1024
integer height = 440
string title = "[FI900] Actualización de Saldo Bancario"
string menuname = "m_consulta"
cb_1 cb_1
end type
global w_fi900_saldo_banco_mensuales w_fi900_saldo_banco_mensuales

on w_fi900_saldo_banco_mensuales.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_fi900_saldo_banco_mensuales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
end on

type cb_1 from commandbutton within w_fi900_saldo_banco_mensuales
integer x = 169
integer y = 32
integer width = 626
integer height = 176
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;String 	ls_mensaje, ls_null

SetNull(ls_null)

//create or replace procedure USP_FIN_SALDO_BANCOS (
//       asi_nada in varchar2  
//) is

DECLARE USP_FIN_SALDO_BANCOS PROCEDURE FOR 
	USP_FIN_SALDO_BANCOS(:ls_null);
	
EXECUTE USP_FIN_SALDO_BANCOS ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox('Error en Procedure USP_FIN_SALDO_BANCOS', ls_mensaje)
	Return
END IF

COMMIT;

CLOSE USP_FIN_SALDO_BANCOS;

Messagebox('Aviso','Proceso de Actualizacion Ha Concluido Satisfactoriamente')
end event

