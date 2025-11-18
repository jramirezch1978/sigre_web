$PBExportHeader$w_al744_antiguedad_saldos.srw
forward
global type w_al744_antiguedad_saldos from w_report_smpl
end type
type cb_1 from commandbutton within w_al744_antiguedad_saldos
end type
type sle_almacen from singlelineedit within w_al744_antiguedad_saldos
end type
type sle_descrip from singlelineedit within w_al744_antiguedad_saldos
end type
type st_2 from statictext within w_al744_antiguedad_saldos
end type
type cbx_almacen from checkbox within w_al744_antiguedad_saldos
end type
type st_1 from statictext within w_al744_antiguedad_saldos
end type
type sle_cod_art from singlelineedit within w_al744_antiguedad_saldos
end type
type sle_desc_art from singlelineedit within w_al744_antiguedad_saldos
end type
type cbx_articulo from checkbox within w_al744_antiguedad_saldos
end type
type cbx_cencos from checkbox within w_al744_antiguedad_saldos
end type
type st_3 from statictext within w_al744_antiguedad_saldos
end type
type sle_cencos from singlelineedit within w_al744_antiguedad_saldos
end type
type sle_desc_cencos from singlelineedit within w_al744_antiguedad_saldos
end type
type rb_cencos from radiobutton within w_al744_antiguedad_saldos
end type
type rb_articulo from radiobutton within w_al744_antiguedad_saldos
end type
type rb_tiempo from radiobutton within w_al744_antiguedad_saldos
end type
type gb_1 from groupbox within w_al744_antiguedad_saldos
end type
type gb_2 from groupbox within w_al744_antiguedad_saldos
end type
end forward

global type w_al744_antiguedad_saldos from w_report_smpl
integer width = 3570
integer height = 1808
string title = "Antiguedad de Saldos por Almacen (AL744)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
cb_1 cb_1
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
cbx_almacen cbx_almacen
st_1 st_1
sle_cod_art sle_cod_art
sle_desc_art sle_desc_art
cbx_articulo cbx_articulo
cbx_cencos cbx_cencos
st_3 st_3
sle_cencos sle_cencos
sle_desc_cencos sle_desc_cencos
rb_cencos rb_cencos
rb_articulo rb_articulo
rb_tiempo rb_tiempo
gb_1 gb_1
gb_2 gb_2
end type
global w_al744_antiguedad_saldos w_al744_antiguedad_saldos

type variables

end variables

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al744_antiguedad_saldos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.cbx_almacen=create cbx_almacen
this.st_1=create st_1
this.sle_cod_art=create sle_cod_art
this.sle_desc_art=create sle_desc_art
this.cbx_articulo=create cbx_articulo
this.cbx_cencos=create cbx_cencos
this.st_3=create st_3
this.sle_cencos=create sle_cencos
this.sle_desc_cencos=create sle_desc_cencos
this.rb_cencos=create rb_cencos
this.rb_articulo=create rb_articulo
this.rb_tiempo=create rb_tiempo
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_almacen
this.Control[iCurrent+3]=this.sle_descrip
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cbx_almacen
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_cod_art
this.Control[iCurrent+8]=this.sle_desc_art
this.Control[iCurrent+9]=this.cbx_articulo
this.Control[iCurrent+10]=this.cbx_cencos
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.sle_cencos
this.Control[iCurrent+13]=this.sle_desc_cencos
this.Control[iCurrent+14]=this.rb_cencos
this.Control[iCurrent+15]=this.rb_articulo
this.Control[iCurrent+16]=this.rb_tiempo
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
end on

on w_al744_antiguedad_saldos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.cbx_almacen)
destroy(this.st_1)
destroy(this.sle_cod_art)
destroy(this.sle_desc_art)
destroy(this.cbx_articulo)
destroy(this.cbx_cencos)
destroy(this.st_3)
destroy(this.sle_cencos)
destroy(this.sle_desc_cencos)
destroy(this.rb_cencos)
destroy(this.rb_articulo)
destroy(this.rb_tiempo)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string	ls_mensaje, ls_almacen, ls_articulo, ls_cencos

if cbx_almacen.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de almacen')
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if

if cbx_articulo.checked then
	ls_articulo = '%%'
