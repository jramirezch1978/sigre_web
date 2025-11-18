$PBExportHeader$w_fl026_nave_repres.srw
forward
global type w_fl026_nave_repres from w_abc_mastdet_smpl
end type
type st_master from statictext within w_fl026_nave_repres
end type
type st_detail from statictext within w_fl026_nave_repres
end type
end forward

global type w_fl026_nave_repres from w_abc_mastdet_smpl
integer width = 2880
integer height = 1684
string title = "Representantes por nave (FL026)"
string menuname = "m_mto_smpl"
event ue_menu ( boolean ab_estado )
st_master st_master
st_detail st_detail
end type
global w_fl026_nave_repres w_fl026_nave_repres

type variables
StaticText 	ist_1
Long			il_st_color
end variables

event ue_menu(boolean ab_estado);menuid.item[1].item[1].item[2].enabled = ab_estado
menuid.item[1].item[1].item[3].enabled = ab_estado
menuid.item[1].item[1].item[4].enabled = ab_estado
menuid.item[1].item[1].item[5].enabled = ab_estado

menuid.item[1].item[1].item[2].visible = ab_estado
menuid.item[1].item[1].item[3].visible = ab_estado
menuid.item[1].item[1].item[4].visible = ab_estado
menuid.item[1].item[1].item[5].visible = ab_estado

MenuId.item[1].item[1].item[2].ToolbarItemvisible = ab_estado
MenuId.item[1].item[1].item[3].ToolbarItemvisible = ab_estado
MenuId.item[1].item[1].item[4].ToolbarItemvisible = ab_estado
MenuId.item[1].item[1].item[5].ToolbarItemvisible = ab_estado

end event

on w_fl026_nave_repres.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.st_master=create st_master
this.st_detail=create st_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_master
this.Control[iCurrent+2]=this.st_detail
end on

on w_fl026_nave_repres.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_master)
destroy(this.st_detail)
end on

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event resize;// Ancestor Script has been Override
dw_master.width  = newwidth  - dw_master.x - 10
st_master.X = dw_master.X
st_master.width = dw_master.width

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
st_detail.x = dw_detail.X
st_Detail.width = dw_detail.width
end event

event ue_open_pre;call super::ue_open_pre;il_st_color = st_master.BackColor
ist_1 		= st_master
end event

event ue_update_pre;call super::ue_update_pre;string	ls_flag
Long 		ll_row
boolean 	lb_resp_cobranza

ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

//Verifico que exista alguien responsable de la Cobranza
lb_resp_cobranza = false
for ll_row = 1 to dw_detail.RowCount()
	ls_flag = dw_detail.object.flag_resp_cobranza[ll_row]
	if ls_flag = '1' then
		lb_resp_cobranza = true
		exit
	end if
next

if lb_resp_cobranza = false then
	MessageBox('Aviso', 'No existe responsable de cobranza para la embarcación', StopSign!)
	ib_update_check = false
	return
end if
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_fl026_nave_repres
integer x = 0
integer y = 84
integer width = 2633
integer height = 652
string dataobject = "d_naves_propias_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  	= il_st_color
ist_1.italic     	= false
ist_1 				= st_master
ist_1.backcolor 	= rgb(100,0,0)
ist_1.italic 		= true


parent.event ue_menu(false)
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fl026_nave_repres
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 832
integer width = 2629
integer height = 596
string dataobject = "d_nave_repres_grid"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = StyleRaised!
end type

event dw_detail::ue_display(string as_columna, long al_row);string 	ls_codigo, ls_data, ls_sql, ls_nave
Long		ll_find
boolean	lb_ret
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "REPRESENTANTE"
		
		ls_sql = "SELECT REPRESENTANTE AS CODIGO, " &
				 + "NOMBRE_COMPLETO AS NOMBRE " &
             + "FROM TG_REPRESENTANTE "
		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			
			ll_find = this.find("representante = '" + ls_codigo + "'", 1, this.RowCount())

			if ll_find > 0 and ll_find <> al_row then
				MessageBox('Aviso', 'Representante ya ha sido ingresado, por favor Verifique', StopSign!)
				SetNull(ls_codigo)
				this.object.representante			[al_row]	= ls_codigo
				this.object.nombre_representante	[al_row]	= ls_codigo
			else
				this.object.nombre_representante[al_row] 	= ls_data		
				this.object.representante[al_row] 			= ls_codigo
			end if
			
			this.ii_update = 1
		end if

