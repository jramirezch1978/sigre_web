$PBExportHeader$w_fi733_doc_x_pagar_pend_tbl.srw
forward
global type w_fi733_doc_x_pagar_pend_tbl from w_rpt
end type
type cbx_todos from checkbox within w_fi733_doc_x_pagar_pend_tbl
end type
type cb_doc from commandbutton within w_fi733_doc_x_pagar_pend_tbl
end type
type rb_fvenc from radiobutton within w_fi733_doc_x_pagar_pend_tbl
end type
type rb_freg from radiobutton within w_fi733_doc_x_pagar_pend_tbl
end type
type cbx_origenes from checkbox within w_fi733_doc_x_pagar_pend_tbl
end type
type cb_3 from commandbutton within w_fi733_doc_x_pagar_pend_tbl
end type
type sle_origen from singlelineedit within w_fi733_doc_x_pagar_pend_tbl
end type
type st_2 from statictext within w_fi733_doc_x_pagar_pend_tbl
end type
type uo_1 from u_ingreso_rango_fechas within w_fi733_doc_x_pagar_pend_tbl
end type
type cb_1 from commandbutton within w_fi733_doc_x_pagar_pend_tbl
end type
type dw_report from u_dw_rpt within w_fi733_doc_x_pagar_pend_tbl
end type
type gb_1 from groupbox within w_fi733_doc_x_pagar_pend_tbl
end type
type gb_2 from groupbox within w_fi733_doc_x_pagar_pend_tbl
end type
type gb_3 from groupbox within w_fi733_doc_x_pagar_pend_tbl
end type
end forward

global type w_fi733_doc_x_pagar_pend_tbl from w_rpt
integer width = 3799
integer height = 2404
string title = "(FI733) Doc. Pendientes Por Pagar "
string menuname = "m_reporte"
cbx_todos cbx_todos
cb_doc cb_doc
rb_fvenc rb_fvenc
rb_freg rb_freg
cbx_origenes cbx_origenes
cb_3 cb_3
sle_origen sle_origen
st_2 st_2
uo_1 uo_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_fi733_doc_x_pagar_pend_tbl w_fi733_doc_x_pagar_pend_tbl

on w_fi733_doc_x_pagar_pend_tbl.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_todos=create cbx_todos
this.cb_doc=create cb_doc
this.rb_fvenc=create rb_fvenc
this.rb_freg=create rb_freg
this.cbx_origenes=create cbx_origenes
this.cb_3=create cb_3
this.sle_origen=create sle_origen
this.st_2=create st_2
this.uo_1=create uo_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_todos
this.Control[iCurrent+2]=this.cb_doc
this.Control[iCurrent+3]=this.rb_fvenc
this.Control[iCurrent+4]=this.rb_freg
this.Control[iCurrent+5]=this.cbx_origenes
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.sle_origen
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.uo_1
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
end on

on w_fi733_doc_x_pagar_pend_tbl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_todos)
destroy(this.cb_doc)
destroy(this.rb_fvenc)
destroy(this.rb_freg)
destroy(this.cbx_origenes)
destroy(this.cb_3)
destroy(this.sle_origen)
destroy(this.st_2)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)



//datos de reporte
ib_preview = False
This.Event ue_preview()
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user


sle_origen.text = gs_origen
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

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

type cbx_todos from checkbox within w_fi733_doc_x_pagar_pend_tbl
integer x = 2523
integer y = 80
integer width = 283
integer height = 104
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	cb_doc.enabled = false
	delete from tt_fin_tipo_doc ;
	
	Insert into tt_fin_tipo_doc
	(tipo_doc)
	select dt.tipo_doc
     from doc_pendientes_cta_cte dp,doc_tipo dt
    where (dp.tipo_doc   = dt.tipo_doc )  and
          (dp.flag_tabla = '3'         )   
   group by  dt.tipo_doc,dt.desc_tipo_doc   ;
	
	
else
	cb_doc.enabled = true	
	delete from tt_fin_tipo_doc ;
end if	
end event

type cb_doc from commandbutton within w_fi733_doc_x_pagar_pend_tbl
integer x = 2519
integer y = 184
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "T. de Documento"
end type

event clicked;str_parametros sl_param 

delete from tt_fin_tipo_doc ;

