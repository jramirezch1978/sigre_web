$PBExportHeader$w_fi361_cheque_emitidos.srw
forward
global type w_fi361_cheque_emitidos from w_abc
end type
type cbx_1 from checkbox within w_fi361_cheque_emitidos
end type
type sle_codctabco from singlelineedit within w_fi361_cheque_emitidos
end type
type st_3 from statictext within w_fi361_cheque_emitidos
end type
type st_nom_ctabco from statictext within w_fi361_cheque_emitidos
end type
type cb_2 from commandbutton within w_fi361_cheque_emitidos
end type
type cb_1 from commandbutton within w_fi361_cheque_emitidos
end type
type uo_1 from u_ingreso_rango_fechas within w_fi361_cheque_emitidos
end type
type dw_master from u_dw_abc within w_fi361_cheque_emitidos
end type
type gb_1 from groupbox within w_fi361_cheque_emitidos
end type
end forward

global type w_fi361_cheque_emitidos from w_abc
integer width = 3177
integer height = 1924
string title = "Cheques Emitidos (FI361)"
string menuname = "m_proceso_graba"
cbx_1 cbx_1
sle_codctabco sle_codctabco
st_3 st_3
st_nom_ctabco st_nom_ctabco
cb_2 cb_2
cb_1 cb_1
uo_1 uo_1
dw_master dw_master
gb_1 gb_1
end type
global w_fi361_cheque_emitidos w_fi361_cheque_emitidos

on w_fi361_cheque_emitidos.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_graba" then this.MenuID = create m_proceso_graba
this.cbx_1=create cbx_1
this.sle_codctabco=create sle_codctabco
this.st_3=create st_3
this.st_nom_ctabco=create st_nom_ctabco
this.cb_2=create cb_2
this.cb_1=create cb_1
this.uo_1=create uo_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.sle_codctabco
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_nom_ctabco
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.uo_1
this.Control[iCurrent+8]=this.dw_master
this.Control[iCurrent+9]=this.gb_1
end on

on w_fi361_cheque_emitidos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.sle_codctabco)
destroy(this.st_3)
destroy(this.st_nom_ctabco)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

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

event ue_open_pre;call super::ue_open_pre;dw_master.Settransobject(sqlca)
idw_1 = dw_master 
end event

type cbx_1 from checkbox within w_fi361_cheque_emitidos
integer x = 1627
integer y = 96
integer width = 869
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todas Las  Cuentas de Banco"
end type

type sle_codctabco from singlelineedit within w_fi361_cheque_emitidos
event ue_enter pbm_keydown
integer x = 530
integer y = 208
integer width = 590
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Long   ll_count
String ls_ctabco,ls_desc

if key = KeyEnter! then
	ls_ctabco = this.text
	
	select count (*) into :ll_count from banco_cnta where cod_ctabco = :ls_ctabco ;
	
	if ll_count > 0 then
		select descripcion into :ls_desc from banco_cnta 
		 where cod_ctabco = :ls_ctabco ;
		
		st_nom_ctabco.text = ls_desc
		
	else
		Messagebox('Aviso','Cuenta de Banco No Existe')
	end if
end if
end event

type st_3 from statictext within w_fi361_cheque_emitidos
integer x = 32
integer y = 216
integer width = 475
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Cuenta de Banco :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_nom_ctabco from statictext within w_fi361_cheque_emitidos
integer x = 1275
integer y = 208
integer width = 1330
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_fi361_cheque_emitidos
integer x = 1147
integer y = 208
integer width = 96
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar


lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT BANCO_CNTA.COD_CTABCO AS CUENTA_BANCO ,'&
								       +'BANCO_CNTA.DESCRIPCION AS DESCRIPCION ,'&
								       +'BANCO_CNTA.CNTA_CTBL AS CUENTA_CONTABLE,'&      
							 	       +'BANCO_CNTA.COD_MONEDA AS MONEDA,'&
								       +'BANCO_CNTA.COD_ORIGEN  CODIGO_ORIGEN '&
								       +'FROM BANCO_CNTA '
				
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codctabco.text = lstr_seleccionar.param1[1]
		st_nom_ctabco.text = lstr_seleccionar.param2[1]
	END IF	
				
end event

type cb_1 from commandbutton within w_fi361_cheque_emitidos
integer x = 2738
integer y = 24
integer width = 375
integer height = 104
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_cta_bco
Date   ld_fecha_inicio,ld_fecha_final

ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()


if cbx_1.checked then //todas las cuentas
	ls_cta_bco = '%'
else
	ls_cta_bco = sle_codctabco.text
	
	IF Isnull(ls_cta_bco) OR Trim(ls_cta_bco) = '' THEN
		Messagebox('Aviso','Debe ingresar Cuenta de Banco ,Verificar!')
		Return
	END IF
	
	ls_cta_bco = ls_cta_bco + '%'
end if


dw_master.Retrieve(ls_cta_bco,ld_fecha_inicio,ld_fecha_final)
end event

type uo_1 from u_ingreso_rango_fechas within w_fi361_cheque_emitidos
integer x = 55
integer y = 92
integer taborder = 40
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type dw_master from u_dw_abc within w_fi361_cheque_emitidos
integer x = 14
integer y = 388
integer width = 3099
integer height = 1336
string dataobject = "d_abc_cheque_emitir_tbl"
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;Accepttext()
end event

event clicked;call super::clicked;
idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;
is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1		


idw_mst = dw_master

end event

type gb_1 from groupbox within w_fi361_cheque_emitidos
integer x = 23
integer y = 8
integer width = 2647
integer height = 348
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos"
end type