else
	if trim(sle_cod_art.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de artículo')
		return
	end if
	ls_articulo = trim(sle_cod_art.text) + '%'
end if

if cbx_cencos.checked then
	ls_cencos = '%%'
else
	if trim(sle_cencos.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un Centro de Costo')
		return
	end if
	ls_cencos = trim(sle_cencos.text) + '%'
end if

if rb_articulo.checked then
	dw_report.dataobject = 'd_rpt_antiguedad_saldo_cencos_tbl'
elseif rb_cencos.checked then
	dw_report.dataobject = 'd_rpt_antig_saldo_x_cencos_tbl'
elseif rb_tiempo.checked then
	dw_report.dataobject = 'd_rpt_antig_saldo_xtiempo_tbl'
end if

//create or replace procedure USP_ALM_RPT_ANTIG_SALDO(
//       asi_almacen          IN almacen.almacen%TYPE,
//       asi_cod_art          IN articulo.cod_art%TYPE,
//       asi_cencos           IN centros_costo.cencos%TYPE
//) IS

DECLARE USP_ALM_RPT_ANTIG_SALDO PROCEDURE FOR
	USP_ALM_RPT_ANTIG_SALDO( :ls_almacen,
									 :ls_articulo,
									 :ls_cencos  );

EXECUTE USP_ALM_RPT_ANTIG_SALDO;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_ALM_RPT_ANTIG_SALDO:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return
END IF

CLOSE USP_ALM_RPT_ANTIG_SALDO;



ib_preview=false
this.event ue_preview()
dw_report.visible = true
dw_report.SetTransObject( sqlca)
dw_report.retrieve()	
dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.object.t_user.text 		= gs_user
dw_report.object.t_objeto.text 	= this.classname( )
dw_report.Object.p_logo.filename = gs_logo

	

end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.DataWindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_al744_antiguedad_saldos
integer x = 0
integer y = 536
integer width = 3429
integer height = 984
string dataobject = "d_rpt_antiguedad_saldo_cencos_tbl"
end type

type cb_1 from commandbutton within w_al744_antiguedad_saldos
integer x = 3045
integer y = 36
integer width = 471
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Genera Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type sle_almacen from singlelineedit within w_al744_antiguedad_saldos
event dobleclick pbm_lbuttondblclk
integer x = 1024
integer y = 52
integer width = 439
integer height = 88
integer taborder = 60
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
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
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
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al744_antiguedad_saldos
integer x = 1477
integer y = 52
integer width = 1426
integer height = 88
integer taborder = 70
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

type st_2 from statictext within w_al744_antiguedad_saldos
integer x = 709
integer y = 64
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_almacen from checkbox within w_al744_antiguedad_saldos
integer x = 50
integer y = 56
integer width = 640
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los almacenes"
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type st_1 from statictext within w_al744_antiguedad_saldos
integer x = 709
integer y = 164
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Artículo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_cod_art from singlelineedit within w_al744_antiguedad_saldos
event dobleclick pbm_lbuttondblclk
integer x = 1024
integer y = 152
integer width = 439
integer height = 88
integer taborder = 70
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
string ls_codigo, ls_data, ls_sql, ls_almacen

if cbx_almacen.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de almacen')
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if

ls_sql = "SELECT distinct a.cod_art AS CODIGO_articulo, " &
	  	 + "a.desc_art AS DESCRIPCION_articulo " &
	    + "FROM articulo a, " &
		 + "articulo_almacen aa " &
		 + "where aa.cod_art = a.cod_art " &
		 + "and aa.almacen like '" + ls_almacen + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
if ls_codigo <> '' then
	this.text 				= ls_codigo
	sle_desc_art.text 	= ls_data
end if

end event

event modified;String 	ls_cod_art, ls_desc

ls_cod_art = this.text
if ls_cod_art = '' or IsNull(ls_cod_art) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de artículo')
	return
end if

SELECT desc_art
	INTO :ls_desc
FROM articulo 
where cod_art = :ls_cod_art ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Artículo no existe')
	return
end if

sle_desc_art.text = ls_desc

end event

type sle_desc_art from singlelineedit within w_al744_antiguedad_saldos
integer x = 1477
integer y = 152
integer width = 1426
integer height = 88
integer taborder = 70
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

type cbx_articulo from checkbox within w_al744_antiguedad_saldos
integer x = 50
integer y = 156
integer width = 640
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los artículos"
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_cod_art.enabled = false
else
	sle_cod_art.enabled = true
end if
end event

type cbx_cencos from checkbox within w_al744_antiguedad_saldos
integer x = 50
integer y = 256
integer width = 640
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los Cen Cos"
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_cencos.enabled = false
else
	sle_cencos.enabled = true
end if
end event

type st_3 from statictext within w_al744_antiguedad_saldos
integer x = 709
integer y = 264
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "CenCos:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_cencos from singlelineedit within w_al744_antiguedad_saldos
event dobleclick pbm_lbuttondblclk
integer x = 1024
integer y = 252
integer width = 439
integer height = 88
integer taborder = 80
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
string ls_codigo, ls_data, ls_sql, ls_almacen

if cbx_almacen.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de almacen')
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if

ls_sql = "SELECT distinct cc.cencos AS CODIGO_cencos, " &
	  	 + "cc.desc_cencos AS DESCRIPCION_cencos " &
	    + "FROM centros_costo cc, " &
		 + "Articulo_mov_proy amp " &
		 + "where cc.cencos = amp.cencos " &
		 + "and amp.CANT_RESERVADO > 0 " &
		 + "and amp.flag_estado = '1' " &
		 + "and amp.almacen like '" + ls_almacen + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
if ls_codigo <> '' then
	this.text 				= ls_codigo
	sle_desc_cencos.text = ls_data
end if

end event

event modified;String 	ls_code, ls_desc

ls_code = this.text
if ls_code = '' or IsNull(ls_code) then
	MessageBox('Aviso', 'Debe Ingresar un Centro de Costo')
	return
end if

SELECT desc_cencos
	INTO :ls_desc
FROM centros_costo
where cencos = :ls_code;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Centro de Costo no existe')
	return
end if

sle_cencos.text = ls_desc

end event

type sle_desc_cencos from singlelineedit within w_al744_antiguedad_saldos
integer x = 1477
integer y = 252
integer width = 1426
integer height = 88
integer taborder = 80
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

type rb_cencos from radiobutton within w_al744_antiguedad_saldos
integer x = 677
integer y = 432
integer width = 782
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Centro de costo/Almacén"
end type

type rb_articulo from radiobutton within w_al744_antiguedad_saldos
integer x = 18
integer y = 432
integer width = 603
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacén/Artículo"
boolean checked = true
end type

type rb_tiempo from radiobutton within w_al744_antiguedad_saldos
integer x = 1463
integer y = 432
integer width = 782
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Antiguedad / Centro de costo"
end type

type gb_1 from groupbox within w_al744_antiguedad_saldos
integer width = 2976
integer height = 368
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type gb_2 from groupbox within w_al744_antiguedad_saldos
integer y = 368
integer width = 2976
integer height = 156
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Ordenar por:"
end type

