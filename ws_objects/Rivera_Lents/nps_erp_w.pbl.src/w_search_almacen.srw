$PBExportHeader$w_search_almacen.srw
forward
global type w_search_almacen from w_abc_master_smpl
end type
type st_campo from statictext within w_search_almacen
end type
type dw_1 from datawindow within w_search_almacen
end type
type cb_1 from commandbutton within w_search_almacen
end type
end forward

global type w_search_almacen from w_abc_master_smpl
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
global w_search_almacen w_search_almacen

type variables
String  is_field_return, is_tipo, is_col = '', is_type
integer ii_ik[]
str_parametros ist_datos
end variables

on w_search_almacen.create
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

on w_search_almacen.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_1)
destroy(this.cb_1)
end on

event ue_open_pre;// Overr

str_parametros sl_param
String 	ls_null, ls_grp_cntbl, ls_cencos, ls_tipo_mov, ls_cnta_prsp, &
			ls_sub_cat
Long 		ll_row
integer	li_factor_prsp

ii_lec_mst = 0
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
				
			CASE '2S'
				ll_row = dw_master.Retrieve( sl_param.string1, sl_param.string2)
				
			CASE '1S_MATRIZ'

				if IsNull(sl_param.factor_prsp) then
					MessageBox('Aviso', 'Debe indicar Factor_prsp en str_parametros')
					return
				end if
				
				ls_tipo_mov  = string(sl_param.string1)
				li_factor_prsp = sl_param.factor_prsp
				
				if li_factor_prsp = 0 then
					ls_grp_cntbl = '%%'
					ls_cnta_prsp = '%%'

				else
					ls_cencos	 = sl_param.string2
					ls_cnta_prsp = sl_param.string3
					
					select grp_cntbl
						into :ls_grp_cntbl
					from centros_costo
					where cencos = :ls_cencos;
					
					if SQLCA.SQlCode = 100 then
						MessageBox('Error', 'Centro de Costo ' + ls_cencos + ' no existe')
						return
					end if
					
					if ls_grp_cntbl = '' or IsNull(ls_grp_cntbl) then
						MessageBox('Aviso', 'El Centro de Costo: ' + ls_cencos &
							+ ' no tiene definido un grupo contable', StopSign!)
						ls_grp_cntbl ='%%'
					end if
					
				end if
				
				ls_tipo_mov = trim(ls_tipo_mov)
				ls_grp_cntbl = trim(ls_grp_cntbl) + '%'
				ls_cnta_prsp = trim(ls_cnta_prsp) + '%'
				
				ll_row = dw_master.Retrieve( ls_tipo_mov, ls_grp_cntbl, ls_cnta_prsp )

			CASE '2S_MATRIZ'

				if IsNull(sl_param.factor_prsp) then
					MessageBox('Aviso', 'Debe indicar Factor_prsp en str_parametros')
					return
				end if
				
				ls_tipo_mov  = string(sl_param.string1)
				li_factor_prsp = sl_param.factor_prsp
				ls_sub_cat = sl_param.string3
				
				if li_factor_prsp = 0 then
					ls_grp_cntbl = '%'
				else
					ls_cencos  = sl_param.string2
					
					select grp_cntbl
						into :ls_grp_cntbl
					from centros_costo
					where cencos = :ls_cencos;
					
					if SQLCA.SQlCode = 100 then
						MessageBox('Error', 'Centro de Costo ' + ls_cencos + ' no existe')
						return
					end if
					
					if ls_grp_cntbl = '' or IsNull(ls_grp_cntbl) then
						MessageBox('Aviso', 'El Centro de Costo: ' + ls_cencos &
							+ ' no tiene definido un grupo contable', StopSign!)
						ls_grp_cntbl ='%'
					end if
					
				end if
				
				ls_tipo_mov  = trim(ls_tipo_mov)
				ls_grp_cntbl = trim(ls_grp_cntbl) + '%'
				ls_sub_cat   = trim(ls_sub_cat) + '%'
				
				ll_row = dw_master.Retrieve( ls_tipo_mov, ls_grp_cntbl, ls_sub_cat )

		END CHOOSE
	end if	

	ist_datos.titulo = 'n'
	This.Title = sl_param.titulo
		
	// Muestra proveedores segun registro actual		
	st_campo.text = "Buscar por: "  //+ is_col
	dw_1.Setfocus()
END IF

Int j, li_col

// Desactiva edicion
li_col = Long( dw_master.Object.DataWindow.Column.Count)

for j =1 to li_col
	dw_master.modify( '#' + string(j) + ".edit.displayonly = true")
	dw_master.modify( '#' + string(j) + ".tabsequence = 0")
next
end event

event ue_set_access;// OVER
end event

event resize;//Overr
dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 150
end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()
end event

type ole_skin from w_abc_master_smpl`ole_skin within w_search_almacen
end type

type st_filter from w_abc_master_smpl`st_filter within w_search_almacen
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_search_almacen
end type

type st_box from w_abc_master_smpl`st_box within w_search_almacen
end type

type uo_h from w_abc_master_smpl`uo_h within w_search_almacen
end type

type dw_master from w_abc_master_smpl`dw_master within w_search_almacen
integer x = 0
integer y = 132
integer width = 1925
integer height = 1236
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
ELSE
	if row > 0 then		
		Any  la_id
		Integer li_x, li_y
		String ls_tipo

		FOR li_x = 1 TO UpperBound(ii_ik)			
			la_id = this.object.data.primary.current[row, ii_ik[li_x]]
			// tipo del dato
			ls_tipo = This.Describe("#" + String(ii_ik[li_x]) + ".ColType")
			
			if LEFT( ls_tipo,4 ) = 'date' then
				ist_datos.field_ret[li_x] = string ( la_id, 'dd/mm/yyyy' )
			elseif LEFT( ls_tipo,4 ) = 'char' then
				ist_datos.field_ret[li_x] = la_id
			elseif LEFT( ls_tipo,4 ) = 'deci' or LEFT( ls_tipo,4 ) = 'numb' then
				ist_datos.field_ret[li_x] = string(la_id)
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

event dw_master::constructor;call super::constructor;ii_access = 0
end event

event dw_master::clicked;call super::clicked;

//f_select_current_row( this)
end event

type st_campo from statictext within w_search_almacen
integer x = 23
integer y = 28
integer width = 919
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

type dw_1 from datawindow within w_search_almacen
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 965
integer y = 24
integer width = 960
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
		end if
	End if	
else
	Messagebox( "Aviso", "Seleccione el orden haciendo doble click en el titulo")
	dw_1.reset()
	this.insertrow(0)
end if	
SetPointer(arrow!)
end event

type cb_1 from commandbutton within w_search_almacen
integer x = 773
integer y = 1396
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

