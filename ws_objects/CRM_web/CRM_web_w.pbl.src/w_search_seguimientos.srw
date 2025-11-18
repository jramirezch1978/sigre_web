$PBExportHeader$w_search_seguimientos.srw
forward
global type w_search_seguimientos from window
end type
type st_1 from statictext within w_search_seguimientos
end type
type st_campo from statictext within w_search_seguimientos
end type
type cb_3 from commandbutton within w_search_seguimientos
end type
type dw_1 from datawindow within w_search_seguimientos
end type
type dw_master from u_dw_abc within w_search_seguimientos
end type
type pb_1 from picturebutton within w_search_seguimientos
end type
type pb_3 from picturebutton within w_search_seguimientos
end type
type pb_2 from picturebutton within w_search_seguimientos
end type
end forward

global type w_search_seguimientos from window
integer width = 4494
integer height = 1624
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
st_1 st_1
st_campo st_campo
cb_3 cb_3
dw_1 dw_1
dw_master dw_master
pb_1 pb_1
pb_3 pb_3
pb_2 pb_2
end type
global w_search_seguimientos w_search_seguimientos

type variables
String  is_field_return, is_tipo, is_col = '', is_type
integer ii_ik[]
str_parametros ist_ret, ist_inp
end variables

on w_search_seguimientos.create
this.st_1=create st_1
this.st_campo=create st_campo
this.cb_3=create cb_3
this.dw_1=create dw_1
this.dw_master=create dw_master
this.pb_1=create pb_1
this.pb_3=create pb_3
this.pb_2=create pb_2
this.Control[]={this.st_1,&
this.st_campo,&
this.cb_3,&
this.dw_1,&
this.dw_master,&
this.pb_1,&
this.pb_3,&
this.pb_2}
end on

on w_search_seguimientos.destroy
destroy(this.st_1)
destroy(this.st_campo)
destroy(this.cb_3)
destroy(this.dw_1)
destroy(this.dw_master)
destroy(this.pb_1)
destroy(this.pb_3)
destroy(this.pb_2)
end on

event close;str_parametros lstr_param
try
	lstr_param.int1 = 0
	lstr_param.b_return	= false
catch(exception ex)
	lstr_param.int1 = 0
	lstr_param.b_return	= false
finally 
	lstr_param.int1 = 0
	lstr_param.b_return	= false
end try
end event

event open;
if TRIM( is_tipo) = '' then 	// Si tipo no es indicado, hace un retrieve
		dw_master.retrieve()
else		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			dw_master.Retrieve(ist_inp.string1)			
	END CHOOSE
end if

cb_3.enabled = false
pb_3.enabled = true
end event

type st_1 from statictext within w_search_seguimientos
integer x = 78
integer y = 12
integer width = 3013
integer height = 116
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "RELACION DE SEGUIMIENTOS"
boolean focusrectangle = false
end type

type st_campo from statictext within w_search_seguimientos
boolean visible = false
integer x = 69
integer y = 68
integer width = 864
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

type cb_3 from commandbutton within w_search_seguimientos
boolean visible = false
integer x = 1874
integer y = 64
integer width = 229
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;Integer ll_i, ll_pos
String  ls_sql_old,ls_sql_new, ls_descripcion, ls_campo, &
    ls_cad_a, ls_file

dw_1.ACCEPTTEXT()
IF TRIM(is_col) = ''  THEN
	Messagebox( "Error", "de Doble click sobre campo a buscar")
	Return 0
END IF

ls_sql_old   = dw_master.GetSQLSelect()

//ls_descripcion = "'"+TRIM(dw_1.object.campo[1])+'%'+"'"
ls_descripcion = "'"+TRIM(dw_1.object.campo[1])+"'"

if Pos(UPPER(dw_master.GetSQLSelect()),'WHERE',1) > 0 then	
//	ls_campo = ' AND ( '+ is_col +' LIKE '+ls_descripcion+' )'
//	if is_type = 'n' then
//		ls_campo = ' AND ( '+ is_col +' = '+ls_descripcion+' )'
//	else
		ls_campo = ' AND ( '+ is_col +' LIKE '+ls_descripcion+' )'