end choose

end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::ue_insert;call super::ue_insert;long ll_row

ll_row = this.GetRow()

if ll_row <= 0 then
	return ll_row
end if

this.object.flag_resp_cobranza[ll_row] = '0'

return ll_row
end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

event dw_detail::itemchanged;call super::itemchanged;string 	ls_data, ls_nave, ls_flag_tipo, &
			ls_representante
Long 		ll_find

this.AcceptText()

choose case lower(dwo.name)
	case "representante"
		
		ls_representante 	= this.object.representante[row]
		ls_nave   			= this.object.nave[row]
		
		ll_find = this.find("representante = '" + ls_representante &
			+ "'", 1, this.RowCount())

		if ll_find > 0 and ll_find <> row then
			MessageBox('Aviso', 'Representante ya ha sido ingresado, por favor Verifique', StopSign!)
			SetNull(ls_representante)
			this.object.representante[row] 			= ls_representante
			this.object.nombre_representante[row]	= ls_representante
			return 1
		end if

		SetNull(ls_data)
		select nombre_completo
			into :ls_data
		from tg_representante
		where representante = :ls_representante;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Error', "CODIGO DE REPRESENTANTE NO EXISTE", StopSign!)
			return 1
		end if
		
		This.object.nombre_representante[row] = ls_data
		
	CASE "flag_tipo"

		ls_flag_tipo 		= this.object.flag_tipo[row]

		if ls_flag_tipo = "A" or ls_flag_tipo="P" then
			ll_find = this.find( "flag_tipo = '" + ls_flag_tipo &
				+ "'", 1, this.RowCount())
			
			if ll_find > 0 and ll_find <> row then
				if ls_flag_tipo = "A" then
					MessageBox('Aviso', 'Esta embarcación ya tiene un Administrador', StopSign!)
				else
					MessageBox('Aviso', 'Esta embarcación ya tiene un Propietario', StopSign!)					
				end if
				SetNull(ls_flag_tipo)
				this.object.flag_tipo[row] = ls_flag_tipo
				return 1
			end if
		end if

		if pos('CDEF', ls_flag_tipo) > 0 then
			
			if ls_flag_tipo = 'C' then
				//Administrador + Propietario
				ll_find = this.find( "pos('APCDE',flag_tipo) > 0 "  , 1, this.RowCount())
			elseif ls_flag_tipo = 'D' then
				//Administrador + Propietario + Bahia
				ll_find = this.find( "pos('ABPCDE',flag_tipo) > 0 "  , 1, this.RowCount())
			elseif ls_flag_tipo = 'E' then
				//Administrador + Bahia
				ll_find = this.find( "pos('ABCDE',flag_tipo) > 0 "  , 1, this.RowCount())
			elseif ls_flag_tipo = 'F' then
				//Propietario + Bahia
				ll_find = this.find( "pos('BPCDE',flag_tipo) > 0 "  , 1, this.RowCount())
			end if

			if ll_find > 0 and ll_find <> row then
				MessageBox('Aviso', 'Ya existe alguien registrado con el mismo tipo', StopSign!)
				SetNull(ls_flag_tipo)
				this.object.flag_tipo[row] = ls_flag_tipo
				return 1
			end if
			
		end if

		if pos('ACDE', ls_flag_tipo) > 0 then
			this.object.flag_resp_cobranza[row] = "1"
		else
			this.object.flag_resp_cobranza[row] = "0"
		end if
end choose

end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  	= il_st_color
ist_1.italic     	= false
ist_1 				= st_detail
ist_1.backcolor 	= rgb(100,0,0)
ist_1.italic 		= true

parent.event ue_menu(true)
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF

end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event dw_detail::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0

end event

type st_master from statictext within w_fl026_nave_repres
integer y = 4
integer width = 2633
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Flota Propia"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_detail from statictext within w_fl026_nave_repres
integer y = 744
integer width = 2629
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Asignación de representantes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

