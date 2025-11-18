$PBExportHeader$w_search_tv.srw
forward
global type w_search_tv from window
end type
type ddlb_opcion from dropdownlistbox within w_search_tv
end type
type cb_buscar from commandbutton within w_search_tv
end type
type dw_1 from datawindow within w_search_tv
end type
type st_campo from statictext within w_search_tv
end type
type pb_aceptar from picturebutton within w_search_tv
end type
type pb_cancelar from picturebutton within w_search_tv
end type
type dw_master from u_dw_abc within w_search_tv
end type
end forward

global type w_search_tv from window
integer width = 3058
integer height = 2408
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_buscar ( )
event ue_aceptar ( )
event ue_cancelar ( )
ddlb_opcion ddlb_opcion
cb_buscar cb_buscar
dw_1 dw_1
st_campo st_campo
pb_aceptar pb_aceptar
pb_cancelar pb_cancelar
dw_master dw_master
end type
global w_search_tv w_search_tv

type variables
str_parametros istr_param
String			is_col, is_type
end variables

event ue_buscar();String ls_dato

dw_1.AcceptText()
ls_dato = trim(dw_1.object.campo [1]) + '%'

if istr_param.opcion = 1 or istr_param.opcion = 2 then
	
	dw_master.Retrieve(ls_Dato)
else
	dw_master.Retrieve()
end if
end event

event ue_aceptar();str_cnta_cntbl lstr_cnta, lstr_cntas[]
str_maquinas	lstr_maquina
str_parametros	lstr_param
Long 				ll_Row, ll_i, ll_count

dw_master.AcceptText()
if dw_master.RowCount() = 0 then return

ll_row = dw_master.GetSelectedRow(0)

if ll_row =0 then
	if istr_param.opcion = 1 then
		MessageBox('Error', 'Debe Seleccionar una cuenta contable del plan de cuentas, por favor verifique!')
	else
		MessageBox('Error', 'Debe Seleccionar un código de maquina del listado de equipos, por favor verifique!')
	end if
	return
end if


if istr_param.opcion = 1 then
	
	//Cuenta contable
	if istr_param.select_multiple = false then
		
		//Seleccion Simple
		lstr_cnta.cnta_cntbl = dw_master.object.cnta_ctbl	[ll_row]
		lstr_cnta.desc_cnta 	= dw_master.object.desc_cnta	[ll_row]
		lstr_cnta.b_return 	= true
		CloseWithReturn( this, lstr_cnta)	
		
	else
		
		//Seleccion multiple
		ll_count = 0
		for ll_i = 1 to dw_master.RowCount() 
			if dw_master.object.checked	[ll_i] = '1' then
				ll_count ++
			end if
		next
		
		if ll_count = 0 then
			gnvo_app.of_mensaje_error("No ha marcado ninguna Cuenta Contable, por favor verifique!")
			return 
		end if
		
		ll_row = 1
		for ll_i = 1 to dw_master.RowCount() 
			if dw_master.object.checked	[ll_i] = '1' then
				lstr_cntas[ll_row].cnta_cntbl = dw_master.object.cnta_ctbl	[ll_i]
				lstr_cntas[ll_row].desc_cnta 	= dw_master.object.desc_cnta	[ll_i]
				ll_row ++
			end if
		next
		
		lstr_param.istr_cntas = lstr_cntas
		lstr_param.b_return = true
		CloseWithReturn( this, lstr_param)	
		
	end if
	
	
	
elseif istr_param.opcion = 2 then
	
	lstr_maquina.cod_maquina 	= dw_master.object.cod_maquina	[ll_row]
	lstr_maquina.desc_maquina 	= dw_master.object.desc_maq		[ll_row]
	lstr_maquina.b_return = true
	CloseWithReturn( this, lstr_maquina)	

end if
	





end event

event ue_cancelar();str_cnta_cntbl lstr_cnta
str_maquinas	lstr_maquina
str_parametros	lstr_param

if istr_param.opcion = 1 then
	if istr_param.select_multiple = false then
		lstr_cnta.b_return = false
		CloseWithReturn( this, lstr_cnta)	
	else
		lstr_param.b_Return = false
		CloseWithReturn( this, lstr_param)	
	end if
	
elseif istr_param.opcion = 2 then
	lstr_maquina.b_return = false
	CloseWithReturn( this, lstr_maquina)	

end if


end event

