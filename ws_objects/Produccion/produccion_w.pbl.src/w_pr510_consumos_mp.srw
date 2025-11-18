$PBExportHeader$w_pr510_consumos_mp.srw
forward
global type w_pr510_consumos_mp from w_report_smpl
end type
type st_1 from statictext within w_pr510_consumos_mp
end type
type cb_proc from commandbutton within w_pr510_consumos_mp
end type
type cbx_categorias from checkbox within w_pr510_consumos_mp
end type
type sle_categoria from singlelineedit within w_pr510_consumos_mp
end type
type st_desc_categoria from statictext within w_pr510_consumos_mp
end type
type cbx_articulos from checkbox within w_pr510_consumos_mp
end type
type sle_cod_art from singlelineedit within w_pr510_consumos_mp
end type
type st_desc_art from statictext within w_pr510_consumos_mp
end type
type sle_year from singlelineedit within w_pr510_consumos_mp
end type
end forward

global type w_pr510_consumos_mp from w_report_smpl
integer width = 3995
integer height = 1356
string title = "[PR510] Consumo Materia Prima"
string menuname = "m_reporte"
event ue_query_retrieve ( )
st_1 st_1
cb_proc cb_proc
cbx_categorias cbx_categorias
sle_categoria sle_categoria
st_desc_categoria st_desc_categoria
cbx_articulos cbx_articulos
sle_cod_art sle_cod_art
st_desc_art st_desc_art
sle_year sle_year
end type
global w_pr510_consumos_mp w_pr510_consumos_mp

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_pr510_consumos_mp.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.cb_proc=create cb_proc
this.cbx_categorias=create cbx_categorias
this.sle_categoria=create sle_categoria
this.st_desc_categoria=create st_desc_categoria
this.cbx_articulos=create cbx_articulos
this.sle_cod_art=create sle_cod_art
this.st_desc_art=create st_desc_art
this.sle_year=create sle_year
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_proc
this.Control[iCurrent+3]=this.cbx_categorias
this.Control[iCurrent+4]=this.sle_categoria
this.Control[iCurrent+5]=this.st_desc_categoria
this.Control[iCurrent+6]=this.cbx_articulos
this.Control[iCurrent+7]=this.sle_cod_art
this.Control[iCurrent+8]=this.st_desc_art
this.Control[iCurrent+9]=this.sle_year
end on

on w_pr510_consumos_mp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_proc)
destroy(this.cbx_categorias)
destroy(this.sle_categoria)
destroy(this.st_desc_categoria)
destroy(this.cbx_articulos)
destroy(this.sle_cod_art)
destroy(this.st_desc_art)
destroy(this.sle_year)
end on

event ue_open_pre;Date	ld_fecha

ld_fecha = DAte(gnvo_app.of_fecha_Actual())

sle_year.text = String(ld_fecha, 'yyyy')

idw_1 = dw_report
idw_1.SetTransObject(sqlca)
idw_1.Visible = False




end event

event ue_retrieve;call super::ue_retrieve;Integer	li_year
String 	ls_categoria, ls_articulo

if cbx_categorias.checked then
	ls_categoria = '%%'
else
	if trim(sle_Categoria.text) = '' then
		gnvo_app.of_mensaje_Error("Debe seleccionar una categoria antes de dar el reporte")
		sle_categoria.setFocus()
		return
	end if
	
	ls_categoria = trim(sle_categoria.text) + '%'
end if

if cbx_articulos.checked then
	ls_articulo = '%%'
else
	if trim(sle_cod_art.text) = '' then
		gnvo_app.of_mensaje_Error("Debe seleccionar un ARTICULO antes de dar el reporte")
		sle_cod_art.setFocus()
		return
	end if
	
	ls_articulo = trim(sle_cod_art.text) + '%'
end if

li_year = Integer(sle_year.text)

dw_report.settransobject( sqlca )
dw_report.retrieve(li_year, ls_categoria, ls_articulo )

end event

