$PBExportHeader$w_cm786_plan_anual_de_compras.srw
forward
global type w_cm786_plan_anual_de_compras from w_rpt
end type
type rb_4 from radiobutton within w_cm786_plan_anual_de_compras
end type
type rb_3 from radiobutton within w_cm786_plan_anual_de_compras
end type
type sle_desc_ot_adm from singlelineedit within w_cm786_plan_anual_de_compras
end type
type sle_ot_adm from singlelineedit within w_cm786_plan_anual_de_compras
end type
type sle_desc_art from singlelineedit within w_cm786_plan_anual_de_compras
end type
type sle_cod_art from singlelineedit within w_cm786_plan_anual_de_compras
end type
type sle_nro_ot from singlelineedit within w_cm786_plan_anual_de_compras
end type
type sle_titulo_ot from singlelineedit within w_cm786_plan_anual_de_compras
end type
type sle_desc_almacen from singlelineedit within w_cm786_plan_anual_de_compras
end type
type sle_almacen from singlelineedit within w_cm786_plan_anual_de_compras
end type
type cbx_ot from checkbox within w_cm786_plan_anual_de_compras
end type
type cbx_cod_art from checkbox within w_cm786_plan_anual_de_compras
end type
type cbx_almacen from checkbox within w_cm786_plan_anual_de_compras
end type
type cbx_ot_adm from checkbox within w_cm786_plan_anual_de_compras
end type
type rb_1 from radiobutton within w_cm786_plan_anual_de_compras
end type
type cb_1 from commandbutton within w_cm786_plan_anual_de_compras
end type
type dw_report from u_dw_rpt within w_cm786_plan_anual_de_compras
end type
type em_year from editmask within w_cm786_plan_anual_de_compras
end type
type st_1 from statictext within w_cm786_plan_anual_de_compras
end type
end forward

global type w_cm786_plan_anual_de_compras from w_rpt
integer width = 3246
integer height = 1984
string title = "Plan Anual de Compras(CM786)"
string menuname = "m_impresion"
long backcolor = 67108864
rb_4 rb_4
rb_3 rb_3
sle_desc_ot_adm sle_desc_ot_adm
sle_ot_adm sle_ot_adm
sle_desc_art sle_desc_art
sle_cod_art sle_cod_art
sle_nro_ot sle_nro_ot
sle_titulo_ot sle_titulo_ot
sle_desc_almacen sle_desc_almacen
sle_almacen sle_almacen
cbx_ot cbx_ot
cbx_cod_art cbx_cod_art
cbx_almacen cbx_almacen
cbx_ot_adm cbx_ot_adm
rb_1 rb_1
cb_1 cb_1
dw_report dw_report
em_year em_year
st_1 st_1
end type
global w_cm786_plan_anual_de_compras w_cm786_plan_anual_de_compras

type variables
String 	is_almacen, is_ot_adm, is_cod_art, &
			is_nro_ot, is_estado, is_func
long		il_year			
end variables

event ue_retrieve;call super::ue_retrieve;sTRING 	ls_mensaje, ls_cod_art, ls_desc_art

il_year =Long(em_year.Text)

if IsNull(il_year) or il_year = 0 then
	MessageBox('COMPRAS', 'NO HA INGRESO UN AÑO VALIDO',StopSign!)
	return
end if

if cbx_almacen.checked then
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un almacen')
		sle_almacen.SetFocus( )
		return
	end if
	is_almacen = trim(sle_almacen.text) + '%'
else
	is_almacen = '%%'
end if


