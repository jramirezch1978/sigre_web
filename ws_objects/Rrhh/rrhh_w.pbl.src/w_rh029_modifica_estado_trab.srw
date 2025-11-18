$PBExportHeader$w_rh029_modifica_estado_trab.srw
forward
global type w_rh029_modifica_estado_trab from w_abc
end type
type dw_lista from u_dw_abc within w_rh029_modifica_estado_trab
end type
type dw_3 from datawindow within w_rh029_modifica_estado_trab
end type
type st_campo from statictext within w_rh029_modifica_estado_trab
end type
type p_2 from picture within w_rh029_modifica_estado_trab
end type
end forward

global type w_rh029_modifica_estado_trab from w_abc
integer width = 1719
integer height = 2076
string title = "[RH029] Modificar Estado Trabajador"
string menuname = "m_modifica_graba"
boolean maxbox = false
boolean resizable = false
dw_lista dw_lista
dw_3 dw_3
st_campo st_campo
p_2 p_2
end type
global w_rh029_modifica_estado_trab w_rh029_modifica_estado_trab

type variables
String is_col,is_tipo
end variables

on w_rh029_modifica_estado_trab.create
int iCurrent
call super::create
if this.MenuName = "m_modifica_graba" then this.MenuID = create m_modifica_graba
this.dw_lista=create dw_lista
this.dw_3=create dw_3
this.st_campo=create st_campo
this.p_2=create p_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.st_campo
this.Control[iCurrent+4]=this.p_2
end on

on w_rh029_modifica_estado_trab.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.dw_3)
destroy(this.st_campo)
destroy(this.p_2)
end on

event ue_open_pre;call super::ue_open_pre;dw_lista.SetTransObject(sqlca)

dw_lista.retrieve(gs_origen)

idw_1 = dw_lista

is_col = 'nombres'

is_tipo = LEFT( dw_lista.Describe(is_col + ".ColType"),1)	

// Bloque dw_lista

dw_lista.ii_protect = 0
dw_lista.of_protect( )
end event

event ue_modify;call super::ue_modify;dw_lista.of_protect()

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_lista.ii_update = 1  THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_lista.ii_update = 0
	END IF
END IF

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_lista.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF dw_lista.ii_update = 1 THEN
	IF dw_lista.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_lista.ii_update = 0
	
	dw_lista.ii_protect = 0
	dw_lista.of_protect( )

END IF

end event

event resize;call super::resize;dw_lista.width  = newwidth  - dw_lista.x - 10
dw_lista.height = newheight - dw_lista.y - 10
end event

type dw_lista from u_dw_abc within w_rh029_modifica_estado_trab
integer y = 296
integer width = 1655
integer height = 1588
integer taborder = 20
string dataobject = "d_abc_modifica_estado_trab_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

if row = 0  then return 
this.Event rowfocuschanged (row)
end event

event constructor;call super::constructor;is_mastdet = 'M'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	



ii_ck[1] = 1				// columnas de lectrua de este dw


idw_mst = dw_lista

end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = this.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')

IF li_pos > 0 THEN
//	is_tipo = 
	is_col  = UPPER( mid(ls_column,1,li_pos - 1) )	
	is_tipo = LEFT( this.Describe(is_col + ".ColType"),1)	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Por " + is_col
	dw_3.reset()
	dw_3.InsertRow(0)
	dw_3.SetFocus()

END IF
end event

event rowfocuschanged;call super::rowfocuschanged;//String ls_cod_trab,ls_flag_estado
//
//
//
//This.SelectRow(0, False)
//This.SelectRow(currentrow, True)
//
//This.Setrow(currentrow)
//
//ls_cod_trab    = this.object.cod_trabajador [currentrow]
//ls_flag_estado = this.object.flag_estado	  [currentrow]
//
//dw_master.retrieve(ls_cod_trab)
//tab_1.tabpage_2.dw_detail_carga.retrieve(ls_cod_trab)
//tab_1.tabpage_4.dw_tarjetas.retrieve(ls_cod_trab)
//tab_1.tabpage_5.dw_cargos.retrieve(ls_cod_trab)
//tab_1.tabpage_7.dw_mov_est.retrieve(ls_cod_trab)
//tab_1.tabpage_8.dw_periodos_laborales.retrieve(ls_cod_trab)
//
//if dw_master.rowcount() > 0 then
//	is_accion = 'fileopen'
//	if ls_flag_estado = '0' then
//		//bloquearlo
//		dw_master.ii_protect = 0
//		tab_1.tabpage_1.dw_detail.ii_protect = 0
//		tab_1.tabpage_2.dw_detail_carga.ii_protect = 0
//		tab_1.tabpage_4.dw_tarjetas.ii_protect = 0
//		tab_1.tabpage_5.dw_cargos.ii_protect = 0
//		tab_1.tabpage_7.dw_mov_est.ii_protect = 0
//		Parent.TriggerEvent('ue_modify')
//	end if
//end if	
//
end event

type dw_3 from datawindow within w_rh029_modifica_estado_trab
event ue_tecla pbm_dwnkey
event dw_enter pbm_dwnprocessenter
integer x = 192
integer y = 184
integer width = 965
integer height = 80
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_lista.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_lista.scrollnextrow()	
end if

ll_row = dw_3.Getrow()

Return 1
end event

event dw_enter;dw_lista.triggerevent(doubleclicked!)
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
	//	ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		IF Upper( is_tipo) = 'N' OR UPPER( is_tipo) = 'D' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_tipo) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF
	
		ll_fila = dw_lista.find(ls_comando, 1, dw_lista.rowcount())
		IF ll_fila <> 0 THEN		// la busqueda resulto exitosa
			dw_lista.selectrow(0, FALSE)
			dw_lista.selectrow(ll_fila, TRUE)
			dw_lista.scrolltorow(ll_fila)
			dw_3.Setfocus()
		END IF
	End if	
end if	
SetPointer(arrow!)
end event

type st_campo from statictext within w_rh029_modifica_estado_trab
integer x = 192
integer y = 100
integer width = 448
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Nombres"
boolean focusrectangle = false
end type

type p_2 from picture within w_rh029_modifica_estado_trab
integer x = 5
integer y = 12
integer width = 165
integer height = 232
string picturename = "H:\Source\Gif\toolbtn_people.gif"
boolean focusrectangle = false
end type

