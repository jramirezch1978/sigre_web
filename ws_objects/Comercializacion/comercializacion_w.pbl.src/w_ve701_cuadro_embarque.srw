$PBExportHeader$w_ve701_cuadro_embarque.srw
forward
global type w_ve701_cuadro_embarque from w_rpt
end type
type cb_6 from commandbutton within w_ve701_cuadro_embarque
end type
type dw_ext from datawindow within w_ve701_cuadro_embarque
end type
type cb_5 from commandbutton within w_ve701_cuadro_embarque
end type
type cb_4 from commandbutton within w_ve701_cuadro_embarque
end type
type cb_3 from commandbutton within w_ve701_cuadro_embarque
end type
type cbx_format2 from checkbox within w_ve701_cuadro_embarque
end type
type cbx_format1 from checkbox within w_ve701_cuadro_embarque
end type
type st_3 from statictext within w_ve701_cuadro_embarque
end type
type rb_1 from radiobutton within w_ve701_cuadro_embarque
end type
type st_1 from statictext within w_ve701_cuadro_embarque
end type
type sle_1 from singlelineedit within w_ve701_cuadro_embarque
end type
type uo_1 from u_ingreso_rango_fechas within w_ve701_cuadro_embarque
end type
type cb_1 from commandbutton within w_ve701_cuadro_embarque
end type
type dw_report from u_dw_rpt within w_ve701_cuadro_embarque
end type
type gb_1 from groupbox within w_ve701_cuadro_embarque
end type
end forward

global type w_ve701_cuadro_embarque from w_rpt
integer width = 4370
integer height = 2132
string title = "(VE701) Cuadro de Embarque"
string menuname = "m_reporte"
long backcolor = 134217728
cb_6 cb_6
dw_ext dw_ext
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cbx_format2 cbx_format2
cbx_format1 cbx_format1
st_3 st_3
rb_1 rb_1
st_1 st_1
sle_1 sle_1
uo_1 uo_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ve701_cuadro_embarque w_ve701_cuadro_embarque

type variables
String is_doc_ov
end variables

on w_ve701_cuadro_embarque.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_6=create cb_6
this.dw_ext=create dw_ext
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cbx_format2=create cbx_format2
this.cbx_format1=create cbx_format1
this.st_3=create st_3
this.rb_1=create rb_1
this.st_1=create st_1
this.sle_1=create sle_1
this.uo_1=create uo_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_6
this.Control[iCurrent+2]=this.dw_ext
this.Control[iCurrent+3]=this.cb_5
this.Control[iCurrent+4]=this.cb_4
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.cbx_format2
this.Control[iCurrent+7]=this.cbx_format1
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.sle_1
this.Control[iCurrent+12]=this.uo_1
this.Control[iCurrent+13]=this.cb_1
this.Control[iCurrent+14]=this.dw_report
this.Control[iCurrent+15]=this.gb_1
end on

on w_ve701_cuadro_embarque.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_6)
destroy(this.dw_ext)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cbx_format2)
destroy(this.cbx_format1)
destroy(this.st_3)
destroy(this.rb_1)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)


idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text 	  = gs_user



ib_preview = false
idw_1.ii_zoom_actual = 140

THIS.Event ue_preview()



select doc_ov into :is_doc_ov from logparam where reckey = '1' ;

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type cb_6 from commandbutton within w_ve701_cuadro_embarque
integer x = 3182
integer y = 20
integer width = 402
integer height = 112
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Articulos"
end type

event clicked;Long ll_count

Date   ld_fecha_inicio,ld_fecha_final
str_parametros sl_param 


/**/


delete from tt_fin_rpt_art ;


sl_param.dw1		= 'd_abc_lista_articulos_vendidos_tbl'
sl_param.titulo	= 'Articulos'
sl_param.opcion   = 19
sl_param.db1 		= 1600
sl_param.string1 	= '1ARTF'
sl_param.string2 	= is_doc_ov
sl_param.tipo	 	= '1ARTF'
sl_param.date1 	= uo_1.of_get_fecha1()
sl_param.date2 	= uo_1.of_get_fecha2()