if cbx_ot_adm.checked then
	if trim(sle_ot_adm.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un OT_ADM')
		sle_ot_adm.SetFocus( )
		return
	end if
	is_ot_adm = trim(sle_ot_adm.text) + '%'
else
	is_ot_adm = '%%'
end if

if cbx_cod_art.checked then
	if trim(sle_cod_art.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un OT_ADM')
		sle_cod_art.SetFocus( )
		return
	end if
	ls_cod_art = trim(sle_cod_art.text) + '%'
else
	ls_cod_art = '%%'
end if

if cbx_ot.checked then
	if trim(sle_nro_ot.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un OT_ADM')
		sle_nro_ot.SetFocus( )
		return
	end if
	is_nro_ot = trim(sle_nro_ot.text) + '%'
else
	is_nro_ot = '%%'
end if

is_func = '0'

IF rb_1.checked THEN  // Aprobados
	is_estado = '1'
ELSEIF rb_3.checked THEN //Presupuestados
   is_estado = '1, 2, 3'
ELSEIF rb_4.checked THEN // Por Atender
	is_estado = '1, 3'
	is_func = '1'
END IF

//create or replace procedure USP_CMP_PLAN_ANUAL_COMPRAS_OT( 
//       ani_year             in NUMBER,
//       asi_almacen          IN almacen.almacen%TYPE,
//       asi_ot_adm           IN ot_administracion.ot_adm%TYPE,
//       asi_cod_art          IN articulo.cod_art%TYPE,
//       asi_nro_ot           IN orden_trabajo.nro_orden%TYPE,
//       asi_estado           IN orden_trabajo.flag_estado%TYPE
//)is

DECLARE USP_CMP_PLAN_ANUAL_COMPRAS_OT PROCEDURE FOR
	USP_CMP_PLAN_ANUAL_COMPRAS_OT( :il_year,
											 :is_almacen,
											 :is_ot_adm,
											 :ls_cod_art, 
											 :is_nro_ot,
											 :is_estado,
											 :is_func);
	
EXECUTE USP_CMP_PLAN_ANUAL_COMPRAS_OT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_CMP_PLAN_ANUAL_COMPRAS_OT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje)	
	return
END IF

CLOSE USP_CMP_PLAN_ANUAL_COMPRAS_OT;

idw_1.Retrieve()
idw_1.Visible = True
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.Object.t_user.text 		= gs_user
idw_1.Object.p_logo.filename 	= gs_logo
idw_1.object.t_objeto.text		= this.ClassName( )

if cbx_almacen.checked then
	idw_1.object.t_subtitulo1.text = sle_desc_almacen.text
else
	idw_1.object.t_subtitulo1.text = 'TODOS LOS ALMACENES'
end if


if cbx_ot_adm.checked then
	idw_1.object.t_subtitulo2.text = sle_desc_ot_adm.text
else
	idw_1.object.t_subtitulo2.text = 'TODOS LOS OT_ADM'
end if

if cbx_cod_art.checked then
	idw_1.object.t_desc_art.visible = false 
else
	idw_1.object.t_desc_art.visible = true 
	idw_1.object.t_desc_art.text = 'TODOS LOS ARTÍCULOS'
end if

if cbx_ot.checked then
	idw_1.object.t_subtitulo4.text = sle_nro_ot.text
else
	idw_1.object.t_subtitulo4.text = 'TODOS LAS ORDENES DE TRABAJO'
end if

if rb_1.checked then
	idw_1.object.t_subtitulo5.text = 'SOLO APROBADOS'
elseif rb_3.checked then
	idw_1.object.t_subtitulo5.text = 'SOLO PRESUPUESTADOS'
elseif rb_4.checked then
	idw_1.object.t_subtitulo5.text = 'SOLO POR ATENDER'	
end if

RETURN

end event

on w_cm786_plan_anual_de_compras.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_4=create rb_4
this.rb_3=create rb_3
this.sle_desc_ot_adm=create sle_desc_ot_adm
this.sle_ot_adm=create sle_ot_adm
this.sle_desc_art=create sle_desc_art
this.sle_cod_art=create sle_cod_art
this.sle_nro_ot=create sle_nro_ot
this.sle_titulo_ot=create sle_titulo_ot
this.sle_desc_almacen=create sle_desc_almacen
this.sle_almacen=create sle_almacen
this.cbx_ot=create cbx_ot
this.cbx_cod_art=create cbx_cod_art
this.cbx_almacen=create cbx_almacen
this.cbx_ot_adm=create cbx_ot_adm
this.rb_1=create rb_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.em_year=create em_year
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_4
this.Control[iCurrent+2]=this.rb_3
this.Control[iCurrent+3]=this.sle_desc_ot_adm
this.Control[iCurrent+4]=this.sle_ot_adm
this.Control[iCurrent+5]=this.sle_desc_art
this.Control[iCurrent+6]=this.sle_cod_art
this.Control[iCurrent+7]=this.sle_nro_ot
this.Control[iCurrent+8]=this.sle_titulo_ot
this.Control[iCurrent+9]=this.sle_desc_almacen
this.Control[iCurrent+10]=this.sle_almacen
this.Control[iCurrent+11]=this.cbx_ot
this.Control[iCurrent+12]=this.cbx_cod_art
this.Control[iCurrent+13]=this.cbx_almacen
this.Control[iCurrent+14]=this.cbx_ot_adm
this.Control[iCurrent+15]=this.rb_1
this.Control[iCurrent+16]=this.cb_1
this.Control[iCurrent+17]=this.dw_report
this.Control[iCurrent+18]=this.em_year
this.Control[iCurrent+19]=this.st_1
end on

on w_cm786_plan_anual_de_compras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.sle_desc_ot_adm)
destroy(this.sle_ot_adm)
destroy(this.sle_desc_art)
destroy(this.sle_cod_art)
destroy(this.sle_nro_ot)
destroy(this.sle_titulo_ot)
destroy(this.sle_desc_almacen)
destroy(this.sle_almacen)
destroy(this.cbx_ot)
destroy(this.cbx_cod_art)
destroy(this.cbx_almacen)
destroy(this.cbx_ot_adm)
destroy(this.rb_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.em_year)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;em_year.text = string( year( today() ) )
idw_1 = dw_report
idw_1.SetTransObject(sqlca)
event ue_preview()
idw_1.ii_zoom_actual = 100
idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))

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

