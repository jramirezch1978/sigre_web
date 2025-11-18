$PBExportHeader$w_get_tipo_doc_amp.srw
forward
global type w_get_tipo_doc_amp from window
end type
type sle_nro_doc from u_sle_codigo within w_get_tipo_doc_amp
end type
type cb_cancelar from commandbutton within w_get_tipo_doc_amp
end type
type cb_buscar from commandbutton within w_get_tipo_doc_amp
end type
type sle_tipo_doc from singlelineedit within w_get_tipo_doc_amp
end type
type st_1 from statictext within w_get_tipo_doc_amp
end type
type st_2 from statictext within w_get_tipo_doc_amp
end type
end forward

global type w_get_tipo_doc_amp from window
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
sle_nro_doc sle_nro_doc
cb_cancelar cb_cancelar
cb_buscar cb_buscar
sle_tipo_doc sle_tipo_doc
st_1 st_1
st_2 st_2
end type
global w_get_tipo_doc_amp w_get_tipo_doc_amp

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

on w_get_tipo_doc_amp.create
this.sle_nro_doc=create sle_nro_doc
this.cb_cancelar=create cb_cancelar
this.cb_buscar=create cb_buscar
this.sle_tipo_doc=create sle_tipo_doc
this.st_1=create st_1
this.st_2=create st_2
this.Control[]={this.sle_nro_doc,&
this.cb_cancelar,&
this.cb_buscar,&
this.sle_tipo_doc,&
this.st_1,&
this.st_2}
end on

on w_get_tipo_doc_amp.destroy
destroy(this.sle_nro_doc)
destroy(this.cb_cancelar)
destroy(this.cb_buscar)
destroy(this.sle_tipo_doc)
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

type sle_nro_doc from u_sle_codigo within w_get_tipo_doc_amp
event dobleclick pbm_lbuttondblclk
integer x = 1010
integer y = 96
integer width = 471
integer height = 92
integer taborder = 20
end type

event dobleclick;boolean lb_ret
string ls_nro_doc, ls_data, ls_sql, ls_tipo_doc

ls_tipo_doc = sle_tipo_doc.text

if ls_tipo_doc = '' or IsNull(ls_tipo_doc) then
	MessageBox('Aviso', 'Debe Indicar primero tipo_doc')
	return
end if

if il_opcion = 1 then  // Consumo interno

	ls_sql = "SELECT distinct a.tipo_doc AS tipo_doc, " &
			 + "a.nro_doc AS numero_documento " &
			 + "FROM articulo_mov_proy a, " &
			 + "articulo b " &
			 + "where a.flag_estado = '1' " &
			 + "and b.cod_art = a.cod_art " &
			 + "and NVL(b.flag_inventariable, '0') = '1' " &
			 + "and a.tipo_doc = '" + ls_tipo_doc + "' " &
			 + "and a.almacen = '" + is_almacen + "' " &
			 + "and a.tipo_mov = '" + is_tipo_mov + "' " &
			 + "and NVL(a.cant_procesada,0) < NVL(cant_proyect,0) " &
			 + "AND to_char(a.FEC_PROYECT, 'yyyymmdd') <= '" + string(id_fecha, 'yyyymmdd') + "' " & 
			 + "order by a.nro_doc " 
			 
elseif il_opcion = 2 then	//Ingreso x Producción
	
	ls_sql = "SELECT distinct a.tipo_doc AS tipo_doc, " &
			 + "a.nro_doc AS numero_documento " &
			 + "FROM articulo_mov_proy a, " &
			 + "articulo b " &
			 + "where a.flag_estado = '1' " &
			 + "and b.cod_art = a.cod_art " &
			 + "and NVL(b.flag_inventariable, '0') = '1' " &
			 + "and a.tipo_doc = '" + ls_tipo_doc + "' " &
			 + "and a.almacen = '" + is_almacen + "' " &
			 + "and a.tipo_mov = '" + is_tipo_mov + "' " &
			 + "and NVL(a.cant_procesada,0) < NVL(cant_proyect,0) " &
			 + "order by a.nro_doc " 
			 
//			 + "AND to_char(a.FEC_PROYECT, 'yyyymmdd') <= '" + string(id_fecha, 'yyyymmdd') + "' " & 
			 
else
	
	MessageBox('Aviso', 'Opcion no esta implementada')
	return
end if
			
lb_ret = f_lista(ls_sql, ls_data, ls_nro_doc, '1')
		
if ls_nro_doc <> '' then
	this.text = ls_nro_doc
end if
end event

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;//cb_1.Triggerevent( clicked!)
end event

type cb_cancelar from commandbutton within w_get_tipo_doc_amp
integer x = 1513
integer y = 148
integer width = 343
integer height = 100
integer taborder = 40
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

type cb_buscar from commandbutton within w_get_tipo_doc_amp
integer x = 1513
integer y = 32
integer width = 343
integer height = 100
integer taborder = 30
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

type sle_tipo_doc from singlelineedit within w_get_tipo_doc_amp
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
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

if il_opcion = 1 then
	ls_sql = "SELECT distinct a.tipo_doc AS tipo_documento, " &
			 + "b.desc_Tipo_doc AS DESCRIPCION_tipo_doc " &
			 + "FROM articulo_mov_proy a, " &
			 + "doc_tipo b, " &
			 + "articulo c " &
			 + "where a.tipo_doc = b.tipo_doc " &
			 + "and a.cod_art = c.cod_art " &
			 + "and NVL(c.flag_inventariable, '0') = '1' " &
			 + "and a.tipo_mov = '" + is_tipo_mov + "' " &
			 + "and a.flag_estado = '1' " &
			 + "and a.almacen = '" + is_almacen + "' " &
			 + "and NVL(a.cant_procesada,0) < NVL(a.cant_proyect,0) " &
			 + "AND to_char(a.FEC_PROYECT, 'yyyymmdd') <= '" + string(id_fecha, 'yyyymmdd') + "'"
			 
elseif il_opcion = 2 then
	
	ls_sql = "SELECT distinct a.tipo_doc AS tipo_documento, " &
			 + "b.desc_Tipo_doc AS DESCRIPCION_tipo_doc " &
			 + "FROM articulo_mov_proy a, " &
			 + "doc_tipo b, " &
			 + "articulo c " &
			 + "where a.tipo_doc = b.tipo_doc " &
			 + "and a.cod_art = c.cod_art " &
			 + "and NVL(c.flag_inventariable, '0') = '1' " &
			 + "and a.tipo_mov = '" + is_tipo_mov + "' " &
			 + "and a.flag_estado = '1' " &
			 + "and a.almacen = '" + is_almacen + "' " &
			 + "and NVL(a.cant_procesada,0) < NVL(a.cant_proyect,0) "
end if

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if

end event

type st_1 from statictext within w_get_tipo_doc_amp
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

type st_2 from statictext within w_get_tipo_doc_amp
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