//	end if
ELSE	
	if is_type = 'n' then
		ls_campo = ' WHERE ' + is_col +' LIKE '+ TRIM(dw_1.object.campo[1]) //+' )' 
	else
		ls_campo = ' WHERE ( ' + is_col +' LIKE '+ls_descripcion+' )' 
	end if
END IF	

ll_pos = POS( ls_sql_old, 'ORDER' )
if ll_pos > 0 THEN	
	ls_cad_a = LEFT( ls_sql_old, ll_pos - 4 ) + ls_campo + &
	   MID( ls_sql_old, ll_pos - 3, LEN( ls_sql_old) -  ll_pos - 3)
	ls_sql_new = ls_cad_a
else
	ls_sql_new   = ls_sql_old + ls_campo
end if

IF dw_master.SetSQLSelect(ls_sql_new) = 1 THEN
	dw_master.Retrieve()
ELSE
	Return -1	
END IF
dw_master.SetSQLSelect(ls_sql_old)
dw_master.setfocus()

dw_1.object.campo[1] = ''   // Limpia dato a buscar
return 1
end event

type dw_1 from datawindow within w_search_seguimientos
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
boolean visible = false
integer x = 1038
integer y = 64
integer width = 818
integer height = 80
integer taborder = 10
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

event type long dwnenter();//Send(Handle(this),256,9,Long(0,0))
//dw_master.triggerevent(doubleclicked!)
cb_3.event clicked()
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
Long ll_fila, li_x

SetPointer(hourglass!)

String ls_campo

if TRIM( is_col) <> '' THEN

	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo

	   IF UPPER( is_type) = 'N' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_type) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF		

		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())	
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
			
			// ubica			
			dw_master.Event ue_output(ll_fila)			
		end if
	End if	
else
	Messagebox( "Aviso", "Seleccione el orden haciendo doble click en el titulo")
	dw_1.reset()
	this.insertrow(0)
end if	
SetPointer(arrow!)
end event

type dw_master from u_dw_abc within w_search_seguimientos
integer x = 32
integer y = 184
integer width = 4416
integer height = 1308
string dataobject = "d_lista_seguimientos_tbl"
end type

event doubleclicked;call super::doubleclicked;Str_parametros lstr_param		
//Integer 				li_seguimiento_id

try
	li_seguimiento_id			= dw_master.object.seguimiento_id			[1]
	lstr_param.b_return	= true
	lstr_param.int1		= li_seguimiento_id
	CloseWithReturn(w_search_seguimientos, lstr_param)
catch(exception ex)
	li_seguimiento_id = 0
	lstr_param.b_return	= false
	MessageBox("Error", ex.GetMessage())
finally
	
end try
end event

event getfocus;call super::getfocus;dw_1.SetFocus()
end event

event rowfocuschanging;call super::rowfocuschanging;if currentrow > 0 then	
	f_select_current_row( this)
end if	
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de es
end event

type pb_1 from picturebutton within w_search_seguimientos
boolean visible = false
integer x = 1637
integer y = 1300
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
alignment htextalign = right!
end type

event clicked;ist_ret.titulo = 'n'
CloseWithReturn( parent, ist_ret)
end event

type pb_3 from picturebutton within w_search_seguimientos
boolean visible = false
integer x = 1243
integer y = 1300
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
alignment htextalign = right!
end type

event clicked;if dw_master.rowCount() > 0 then
   Parent.PostEvent("ue_filter")
end if
end event

type pb_2 from picturebutton within w_search_seguimientos
boolean visible = false
integer x = 850
integer y = 1300
integer width = 325
integer height = 188
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
alignment htextalign = right!
end type

event clicked;
if TRIM( is_tipo) = '' then 	// Si tipo no es indicado, hace un retrieve
		dw_master.retrieve()
else		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			dw_master.Retrieve( ist_inp.string1)			
	END CHOOSE
end if

cb_3.enabled = false
pb_3.enabled = true
end event

