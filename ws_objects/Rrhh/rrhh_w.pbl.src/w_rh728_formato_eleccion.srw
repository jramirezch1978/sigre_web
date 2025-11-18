$PBExportHeader$w_rh728_formato_eleccion.srw
forward
global type w_rh728_formato_eleccion from w_report_smpl
end type
type cb_2 from commandbutton within w_rh728_formato_eleccion
end type
type cbx_origen from checkbox within w_rh728_formato_eleccion
end type
type cbx_ttrab from checkbox within w_rh728_formato_eleccion
end type
type cb_3 from commandbutton within w_rh728_formato_eleccion
end type
type sle_origen from singlelineedit within w_rh728_formato_eleccion
end type
type st_3 from statictext within w_rh728_formato_eleccion
end type
type sle_ttrabajador from singlelineedit within w_rh728_formato_eleccion
end type
type st_2 from statictext within w_rh728_formato_eleccion
end type
type cb_1 from commandbutton within w_rh728_formato_eleccion
end type
type st_4 from statictext within w_rh728_formato_eleccion
end type
type sle_codigo from singlelineedit within w_rh728_formato_eleccion
end type
type cb_codigo from commandbutton within w_rh728_formato_eleccion
end type
type cbx_codigo from checkbox within w_rh728_formato_eleccion
end type
type st_nom_trabajador from statictext within w_rh728_formato_eleccion
end type
type gb_1 from groupbox within w_rh728_formato_eleccion
end type
end forward

global type w_rh728_formato_eleccion from w_report_smpl
integer width = 3589
integer height = 1812
string title = "(RH727) Liquidacion Anual - Retenciones"
string menuname = "m_impresion"
cb_2 cb_2
cbx_origen cbx_origen
cbx_ttrab cbx_ttrab
cb_3 cb_3
sle_origen sle_origen
st_3 st_3
sle_ttrabajador sle_ttrabajador
st_2 st_2
cb_1 cb_1
st_4 st_4
sle_codigo sle_codigo
cb_codigo cb_codigo
cbx_codigo cbx_codigo
st_nom_trabajador st_nom_trabajador
gb_1 gb_1
end type
global w_rh728_formato_eleccion w_rh728_formato_eleccion

on w_rh728_formato_eleccion.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_2=create cb_2
this.cbx_origen=create cbx_origen
this.cbx_ttrab=create cbx_ttrab
this.cb_3=create cb_3
this.sle_origen=create sle_origen
this.st_3=create st_3
this.sle_ttrabajador=create sle_ttrabajador
this.st_2=create st_2
this.cb_1=create cb_1
this.st_4=create st_4
this.sle_codigo=create sle_codigo
this.cb_codigo=create cb_codigo
this.cbx_codigo=create cbx_codigo
this.st_nom_trabajador=create st_nom_trabajador
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cbx_origen
this.Control[iCurrent+3]=this.cbx_ttrab
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.sle_origen
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_ttrabajador
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.sle_codigo
this.Control[iCurrent+12]=this.cb_codigo
this.Control[iCurrent+13]=this.cbx_codigo
this.Control[iCurrent+14]=this.st_nom_trabajador
this.Control[iCurrent+15]=this.gb_1
end on

on w_rh728_formato_eleccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.cbx_origen)
destroy(this.cbx_ttrab)
destroy(this.cb_3)
destroy(this.sle_origen)
destroy(this.st_3)
destroy(this.sle_ttrabajador)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.sle_codigo)
destroy(this.cb_codigo)
destroy(this.cbx_codigo)
destroy(this.st_nom_trabajador)
destroy(this.gb_1)
end on

event ue_retrieve;String	ls_origen, ls_tipo_trabaj, ls_codigo

if cbx_ttrab.checked then
	ls_tipo_trabaj = '%%'
else
	ls_tipo_trabaj = trim(sle_ttrabajador.text) + '%'
end if

if cbx_origen.checked then
	ls_origen = '%%'
else
	ls_origen = trim(sle_origen.text) + '%'
end if

if cbx_codigo.checked then
	ls_codigo = '%%'
else
	ls_codigo = trim(sle_codigo.text) + '%'
end if

dw_report.retrieve(ls_origen, ls_tipo_trabaj, ls_codigo)

dw_report.object.p_logo.filename 	= gs_logo
dw_report.object.t_nom_empresa.text = gnvo_app.empresa.is_nom_empresa
dw_report.object.t_ruc_empresa.text = gnvo_app.empresa.is_ruc


end event

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = true
//em_year.text = string(gnvo_app.of_fecha_actual(), 'yyyy')
end event

