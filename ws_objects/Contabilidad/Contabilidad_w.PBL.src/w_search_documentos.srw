$PBExportHeader$w_search_documentos.srw
forward
global type w_search_documentos from w_abc_master_smpl
end type
type st_campo from statictext within w_search_documentos
end type
type dw_1 from datawindow within w_search_documentos
end type
type cb_3 from commandbutton within w_search_documentos
end type
type pb_1 from picturebutton within w_search_documentos
end type
type pb_2 from picturebutton within w_search_documentos
end type
type pb_3 from picturebutton within w_search_documentos
end type
end forward

global type w_search_documentos from w_abc_master_smpl
integer width = 1829
integer height = 1576
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_campo st_campo
dw_1 dw_1
cb_3 cb_3
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
end type
global w_search_documentos w_search_documentos

type variables
String  is_field_return, is_tipo, is_col = '', is_type
integer ii_ik[]
str_parametros ist_ret, ist_inp
end variables

on w_search_documentos.create
int iCurrent
call super::create
this.st_campo=create st_campo
this.dw_1=create dw_1
this.cb_3=create cb_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.pb_3
end on

on w_search_documentos.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_1)
destroy(this.cb_3)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
end on

event ue_open_pre();// Overr

String ls_null
Long ll_row
ii_lec_mst = 0

idw_1 = dw_master
// Recoge parametro enviado
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_inp = MESSAGE.POWEROBJECTPARM
	ii_ik = ist_inp.field_ret_i	// Numero de campo a devolver
	is_tipo = ist_inp.tipo
	dw_master.DataObject = ist_inp.dw1
	dw_master.SetTransObject( SQLCA)	

	This.Title = ist_inp.titulo		// Titulo de ventana

	dw_1.object.campo.background.mode = 0
	dw_1.object.campo.background.color = RGB(192,192,192)			
	dw_1.object.campo.protect = 1	
	
	st_campo.text = "Buscar por: "  //+ is_col
	dw_1.Setfocus()
END IF
end event

event ue_set_access;// OVER
end event

event resize;//Overr
Long ll_x, ll_y

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 200

ll_x = (w_main.WorkSpaceWidth() - This.WorkSpacewidth() ) - 50
ll_y = (w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) - 50

this.move(ll_x, ll_y)
end event

event open;//override
THIS.EVENT ue_open_pre()

end event

type dw_master from w_abc_master_smpl`dw_master within w_search_documentos
integer x = 27
integer y = 112
integer width = 1765
integer height = 1092
end type

event dw_master::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then	
	f_select_current_row( this)
end if	
end event

event dw_master::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column 
Long ll_row

li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = mid(ls_column,1,li_pos - 1)	
	 			
	st_campo.text = "Buscar por: " + dw_master.describe( is_col + "_t.text")
	dw_1.reset()
	dw_1.InsertRow(0)
	dw_1.SetFocus()	

	is_type = LEFT( this.Describe(is_col + ".ColType"),1)
	dw_1.object.campo.background.color = RGB(255,255,255)
	dw_1.object.campo.protect = 0
ELSE
//	if row > 0 then
//		ist_ret.titulo = "n"
//		CloseWithReturn( parent, ist_ret)
//	end if
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
				ist_ret.field_ret[li_x] = string ( la_id)
			end if
			if LEFT( ls_tipo,1) = 'c' then
				ist_ret.field_ret[li_x] = la_id
			end if
		NEXT
		ist_ret.titulo = "s"		
		CloseWithReturn( parent, ist_ret)
	end if
END  IF
// Si el evento es disparado desde otro objeto que esta activo, este evento no reconoce el valor row como tal.
end event

event dw_master::getfocus;call super::getfocus;dw_1.SetFocus()
end event

event dw_master::ue_output(long al_row);call super::ue_output;// Ubica registro
//ist_inp.dw_m.ScrollToRow( al_row )
//
//ist_inp.dw_m.TriggerEVENT ("ue_refresh_det")
//ist_inp.dw_d.ScrollToRow(al_row)
end event

type st_campo from statictext within w_search_documentos
integer x = 14
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

type dw_1 from datawindow within w_search_documentos
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 736
integer y = 20
integer width = 818
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

type cb_3 from commandbutton within w_search_documentos
integer x = 1573
integer y = 16
integer width = 229
integer height = 84
integer taborder = 30
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

type pb_1 from picturebutton within w_search_documentos
integer x = 1047
integer y = 1292
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
string picturename = "\Source\Bmp\Salir.bmp"
alignment htextalign = right!
end type

event clicked;ist_ret.titulo = 'n'
CloseWithReturn( parent, ist_ret)
end event

type pb_2 from picturebutton within w_search_documentos
integer x = 261
integer y = 1292
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
boolean originalsize = true
string picturename = "\Source\Bmp\Todos.bmp"
alignment htextalign = right!
end type

event clicked;if TRIM( is_tipo) = '' then 	// Si tipo no es indicado, hace un retrieve
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

type pb_3 from picturebutton within w_search_documentos
integer x = 654
integer y = 1292
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
boolean enabled = false
string picturename = "\Source\Bmp\filtrar.bmp"
string disabledname = "\Source\Bmp\filtrar.bmp"
alignment htextalign = right!
end type

event clicked;messagebox('Aviso','clicked')
if dw_master.rowCount() > 0 then
   Parent.PostEvent("ue_filter")
end if

end event

