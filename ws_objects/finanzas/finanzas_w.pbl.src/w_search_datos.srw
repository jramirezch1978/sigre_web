$PBExportHeader$w_search_datos.srw
forward
global type w_search_datos from w_abc_master_smpl
end type
type st_campo from statictext within w_search_datos
end type
type dw_1 from datawindow within w_search_datos
end type
type cb_1 from commandbutton within w_search_datos
end type
end forward

global type w_search_datos from w_abc_master_smpl
integer width = 1984
integer height = 1608
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_campo st_campo
dw_1 dw_1
cb_1 cb_1
end type
global w_search_datos w_search_datos

type variables
String is_col = '', is_field_return, is_tipo
integer ii_ik[]
str_parametros ist_datos
end variables

on w_search_datos.create
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

on w_search_datos.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_1)
destroy(this.cb_1)
end on

event ue_open_pre;// Overr
str_parametros sl_param
String ls_null
Long   ll_row

ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

// Recoge parametro enviado
IF NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	sl_param = MESSAGE.POWEROBJECTPARM
	ii_ik = sl_param.field_ret_i	// Numero de campo a devolver
	is_tipo = sl_param.tipo
	dw_master.DataObject = sl_param.dw1
	dw_master.SetTransObject( SQLCA)

	IF TRIM( is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_master.retrieve()
	ELSE		// caso contrario hace un retrieve con parametros
		CHOOSE CASE is_tipo
				 CASE '1P'
					   ll_row = dw_master.Retrieve( sl_param.string1)
				 CASE '1CP'
					   ll_row = dw_master.Retrieve( sl_param.string1)
				 CASE 'LCR'		//Letras x Cobrar Renovación	
						ll_row = dw_master.Retrieve( sl_param.string1)
				 CASE	'NDC'		//Notas de Debito y Credito	
					   ll_row = dw_master.Retrieve( sl_param.string1,sl_param.string2)
				 CASE	'1CB'    	//Cartera de Pagos
					   ll_row = dw_master.Retrieve( sl_param.string1) 
				 CASE	'1CB_X_CB'	//Cuenta de Banco	
						ll_row = dw_master.Retrieve( sl_param.string1) 
				 CASE	'1CA'			//Canje Por Adelanto
						ll_row = dw_master.Retrieve( sl_param.string1) 
				 CASE	'1CD'			//Canje Por Adelanto
						ll_row = dw_master.Retrieve( sl_param.string1) 		
		END CHOOSE
	END IF
	
	ist_datos.titulo = 'n'
	This.Title = sl_param.titulo
	is_col = dw_master.Describe("#1" + ".name")
	st_campo.text = "Orden: " + is_col
END IF
end event

event ue_set_access;// OVER
end event

event resize;//Overr
dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 150
end event

event open;//override
THIS.EVENT ue_open_pre()
end event

type dw_master from w_abc_master_smpl`dw_master within w_search_datos
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
Long ll_row, ll_count
//str_parametros sl_datos

li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	is_tipo = LEFT( this.Describe(is_col + ".ColType"),1)
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"

//	ls_report = dw_lista.Describe(ls_column )	
//	dw_lista.Modify( ls_color)
//	this.Triggerevent( "ue_color_header")
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

			if LEFT( ls_tipo,4) = 'deci' or LEFT( ls_tipo,1) = 'numb' then
				ist_datos.field_ret[li_x] = string ( la_id)
			elseif LEFT( ls_tipo,1) = 'c' then
				ist_datos.field_ret[li_x] = la_id
			elseif LEFT( ls_tipo,4) = 'date' then
				ist_datos.field_ret[li_x] = string(la_id, 'dd/mm/yyyy')
				ll_count = upperbound(ist_datos.field_date)
				if IsNull(ll_count) then ll_count = 0
				ll_count ++
				ist_datos.field_date[ll_count] = Date ( la_id )
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

type st_campo from statictext within w_search_datos
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

type dw_1 from datawindow within w_search_datos
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
//		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		IF Upper( is_tipo) = 'N' OR UPPER( is_tipo) = 'D' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_tipo) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF
		
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

type cb_1 from commandbutton within w_search_datos
integer x = 864
integer y = 1396
integer width = 247
integer height = 108
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

