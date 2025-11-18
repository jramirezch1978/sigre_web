$PBExportHeader$w_cm713_atencion_x_ot.srw
forward
global type w_cm713_atencion_x_ot from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_cm713_atencion_x_ot
end type
type cb_3 from commandbutton within w_cm713_atencion_x_ot
end type
type rb_1 from radiobutton within w_cm713_atencion_x_ot
end type
type rb_2 from radiobutton within w_cm713_atencion_x_ot
end type
type sle_nro_orden from singlelineedit within w_cm713_atencion_x_ot
end type
type rb_3 from radiobutton within w_cm713_atencion_x_ot
end type
type cb_seleccion from commandbutton within w_cm713_atencion_x_ot
end type
type gb_1 from groupbox within w_cm713_atencion_x_ot
end type
type gb_2 from groupbox within w_cm713_atencion_x_ot
end type
end forward

global type w_cm713_atencion_x_ot from w_report_smpl
integer width = 2487
integer height = 1392
string title = "Atención de Materiales - OT (CM713)"
string menuname = "m_impresion"
uo_1 uo_1
cb_3 cb_3
rb_1 rb_1
rb_2 rb_2
sle_nro_orden sle_nro_orden
rb_3 rb_3
cb_seleccion cb_seleccion
gb_1 gb_1
gb_2 gb_2
end type
global w_cm713_atencion_x_ot w_cm713_atencion_x_ot

type variables

end variables

on w_cm713_atencion_x_ot.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.sle_nro_orden=create sle_nro_orden
this.rb_3=create rb_3
this.cb_seleccion=create cb_seleccion
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.sle_nro_orden
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.cb_seleccion
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_cm713_atencion_x_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.sle_nro_orden)
destroy(this.rb_3)
destroy(this.cb_seleccion)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;Date ld_desde, ld_hasta
string ls_nro_ot
integer li_verifica

if rb_2.checked = true then
	
	if IsNull(sle_nro_orden.text) or trim(sle_nro_orden.text) = '' then
		MessageBox('Error', 'Debe ingresar el numero de una OT')
	end if
	ls_nro_ot = trim(sle_nro_orden.text) + '%'
	
	insert into tt_ot_adm (ot_adm)
	select ot_adm
	  from ot_administracion;
	 
elseif rb_1.checked = true then
	
	ls_nro_ot = '%'
	insert into tt_ot_adm (ot_adm)
	select ot_adm
	  from ot_administracion;

elseif rb_3.checked = true then
	
	select count(*)
	  into :li_verifica
	  from tt_ot_adm;
	if li_verifica = 0 then
		messagebox('Aviso','Debe de Ingresar al menos una Administracion de OT por medio del boton de seleccion')
		return
	end if
	ls_nro_ot = '%%'
	
end if

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

idw_1.Retrieve(ld_desde, ld_hasta, ls_nro_ot)

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text     = gs_user
idw_1.object.t_empresa.text  = gs_empresa
idw_1.object.t_codigo.text   = dw_report.dataobject
idw_1.object.t_fecha.text    = string(ld_desde, 'dd/mm/yyyy') + ' AL ' + string(ld_hasta, 'dd/mm/yyyy')

end event

event ue_preview();call super::ue_preview;ib_preview = FALSE

end event

event ue_open_pre;call super::ue_open_pre;idw_1.Object.DataWindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_cm713_atencion_x_ot
integer x = 37
integer y = 416
integer width = 2345
integer height = 740
string dataobject = "d_rpt_atencion_ot_mat"
integer ii_zoom_actual = 100
end type

event dw_report::doubleclicked;call super::doubleclicked;string ls_oper_sec, ls_cod_art, ls_almacen
str_parametros lstr_param