sl_param.dw1		= 'd_abc_doc_tipo_lista_tbl'
sl_param.titulo	= 'Lista de Documentos'
sl_param.opcion   = 19

sl_param.db1 		= 1500
sl_param.string1 	= '1TD'




OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type rb_fvenc from radiobutton within w_fi733_doc_x_pagar_pend_tbl
integer x = 1751
integer y = 152
integer width = 709
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Fecha de Vencimiento"
end type

type rb_freg from radiobutton within w_fi733_doc_x_pagar_pend_tbl
integer x = 1751
integer y = 68
integer width = 709
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Fecha de Registro"
boolean checked = true
end type

type cbx_origenes from checkbox within w_fi733_doc_x_pagar_pend_tbl
integer x = 1047
integer y = 216
integer width = 645
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes"
end type

event clicked;if this.checked then
	sle_origen.Enabled = FALSE
	sle_origen.Text	  = '%'
else
	sle_origen.Enabled = TRUE
	sle_origen.Text	  = ''
end if
end event

type cb_3 from commandbutton within w_fi733_doc_x_pagar_pend_tbl
integer x = 786
integer y = 216
integer width = 114
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

event clicked;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "SELECT COD_ORIGEN AS CODIGO_ORIGEN, " &
		  + "NOMBRE AS NOMBRE_ORIGEN " &
		  + "FROM ORIGEN " 
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	sle_origen.text		= ls_codigo
end if
end event

type sle_origen from singlelineedit within w_fi733_doc_x_pagar_pend_tbl
integer x = 407
integer y = 212
integer width = 343
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_fi733_doc_x_pagar_pend_tbl
integer x = 78
integer y = 220
integer width = 288
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_fi733_doc_x_pagar_pend_tbl
event destroy ( )
integer x = 64
integer y = 80
integer taborder = 30
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(date(today()),date(today()))
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type cb_1 from commandbutton within w_fi733_doc_x_pagar_pend_tbl
integer x = 3054
integer y = 64
integer width = 425
integer height = 200
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Recuperar"
end type

event clicked;String 	ls_origen,ls_nombre
Long   	ll_count
Date		ld_Fecha_inicio, ld_fecha_final


//para leer las fechas
ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()

ls_origen = sle_origen.text

if cbx_origenes.checked = False then
	//buscar descripcion y exigir origen
	select nombre into :ls_nombre from origen where cod_origen = :ls_origen ;
	
	IF Isnull(ls_nombre) or Trim(ls_nombre) = '' THEN
		Messagebox('Aviso','Origen No Existe , Verifique!')
		Return
	END IF
	
	ls_origen = ls_origen + '%'
else
	ls_nombre = 'Todos Los Origenes'
	ls_origen = '%'	
end if

if rb_freg.checked then
	//por fecha de registro
	dw_report.dataobject = 'd_abc_reporte_provision_pend_tbl'
	
elseif rb_fvenc.checked then
	
	//por fecha de vencimiento
	dw_report.dataobject = 'd_abc_reporte_provision_pend_x_fvenc_tbl'
	
end if	


select count(*) into :ll_count from tt_fin_tipo_doc ;

if ll_count = 0 then
	messagebox('Aviso','Debe Seleccionar algun Documento Verifique! ')
	return
end if	

dw_report.Settransobject( sqlca)
dw_report.Retrieve(ld_fecha_inicio,ld_fecha_final,ls_origen,ls_nombre)

//datos de reporte
ib_preview = False
Parent.Event ue_preview()
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user


end event

type dw_report from u_dw_rpt within w_fi733_doc_x_pagar_pend_tbl
integer y = 340
integer width = 3310
integer height = 1748
string dataobject = "d_abc_reporte_provision_pend_tbl"
boolean livescroll = false
end type

type gb_1 from groupbox within w_fi733_doc_x_pagar_pend_tbl
integer x = 27
integer y = 16
integer width = 1687
integer height = 304
integer taborder = 30
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

type gb_2 from groupbox within w_fi733_doc_x_pagar_pend_tbl
integer x = 1719
integer y = 16
integer width = 759
integer height = 304
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Recuperación"
end type

type gb_3 from groupbox within w_fi733_doc_x_pagar_pend_tbl
integer x = 2482
integer y = 16
integer width = 544
integer height = 304
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Documentos"
end type

