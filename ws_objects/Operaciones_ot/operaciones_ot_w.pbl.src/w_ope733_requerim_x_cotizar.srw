$PBExportHeader$w_ope733_requerim_x_cotizar.srw
forward
global type w_ope733_requerim_x_cotizar from w_rpt
end type
type sle_codigo from singlelineedit within w_ope733_requerim_x_cotizar
end type
type sle_descrip from singlelineedit within w_ope733_requerim_x_cotizar
end type
type pb_1 from picturebutton within w_ope733_requerim_x_cotizar
end type
type rb_cencos_slc from radiobutton within w_ope733_requerim_x_cotizar
end type
type rb_almacen from radiobutton within w_ope733_requerim_x_cotizar
end type
type rb_ot_adm from radiobutton within w_ope733_requerim_x_cotizar
end type
type rb_fecha from radiobutton within w_ope733_requerim_x_cotizar
end type
type uo_1 from u_ingreso_rango_fechas within w_ope733_requerim_x_cotizar
end type
type cb_2 from commandbutton within w_ope733_requerim_x_cotizar
end type
type dw_report from u_dw_rpt within w_ope733_requerim_x_cotizar
end type
type gb_1 from groupbox within w_ope733_requerim_x_cotizar
end type
end forward

global type w_ope733_requerim_x_cotizar from w_rpt
integer width = 3278
integer height = 1984
string title = "Requerimientos solicitados a cotizar (OPE733)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
sle_codigo sle_codigo
sle_descrip sle_descrip
pb_1 pb_1
rb_cencos_slc rb_cencos_slc
rb_almacen rb_almacen
rb_ot_adm rb_ot_adm
rb_fecha rb_fecha
uo_1 uo_1
cb_2 cb_2
dw_report dw_report
gb_1 gb_1
end type
global w_ope733_requerim_x_cotizar w_ope733_requerim_x_cotizar

on w_ope733_requerim_x_cotizar.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.sle_codigo=create sle_codigo
this.sle_descrip=create sle_descrip
this.pb_1=create pb_1
this.rb_cencos_slc=create rb_cencos_slc
this.rb_almacen=create rb_almacen
this.rb_ot_adm=create rb_ot_adm
this.rb_fecha=create rb_fecha
this.uo_1=create uo_1
this.cb_2=create cb_2
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codigo
this.Control[iCurrent+2]=this.sle_descrip
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.rb_cencos_slc
this.Control[iCurrent+5]=this.rb_almacen
this.Control[iCurrent+6]=this.rb_ot_adm
this.Control[iCurrent+7]=this.rb_fecha
this.Control[iCurrent+8]=this.uo_1
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.dw_report
this.Control[iCurrent+11]=this.gb_1
end on

on w_ope733_requerim_x_cotizar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codigo)
destroy(this.sle_descrip)
destroy(this.pb_1)
destroy(this.rb_cencos_slc)
destroy(this.rb_almacen)
destroy(this.rb_ot_adm)
destroy(this.rb_fecha)
destroy(this.uo_1)
destroy(this.cb_2)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = FALSE
THIS.Event ue_preview()

rb_fecha.checked = enabled
sle_codigo.text = ''
sle_codigo.enabled = false
sle_descrip.text = ''
sle_descrip.enabled = false



end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_retrieve;call super::ue_retrieve;String ls_codigo, ls_texto
Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

IF rb_fecha.checked=false and &
	rb_ot_adm.checked=false and &
	rb_almacen.checked=false and &
	rb_cencos_slc.checked=false then
	messagebox('Aviso','Seleccione una opción')
	return
end if

IF rb_fecha.checked=true then
	idw_1.dataobject = 'd_rpt_artic_solicitados_cotizar_tbl'	
elseif rb_ot_adm.checked=true then
	idw_1.dataobject = 'd_rpt_artic_solicitados_cotizar_tbl'	
end if 
idw_1.SettransObject(sqlca)

IF rb_fecha.checked=true then
	ls_texto = 'Todos '
else
	ls_codigo = TRIM( sle_codigo.text )
	ls_texto = TRIM( sle_descrip.text )
end if

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_texto.text = ls_texto + ' - Del ' + string(ld_fec_ini,'dd/mm/yyyy') + ' al ' + string(ld_fec_fin,'dd/mm/yyyy')
idw_1.object.t_user.text = gs_user

IF rb_fecha.checked=true then
	idw_1.Retrieve(ld_fec_ini, ld_fec_fin)
ELSE
	idw_1.Retrieve(ls_codigo, ld_fec_ini, ld_fec_fin)
END IF


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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_filter();call super::ue_filter;idw_1.GroupCalc()
end event

type sle_codigo from singlelineedit within w_ope733_requerim_x_cotizar
integer x = 658
integer y = 100
integer width = 306
integer height = 84
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;Long ll_count
String ls_codigo, ls_nombre

ls_codigo = TRIM(sle_codigo.text)

