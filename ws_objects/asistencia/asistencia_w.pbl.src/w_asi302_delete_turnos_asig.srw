$PBExportHeader$w_asi302_delete_turnos_asig.srw
forward
global type w_asi302_delete_turnos_asig from w_abc
end type
type cbx_todos_codigo from checkbox within w_asi302_delete_turnos_asig
end type
type em_nombres from editmask within w_asi302_delete_turnos_asig
end type
type cb_4 from commandbutton within w_asi302_delete_turnos_asig
end type
type em_codigo from editmask within w_asi302_delete_turnos_asig
end type
type st_1 from statictext within w_asi302_delete_turnos_asig
end type
type cbx_1 from checkbox within w_asi302_delete_turnos_asig
end type
type cbx_todos_origenes from checkbox within w_asi302_delete_turnos_asig
end type
type cbx_todos_ttrab from checkbox within w_asi302_delete_turnos_asig
end type
type em_desc_ttrab from editmask within w_asi302_delete_turnos_asig
end type
type em_desc_origen from editmask within w_asi302_delete_turnos_asig
end type
type em_origen from editmask within w_asi302_delete_turnos_asig
end type
type cb_3 from commandbutton within w_asi302_delete_turnos_asig
end type
type cb_2 from commandbutton within w_asi302_delete_turnos_asig
end type
type em_ttrab from editmask within w_asi302_delete_turnos_asig
end type
type st_3 from statictext within w_asi302_delete_turnos_asig
end type
type st_2 from statictext within w_asi302_delete_turnos_asig
end type
type uo_1 from u_ingreso_rango_fechas within w_asi302_delete_turnos_asig
end type
type cb_1 from commandbutton within w_asi302_delete_turnos_asig
end type
type dw_master from u_dw_abc within w_asi302_delete_turnos_asig
end type
type gb_1 from groupbox within w_asi302_delete_turnos_asig
end type
end forward

global type w_asi302_delete_turnos_asig from w_abc
integer width = 2587
integer height = 1904
string title = "Elimina Asignación de Turnos (ASI302)"
string menuname = "m_proceso_save"
cbx_todos_codigo cbx_todos_codigo
em_nombres em_nombres
cb_4 cb_4
em_codigo em_codigo
st_1 st_1
cbx_1 cbx_1
cbx_todos_origenes cbx_todos_origenes
cbx_todos_ttrab cbx_todos_ttrab
em_desc_ttrab em_desc_ttrab
em_desc_origen em_desc_origen
em_origen em_origen
cb_3 cb_3
cb_2 cb_2
em_ttrab em_ttrab
st_3 st_3
st_2 st_2
uo_1 uo_1
cb_1 cb_1
dw_master dw_master
gb_1 gb_1
end type
global w_asi302_delete_turnos_asig w_asi302_delete_turnos_asig

on w_asi302_delete_turnos_asig.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_save" then this.MenuID = create m_proceso_save
this.cbx_todos_codigo=create cbx_todos_codigo
this.em_nombres=create em_nombres
this.cb_4=create cb_4
this.em_codigo=create em_codigo
this.st_1=create st_1
this.cbx_1=create cbx_1
this.cbx_todos_origenes=create cbx_todos_origenes
this.cbx_todos_ttrab=create cbx_todos_ttrab
this.em_desc_ttrab=create em_desc_ttrab
this.em_desc_origen=create em_desc_origen
this.em_origen=create em_origen
this.cb_3=create cb_3
this.cb_2=create cb_2
this.em_ttrab=create em_ttrab
this.st_3=create st_3
this.st_2=create st_2
this.uo_1=create uo_1
this.cb_1=create cb_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_todos_codigo
this.Control[iCurrent+2]=this.em_nombres
this.Control[iCurrent+3]=this.cb_4
this.Control[iCurrent+4]=this.em_codigo
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.cbx_todos_origenes
this.Control[iCurrent+8]=this.cbx_todos_ttrab
this.Control[iCurrent+9]=this.em_desc_ttrab
this.Control[iCurrent+10]=this.em_desc_origen
this.Control[iCurrent+11]=this.em_origen
this.Control[iCurrent+12]=this.cb_3
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.em_ttrab
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.uo_1
this.Control[iCurrent+18]=this.cb_1
this.Control[iCurrent+19]=this.dw_master
this.Control[iCurrent+20]=this.gb_1
end on

on w_asi302_delete_turnos_asig.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_todos_codigo)
destroy(this.em_nombres)
destroy(this.cb_4)
destroy(this.em_codigo)
destroy(this.st_1)
destroy(this.cbx_1)
destroy(this.cbx_todos_origenes)
destroy(this.cbx_todos_ttrab)
destroy(this.em_desc_ttrab)
destroy(this.em_desc_origen)
destroy(this.em_origen)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.em_ttrab)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;
dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente



dw_master.of_protect()         		// bloquear modificaciones 


of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

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
else
	Rollback using SQLCA;
END IF

end event

event ue_update_pre;call super::ue_update_pre;String ls_filtro
Long   ll_inicio



//filtro marcados
ls_filtro = 'flag_sel = '+"'"+'1'+"'"

dw_master.SetFilter(ls_filtro)
dw_master.Filter( )

