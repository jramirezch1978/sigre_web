$PBExportHeader$w_search_cencos.srw
forward
global type w_search_cencos from w_abc_master_smpl
end type
type st_campo from statictext within w_search_cencos
end type
type dw_1 from datawindow within w_search_cencos
end type
type cb_1 from commandbutton within w_search_cencos
end type
end forward

global type w_search_cencos from w_abc_master_smpl
integer width = 1984
integer height = 1608
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_campo st_campo
dw_1 dw_1
cb_1 cb_1
end type
global w_search_cencos w_search_cencos

type variables
String is_col = '', is_field_return, is_tipo
integer ii_ik[]
str_parametros ist_datos
end variables

on w_search_cencos.create
int iCurrent
call super::create
this.st_campo=create st_campo
this.dw_1=create dw_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_1
end on

on w_search_cencos.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_1)
destroy(this.cb_1)
end on

event ue_open_pre;// Overr
str_parametros sl_param
String ls_null
Long ll_row
ii_lec_mst = 0
//ii_ss = 1
// Recoge parametro enviado
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	sl_param = MESSAGE.POWEROBJECTPARM
	ii_ik = sl_param.field_ret_i	// Numero de campo a devolver
	is_tipo = sl_param.tipo
	dw_master.DataObject = sl_param.dw1
	dw_master.SetTransObject( SQLCA)
	CHOOSE CASE sl_param.tipo 
		case '1S'
			ll_row = dw_master.retrieve(sl_param.string1)
		case '1N'
			ll_row = dw_master.retrieve(sl_param.long1)
		case '2S'
			ll_row = dw_master.retrieve(sl_param.string1, sl_param.string2)
		case '3S'
			ll_row = dw_master.retrieve(sl_param.string1, sl_param.string2, sl_param.string3)
		case '1N1S'
			ll_row = dw_master.retrieve(sl_param.long1, sl_param.string1)
		case else
			ll_row = dw_master.retrieve()
	END CHOOSE	
	
	ist_datos.titulo = 'n'
	This.Title = sl_param.titulo
	is_col = dw_master.Describe("#1" + ".name")
	st_campo.text = "Orden " + is_col
END IF
end event

event ue_set_access;// OVER
end event

event resize;//Override

end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()

end event

type dw_master from w_abc_master_smpl`dw_master within w_search_cencos
integer x = 37
integer y = 140
integer width = 1893
integer height = 1236
end type

event dw_master::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then	
	dw_master.SelectRow(0, false)
	dw_master.SelectRow(currentrow, true)
end if	
end event

event dw_master::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row
//str_parametros sl_datos

li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = LOWER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
//	ls_report = dw_lista.Describe(ls_column )	
//	dw_lista.Modify( ls_color)
//	this.Triggerevent( "ue_color_header")
	st_campo.text = "Orden " + is_col
	dw_1.reset()
	dw_1.InsertRow(0)
	dw_1.SetFocus()
ELSE
	ll_row = this.GetRow()
	
	if ll_row > 0 then		
		Any  la_id
		Integer li_x, li_y
		String ls_tipo

		FOR li_x = 1 TO UpperBound(ii_ik)			
			la_id = dw_master.object.data.primary.current[dw_master.getrow(), ii_ik[li_x]]
			// tipo del dato
			ls_tipo = This.Describe("#" + String(ii_ik[li_x]) + ".ColType")

			if LEFT( ls_tipo,1) = 'd' then
				ist_datos.field_ret[li_x] = string ( la_id)
			end if
			if LEFT( ls_tipo,1) = 'c' then
				ist_datos.field_ret[li_x] = la_id
			end if
		NEXT
		ist_datos.titulo = "s"		
		CloseWithReturn( parent, ist_datos)
	end if
END  IF
// Si el evento es disparado desde otro objeto que esta activo, este evento no reconoce el valor row como tal.
end event

event dw_master::getfocus;call super::getfocus;dw_1.SetFocus()
end event

event dw_master::constructor;call super::constructor;ii_ss = 1
end event

type st_campo from statictext within w_search_cencos
integer x = 23
integer y = 32
integer width = 713
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_search_cencos
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 745
integer y = 28
integer width = 1157
integer height = 80
integer taborder = 20
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_master.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_master.scrollnextrow()	
end if
ll_row = dw_master.Getrow()

//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
dw_master.triggerevent(doubleclicked!)
return 1
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type cb_1 from commandbutton within w_search_cencos
integer x = 859
integer y = 1404
integer width = 247
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cerrar"
end type

event clicked;ist_datos.titulo = "n"
CloseWithReturn( parent, ist_datos)
end event

