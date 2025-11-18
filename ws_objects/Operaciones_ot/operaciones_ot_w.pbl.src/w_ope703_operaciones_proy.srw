$PBExportHeader$w_ope703_operaciones_proy.srw
forward
global type w_ope703_operaciones_proy from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_ope703_operaciones_proy
end type
type cb_5 from commandbutton within w_ope703_operaciones_proy
end type
type cbx_4 from checkbox within w_ope703_operaciones_proy
end type
type cbx_3 from checkbox within w_ope703_operaciones_proy
end type
type cbx_2 from checkbox within w_ope703_operaciones_proy
end type
type cbx_1 from checkbox within w_ope703_operaciones_proy
end type
type cb_4 from commandbutton within w_ope703_operaciones_proy
end type
type cb_3 from commandbutton within w_ope703_operaciones_proy
end type
type cb_2 from commandbutton within w_ope703_operaciones_proy
end type
type cb_1 from commandbutton within w_ope703_operaciones_proy
end type
type dw_report from u_dw_rpt within w_ope703_operaciones_proy
end type
type gb_1 from groupbox within w_ope703_operaciones_proy
end type
end forward

global type w_ope703_operaciones_proy from w_rpt
integer width = 3342
integer height = 2300
string title = "Operaciones Proyectadas x OT"
string menuname = "m_rpt_smpl"
long backcolor = 134217738
uo_1 uo_1
cb_5 cb_5
cbx_4 cbx_4
cbx_3 cbx_3
cbx_2 cbx_2
cbx_1 cbx_1
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ope703_operaciones_proy w_ope703_operaciones_proy

on w_ope703_operaciones_proy.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_1=create uo_1
this.cb_5=create cb_5
this.cbx_4=create cbx_4
this.cbx_3=create cbx_3
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_5
this.Control[iCurrent+3]=this.cbx_4
this.Control[iCurrent+4]=this.cbx_3
this.Control[iCurrent+5]=this.cbx_2
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
end on

on w_ope703_operaciones_proy.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_5)
destroy(this.cbx_4)
destroy(this.cbx_3)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
//idw_1.Visible = False
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
//This.Event ue_retrieve()
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type uo_1 from u_ingreso_rango_fechas within w_ope703_operaciones_proy
integer x = 55
integer y = 92
integer taborder = 20
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
//of_set_fecha(date('01/01/1900'), date('31/12/9999') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_5 from commandbutton within w_ope703_operaciones_proy
integer x = 2885
integer y = 476
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Long   ll_count
String ls_fecha_inicio,ls_fecha_final


//verificación de fechas
ls_fecha_inicio = String(uo_1.of_get_fecha1(),'yyyymmdd')
ls_fecha_final  = String(uo_1.of_get_fecha2(),'yyyymmdd')


IF Isnull(ls_fecha_inicio) OR Trim(ls_fecha_inicio) = '00000000' THEN
	Messagebox('Aviso','Debe Ingresar Alguna Fecha Inicial')	
	RETURN
END IF	

IF Isnull(ls_fecha_final)  OR Trim(ls_fecha_final)  = '00000000' THEN
	Messagebox('Aviso','Debe Ingresar Alguna Fecha Final')	
	RETURN
END IF	


IF cbx_2.checked THEN //ADMINISTRACION
	//todas las ot administración
	insert into tt_ope_ot_adm 
	select ot_adm from ot_administracion ;
ELSE
	select count(*) into :ll_count from tt_ope_ot_adm ;
	
	IF ll_count = 0 THEN 
		Messagebox('Aviso','Debe Seleccionar alguna Administración de OT')
		RETURN
	END IF
END IF

IF cbx_3.checked THEN //CENTROS COSTO RESPONSABLE
	//todos los centros de costo
	insert into tt_ope_cencos_rsp
	select cencos from centros_costo ;
ELSE
   select count(*) into :ll_count from tt_ope_cencos_rsp ;
	
	IF ll_count = 0 THEN 
		Messagebox('Aviso','Debe Seleccionar algun Centro de Costo Responsable')
		RETURN
	END IF
END IF

IF cbx_4.checked THEN //CENTRO COSTO SOLICITANTE
	//todos los centros de costo
	insert into tt_ope_cencos_slc
	select cencos from centros_costo ;
