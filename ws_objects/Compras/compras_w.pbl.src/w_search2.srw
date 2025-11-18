$PBExportHeader$w_search2.srw
forward
global type w_search2 from w_cns
end type
type dw_master from u_dw_cns within w_search2
end type
type st_campo from statictext within w_search2
end type
type dw_1 from datawindow within w_search2
end type
type cb_1 from commandbutton within w_search2
end type
end forward

global type w_search2 from w_cns
integer width = 1920
integer height = 1592
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_master dw_master
st_campo st_campo
dw_1 dw_1
cb_1 cb_1
end type
global w_search2 w_search2

type variables
String is_col = '', is_field_return, is_tipo
integer ii_ik[]
str_parametros ist_datos
end variables

event ue_open_pre;call super::ue_open_pre;str_parametros sl_param
String ls_null
Long ll_row

// Recoge parametro enviado
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	sl_param = MESSAGE.POWEROBJECTPARM
	ii_ik = sl_param.field_ret_i	// Numero de campo a devolver
	is_tipo = sl_param.tipo
	dw_master.DataObject = sl_param.dw1
	dw_master.SetTransObject( SQLCA)	

	if TRIM( is_tipo) = '' then 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_master.retrieve()
	else		// caso contrario hace un retrieve con parametros
		CHOOSE CASE is_tipo
			CASE '1S'
				ll_row = dw_master.Retrieve( sl_param.string1)
		END CHOOSE
	end if
	ist_datos.titulo = 'n'
	This.Title = sl_param.titulo
	is_col = dw_master.Describe("#1" + ".name")
	st_campo.text = "Orden: " + is_col
END IF
end event

on w_search2.create
int iCurrent
call super::create
this.dw_master=create dw_master
this.st_campo=create st_campo
this.dw_1=create dw_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.st_campo
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cb_1
end on

on w_search2.destroy
call super::destroy
destroy(this.dw_master)
destroy(this.st_campo)
destroy(this.dw_1)
destroy(this.cb_1)
end on

type dw_master from u_dw_cns within w_search2
integer x = 9
integer y = 160
integer width = 1879
integer height = 1192
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw
// ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
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

event getfocus;call super::getfocus;dw_1.SetFocus()
end event

event rowfocuschanged;call super::rowfocuschanged;f_Select_current_row(this)
end event

type st_campo from statictext within w_search2
integer x = 23
integer y = 20
integer width = 713
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_search2
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
ll_row = dw_1.Getrow()

//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
dw_master.triggerevent(doubleclicked!)
return 1
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

event constructor;	// Adiciona registro en dw1
	Long ll_reg

	ll_reg = dw_1.insertrow(0)


end event

type cb_1 from commandbutton within w_search2
integer x = 773
integer y = 1384
integer width = 247
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
end type

event clicked;ist_datos.titulo = "n"
CloseWithReturn( parent, ist_datos)
end event