type dw_report from w_report_smpl`dw_report within w_pr510_consumos_mp
integer x = 0
integer y = 288
integer width = 3314
integer height = 836
integer taborder = 10
string dataobject = "d_cns_consumo_mp_anual_tbl"
string is_dwform = ""
end type

event dw_report::itemchanged;call super::itemchanged;gnvo_app.of_select_current_row(this)
end event

type st_1 from statictext within w_pr510_consumos_mp
integer x = 18
integer y = 24
integer width = 613
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_proc from commandbutton within w_pr510_consumos_mp
integer x = 1755
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
boolean default = true
end type

event clicked;parent.event ue_retrieve()
end event

type cbx_categorias from checkbox within w_pr510_consumos_mp
integer x = 18
integer y = 108
integer width = 613
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todas las Categorias"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_categoria.enabled = false
	sle_categoria.text=''
	st_desc_categoria.text = ''
Else
	sle_categoria.enabled = true
	sle_categoria.text=''
End If
end event

type sle_categoria from singlelineedit within w_pr510_consumos_mp
event dobleclick pbm_lbuttondblclk
integer x = 645
integer y = 108
integer width = 357
integer height = 80
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\SOURCE\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select a.cat_art as codigo_categoria, " &
		 + "a.desc_categoria as descripcion_Categoria " &
		 + "from articulo_Categ a " &
		 + "where a.flag_estado = '1'"
				 

			
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
	this.text= ls_codigo
	st_desc_categoria.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una TAREA')
	return
end if

SELECT desc_categoria
	INTO :ls_desc
FROM articulo_Categ
WHERE cat_art = :ls_codigo
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Categoria ' + ls_codigo + ' no existe o no está activo')
	return
end if

st_desc_categoria.text = ls_desc
end event

type st_desc_categoria from statictext within w_pr510_consumos_mp
integer x = 1015
integer y = 108
integer width = 1285
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type cbx_articulos from checkbox within w_pr510_consumos_mp
integer x = 18
integer y = 196
integer width = 613
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todas las Articulos"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_cod_art.enabled = false
	sle_cod_art.text=''
	st_desc_art.text = ''
Else
	sle_cod_art.enabled = true
	st_desc_art.text=''
End If
end event

type sle_cod_art from singlelineedit within w_pr510_consumos_mp
event dobleclick pbm_lbuttondblclk
integer x = 645
integer y = 196
integer width = 357
integer height = 80
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\SOURCE\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_categoria

if cbx_categorias.checked then
	ls_categoria = '%%'
else
	if trim(sle_categoria.text) = '' then
		MEssageBox('Error', 'Debe elegir primero la cateoria. Por favor corrija!', StopSign!)
		sle_categoria.setFocus()
		return
	end if
	
	ls_categoria = trim(sle_categoria.text) + '%'
	
end if

ls_sql = "select distinct a.cod_art as codigo_articulo, " &
		 + "a.desc_art as descripcion_articulo " &
		 + "from vale_mov vm, " &
		 + "     articulo_mov am, " &
		 + "     articulo     a, " &
		 + "      articulo_sub_categ a2 " &
		 + "where vm.nro_vale = am.nro_Vale " &
		 + "  and am.cod_art  = a.cod_Art " &
		 + "  and a.sub_cat_art = a2.cod_sub_cat " &
		 + "  and vm.flag_estado <> '0' " &
		 + "   and am.flag_estado <> '0' " &
		 + "   and a2.cat_art like '" + ls_categoria + "'"
				 

			
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
	this.text= ls_codigo
	st_desc_art.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una TAREA')
	return
end if

SELECT desc_categoria
	INTO :ls_desc
FROM articulo_Categ
WHERE cat_art = :ls_codigo
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Categoria ' + ls_codigo + ' no existe o no está activo')
	return
end if

st_desc_categoria.text = ls_desc
end event

type st_desc_art from statictext within w_pr510_consumos_mp
integer x = 1015
integer y = 196
integer width = 1285
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_pr510_consumos_mp
event dobleclick pbm_lbuttondblclk
integer x = 645
integer y = 20
integer width = 357
integer height = 80
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\SOURCE\CUR\taladro.cur"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select a.cat_art as codigo_categoria, " &
		 + "a.desc_categoria as descripcion_Categoria " &
		 + "from articulo_Categ a " &
		 + "where a.flag_estado = '1'"
				 

			
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
	this.text= ls_codigo
	st_desc_categoria.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una TAREA')
	return
end if

SELECT desc_categoria
	INTO :ls_desc
FROM articulo_Categ
WHERE cat_art = :ls_codigo
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Categoria ' + ls_codigo + ' no existe o no está activo')
	return
end if

st_desc_categoria.text = ls_desc
end event