ELSE
   select count(*) into :ll_count from tt_ope_cencos_slc ;
	
	IF ll_count = 0 THEN 
		Messagebox('Aviso','Debe Seleccionar algun Centro de Costo Solicitante')
		RETURN
	END IF
END IF



//POR MAQUINA
IF cbx_1.checked then
	//todas las ot con o sin maquina
	dw_report.dataobject = 'd_operaciones_pend_ot_tbl'
ELSE
	dw_report.dataobject = 'd_operaciones_pend_ot_x_maquina_tbl'
	//SELECCIONE MAQUINA
	select count(*) into :ll_count from tt_ope_maquina;
	
	IF ll_count = 0 THEN 
		Messagebox('Aviso','Debe Seleccionar alguna Maquina')
		RETURN
	END IF
	
END IF

dw_report.SettransObject(sqlca)

ib_preview = FALSE
idw_1.ii_zoom_actual = 100
Parent.Event ue_preview()

idw_1.Retrieve(ls_fecha_inicio,ls_fecha_final,gs_empresa,gs_user)

//elimina información de tabla temporal
delete from tt_ope_ot_adm     ;
delete from tt_ope_cencos_rsp ;
delete from tt_ope_cencos_slc ;
delete from tt_ope_maquina    ;
end event

type cbx_4 from checkbox within w_ope703_operaciones_proy
integer x = 1906
integer y = 500
integer width = 818
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Cencos Solic."
end type

type cbx_3 from checkbox within w_ope703_operaciones_proy
integer x = 1906
integer y = 420
integer width = 818
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Cencos Resp."
end type

type cbx_2 from checkbox within w_ope703_operaciones_proy
integer x = 1906
integer y = 344
integer width = 818
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas los Administradores "
end type

type cbx_1 from checkbox within w_ope703_operaciones_proy
integer x = 1906
integer y = 272
integer width = 818
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas las Ot Con o Sin Maquina"
end type

type cb_4 from commandbutton within w_ope703_operaciones_proy
integer x = 2885
integer y = 360
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "CenCos Solic."
end type

event clicked;Long ll_count
str_parametros sl_param 


delete from tt_ope_cencos_slc ;

sl_param.dw1		= 'd_abc_lista_cencos_tbl'
sl_param.titulo	= 'Centros de Costo Solicitante'
sl_param.opcion   = 22
sl_param.db1 		= 1600
sl_param.string1 	= '1CCOS'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cb_3 from commandbutton within w_ope703_operaciones_proy
integer x = 2885
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Maquina"
end type

event clicked;
Long ll_count
str_parametros sl_param 


delete from tt_ope_maquina ;

sl_param.dw1		= 'd_abc_lista_maquina_tbl'
sl_param.titulo	= 'Maquina'
sl_param.opcion   = 20
sl_param.db1 		= 1600
sl_param.string1 	= '1MAQ'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cb_2 from commandbutton within w_ope703_operaciones_proy
integer x = 2885
integer y = 124
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Administradores"
end type

event clicked;
Long ll_count
str_parametros sl_param 


delete from tt_ope_ot_adm ;

sl_param.dw1		= 'd_abc_ot_adm_tbl'
sl_param.titulo	= 'Administración de OT'
sl_param.opcion   = 24
sl_param.db1 		= 1600
sl_param.string1 	= '1OADM'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cb_1 from commandbutton within w_ope703_operaciones_proy
integer x = 2885
integer y = 244
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "CenCos Resp."
end type

event clicked;Long ll_count
str_parametros sl_param 


delete from tt_ope_cencos_rsp ;

sl_param.dw1		= 'd_abc_lista_cencos_tbl'
sl_param.titulo	= 'Centros de Costo Responsable'
sl_param.opcion   = 23
sl_param.db1 		= 1600
sl_param.string1 	= '1CCOS'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type dw_report from u_dw_rpt within w_ope703_operaciones_proy
integer x = 27
integer y = 624
integer width = 3250
integer height = 1484
string dataobject = "d_operaciones_pend_ot_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ope703_operaciones_proy
integer x = 27
integer y = 24
integer width = 1376
integer height = 184
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Fechas"
end type

