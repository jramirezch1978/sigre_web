$PBExportHeader$w_cm323_almacen_mov_proy.srw
forward
global type w_cm323_almacen_mov_proy from w_abc_master
end type
type st_1 from statictext within w_cm323_almacen_mov_proy
end type
type st_2 from statictext within w_cm323_almacen_mov_proy
end type
type sle_tipo_doc from singlelineedit within w_cm323_almacen_mov_proy
end type
type cb_1 from commandbutton within w_cm323_almacen_mov_proy
end type
type sle_nro_doc from singlelineedit within w_cm323_almacen_mov_proy
end type
end forward

global type w_cm323_almacen_mov_proy from w_abc_master
integer width = 3657
integer height = 1544
string title = "Modificar Almacen en AMPs (CM323)"
string menuname = "m_anulacion_mod"
windowstate windowstate = maximized!
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
st_1 st_1
st_2 st_2
sle_tipo_doc sle_tipo_doc
cb_1 cb_1
sle_nro_doc sle_nro_doc
end type
global w_cm323_almacen_mov_proy w_cm323_almacen_mov_proy

type variables

end variables

event ue_anular();Integer j

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF
// Anulando 
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1


end event

on w_cm323_almacen_mov_proy.create
int iCurrent
call super::create
if this.MenuName = "m_anulacion_mod" then this.MenuID = create m_anulacion_mod
this.st_1=create st_1
this.st_2=create st_2
this.sle_tipo_doc=create sle_tipo_doc
this.cb_1=create cb_1
this.sle_nro_doc=create sle_nro_doc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_tipo_doc
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.sle_nro_doc
end on

on w_cm323_almacen_mov_proy.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_tipo_doc)
destroy(this.cb_1)
destroy(this.sle_nro_doc)
end on

event ue_open_pre;call super::ue_open_pre;//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)




end event

event ue_update_pre;call super::ue_update_pre;if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master`dw_master within w_cm323_almacen_mov_proy
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 272
integer width = 3442
integer height = 820
string dataobject = "d_abc_almacen_mov_proy"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "almacen"
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "DESC_almacen AS DESCRIPCION_almacen " &
				  + "FROM almacen " &
				  + "where flag_estado <> '0'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.almacen [al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,                    	
is_dwform = 'tabular'	
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this)
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event dw_master::itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_null
this.AcceptText()
SetNull(ls_null)
if row <= 0 then return 

choose case lower(dwo.name)
	case "almacen"
		
		SetNull(ls_data)
		select desc_almacen
			into :ls_data
		from almacen
		where almacen = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Codigo de Almacen no existe o no esta activo", StopSign!)
			this.object.almacen	[row] = ls_null
			return 1
		end if

end choose

end event

type st_1 from statictext within w_cm323_almacen_mov_proy
integer x = 585
integer y = 44
integer width = 2441
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Permite Cambiar el ALMACEN, en Movimientos Proyectados"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm323_almacen_mov_proy
integer x = 101
integer y = 172
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Documento:"
boolean focusrectangle = false
end type

type sle_tipo_doc from singlelineedit within w_cm323_almacen_mov_proy
event dobleclick pbm_lbuttondblclk
integer x = 475
integer y = 160
integer width = 169
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT distinct a.tipo_doc AS tipo_documento, " &
		 + "b.desc_Tipo_doc AS DESCRIPCION_tipo_doc " &
		 + "FROM articulo_mov_proy a, " &
		 + "doc_tipo b " &
		 + "where a.tipo_doc = b.tipo_doc " &
		 + "and a.flag_estado = '1' " 
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if

end event

type cb_1 from commandbutton within w_cm323_almacen_mov_proy
integer x = 1115
integer y = 148
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;dw_master.retrieve( sle_tipo_doc.text, sle_nro_doc.text)
dw_master.ii_protect = 0
dw_master.of_protect()
end event

type sle_nro_doc from singlelineedit within w_cm323_almacen_mov_proy
event dobleclick pbm_lbuttondblclk
integer x = 663
integer y = 160
integer width = 439
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_nro_doc, ls_data, ls_sql, ls_tipo_doc

ls_tipo_doc = sle_tipo_doc.text

if ls_tipo_doc = '' or IsNull(ls_tipo_doc) then
	MessageBox('Aviso', 'Debe Indicar primero tipo_doc')
	return
end if

ls_sql = "SELECT distinct a.tipo_doc AS tipo_doc, " &
		 + "a.nro_doc AS numero_documento " &
		 + "FROM articulo_mov_proy a " &
		 + "where a.flag_estado = '1' " &
		 + "and a.tipo_doc = '" + ls_tipo_doc + "' " &
		 + "order by a.nro_doc " 
			 
lb_ret = f_lista(ls_sql, ls_data, ls_nro_doc, '1')
		
if ls_nro_doc <> '' then
	this.text = ls_nro_doc
end if
end event

