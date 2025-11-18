$PBExportHeader$w_search_naves.srw
forward
global type w_search_naves from w_cns
end type
type cb_nuevo from commandbutton within w_search_naves
end type
type cb_cancelar from commandbutton within w_search_naves
end type
type dw_master from u_dw_abc within w_search_naves
end type
type uo_search from n_cst_search within w_search_naves
end type
type cb_aceptar from commandbutton within w_search_naves
end type
end forward

global type w_search_naves from w_cns
integer width = 4014
integer height = 1972
string title = "Busqueda de Naves"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_filtro ( string as_filtro )
event ue_aceptar ( )
event ue_nuevo ( )
cb_nuevo cb_nuevo
cb_cancelar cb_cancelar
dw_master dw_master
uo_search uo_search
cb_aceptar cb_aceptar
end type
global w_search_naves w_search_naves

type variables
str_nave 	istr_nave
Str_parametros istr_param
end variables

forward prototypes
public function string wf_condicion_sql (string as_cadena)
end prototypes

event ue_filtro(string as_filtro);
dw_master.Retrieve(as_filtro, istr_param.string1)

if dw_master.RowCount() > 0 then
	dw_master.setRow(1)
	
	dw_master.SelectRow(0, false)
	dw_master.SelectRow(1, true)
	
	cb_aceptar.enabled = true
else
	cb_aceptar.enabled = false
end if
end event

event ue_aceptar();if dw_master.RowCount() = 0 then
	cb_aceptar.enabled = false
	return
end if

istr_nave.b_return = true

istr_nave.nave 		= dw_master.object.nave 				[dw_master.GetRow()]
istr_nave.nombre 		= dw_master.object.nomb_nave 			[dw_master.GetRow()]
istr_nave.matricula	= dw_master.object.matricula 			[dw_master.GetRow()]
istr_nave.tipo_flota = dw_master.object.flag_tipo_flota 	[dw_master.GetRow()]



CloseWithReturn( this, istr_nave)

end event

event ue_nuevo();Str_parametros lstr_param
string			ls_nave
long				ll_found

OpenWithParm(w_add_nave, istr_param)

lstr_param = Message.Powerobjectparm

ls_nave = lstr_param.string1

if lstr_param.b_return then 
	
	
	uo_search.event ue_buscar( )
	
	if Not IsNull(ls_nave) and trim(ls_nave) <> '' then
		ll_found = dw_master.find( "nave='" + ls_nave + "'", 1, dw_master.RowCount())
		if ll_found > 0 then
			dw_master.setRow( ll_found )
			dw_master.Scrolltorow( ll_found )
			dw_master.selectrow( 0, false)
			dw_master.selectrow( ll_found, true)
		end if
	end if
end if
end event

public function string wf_condicion_sql (string as_cadena);return ''
end function

on w_search_naves.create
int iCurrent
call super::create
this.cb_nuevo=create cb_nuevo
this.cb_cancelar=create cb_cancelar
this.dw_master=create dw_master
this.uo_search=create uo_search
this.cb_aceptar=create cb_aceptar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_nuevo
this.Control[iCurrent+2]=this.cb_cancelar
this.Control[iCurrent+3]=this.dw_master
this.Control[iCurrent+4]=this.uo_search
this.Control[iCurrent+5]=this.cb_aceptar
end on

on w_search_naves.destroy
call super::destroy
destroy(this.cb_nuevo)
destroy(this.cb_cancelar)
destroy(this.dw_master)
destroy(this.uo_search)
destroy(this.cb_aceptar)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;

if not IsNull(Message.PowerObjectParm) and IsValid(Message.PowerObjectParm) then
	istr_param = Message.PowerObjectParm
	
	
end if

dw_master.SetTransObject(SQLCA)

uo_search.of_set_dw(dw_master)

this.event ue_filtro( '%%' )

end event

type cb_nuevo from commandbutton within w_search_naves
integer x = 2949
integer y = 4
integer width = 288
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Nuevo"
end type

event clicked;parent.event dynamic ue_nuevo( )
end event

type cb_cancelar from commandbutton within w_search_naves
integer x = 3515
integer y = 4
integer width = 283
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;istr_nave.b_Return = false
CloseWithReturn( parent, istr_nave)

end event

type dw_master from u_dw_abc within w_search_naves
event ue_nuevo ( )
integer y = 108
integer width = 2258
integer height = 1264
integer taborder = 30
string dataobject = "d_lista_naves_tbl"
end type

event ue_nuevo();Str_parametros lstr_param
string			ls_nave
long				ll_found

OpenWithParm(w_add_nave, istr_param)

lstr_param = Message.Powerobjectparm

ls_nave = lstr_param.string1

if lstr_param.b_return then 
	
	
	uo_search.event ue_buscar( )
	
	if Not IsNull(ls_nave) and trim(ls_nave) <> '' then
		ll_found = dw_master.find( "nave='" + ls_nave + "'", 1, dw_master.RowCount())
		if ll_found > 0 then
			dw_master.setRow( ll_found )
			dw_master.Scrolltorow( ll_found )
			dw_master.selectrow( 0, false)
			dw_master.selectrow( ll_found, true)
		end if
	end if
end if
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

end event

event doubleclicked;call super::doubleclicked;if row = 0 then return

parent.event ue_aceptar()
end event

type uo_search from n_cst_search within w_search_naves
event destroy ( )
integer y = 4
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_buscar;call super::ue_buscar;String ls_buscar

ls_buscar = this.of_get_filtro()

parent.event ue_filtro( ls_buscar)
end event

event ue_post_editchanged;call super::ue_post_editchanged;if dw_master.RowCount() = 0 then
	cb_aceptar.enabled = true
else
	cb_aceptar.enabled = false
end if
end event

type cb_aceptar from commandbutton within w_search_naves
integer x = 3232
integer y = 4
integer width = 283
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Aceptar"
end type

event clicked;parent.event ue_aceptar()
end event

