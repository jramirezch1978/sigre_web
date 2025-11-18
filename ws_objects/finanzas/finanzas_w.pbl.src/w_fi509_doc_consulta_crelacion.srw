$PBExportHeader$w_fi509_doc_consulta_crelacion.srw
forward
global type w_fi509_doc_consulta_crelacion from w_cns
end type
type dw_cns from u_dw_cns within w_fi509_doc_consulta_crelacion
end type
type sle_nro_doc from singlelineedit within w_fi509_doc_consulta_crelacion
end type
type st_3 from statictext within w_fi509_doc_consulta_crelacion
end type
type sle_tipo_doc from singlelineedit within w_fi509_doc_consulta_crelacion
end type
type st_tipo_doc from statictext within w_fi509_doc_consulta_crelacion
end type
type st_2 from statictext within w_fi509_doc_consulta_crelacion
end type
type st_ruc from statictext within w_fi509_doc_consulta_crelacion
end type
type st_proveedor from statictext within w_fi509_doc_consulta_crelacion
end type
type sle_proveedor from singlelineedit within w_fi509_doc_consulta_crelacion
end type
type st_1 from statictext within w_fi509_doc_consulta_crelacion
end type
type cb_1 from commandbutton within w_fi509_doc_consulta_crelacion
end type
end forward

global type w_fi509_doc_consulta_crelacion from w_cns
integer width = 3762
integer height = 1796
string title = "[FI509] Documentos x Finanzas"
string menuname = "m_consulta"
dw_cns dw_cns
sle_nro_doc sle_nro_doc
st_3 st_3
sle_tipo_doc sle_tipo_doc
st_tipo_doc st_tipo_doc
st_2 st_2
st_ruc st_ruc
st_proveedor st_proveedor
sle_proveedor sle_proveedor
st_1 st_1
cb_1 cb_1
end type
global w_fi509_doc_consulta_crelacion w_fi509_doc_consulta_crelacion

event ue_open_pre;call super::ue_open_pre;dw_cns.settransobject(sqlca)
idw_1 = dw_cns
end event

on w_fi509_doc_consulta_crelacion.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.dw_cns=create dw_cns
this.sle_nro_doc=create sle_nro_doc
this.st_3=create st_3
this.sle_tipo_doc=create sle_tipo_doc
this.st_tipo_doc=create st_tipo_doc
this.st_2=create st_2
this.st_ruc=create st_ruc
this.st_proveedor=create st_proveedor
this.sle_proveedor=create sle_proveedor
this.st_1=create st_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cns
this.Control[iCurrent+2]=this.sle_nro_doc
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_tipo_doc
this.Control[iCurrent+5]=this.st_tipo_doc
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_ruc
this.Control[iCurrent+8]=this.st_proveedor
this.Control[iCurrent+9]=this.sle_proveedor
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.cb_1
end on

on w_fi509_doc_consulta_crelacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cns)
destroy(this.sle_nro_doc)
destroy(this.st_3)
destroy(this.sle_tipo_doc)
destroy(this.st_tipo_doc)
destroy(this.st_2)
destroy(this.st_ruc)
destroy(this.st_proveedor)
destroy(this.sle_proveedor)
destroy(this.st_1)
destroy(this.cb_1)
end on

event resize;call super::resize;dw_cns.width  = newwidth  - dw_cns.x - 10
dw_cns.height = newheight - dw_cns.y - 10
end event

type dw_cns from u_dw_cns within w_fi509_doc_consulta_crelacion
integer y = 304
integer width = 3365
integer height = 1180
integer taborder = 50
string dataobject = "d_cns_doc_mov_cb_detalle_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1         // columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type sle_nro_doc from singlelineedit within w_fi509_doc_consulta_crelacion
integer x = 366
integer y = 204
integer width = 379
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_fi509_doc_consulta_crelacion
integer x = 5
integer y = 208
integer width = 343
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Doc :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_tipo_doc from singlelineedit within w_fi509_doc_consulta_crelacion
event ue_dobleclick pbm_lbuttondblclk
integer x = 366
integer y = 112
integer width = 379
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = 'SELECT DT.TIPO_DOC AS CODIGO ,'&
		 + 'DT.DESC_TIPO_DOC AS DESCRIPCION '&
		 + 'FROM DOC_TIPO DT'
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	st_tipo_doc.text 	= ls_data
end if
	

