$PBExportHeader$w_abc_seleccion_lista_search.srw
forward
global type w_abc_seleccion_lista_search from w_abc_list
end type
type cb_1 from commandbutton within w_abc_seleccion_lista_search
end type
type st_campo from statictext within w_abc_seleccion_lista_search
end type
type dw_3 from datawindow within w_abc_seleccion_lista_search
end type
end forward

global type w_abc_seleccion_lista_search from w_abc_list
integer x = 50
integer width = 3191
integer height = 1792
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_1 cb_1
st_campo st_campo
dw_3 dw_3
end type
global w_abc_seleccion_lista_search w_abc_seleccion_lista_search

type variables
String is_tipo,is_col
str_parametros is_param

end variables

forward prototypes
public function boolean of_opcion1 ()
public function boolean of_opcion2 ()
end prototypes

public function boolean of_opcion1 ();Long 		ll_i
String 	ls_codigo

delete tt_cntbl_cliente;
if gnvo_app.of_ExistsError(SQLCA) then
	 rollback;
	 return false
end if
commit;

for ll_i = 1 to dw_2.rowcount()
  	 ls_codigo      = dw_2.object.proveedor		[ll_i]
	 
	 insert into tt_cntbl_cliente (codigo)
	 values (:ls_codigo) ;
	 
	 if gnvo_app.of_ExistsError(SQLCA) then
		 rollback;
		 return false
	end if
next
		
return true
end function

public function boolean of_opcion2 ();Long 		ll_i
String 	ls_codigo

delete tt_cnt_cnta_ctbl;
if gnvo_app.of_ExistsError(SQLCA) then
	 rollback;
	 return false
end if
commit;

for ll_i = 1 to dw_2.rowcount()
  	 ls_codigo      = dw_2.object.cnta_ctbl		[ll_i]
	 
	 insert into tt_cnt_cnta_ctbl (CNTA_CTBL)
	 values (:ls_codigo) ;
	 
	 if gnvo_app.of_ExistsError(SQLCA) then
		 rollback;
		 return false
	end if
next
		
return true
end function

on w_abc_seleccion_lista_search.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_campo=create st_campo
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_campo
this.Control[iCurrent+3]=this.dw_3
end on

on w_abc_seleccion_lista_search.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_campo)
destroy(this.dw_3)
end on

event ue_open_pre;// Overr
String ls_null
Long   ll_row

// Recoge parametro enviado

This.Title 	= is_param.titulo
is_tipo 		= is_param.tipo
//this.width 	= is_param.db1

dw_1.DataObject = is_param.dw1
dw_2.Dataobject = is_param.dw1

dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)



//Inicializar Variable de Busqueda //

CHOOSE CASE is_tipo
	CASE '1S'
		ll_row = dw_1.Retrieve( is_param.string1 )
	CASE '1L'
		ll_row = dw_1.Retrieve( is_param.long1 )
END CHOOSE

end event

event open;//override
THIS.EVENT ue_open_pre()
end event

event resize;call super::resize;dw_2.height = newheight - dw_2.y - 10
dw_1.height = newheight - dw_1.y - 10

pb_1.x 	  = newWidth / 2 - pb_1.width / 2
pb_2.x 	  = newWidth / 2 - pb_2.width / 2

dw_1.width = pb_1.x - dw_1.x - 10
dw_2.x = pb_1.x + pb_1.width + 10
dw_2.width = newwidth - dw_2.x - 10

cb_1.x	  = dw_2.x + dw_2.width - cb_1.width

end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_lista_search
integer x = 9
integer y = 136
integer width = 517
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	is_param = MESSAGE.POWEROBJECTPARM	
end if

ii_ss 	  = 0
is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form
idw_det  = dw_2 				// dw_detail 

ii_ss = 0
end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	   ll_row, ll_rc, ll_count
Any	   la_id
Integer	li_x


ll_row = idw_det.EVENT ue_insert()

ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)



end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

event dw_1::getfocus;call super::getfocus;dw_1.SetFocus()
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')

IF li_pos > 0 THEN
//	is_tipo = 
	is_col  = UPPER( mid(ls_column,1,li_pos - 1) )	
	is_tipo = LEFT( this.Describe(is_col + ".ColType"),1)	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	dw_3.reset()
	dw_3.InsertRow(0)
	dw_3.SetFocus()

END IF
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_lista_search
integer x = 699
integer y = 136
integer width = 517
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ss 	  = 0
ii_ck[1] = 1

end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)


end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_lista_search
integer x = 539
integer y = 456
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_lista_search
integer x = 539
integer y = 704
end type

type cb_1 from commandbutton within w_abc_seleccion_lista_search
integer x = 1472
integer y = 20
integer width = 297
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;dw_2.Accepttext()


CHOOSE CASE is_param.opcion
	CASE 1 //Reporte CN736
		if not of_opcion1() then
			is_param.i_return = -1
		else
			is_param.i_return = 1
		end if
				
	CASE 2 //Reporte CN736
		if not of_opcion2() then
			is_param.i_return = -1
		else
			is_param.i_return = 1
		end if

END CHOOSE

Closewithreturn(parent,is_param)
end event

type st_campo from statictext within w_abc_seleccion_lista_search
integer x = 27
integer y = 24
integer width = 453
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda :"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_abc_seleccion_lista_search
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 489
integer y = 24
integer width = 974
integer height = 80
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long dw_enter();//Send(Handle(this),256,9,Long(0,0))
dw_1.triggerevent(doubleclicked!)
return 1
end event

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if

ll_row = dw_3.Getrow()

Return 1
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
	//	ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		IF Upper( is_tipo) = 'N' OR UPPER( is_tipo) = 'D' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_tipo) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
			dw_3.Setfocus()
		end if
	End if	
end if	
SetPointer(arrow!)
end event

