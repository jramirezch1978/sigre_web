$PBExportHeader$w_fi747_cntas_pagar_pend_x_prov.srw
forward
global type w_fi747_cntas_pagar_pend_x_prov from w_rpt
end type
type cbx_todos from checkbox within w_fi747_cntas_pagar_pend_x_prov
end type
type cb_doc from commandbutton within w_fi747_cntas_pagar_pend_x_prov
end type
type uo_1 from u_ingreso_rango_fechas within w_fi747_cntas_pagar_pend_x_prov
end type
type sle_nombre from singlelineedit within w_fi747_cntas_pagar_pend_x_prov
end type
type cb_2 from commandbutton within w_fi747_cntas_pagar_pend_x_prov
end type
type em_proveedor from editmask within w_fi747_cntas_pagar_pend_x_prov
end type
type cb_1 from commandbutton within w_fi747_cntas_pagar_pend_x_prov
end type
type dw_report from u_dw_rpt within w_fi747_cntas_pagar_pend_x_prov
end type
type gb_1 from groupbox within w_fi747_cntas_pagar_pend_x_prov
end type
end forward

global type w_fi747_cntas_pagar_pend_x_prov from w_rpt
integer width = 3310
integer height = 2404
string title = "(FI747) Doc. Pendientes Por Pagar "
string menuname = "m_reporte"
cbx_todos cbx_todos
cb_doc cb_doc
uo_1 uo_1
sle_nombre sle_nombre
cb_2 cb_2
em_proveedor em_proveedor
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_fi747_cntas_pagar_pend_x_prov w_fi747_cntas_pagar_pend_x_prov

type variables

end variables

on w_fi747_cntas_pagar_pend_x_prov.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_todos=create cbx_todos
this.cb_doc=create cb_doc
this.uo_1=create uo_1
this.sle_nombre=create sle_nombre
this.cb_2=create cb_2
this.em_proveedor=create em_proveedor
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_todos
this.Control[iCurrent+2]=this.cb_doc
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.sle_nombre
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.em_proveedor
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.gb_1
end on

on w_fi747_cntas_pagar_pend_x_prov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_todos)
destroy(this.cb_doc)
destroy(this.uo_1)
destroy(this.sle_nombre)
destroy(this.cb_2)
destroy(this.em_proveedor)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)
//
//
//
////datos de reporte
ib_preview = False
This.Event ue_preview()
//dw_report.object.p_logo.filename = gs_logo
//dw_report.object.t_nombre.text = gs_empresa
//dw_report.object.t_user.text = gs_user
//
//
//sle_origen.text = gs_origen
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

type cbx_todos from checkbox within w_fi747_cntas_pagar_pend_x_prov
boolean visible = false
integer x = 2071
integer y = 60
integer width = 1143
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Todos Los Documentos"
boolean automatic = false
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

type cb_doc from commandbutton within w_fi747_cntas_pagar_pend_x_prov
boolean visible = false
integer x = 1751
integer y = 60
integer width = 283
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Tipo Doc"
end type

event clicked;str_parametros sl_param 

delete from tt_fin_tipo_doc ;

sl_param.dw1		= 'd_abc_doc_tipo_lista_tbl'
sl_param.titulo	= 'Lista de Documentos'
sl_param.opcion   = 19

sl_param.db1 		= 1500
sl_param.string1 	= '1TD'


OpenWithParm( w_abc_seleccion_lista_search, sl_param)
// tt_fin_tipo_doc


end event

type uo_1 from u_ingreso_rango_fechas within w_fi747_cntas_pagar_pend_x_prov
integer x = 91
integer y = 200
integer height = 88
integer taborder = 60
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type sle_nombre from singlelineedit within w_fi747_cntas_pagar_pend_x_prov
integer x = 521
integer y = 84
integer width = 1143
integer height = 76
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217750
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_fi747_cntas_pagar_pend_x_prov
integer x = 379
integer y = 84
integer width = 123
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;Str_seleccionar lstr_seleccionar

string ls_sql, ls_codigo, ls_data
boolean lb_ret

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql =  "SELECT PROVEEDOR AS CODIGO, " &
   							  + "NOM_PROVEEDOR AS NOMBRE, " &
								  + "FLAG_ESTADO AS ESTADO " &
								  + "FROM PROVEEDOR " 

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	em_proveedor.text	= lstr_seleccionar.param1[1]
	sle_nombre.text 	= lstr_seleccionar.param2[1]
END IF

end event

type em_proveedor from editmask within w_fi747_cntas_pagar_pend_x_prov
integer x = 69
integer y = 88
integer width = 283
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!!!!!!!"
end type

event modified;Long ll_count
String ls_codigo, ls_nombre

ls_codigo = TRIM(em_proveedor.text)

SELECT count(*) INTO :ll_count FROM proveedor p WHERE p.proveedor = :ls_codigo ;

IF ll_count = 0 THEN
	MessageBox('Aviso', 'Codigo de relacion no existe')
	Return
ELSE
	SELECT nom_proveedor INTO :ls_nombre FROM proveedor p WHERE p.proveedor = :ls_codigo ;
END IF

sle_nombre.text = TRIM(ls_nombre)
end event

type cb_1 from commandbutton within w_fi747_cntas_pagar_pend_x_prov
integer x = 1787
integer y = 184
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Recuperar"
end type

event clicked;String ls_proveedor 
Date ld_fec_ini, ld_fec_fin 

ib_preview = false

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()
ls_proveedor = TRIM(em_proveedor.text)

dw_report.Retrieve(ls_proveedor, ld_fec_ini, ld_fec_fin)

//datos de reporte
ib_preview = False
Parent.Event ue_preview()
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_user.text     = gs_user
dw_report.object.t_texto.text    = TRIM(sle_nombre.text)+' , del ' + string(ld_fec_ini,'dd/mm/yyyy')+ ' al ' + string(ld_fec_fin, 'dd/mm/yyyy')
end event

type dw_report from u_dw_rpt within w_fi747_cntas_pagar_pend_x_prov
integer x = 18
integer y = 368
integer width = 3200
integer height = 1804
string dataobject = "d_cntas_pagar_x_cod_rel_grd"
boolean livescroll = false
end type

event doubleclicked;call super::doubleclicked;String ls_cod_rel, ls_tipo_doc, ls_nro_doc

ls_cod_rel = this.object.cod_relacion[this.GetRow()]
ls_tipo_doc = this.object.tipo_doc[this.GetRow()]
ls_nro_doc = this.object.nro_doc[this.GetRow()]

// Mostrar detalle de asientos contables o informacion de pago en finanzas

end event

type gb_1 from groupbox within w_fi747_cntas_pagar_pend_x_prov
integer x = 32
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