type rb_4 from radiobutton within w_cm786_plan_anual_de_compras
integer x = 32
integer y = 300
integer width = 489
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Atender"
boolean lefttext = true
boolean righttoleft = true
end type

type rb_3 from radiobutton within w_cm786_plan_anual_de_compras
integer x = 32
integer y = 220
integer width = 489
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Presupuestado"
boolean lefttext = true
boolean righttoleft = true
end type

type sle_desc_ot_adm from singlelineedit within w_cm786_plan_anual_de_compras
integer x = 1568
integer y = 16
integer width = 1211
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_ot_adm from singlelineedit within w_cm786_plan_anual_de_compras
event dobleclick pbm_lbuttondblclk
integer x = 1234
integer y = 16
integer width = 329
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT OT_ADM AS CODIGO_OT_ADM, " &
	  	 + "descripcion AS DESCRIPCION_OT_ADM " &
	    + "FROM ot_administracion "
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
if ls_codigo <> '' then
	this.text 				= ls_codigo
	sle_desc_ot_adm.text = ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un OT_ADM')
	return
end if

SELECT descripcion 
	INTO :ls_desc
FROM ot_administracion
where ot_adm = :ls_codigo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'OT_ADM no existe, por favor verificar')
	return
end if

sle_desc_ot_adm.text = ls_desc


end event

type sle_desc_art from singlelineedit within w_cm786_plan_anual_de_compras
integer x = 1568
integer y = 200
integer width = 1211
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_cod_art from singlelineedit within w_cm786_plan_anual_de_compras
event dobleclick pbm_lbuttondblclk
integer x = 1234
integer y = 200
integer width = 329
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_art AS CODIGO_artículo, " &
	  	 + "DESC_art AS DESCRIPCION_artículo " &
	    + "FROM articulo " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
if ls_codigo <> '' then
	this.text 				= ls_codigo
	sle_desc_art.text 	= ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un código de artículo')
	return
end if

SELECT desc_art 
	INTO :ls_desc
FROM articulo
where cod_art = :ls_codigo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Código de Articulo no existe, por favor verificar')
	return
end if

sle_desc_art.text = ls_desc


end event

type sle_nro_ot from singlelineedit within w_cm786_plan_anual_de_compras
event dobleclick pbm_lbuttondblclk
integer x = 1234
integer y = 292
integer width = 329
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_ot_adm

