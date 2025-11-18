$PBExportHeader$w_pr730_cencos_por_cenbenef_tbl.srw
forward
global type w_pr730_cencos_por_cenbenef_tbl from w_report_smpl
end type
type cb_2 from commandbutton within w_pr730_cencos_por_cenbenef_tbl
end type
type em_descripcion from editmask within w_pr730_cencos_por_cenbenef_tbl
end type
type em_origen from singlelineedit within w_pr730_cencos_por_cenbenef_tbl
end type
type cbx_planta from checkbox within w_pr730_cencos_por_cenbenef_tbl
end type
type sle_planta from singlelineedit within w_pr730_cencos_por_cenbenef_tbl
end type
type em_desc_planta from editmask within w_pr730_cencos_por_cenbenef_tbl
end type
type cbx_origen from checkbox within w_pr730_cencos_por_cenbenef_tbl
end type
type rb_1 from radiobutton within w_pr730_cencos_por_cenbenef_tbl
end type
type rb_2 from radiobutton within w_pr730_cencos_por_cenbenef_tbl
end type
type gb_3 from groupbox within w_pr730_cencos_por_cenbenef_tbl
end type
type gb_1 from groupbox within w_pr730_cencos_por_cenbenef_tbl
end type
type gb_2 from groupbox within w_pr730_cencos_por_cenbenef_tbl
end type
end forward

global type w_pr730_cencos_por_cenbenef_tbl from w_report_smpl
integer width = 2373
integer height = 2056
string title = "Relacion Cencos / CenBenef(PR730)"
string menuname = "m_reporte"
long backcolor = 67108864
event ue_query_retrieve ( )
cb_2 cb_2
em_descripcion em_descripcion
em_origen em_origen
cbx_planta cbx_planta
sle_planta sle_planta
em_desc_planta em_desc_planta
cbx_origen cbx_origen
rb_1 rb_1
rb_2 rb_2
gb_3 gb_3
gb_1 gb_1
gb_2 gb_2
end type
global w_pr730_cencos_por_cenbenef_tbl w_pr730_cencos_por_cenbenef_tbl

event ue_query_retrieve();SetPointer(HourGlass!)
This.event ue_retrieve()
SetPointer(Arrow!)
end event

on w_pr730_cencos_por_cenbenef_tbl.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_2=create cb_2
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cbx_planta=create cbx_planta
this.sle_planta=create sle_planta
this.em_desc_planta=create em_desc_planta
this.cbx_origen=create cbx_origen
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cbx_planta
this.Control[iCurrent+5]=this.sle_planta
this.Control[iCurrent+6]=this.em_desc_planta
this.Control[iCurrent+7]=this.cbx_origen
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.gb_3
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_pr730_cencos_por_cenbenef_tbl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cbx_planta)
destroy(this.sle_planta)
destroy(this.em_desc_planta)
destroy(this.cbx_origen)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String ls_cod_origen, ls_cod_planta

ls_cod_origen = em_origen.text
ls_cod_planta = sle_planta.text

if cbx_origen.checked = true then
	ls_cod_origen = '%%'
else
	ls_cod_origen 	= trim(em_origen.text)
	IF ls_cod_origen = '' or isnull(ls_cod_origen) then
		Messagebox('Producción', 'Debe de Indicar un Código de Origen')
		Return
	end if
	
end if

if cbx_planta.checked = true then
	ls_cod_planta = '%%'
else
	ls_cod_planta 	= trim(sle_planta.text)
	IF ls_cod_planta = '' or isnull(ls_cod_planta) then
		Messagebox('Producción', 'Debe de Indicar un Código de Planta')
		Return
	end if
end if

if rb_1.checked = true then
	dw_report.dataobject = 'd_abc_cencos_por_centro_benef_tbl'
	dw_report.settransobject(sqlca)
   idw_1.Retrieve(ls_cod_planta, ls_cod_origen)
	idw_1.Object.cabecera_t.text = 'Reporte de Centros de Costo por Centros de Benefico'
else
	dw_report.dataobject = 'd_abc_centro_benef_por_cencos_tbl'
	dw_report.settransobject(sqlca)
   idw_1.Retrieve(ls_cod_planta, ls_cod_origen)
	idw_1.Object.cabecera_t.text = 'Reporte de Centros de Benefico por Centros de Costo'
end if

idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user


end event

type dw_report from w_report_smpl`dw_report within w_pr730_cencos_por_cenbenef_tbl
integer x = 46
integer y = 596
integer width = 2249
integer height = 1248
string dataobject = "d_abc_cencos_por_centro_benef_tbl"
end type

type cb_2 from commandbutton within w_pr730_cencos_por_cenbenef_tbl
integer x = 1417
integer y = 424
integer width = 855
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type em_descripcion from editmask within w_pr730_cencos_por_cenbenef_tbl
integer x = 389
integer y = 196
integer width = 663
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from singlelineedit within w_pr730_cencos_por_cenbenef_tbl
event dobleclick pbm_lbuttondblclk
integer x = 247
integer y = 196
integer width = 128
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type cbx_planta from checkbox within w_pr730_cencos_por_cenbenef_tbl
integer x = 1170
integer y = 184
integer width = 78
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	
	sle_planta.enabled = false
	em_desc_planta.text = '' 
	
else
	
	sle_planta.enabled = true

end if
end event

type sle_planta from singlelineedit within w_pr730_cencos_por_cenbenef_tbl
event dobleclick pbm_lbuttondblclk
integer x = 1298
integer y = 188
integer width = 128
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_planta as codigo_de_planta, " & 
		  +"desc_planta AS nombre_de_planta " &
		  + "FROM tg_plantas " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_desc_planta.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Planta')
	return
end if

SELECT desc_planta INTO :ls_desc
FROM tg_plantas
WHERE cod_planta =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Planta no existe')
	return
end if

em_desc_planta.text = ls_desc

end event

type em_desc_planta from editmask within w_pr730_cencos_por_cenbenef_tbl
integer x = 1426
integer y = 188
integer width = 745
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cbx_origen from checkbox within w_pr730_cencos_por_cenbenef_tbl
integer x = 155
integer y = 184
integer width = 78
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	
	em_origen.enabled = false
	em_origen.text = '' 
	
else
	
	em_origen.enabled = true

end if
end event

type rb_1 from radiobutton within w_pr730_cencos_por_cenbenef_tbl
integer x = 59
integer y = 396
integer width = 1239
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centros de Costo Por Centros de Beneficio"
end type

type rb_2 from radiobutton within w_pr730_cencos_por_cenbenef_tbl
integer x = 59
integer y = 476
integer width = 1239
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centros de Beneficio Por Centros de Costo "
end type

type gb_3 from groupbox within w_pr730_cencos_por_cenbenef_tbl
integer x = 114
integer y = 128
integer width = 978
integer height = 168
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_1 from groupbox within w_pr730_cencos_por_cenbenef_tbl
integer x = 1147
integer y = 128
integer width = 1070
integer height = 168
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Todas   -   Seleccione Planta"
end type

type gb_2 from groupbox within w_pr730_cencos_por_cenbenef_tbl
integer x = 59
integer y = 40
integer width = 2222
integer height = 324
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Filtro"
end type

