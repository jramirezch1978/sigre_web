$PBExportHeader$w_fi021_abc_saldo_bancario.srw
forward
global type w_fi021_abc_saldo_bancario from w_abc
end type
type dw_1 from datawindow within w_fi021_abc_saldo_bancario
end type
type cb_1 from commandbutton within w_fi021_abc_saldo_bancario
end type
type dw_master from u_dw_abc within w_fi021_abc_saldo_bancario
end type
end forward

global type w_fi021_abc_saldo_bancario from w_abc
integer width = 2423
integer height = 1204
string title = "Saldos Mensuales de Cuenta de Banco (FI021)"
string menuname = "m_save_exit"
dw_1 dw_1
cb_1 cb_1
dw_master dw_master
end type
global w_fi021_abc_saldo_bancario w_fi021_abc_saldo_bancario

on w_fi021_abc_saldo_bancario.create
int iCurrent
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
this.dw_1=create dw_1
this.cb_1=create cb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_fi021_abc_saldo_bancario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.dw_master)
end on

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca) 
idw_1 = dw_master    
end event

event resize;call super::resize;
dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0

	END IF
END IF

end event

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
	   Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type ole_skin from w_abc`ole_skin within w_fi021_abc_saldo_bancario
end type

type dw_1 from datawindow within w_fi021_abc_saldo_bancario
integer x = 32
integer y = 24
integer width = 786
integer height = 224
integer taborder = 20
string title = "none"
string dataobject = "d_ext_ano_mes_tbl"
boolean border = false
boolean livescroll = true
end type

event constructor;Settransobject(sqlca)
InsertRow(0)
end event

type cb_1 from commandbutton within w_fi021_abc_saldo_bancario
integer x = 1093
integer y = 32
integer width = 343
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;Long ll_ano,ll_mes

dw_1.Accepttext()

ll_ano = dw_1.object.ano [1]
ll_mes = dw_1.object.mes [1]


IF dw_master.ii_update = 1 THEN
	Messagebox('Aviso','Grabe Cambios Antes de Selecionar Otro Año')
	Return 
END IF

dw_master.Retrieve(ll_ano,ll_mes)

end event

type dw_master from u_dw_abc within w_fi021_abc_saldo_bancario
integer x = 18
integer y = 264
integer width = 2350
integer height = 736
string dataobject = "d_abc_saldo_banco_mes_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3

idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;accepttext()
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row (This)
end event