end event

event modified;String 	ls_desc, ls_codigo

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	this.text = ''
	st_tipo_doc.text = ''
	MessageBox('Aviso', 'Debe Ingresar un codigo de Tipo de documento', StopSign!)
	return
end if

select desc_tipo_doc
	into :ls_desc
from doc_tipo
where tipo_doc = :ls_codigo;


IF SQLCA.SQLCode = 100 THEN
	this.text = ''
	st_tipo_doc.text = ''
	Messagebox('Aviso', 'Codigo de Tipo de Documento ' + ls_codigo + ' no existe ', StopSign!)
	return
end if

st_tipo_doc.text = ls_desc
end event

type st_tipo_doc from statictext within w_fi509_doc_consulta_crelacion
integer x = 763
integer y = 112
integer width = 1669
integer height = 84
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

type st_2 from statictext within w_fi509_doc_consulta_crelacion
integer x = 5
integer y = 116
integer width = 343
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Doc :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ruc from statictext within w_fi509_doc_consulta_crelacion
integer x = 2446
integer y = 20
integer width = 521
integer height = 84
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

type st_proveedor from statictext within w_fi509_doc_consulta_crelacion
integer x = 763
integer y = 20
integer width = 1669
integer height = 84
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

type sle_proveedor from singlelineedit within w_fi509_doc_consulta_crelacion
event ue_dobleclick pbm_lbuttondblclk
integer x = 366
integer y = 20
integer width = 379
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_ruc

ls_sql = "SELECT P.PROVEEDOR    AS CODIGO_PROVEEDOR ,"&
		 + "P.NOM_PROVEEDOR AS NOMBRES, "&
		 + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni " &
		 + "FROM PROVEEDOR P"
				 
lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	st_proveedor.text = ls_data
	st_ruc.text 		= ls_ruc
end if

end event

event modified;String 	ls_desc, ls_codigo, ls_ruc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	st_proveedor.text = ''
	st_ruc.text			= ''

	MessageBox('Aviso', 'Debe Ingresar un codigo de Proveedor', StopSign!)
	this.SetFocus()
	return
end if

select 	p.nom_proveedor, 
			decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni
	into :ls_desc, :ls_ruc
from proveedor p
where p.proveedor = :ls_codigo;


IF SQLCA.SQLCode = 100 THEN
	this.text 			= ''
	st_proveedor.text = ''
	st_ruc.text			= ''
	Messagebox('Aviso', 'Codigo de proveedor ' + ls_codigo + ' no existe, por favor verifique!', StopSign!)
	return
end if

st_proveedor.text = ls_desc
st_ruc.text			= ls_ruc
end event

type st_1 from statictext within w_fi509_doc_consulta_crelacion
integer x = 18
integer y = 28
integer width = 343
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cod. Relacion :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_fi509_doc_consulta_crelacion
integer x = 3131
integer y = 28
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Consultar"
end type

event clicked;String ls_cod_relacion,ls_tipo_doc,ls_nro_doc

if trim(sle_proveedor.text) = '' then
	ls_cod_relacion = '%%'
else
	ls_cod_relacion =	trim(sle_proveedor.text) + '%'
end if

if trim(sle_tipo_doc.text) = '' then
	ls_tipo_doc = '%%'
else
	ls_tipo_doc = trim(sle_tipo_doc.text) + '%'
end if

if trim(sle_nro_doc.text) = '' then
	ls_nro_doc = '%%'
else
	ls_nro_doc = trim(sle_nro_doc.text) + '%'
end if


dw_cns.retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
end event