if cbx_ot_adm.checked then
	if trim(sle_ot_adm.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un OT_ADM')
		sle_ot_adm.SetFocus( )
		return
	end if
	ls_ot_adm = trim(sle_ot_adm.text) + '%'
else
	ls_ot_adm = '%%'
end if

ls_sql = "SELECT nro_orden AS numero_orden, " &
	  	 + "titulo AS titulo_orden " &
	    + "FROM orden_trabajo " &
		 + "where ot_adm like '" + ls_ot_adm + "' " &
		 + "and flag_estado <> '0' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_titulo_ot.text 	= ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc, ls_ot_adm

if cbx_ot_adm.checked then
	if trim(sle_ot_adm.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un OT_ADM')
		sle_ot_adm.SetFocus( )
		return
	end if
	ls_ot_adm = trim(sle_ot_adm.text) + '%'
else
	ls_ot_adm = '%%'
end if


ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una Orden de Trabajo')
	return
end if

SELECT titulo 
	INTO :ls_desc
FROM orden_trabajo
where nro_orden = :ls_codigo
  and ot_adm like :ls_ot_adm;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Numero de OT no existe o no esta en el OT_ADM, por favor verificar')
	return
end if

sle_titulo_ot.text = ls_desc


end event

type sle_titulo_ot from singlelineedit within w_cm786_plan_anual_de_compras
integer x = 1568
integer y = 292
integer width = 1211
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_desc_almacen from singlelineedit within w_cm786_plan_anual_de_compras
integer x = 1568
integer y = 108
integer width = 1211
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_almacen from singlelineedit within w_cm786_plan_anual_de_compras
event dobleclick pbm_lbuttondblclk
integer x = 1234
integer y = 108
integer width = 329
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " &
		 + "where flag_tipo_almacen <> 'O'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_desc_almacen.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen 
  and flag_tipo_almacen <> 'O';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe o es un almacén de tránsito')
	return
end if

sle_desc_almacen.text = ls_desc


end event

type cbx_ot from checkbox within w_cm786_plan_anual_de_compras
integer x = 585
integer y = 300
integer width = 635
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por orden de trabajo"
boolean lefttext = true
boolean righttoleft = true
end type

event clicked;if this.checked then
	sle_nro_ot.enabled = true
else
	sle_nro_ot.enabled = false
end if
end event

type cbx_cod_art from checkbox within w_cm786_plan_anual_de_compras
integer x = 585
integer y = 208
integer width = 635
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Artículo"
boolean lefttext = true
boolean righttoleft = true
end type

event clicked;if this.checked then
	sle_cod_art.enabled = true
else
	sle_cod_art.enabled = false
end if
end event

type cbx_almacen from checkbox within w_cm786_plan_anual_de_compras
integer x = 585
integer y = 116
integer width = 635
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por almacen"
boolean lefttext = true
boolean righttoleft = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = true
else
	sle_almacen.enabled = false
end if
end event

type cbx_ot_adm from checkbox within w_cm786_plan_anual_de_compras
integer x = 585
integer y = 24
integer width = 635
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Administrador de OT "
boolean lefttext = true
boolean righttoleft = true
end type

event clicked;if this.checked then
	sle_ot_adm.enabled = true
else
	sle_ot_adm.enabled = false
end if
end event

type rb_1 from radiobutton within w_cm786_plan_anual_de_compras
integer x = 32
integer y = 140
integer width = 489
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aprobados"
boolean checked = true
boolean lefttext = true
boolean righttoleft = true
end type

type cb_1 from commandbutton within w_cm786_plan_anual_de_compras
integer x = 2843
integer y = 68
integer width = 283
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_cm786_plan_anual_de_compras
integer y = 420
integer width = 2930
integer height = 1316
integer taborder = 20
string dataobject = "d_rpt_plan_anual_compras_ot_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;string 			ls_cod_art
str_parametros  lstr_param
w_rpt_preview	lw_1

if this.RowCount() = 0 or row = 0 then return

//CHOOSE CASE dwo.Name
	    
	IF dwo.Name = 'cod_art' THEN  //Nota de Ingreso 

		ls_cod_art	 = this.object.cod_art [row]

			lstr_param.dw1     = 'd_plan_anual_detalle_articulo'
			lstr_param.titulo  = "Detalle de Artículo"
			lstr_param.tipo 	 = '6S1I'
			lstr_param.string1 = ls_cod_art
			lstr_param.string2 = is_almacen
			lstr_param.string3 = is_ot_adm
			lstr_param.string4 = is_nro_ot
			lstr_param.string5 = is_estado
			lstr_param.string6 = is_func
			lstr_param.int1 	 = il_year
			OpenSheetWithParm( lw_1, lstr_param, w_main, 0, Layered!)
	End IF
end event

type em_year from editmask within w_cm786_plan_anual_de_compras
integer x = 261
integer y = 32
integer width = 261
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean autoskip = true
boolean spin = true
double increment = 1
end type

type st_1 from statictext within w_cm786_plan_anual_de_compras
integer x = 41
integer y = 44
integer width = 165
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