on w_search_tv.create
this.ddlb_opcion=create ddlb_opcion
this.cb_buscar=create cb_buscar
this.dw_1=create dw_1
this.st_campo=create st_campo
this.pb_aceptar=create pb_aceptar
this.pb_cancelar=create pb_cancelar
this.dw_master=create dw_master
this.Control[]={this.ddlb_opcion,&
this.cb_buscar,&
this.dw_1,&
this.st_campo,&
this.pb_aceptar,&
this.pb_cancelar,&
this.dw_master}
end on

on w_search_tv.destroy
destroy(this.ddlb_opcion)
destroy(this.cb_buscar)
destroy(this.dw_1)
destroy(this.st_campo)
destroy(this.pb_aceptar)
destroy(this.pb_cancelar)
destroy(this.dw_master)
end on

event resize;dw_master.width 	= newwidth - dw_master.x - 10
dw_master.height  = pb_aceptar.y - dw_master.y - 10

cb_buscar.x = dw_master.width - cb_buscar.width


dw_1.width = cb_buscar.x - dw_1.x - 10

pb_aceptar.x = newwidth / 2 - pb_aceptar.width - 10
pb_cancelar.x = pb_aceptar.x + pb_aceptar.width + 10

end event

event open;
istr_param = Message.PowerObjectParm

dw_master.dataObject = istr_param.dw1
dw_master.SetTransObject(SQLCA)


this.title = istr_param.titulo

ddlb_opcion.selectitem(1)

if istr_param.opcion = 1 then
	dw_master.Retrieve('%%')
else
	dw_master.Retrieve('%%')
end if

dw_master.setFocus()
end event

type ddlb_opcion from dropdownlistbox within w_search_tv
integer x = 279
integer y = 20
integer width = 562
integer height = 352
integer taborder = 30
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string item[] = {"Comienza","Contiene"}
borderstyle borderstyle = stylelowered!
end type

type cb_buscar from commandbutton within w_search_tv
integer x = 2711
integer y = 16
integer width = 229
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;Parent.event ue_buscar()

end event

type dw_1 from datawindow within w_search_tv
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 846
integer y = 20
integer width = 1815
integer height = 80
integer taborder = 10
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;//Long 	ll_row
//
//if key = KeyUpArrow! then		// Anterior
//	if dw_master.RowCount() > 0 then
//		dw_master.scrollpriorRow()
//	end if
//elseif key = KeyDownArrow! then	// Siguiente
//	if dw_master.RowCount() > 0 then
//		dw_master.scrollnextrow()	
//	end if
//end if
//ll_row = dw_master.Getrow()
//
//dw_master.SetRow(ll_row)
//f_select_current_row(dw_master)
//
//if key = KeyUpArrow! or key = KeyDownArrow! then
//
//	IF UPPER( LEFT(is_type,4) ) = 'NUMB' OR UPPER( LEFT(is_type,4) ) = "DECI" then
//		dw_1.object.campo[1] = String( dw_master.GetItemNumber(ll_row, is_col) )
//	ELSEIF UPPER( LEFT(is_type,4) ) = 'CHAR' then
//		dw_1.object.campo[1] = dw_master.GetItemString(ll_row, is_col)
//	ELSEIF UPPER( is_type ) = 'DATE' then
//		dw_1.object.campo[1] = String( dw_master.GetItemDate(ll_row, is_col), 'dd/mm/yyyy' )
//	ELSEIF UPPER( is_type ) = 'DATETIME' then
//		dw_1.object.campo[1] = String( dw_master.GetItemDateTime(ll_row, is_col), 'dd/mm/yyyy' )
//	END IF		
//end if
end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
//dw_master.triggerevent(doubleclicked!)
parent.event ue_buscar()
return 1
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

string 	ls_item
Integer	li_opcion

ls_item = upper( this.GetText() )

if upper(ddlb_opcion.Text) = 'COMIENZA' then
	li_opcion = 1
else
	li_opcion = 2
end if


dw_master.of_filtrar(ls_item, li_opcion)


end event

type st_campo from statictext within w_search_tv
integer x = 14
integer y = 20
integer width = 251
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Buscar: "
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_aceptar from picturebutton within w_search_tv
integer x = 1198
integer y = 2072
integer width = 325
integer height = 188
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = right!
end type

event clicked;parent.event ue_Aceptar()
end event

type pb_cancelar from picturebutton within w_search_tv
integer x = 1531
integer y = 2072
integer width = 325
integer height = 188
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "c:\sigre\resources\Bmp\Salir.bmp"
alignment htextalign = right!
end type

event clicked;parent.event dynamic ue_cancelar()
end event

type dw_master from u_dw_abc within w_search_tv
integer y = 112
integer width = 3022
integer height = 1932
string dataobject = "d_cnta_cntbl_tv"
boolean hscrollbar = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