type dw_report from w_report_smpl`dw_report within w_rh728_formato_eleccion
integer x = 0
integer y = 340
integer width = 3520
integer height = 1056
integer taborder = 40
string dataobject = "d_rpt_formato_eleccion_snp_afp_tbl"
end type

type cb_2 from commandbutton within w_rh728_formato_eleccion
integer x = 2176
integer y = 48
integer width = 480
integer height = 124
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type cbx_origen from checkbox within w_rh728_formato_eleccion
integer x = 955
integer y = 144
integer width = 343
integer height = 84
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

event clicked;if this.checked then
	sle_origen.text	 = ''
	sle_origen.enabled = false
	cb_3.enabled = false
else
	sle_origen.enabled = true
	cb_3.enabled = true
end if	
end event

type cbx_ttrab from checkbox within w_rh728_formato_eleccion
integer x = 960
integer y = 56
integer width = 343
integer height = 84
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

event clicked;if this.checked then
	sle_ttrabajador.enabled = false
	cb_1.enabled = false
	sle_ttrabajador.text 	= ''
else
	sle_ttrabajador.enabled = true
	cb_1.enabled = true
end if	
end event

type cb_3 from commandbutton within w_rh728_formato_eleccion
integer x = 791
integer y = 148
integer width = 110
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO      , '&
								       +'ORIGEN.NOMBRE     AS DESCRIPCION   '&
				   				 	 +'FROM ORIGEN '&

														 
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_origen.text = lstr_seleccionar.param1[1]
END IF														 

end event

type sle_origen from singlelineedit within w_rh728_formato_eleccion
integer x = 571
integer y = 144
integer width = 183
integer height = 84
integer taborder = 40
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
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_rh728_formato_eleccion
integer x = 55
integer y = 156
integer width = 507
integer height = 56
boolean bringtotop = true
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

type sle_ttrabajador from singlelineedit within w_rh728_formato_eleccion
integer x = 571
integer y = 56
integer width = 183
integer height = 84
integer taborder = 50
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
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_rh728_formato_eleccion
integer x = 50
integer y = 68
integer width = 507
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_rh728_formato_eleccion
integer x = 786
integer y = 60
integer width = 110
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT TIPO_TRABAJADOR.TIPO_TRABAJADOR AS TTRABAJADOR , '&
								       +'TIPO_TRABAJADOR.DESC_TIPO_TRA   AS DESCRIPCION , '&
										 +'TIPO_TRABAJADOR.LIBRO_PLANILLA  AS NRO_LIBRO  '&
				   				 	 +'FROM TIPO_TRABAJADOR '&

														 
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_ttrabajador.text = lstr_seleccionar.param1[1]
END IF														 

end event

type st_4 from statictext within w_rh728_formato_eleccion
integer x = 55
integer y = 244
integer width = 507
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_codigo from singlelineedit within w_rh728_formato_eleccion
integer x = 576
integer y = 232
integer width = 311
integer height = 84
integer taborder = 50
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
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type cb_codigo from commandbutton within w_rh728_formato_eleccion
integer x = 891
integer y = 236
integer width = 110
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;String ls_sql, ls_tipo_trabaj, ls_return1, ls_return2

if cbx_ttrab.checked then
	ls_tipo_trabaj = '%%'
else
	ls_tipo_trabaj = trim(sle_ttrabajador.text) + '%'
end if

ls_sql = "select m.COD_TRABAJADOR as codigo_trabajador, " &
		 + "m.NOM_TRABAJADOR as nombre_trabajador " &
		 + "from vw_pr_trabajador m " &
		 + "where m.flag_estado = '1' " &
		 + "  and m.TIPO_TRABAJADOR = '" + ls_tipo_trabaj + "'"
		 
f_lista(ls_sql, ls_return1, ls_return2, '2')

sle_codigo.text = ls_return1
st_nom_trabajador.text = ls_return2
end event

type cbx_codigo from checkbox within w_rh728_formato_eleccion
integer x = 2368
integer y = 220
integer width = 302
integer height = 84
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

event clicked;if this.checked then
	sle_codigo.text	 = ''
	st_nom_trabajador.text = ''
	sle_codigo.enabled = false
	st_nom_trabajador.enabled = false
	cb_codigo.enabled = false
else
	sle_codigo.enabled = true
	st_nom_trabajador.enabled = true
	cb_codigo.enabled = true
end if	
end event

type st_nom_trabajador from statictext within w_rh728_formato_eleccion
integer x = 1006
integer y = 232
integer width = 1344
integer height = 84
boolean bringtotop = true
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

type gb_1 from groupbox within w_rh728_formato_eleccion
integer width = 2688
integer height = 332
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Datos"
end type

