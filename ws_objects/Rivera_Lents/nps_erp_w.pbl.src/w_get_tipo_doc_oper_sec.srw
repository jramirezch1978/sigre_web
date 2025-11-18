$PBExportHeader$w_get_tipo_doc_oper_sec.srw
forward
global type w_get_tipo_doc_oper_sec from window
end type
type cb_cancelar from commandbutton within w_get_tipo_doc_oper_sec
end type
type cb_buscar from commandbutton within w_get_tipo_doc_oper_sec
end type
type sle_tipo_doc from singlelineedit within w_get_tipo_doc_oper_sec
end type
type sle_nro_doc from singlelineedit within w_get_tipo_doc_oper_sec
end type
type st_1 from statictext within w_get_tipo_doc_oper_sec
end type
type st_2 from statictext within w_get_tipo_doc_oper_sec
end type
end forward

global type w_get_tipo_doc_oper_sec from window
integer width = 1966
integer height = 364
boolean titlebar = true
string title = "Buscar Documento en Articulo Mov Proy"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_buscar ( )
event ue_cancelar ( )
cb_cancelar cb_cancelar
cb_buscar cb_buscar
sle_tipo_doc sle_tipo_doc
sle_nro_doc sle_nro_doc
st_1 st_1
st_2 st_2
end type
global w_get_tipo_doc_oper_sec w_get_tipo_doc_oper_sec

type variables
string 	is_almacen, is_tipo_mov
date   	id_fecha
Long		il_opcion

end variables

event ue_buscar();string ls_tipo_doc, ls_nro_doc
str_parametros lstr_param

ls_tipo_Doc = sle_tipo_doc.text
ls_nro_doc  = sle_nro_doc.text

if ls_tipo_doc = '' or IsNull(ls_tipo_doc) then
	MessageBox('Aviso', 'Tipo de Documento esta vacio')
	return
end if

if ls_nro_doc = '' or IsNull(ls_nro_doc) then
	MessageBox('Aviso', 'Numero de Documento esta vacio')
	return
end if

lstr_param.titulo = 's'
lstr_param.tipo_doc 	= ls_tipo_doc
lstr_param.nro_doc 	= ls_nro_doc

CloseWithReturn(this, lstr_param)
end event

event ue_cancelar();str_parametros lstr_param

lstr_param.titulo = 'n'

CloseWithReturn(this, lstr_param)
end event

on w_get_tipo_doc_oper_sec.create
this.cb_cancelar=create cb_cancelar
this.cb_buscar=create cb_buscar
this.sle_tipo_doc=create sle_tipo_doc
this.sle_nro_doc=create sle_nro_doc
this.st_1=create st_1
this.st_2=create st_2
this.Control[]={this.cb_cancelar,&
this.cb_buscar,&
this.sle_tipo_doc,&
this.sle_nro_doc,&
this.st_1,&
this.st_2}
end on

on w_get_tipo_doc_oper_sec.destroy
destroy(this.cb_cancelar)
destroy(this.cb_buscar)
destroy(this.sle_tipo_doc)
destroy(this.sle_nro_doc)
destroy(this.st_1)
destroy(this.st_2)
end on

event open;str_parametros lstr_param

if not IsValid(Message.PowerObjectParm) or &
	IsNull(Message.PowerObjectParm) then
	
	MessageBox('Aviso', 'Objeto enviado por Parametro es Invalido o Nulo')
	Close(this)
end if

if Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Aviso', 'Objeto enviado por Parametro no es del tipo str_parametros')
	close(this)
end if

lstr_param = Message.PowerObjectParm

is_tipo_mov = lstr_param.tipo_mov
id_fecha		= lstr_param.fecha1
is_almacen	= lstr_param.almacen
il_opcion	= lstr_param.opcion

if lstr_param.tipo_doc <> '' then
	sle_tipo_doc.text = lstr_param.tipo_doc
end if

if lstr_param.nro_doc <> '' then
	sle_nro_doc.text = lstr_param.nro_doc
end if

if lstr_param.tipo_doc <> '' and lstr_param.nro_doc <> '' then
	this.event dynamic ue_buscar()	
end if
end event

type cb_cancelar from commandbutton within w_get_tipo_doc_oper_sec
integer x = 1513
integer y = 148
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;parent.event dynamic ue_cancelar()
end event

type cb_buscar from commandbutton within w_get_tipo_doc_oper_sec
integer x = 1513
integer y = 32
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
boolean default = true
end type

event clicked;parent.event dynamic ue_buscar()

end event

type sle_tipo_doc from singlelineedit within w_get_tipo_doc_oper_sec
event dobleclick pbm_lbuttondblclk
integer x = 384
integer y = 96
integer width = 178
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type sle_nro_doc from singlelineedit within w_get_tipo_doc_oper_sec
event dobleclick pbm_lbuttondblclk
integer x = 1015
integer y = 92
integer width = 402
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_nro_doc, ls_data, ls_sql, ls_tipo_doc

ls_tipo_doc = sle_tipo_doc.text

if ls_tipo_doc = '' or IsNull(ls_tipo_doc) then
	MessageBox('Aviso', 'Debe Indicar primero tipo_doc')
	return
end if

ls_sql = "SELECT distinct 'Ot' as tipo_doc, " &
		 + "op.nro_orden AS numero_documento " &
		 + "FROM operaciones op " &
		 + "where op.flag_estado in ('1', '3') " &
		 + "and USF_CMP_OPER_SEC_ACTIVO(op.oper_sec ) = 1 " &
		 + "order by op.nro_orden " 
			
lb_ret = f_lista(ls_sql, ls_data, ls_nro_doc, '1')
		
if ls_nro_doc <> '' then
	this.text = ls_nro_doc
end if
end event

type st_1 from statictext within w_get_tipo_doc_oper_sec
integer x = 78
integer y = 100
integer width = 270
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Doc"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_get_tipo_doc_oper_sec
integer x = 731
integer y = 100
integer width = 270
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Doc:"
alignment alignment = right!
boolean focusrectangle = false
end type