OpenWithParm( w_abc_seleccion_lista_search, sl_param)


sl_param = message.powerobjectparm


end event

type dw_ext from datawindow within w_ve701_cuadro_embarque
boolean visible = false
integer x = 1289
integer y = 260
integer width = 1225
integer height = 568
integer taborder = 40
boolean titlebar = true
string title = "Datos Financieros"
string dataobject = "d_ext_datos_financieros_tbl"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;String ls_banco,ls_tipo_doc,ls_nro_doc,ls_expresion

//filtrar Informacion
dw_ext.accepttext()

ls_banco    = dw_ext.object.cod_banco [1]
ls_tipo_doc = dw_ext.object.tipo_doc  [1]
ls_nro_doc  = dw_ext.object.nro_doc   [1]


if Isnull(ls_nro_doc) or trim(ls_nro_doc) = '' then
	ls_nro_doc = '%'
else	
	ls_nro_doc = trim(ls_nro_doc)+'%'
end if

ls_expresion = 'cod_banco = '+"'"+ls_banco+"' and tipo_doc = "+"'"+ls_tipo_doc+"' and nro_doc like "+"'"+ls_nro_doc+"'"



dw_report.SetFilter(ls_expresion)
dw_report.Filter( )

dw_ext.visible = false

end event

event constructor;settransobject(sqlca)

end event

type cb_5 from commandbutton within w_ve701_cuadro_embarque
integer x = 2194
integer y = 224
integer width = 663
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Datos Financieros"
end type

event clicked;dw_ext.reset()
dw_ext.Insertrow(0)
dw_ext.visible = true
end event

type cb_4 from commandbutton within w_ve701_cuadro_embarque
integer x = 713
integer y = 192
integer width = 87
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

event clicked;boolean 	lb_ret
String 	ls_codigo, ls_data, ls_sql ,ls_doc_ov
date		ld_fecha1, ld_Fecha2

ld_fecha1 = uo_1.of_get_fecha1( )
ld_fecha2 = uo_1.of_get_fecha2( )


select doc_ov into :ls_doc_ov from logparam where reckey = '1' ;

ls_sql = "SELECT OV.NRO_OV AS NRO_OVENTA , " & 
					+"OV.FEC_REGISTRO AS FECHA , " &
					+"OV.OBS,FLAG_ESTADO AS ESTADO " &
		 			+"FROM ORDEN_VENTA OV " &
			      +"WHERE TO_CHAR(OV.FEC_REGISTRO, 'yyyymmdd') BETWEEN '" + string(ld_Fecha1, 'yyyymmdd') + "' and '" + string(ld_fecha2, 'yyyymmdd') + "'" 				
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

IF ls_codigo <> '' THEN
	sle_1.text  = ls_codigo

END IF
	
end event

type cb_3 from commandbutton within w_ve701_cuadro_embarque
integer x = 2194
integer y = 108
integer width = 393
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Limpiar Datos"
end type

event clicked;rb_1.checked = false
cb_6.enabled = true
end event

type cbx_format2 from checkbox within w_ve701_cuadro_embarque
integer x = 1481
integer y = 164
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato 2"
end type

event clicked;if this.checked then
	cbx_format1.checked = false
end if	
end event

type cbx_format1 from checkbox within w_ve701_cuadro_embarque
integer x = 1481
integer y = 72
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato 1"
boolean checked = true
end type

event clicked;if this.checked then
	cbx_format2.checked = false
end if	
end event

type st_3 from statictext within w_ve701_cuadro_embarque
integer x = 2190
integer y = 348
integer width = 1426
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Solo se Visualizara Ordenes de VENTA DE EXPORTACION"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_ve701_cuadro_embarque
integer x = 2190
integer y = 24
integer width = 677
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Articulos"
boolean lefttext = true
end type