choose case lower(dwo.name)
	case "cant_comp_prog"
		ls_oper_sec = this.object.oper_sec[row]
		ls_cod_art	= this.object.cod_art [row]
		ls_almacen	= this.object.almacen [row]
		
		lstr_param.dw1 = 'd_cns_cant_comp_prog_tbl'
		lstr_param.string1 = ls_oper_sec
		lstr_param.string2 = ls_cod_art
		lstr_param.string3 = ls_almacen
		OpenWithParm(w_cns_datos_cm714, lstr_param)
		
	case "cant_comp_sprog"
		ls_oper_sec = this.object.oper_sec[row]
		ls_cod_art	= this.object.cod_art [row]
		ls_almacen	= this.object.almacen [row]
		
		lstr_param.dw1 = 'd_cns_cant_comp_sprog_tbl'
		lstr_param.string1 = ls_oper_sec
		lstr_param.string2 = ls_cod_art
		lstr_param.string3 = ls_almacen
		OpenWithParm(w_cns_datos_cm714, lstr_param)

	case "cant_ingresada"
		ls_oper_sec = this.object.oper_sec[row]
		ls_cod_art	= this.object.cod_art [row]
		ls_almacen	= this.object.almacen [row]
		
		lstr_param.dw1 = 'd_cns_cant_ingreso_tbl'
		lstr_param.string1 = ls_oper_sec
		lstr_param.string2 = ls_cod_art
		lstr_param.string3 = ls_almacen
		OpenWithParm(w_cns_datos_cm714, lstr_param)

	case "cant_procesada"
		ls_oper_sec = this.object.oper_sec[row]
		ls_cod_art	= this.object.cod_art [row]
		ls_almacen	= this.object.almacen [row]
		
		lstr_param.dw1 = 'd_cns_cant_salida_tbl'
		lstr_param.string1 = ls_oper_sec
		lstr_param.string2 = ls_cod_art
		lstr_param.string3 = ls_almacen
		OpenWithParm(w_cns_datos_cm714, lstr_param)
		
	case "cant_programada"
		ls_oper_sec = this.object.oper_sec[row]
		ls_cod_art	= this.object.cod_art [row]
		ls_almacen	= this.object.almacen [row]
		
		lstr_param.dw1 = 'd_cns_cant_progamada_tbl'
		lstr_param.string1 = ls_oper_sec
		lstr_param.string2 = ls_cod_art
		lstr_param.string3 = ls_almacen
		OpenWithParm(w_cns_datos_cm714, lstr_param)

end choose

end event

type uo_1 from u_ingreso_rango_fechas within w_cm713_atencion_x_ot
integer x = 1047
integer y = 104
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_3 from commandbutton within w_cm713_atencion_x_ot
integer x = 1024
integer y = 288
integer width = 370
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.Event ue_retrieve()
end event

type rb_1 from radiobutton within w_cm713_atencion_x_ot
integer x = 73
integer y = 104
integer width = 421
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;sle_nro_orden.enabled = false
cb_seleccion.enabled = false
end event

type rb_2 from radiobutton within w_cm713_atencion_x_ot
integer x = 73
integer y = 192
integer width = 421
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Ord Trabjo"
end type

event clicked;if this.checked then
	sle_nro_orden.enabled = true
	cb_seleccion.enabled	 = false
else
	sle_nro_orden.enabled = false
end if
end event

type sle_nro_orden from singlelineedit within w_cm713_atencion_x_ot
integer x = 526
integer y = 192
integer width = 421
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type rb_3 from radiobutton within w_cm713_atencion_x_ot
integer x = 73
integer y = 280
integer width = 421
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT Adm"
end type

event clicked;if this.checked then
	cb_seleccion.enabled = true
	sle_nro_orden.enabled = false
else
	cb_seleccion.enabled = false
end if
end event

type cb_seleccion from commandbutton within w_cm713_atencion_x_ot
integer x = 526
integer y = 276
integer width = 421
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccion..."
end type

event clicked;open(w_seleccion_ot_adm)
end event

type gb_1 from groupbox within w_cm713_atencion_x_ot
integer x = 1024
integer y = 32
integer width = 1358
integer height = 196
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

type gb_2 from groupbox within w_cm713_atencion_x_ot
integer x = 37
integer y = 32
integer width = 955
integer height = 356
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