//elimina asientos generados
DO WHILE dw_master.Rowcount() > 0
	dw_master.deleterow(0)
LOOP

//limpio filtro


dw_master.SetFilter('')

dw_master.Filter( )
end event

type cbx_todos_codigo from checkbox within w_asi302_delete_turnos_asig
integer x = 2167
integer y = 392
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Todos"
end type

event clicked;
if this.checked then
	em_codigo.enabled = false
else
	em_codigo.enabled = true
end if
end event

type em_nombres from editmask within w_asi302_delete_turnos_asig
integer x = 891
integer y = 384
integer width = 1202
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_4 from commandbutton within w_asi302_delete_turnos_asig
integer x = 795
integer y = 384
integer width = 87
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_rpt_seleccion_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param )
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_codigo.text  = sl_param.field_ret[1]
	em_nombres.text = sl_param.field_ret[2]
END IF
end event

type em_codigo from editmask within w_asi302_delete_turnos_asig
integer x = 439
integer y = 384
integer width = 338
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_asi302_delete_turnos_asig
integer x = 46
integer y = 392
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "C.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_asi302_delete_turnos_asig
integer x = 46
integer y = 556
integer width = 512
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Marcar Todos"
end type

event clicked;Long ll_inicio

if this.checked then
	For ll_inicio = 1 to dw_master.Rowcount()
		 dw_master.object.flag_sel	[ll_inicio] = '1'
		 dw_master.ii_update = 1
	Next
	
else	
	
	For ll_inicio = 1 to dw_master.Rowcount()
		 dw_master.object.flag_sel	[ll_inicio] = '0'
		 dw_master.ii_update = 1
	Next
end if
end event

type cbx_todos_origenes from checkbox within w_asi302_delete_turnos_asig
integer x = 2167
integer y = 216
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Todos"
end type

event clicked;
if this.checked then
	em_origen.enabled = false
else
	em_origen.enabled = true
end if
end event

type cbx_todos_ttrab from checkbox within w_asi302_delete_turnos_asig
integer x = 2167
integer y = 304
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Todos"
end type

event clicked;
if this.checked then
	em_ttrab.enabled = false
else
	em_ttrab.enabled = true
end if
end event

type em_desc_ttrab from editmask within w_asi302_delete_turnos_asig
integer x = 891
integer y = 300
integer width = 1202
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_origen from editmask within w_asi302_delete_turnos_asig
integer x = 891
integer y = 216
integer width = 1202
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_asi302_delete_turnos_asig
integer x = 439
integer y = 216
integer width = 338
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_3 from commandbutton within w_asi302_delete_turnos_asig
integer x = 795
integer y = 216
integer width = 87
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_desc_origen.text = sl_param.field_ret[2]
END IF

end event

type cb_2 from commandbutton within w_asi302_delete_turnos_asig
integer x = 795
integer y = 300
integer width = 87
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_ttrab.text      = sl_param.field_ret[1]
	em_desc_ttrab.text = sl_param.field_ret[2]
END IF

end event

type em_ttrab from editmask within w_asi302_delete_turnos_asig
integer x = 439
integer y = 300
integer width = 338
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_3 from statictext within w_asi302_delete_turnos_asig
integer x = 46
integer y = 308
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_asi302_delete_turnos_asig
integer x = 46
integer y = 224
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_asi302_delete_turnos_asig
integer x = 50
integer y = 96
integer taborder = 20
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_asi302_delete_turnos_asig
integer x = 2130
integer y = 68
integer width = 357
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;Date   ld_fecha_inicio,ld_fecha_final
String ls_tip_trab,ls_origen,ls_cod_trab


ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()



ls_tip_trab	= em_ttrab.text
ls_origen	= em_origen.text
ls_cod_trab	= em_codigo.text


if cbx_todos_origenes.checked then
	ls_origen = '%'
else
	if Isnull(ls_origen) or Trim(ls_origen) = '' then
		Messagebox('Aviso','Debe Ingresar Origen a Recuperar ,Verifique!')
		Return
	end if
end if	


if cbx_todos_ttrab.checked then
	ls_tip_trab = '%'
else
	if Isnull(ls_tip_trab) or Trim(ls_tip_trab) = '' then
		Messagebox('Aviso','Debe Ingresar Tipo de Trabajador ,Verifique!')
		Return
	end if
	
end if	


if cbx_todos_codigo.checked then
	ls_cod_trab = '%'
else
	if Isnull(ls_cod_trab) or Trim(ls_cod_trab) = '' then
		Messagebox('Aviso','Debe Ingresar Codigo de Trabajador ,Verifique!')
		Return
	end if
	
end if

dw_master.Retrieve(ls_origen,ls_tip_trab,ls_cod_trab,ld_fecha_inicio,ld_fecha_final)
end event

type dw_master from u_dw_abc within w_asi302_delete_turnos_asig
integer x = 18
integer y = 652
integer width = 2496
integer height = 1052
string dataobject = "d_abc_delete_asig_turnos_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3


idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;Accepttext()
end event

type gb_1 from groupbox within w_asi302_delete_turnos_asig
integer x = 32
integer y = 4
integer width = 2510
integer height = 504
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Busqueda"
end type