event clicked;if rb_1.checked then
	cb_6.enabled = false
else
	cb_6.enabled = true
end if	
end event

type st_1 from statictext within w_ve701_cuadro_embarque
integer x = 50
integer y = 204
integer width = 274
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "O.Venta :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_ve701_cuadro_embarque
integer x = 347
integer y = 192
integer width = 343
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type uo_1 from u_ingreso_rango_fechas within w_ve701_cuadro_embarque
integer x = 55
integer y = 80
integer taborder = 20
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(),today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin( date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_ve701_cuadro_embarque
integer x = 3182
integer y = 152
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_nro_ov
Date   ldt_fecha_inicio,ldt_fecha_final


ldt_fecha_inicio = uo_1.of_get_fecha1()
ldt_fecha_final  = uo_1.of_get_fecha2()
ls_nro_ov 		  = sle_1.text


IF Isnull(ls_nro_ov) OR Trim(ls_nro_ov) = '' THEN
	ls_nro_ov = '%'
ELSE
	ls_nro_ov = ls_nro_ov + '%'
END IF


IF rb_1.Checked THEN //todos los articulos
	//elimina tabla temporal
	delete from tt_fin_rpt_art ;
	//llena_tabla temporal
	Insert Into tt_fin_rpt_art
 	(cod_art)
	select distinct a.cod_art 
  	  from articulo a,articulo_mov_proy amp, orden_venta ov 
	 where (ov.nro_ov    = amp.nro_doc ) and
   	    (amp.cod_art  = a.cod_art   ) and
      	 (amp.tipo_doc = :is_doc_ov  ) and	
	       (amp.flag_estado <> '0' 	  ) and
   	    (trunc(ov.fec_registro) between :ldt_fecha_inicio and :ldt_fecha_final )	;
END IF	
long ll_count
select count(*) into :ll_count from tt_fin_rpt_art ;





if cbx_format1.checked then
	dw_report.dataobject = 'd_rpt_cuadro_embarque'
	dw_report.Settransobject (sqlca)
	idw_1.ii_zoom_actual = 140
elseif cbx_format2.checked then	
	dw_report.dataobject = 'd_rpt_cuadro_embarque_x_ov'
	dw_report.Settransobject (sqlca)
	idw_1.ii_zoom_actual = 100
else	
	Messagebox('Aviso','Debe Seleccionar Tipo de Formato para Reporte' )
	Return
end if	

ib_preview = false
Parent.Event ue_preview()


declare PB_USP_COM_RPT_CDO_EMBARQUE procedure for USP_COM_RPT_CDO_EMBARQUE(:ldt_fecha_inicio,:ldt_fecha_final,:ls_nro_ov);
execute PB_USP_COM_RPT_CDO_EMBARQUE ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

close	PB_USP_COM_RPT_CDO_EMBARQUE ;

dw_report.retrieve(ldt_fecha_inicio,ldt_fecha_final)
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text 	  = gs_user


end event

type dw_report from u_dw_rpt within w_ve701_cuadro_embarque
integer x = 18
integer y = 452
integer width = 4242
integer height = 1308
string dataobject = "d_rpt_cuadro_embarque"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;String ls_cod_art,ls_nro_embarque

IF row = 0 THEN RETURN

str_cns_pop lstr_1

This.accepttext ()



ls_cod_art 		 = this.object.cod_art  	 [row]
ls_nro_embarque = this.object.nro_embarque [row]


lstr_1.DataObject = 'd_rpt_cuadro_embarque_det'
lstr_1.Width = 2900
lstr_1.Height= 1300
lstr_1.title = 'Embarque - Instruccion - Caracteristicas'
lstr_1.arg [1] = ls_nro_embarque
lstr_1.arg [2] = ls_cod_art
lstr_1.Tipo_Cascada = 'R'


of_new_sheet(lstr_1)



end event

type gb_1 from groupbox within w_ve701_cuadro_embarque
integer x = 23
integer width = 2144
integer height = 420
integer taborder = 20
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

