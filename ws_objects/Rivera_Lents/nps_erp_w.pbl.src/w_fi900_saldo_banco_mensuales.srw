$PBExportHeader$w_fi900_saldo_banco_mensuales.srw
forward
global type w_fi900_saldo_banco_mensuales from w_prc
end type
type dw_master from datawindow within w_fi900_saldo_banco_mensuales
end type
type cb_1 from commandbutton within w_fi900_saldo_banco_mensuales
end type
end forward

global type w_fi900_saldo_banco_mensuales from w_prc
integer width = 1390
integer height = 480
string title = "Actualización de Saldo Bancario"
string menuname = "m_only_exit"
dw_master dw_master
cb_1 cb_1
end type
global w_fi900_saldo_banco_mensuales w_fi900_saldo_banco_mensuales

on w_fi900_saldo_banco_mensuales.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.dw_master=create dw_master
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.cb_1
end on

on w_fi900_saldo_banco_mensuales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.cb_1)
end on

type dw_master from datawindow within w_fi900_saldo_banco_mensuales
integer x = 23
integer y = 28
integer width = 763
integer height = 232
integer taborder = 20
string title = "none"
string dataobject = "d_ext_ano_mes_tbl"
boolean border = false
boolean livescroll = true
end type

event constructor;SettransObject(sqlca)
InsertRow(0)
end event

type cb_1 from commandbutton within w_fi900_saldo_banco_mensuales
integer x = 882
integer y = 24
integer width = 384
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;Long 		ll_ano,ll_mes ,ll_ano_ant,ll_mes_ant
String 	ls_mensaje

dw_master.Accepttext()

ll_ano = dw_master.object.ano [1]
ll_mes = dw_master.object.mes [1]


IF Isnull(ll_ano) OR ll_ano = 0 THEN
	dw_master.SetFocus()
	dw_master.SetColumn('ano')
	Return
END IF

IF Isnull(ll_mes) OR ll_mes = 0 THEN
	dw_master.SetFocus()
	dw_master.SetColumn('mes')
	Return
END IF



IF ll_mes = 1 THEN
	ll_mes_ant = 12
	ll_ano_ant = ll_ano - 1
ELSE
	ll_mes_ant = ll_mes - 1
	ll_ano_ant = ll_ano 
END IF	


DECLARE USP_FIN_SALDO_BANCOS PROCEDURE FOR 
	USP_FIN_SALDO_BANCOS(:ll_ano,
								:ll_mes,
								:ll_ano_ant,
								:ll_mes_ant);
EXECUTE USP_FIN_SALDO_BANCOS ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox('Error de Actualización de Saldos de Bancos Mensuales', ls_mensaje)
	Return
END IF

COMMIT;

CLOSE USP_FIN_SALDO_BANCOS;

Messagebox('Aviso','Proceso de Actualizacion Ha Concluido Satisfactoriamente')
end event