IF rb_ot_adm.checked=true then
	
	SELECT count(*)
     INTO :ll_count
	  FROM ot_administracion
	 WHERE ot_adm = :ls_codigo ;

	IF ll_count > 0 THEN
		SELECT descripcion
		  INTO :ls_nombre
		  FROM ot_administracion
		 WHERE ot_adm = :ls_codigo ;
		
		sle_descrip.text = ls_nombre
	END IF
ELSEIF rb_almacen.checked = true THEN	
	
	SELECT count(*)
     INTO :ll_count
	  FROM almacen
	 WHERE almacen = :ls_codigo ;

	IF ll_count > 0 THEN
		SELECT desc_almacen
		  INTO :ls_nombre
		  FROM almacen
		 WHERE almacen = :ls_codigo ;
		
		sle_descrip.text = ls_nombre
	END IF

ELSEIF rb_cencos_slc.checked = true THEN		

	SELECT count(*)
     INTO :ll_count
	  FROM centros_costo
	 WHERE cencos = :ls_codigo ;

	IF ll_count > 0 THEN
		SELECT desc_cencos
		  INTO :ls_nombre
		  FROM centros_costo
		 WHERE cencos = :ls_codigo ;
		
		sle_descrip.text = ls_nombre
	END IF
END IF
end event

type sle_descrip from singlelineedit within w_ope733_requerim_x_cotizar
integer x = 1143
integer y = 100
integer width = 1353
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_ope733_requerim_x_cotizar
integer x = 987
integer y = 96
integer width = 128
integer height = 104
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String ls_codigo, ls_descrip
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'

IF rb_ot_adm.checked = true THEN

	lstr_seleccionar.s_sql = 'SELECT ot_administracion.ot_adm  AS codigo, '&
											 +'ot_administracion.descripcion AS descripcion '&     	
		 		   						 +'FROM ot_administracion '
   IF lstr_seleccionar.s_seleccion = 'S' THEN
		OpenWithParm(w_seleccionar,lstr_seleccionar)	
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			sle_codigo.text = lstr_seleccionar.param1[1]
			sle_descrip.text = lstr_seleccionar.param2[1]
		END IF
	END IF
	
ELSEIF rb_almacen.checked = true THEN
	
	lstr_seleccionar.s_sql = 'SELECT almacen.almacen  AS codigo, '&
											 +'almacen.desc_almacen AS descripcion '&     	
		 		   						 +'FROM almacen '
   IF lstr_seleccionar.s_seleccion = 'S' THEN
		OpenWithParm(w_seleccionar,lstr_seleccionar)	
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			sle_codigo.text = lstr_seleccionar.param1[1]
			sle_descrip.text = lstr_seleccionar.param2[1]
		END IF
	END IF
	
ELSEIF rb_cencos_slc.checked = true THEN	

	lstr_seleccionar.s_sql = 'SELECT centros_costo.cencos  AS codigo, '&
											 +'centros_costo.desc_cencos AS descripcion '&     	
		 		   						 +'FROM centros_costo '
   IF lstr_seleccionar.s_seleccion = 'S' THEN
		OpenWithParm(w_seleccionar,lstr_seleccionar)	
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			sle_codigo.text = lstr_seleccionar.param1[1]
			sle_descrip.text = lstr_seleccionar.param2[1]
		END IF
	END IF
	
END IF
end event

type rb_cencos_slc from radiobutton within w_ope733_requerim_x_cotizar
integer x = 50
integer y = 308
integer width = 553
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "x centro costo slc"
end type

event clicked;//sle_codigo.text = ''
sle_codigo.enabled = true
//sle_descrip.text = ''
sle_descrip.enabled = true
pb_1.enabled = true

end event

type rb_almacen from radiobutton within w_ope733_requerim_x_cotizar
integer x = 50
integer y = 236
integer width = 389
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x almacen"
end type

event clicked;//sle_codigo.text = ''
sle_codigo.enabled = true
//sle_descrip.text = ''
sle_descrip.enabled = true
pb_1.enabled = true

end event

type rb_ot_adm from radiobutton within w_ope733_requerim_x_cotizar
integer x = 50
integer y = 164
integer width = 389
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x ot_adm"
end type

event clicked;//sle_codigo.text = ''
sle_codigo.enabled = true
//sle_descrip.text = ''
sle_descrip.enabled = true
pb_1.enabled = true

end event

type rb_fecha from radiobutton within w_ope733_requerim_x_cotizar
integer x = 50
integer y = 92
integer width = 389
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x fecha"
end type

event clicked;sle_codigo.text = ''
sle_codigo.enabled = false
sle_descrip.text = ''
sle_descrip.enabled = false
pb_1.enabled = false

end event

type uo_1 from u_ingreso_rango_fechas within w_ope733_requerim_x_cotizar
integer x = 658
integer y = 248
integer taborder = 40
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') 
of_set_fecha(today(), today())
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_2 from commandbutton within w_ope733_requerim_x_cotizar
integer x = 2711
integer y = 176
integer width = 315
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_ope733_requerim_x_cotizar
integer y = 472
integer width = 3186
integer height = 1296
string dataobject = "d_rpt_artic_solicitados_cotizar_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ope733_requerim_x_cotizar
integer x = 18
integer y = 16
integer width = 2533
integer height = 372
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opciones"
end type

