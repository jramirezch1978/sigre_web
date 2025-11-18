$PBExportHeader$w_pt002_cnta_presupuestal.srw
forward
global type w_pt002_cnta_presupuestal from w_abc_master_lstmst
end type
type st_campo from statictext within w_pt002_cnta_presupuestal
end type
type dw_1 from datawindow within w_pt002_cnta_presupuestal
end type
end forward

global type w_pt002_cnta_presupuestal from w_abc_master_lstmst
integer width = 3442
integer height = 1732
string title = "Definición de Cuentas presupuestales (PT002)"
string menuname = "m_mantenimiento_sl"
st_campo st_campo
dw_1 dw_1
end type
global w_pt002_cnta_presupuestal w_pt002_cnta_presupuestal

type variables
DatawindowChild idw_child_n2, idw_child_n3
String is_col = ''


end variables

on w_pt002_cnta_presupuestal.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.st_campo=create st_campo
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_1
end on

on w_pt002_cnta_presupuestal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_campo)
destroy(this.dw_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar( this)

ib_log = TRUE
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then		
	return
end if
ib_update_check = True

dw_master.of_set_flag_replicacion()

end event

event ue_retrieve_dddw();call super::ue_retrieve_dddw;dw_master.GetChild("niv2",idw_child_n2)
idw_child_n2.Settransobject(SQLCA)
dw_master.GetChild("niv3",idw_child_n3)
idw_child_n3.Settransobject(SQLCA)
end event

type dw_master from w_abc_master_lstmst`dw_master within w_pt002_cnta_presupuestal
event ue_display ( string as_columna,  long al_row )
integer x = 1536
integer y = 4
integer width = 1842
integer height = 1084
string dataobject = "d_abc_presupuesto_cuenta_bak"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_niv1, ls_niv2

choose case lower(as_columna)
		
	case "niv1"
		ls_sql = 'SELECT niv1 AS CODIGO, '&   
				 + 'descripcion AS DESC_NIVEL '&
				 + 'FROM presupuesto_cuenta_niv1 '
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.niv1		[al_row] = ls_codigo
			this.object.desc_niv1[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "niv2"
		ls_niv1 = this.object.niv1 [al_row]
		
		if IsNull(ls_niv1) or ls_niv1 = '' then
			MessageBox('Aviso', 'Debe indicar el Nivel1')
			return
		end if

		ls_sql = "SELECT niv2 AS CODIGO, " &    
				 + "descripcion AS DESC_NIVEL2 " &
				 + "FROM presupuesto_cuenta_niv2 " &
				 + "WHERE niv1 = '" + ls_niv1 + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.niv2		[al_row] = ls_codigo
			this.object.desc_niv2[al_row] = ls_data
			this.ii_update = 1
		end if

	case "niv3"
		ls_niv1 = this.object.niv1 [al_row]
		
		if IsNull(ls_niv1) or ls_niv1 = '' then
			MessageBox('Aviso', 'Debe indicar el Nivel1')
			return
		end if
		
		ls_niv2 = this.object.niv2 [al_row]
		
		if IsNull(ls_niv2) or ls_niv2 = '' then
			MessageBox('Aviso', 'Debe indicar el Nivel2')
			return
		end if

		ls_sql = "SELECT niv3 AS CODIGO, " &   
		       + "descripcion AS DESC_NIVEL3 " &
				 + "FROM presupuesto_cuenta_niv3 " &
				 + "WHERE niv1 = '" + ls_niv1 + "' " &
				 + "AND niv2 = '" + ls_niv2 + "'" 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.niv3		[al_row] = ls_codigo
			this.object.desc_niv3[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'tipo_cuenta'
		ls_sql = "SELECT TIPO_PRTDA_PRSP AS tipo_partida, " &
				  + "DESC_TIPO_PRSP AS descripcion_tipo_prtda, " &
				  + "GRP_PRTDA_PRSP as grp_tipo_partida " &
				  + "FROM tipo_prtda_prsp_det " &
				  + "WHERE flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_cuenta		[al_row] = ls_codigo
			this.object.desc_tipo_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
ii_ck[1] = 1			// columnas de lectrua de este dw

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_desc, ls_null, ls_niv1, ls_niv2
SetNull(ls_null)
this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "niv1"
		
		select descripcion
			into :ls_desc
		from presupuesto_cuenta_niv1
		where niv1 = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Nivel1 de Cuenta presupuestal no existe", StopSign!)
			this.object.niv1		[row] = ls_null
			this.object.desc_niv1[row] = ls_null
			return 1
		end if

		this.object.desc_niv1[row] = ls_null
		
	case "niv2"
		ls_niv1 = this.object.niv1 [row]
		
		if IsNull(ls_niv1) or ls_niv1 = '' then
			MessageBox('Aviso', 'Debe indicar el Nivel1')
			return
		end if

		select descripcion
			into :ls_desc
		from presupuesto_cuenta_niv2
		where niv2 = :data
		  and niv1 = :ls_niv1;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Nivel2 de Cuenta presupuestal no existe", StopSign!)
			this.object.niv2		[row] = ls_null
			this.object.desc_niv2[row] = ls_null
			return 1
		end if

		this.object.desc_niv2[row] = ls_null

	case "niv3"
		ls_niv1 = this.object.niv1 [row]
		
		if IsNull(ls_niv1) or ls_niv1 = '' then
			MessageBox('Aviso', 'Debe indicar el Nivel1')
			return
		end if
		
		ls_niv2 = this.object.niv2 [row]
		
		if IsNull(ls_niv2) or ls_niv2 = '' then
			MessageBox('Aviso', 'Debe indicar el Nivel2')
			return
		end if

		select descripcion
			into :ls_desc
		from presupuesto_cuenta_niv3
		where niv3 = :data
		  and niv1 = :ls_niv1
		  and niv2 = :ls_niv2;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Nivel3 de Cuenta presupuestal no existe", StopSign!)
			this.object.niv3		[row] = ls_null
			this.object.desc_niv3[row] = ls_null
			return 1
		end if

		this.object.desc_niv3[row] = ls_null

	case 'tipo_cuenta'
		Select DESC_TIPO_PRSP 
			into :ls_desc
		from tipo_prtda_prsp_det
		where TIPO_PRTDA_PRSP = :data
		  and flag_estado = '1';
		  
		if SQLCA.SQLCode = 100 then
			Messagebox( "Error", "Tipo de Partida Presupuestal no existe", Exclamation!)		
			this.object.tipo_cuenta		[row] = ls_null
			this.object.desc_tipo_prsp	[row] = ls_null
			Return 1
		end if
		this.object.desc_tipo_prsp [row] = ls_desc
		
end choose


end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, row)
end if

end event

event dw_master::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
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

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row] = '1'
end event

type dw_lista from w_abc_master_lstmst`dw_lista within w_pt002_cnta_presupuestal
integer y = 140
integer width = 1513
integer height = 1384
string dataobject = "d_lista_Presupuesto_cuenta"
end type

event dw_lista::constructor;call super::constructor;ii_ck[1] = 1      // columnas de lectrua de este dw

end event

event dw_lista::ue_output(long al_row);call super::ue_output;dw_master.ScrollToRow(al_row)

end event

event dw_lista::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column 
Long ll_row

li_col = this.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	ls_column = UPPER( mid(ls_column,1,li_pos - 1) + "_t.text" )	
	is_col = UPPER( mid(ls_column,1,li_pos - 1)  )	

	ls_column = this.describe( ls_column)
	st_campo.text = "Orden: " + ls_column
	dw_1.reset()
	dw_1.InsertRow(0)
	dw_1.SetFocus()
END  IF
end event

event dw_lista::getfocus;call super::getfocus;dw_1.SetFocus()
end event

event dw_lista::rowfocuschanged;call super::rowfocuschanged;// Filtra datos
String ls_filter, ls_niv1, ls_niv2

if currentrow > 0 then
	f_select_current_row(this)
	ls_niv1 = GetItemString(currentrow,"niv1")
	ls_niv2 = GetItemString(currentrow,"niv2")

	if TRIM( ls_niv1 ) <> '' AND TRIM( ls_niv2 ) <> '' then
		ls_filter ='niv1 = "'+ ls_niv1 + '"'
		idw_Child_n2.SetFilter(ls_filter)
		idw_Child_n2.Filter()
		
		ls_filter = 'niv1 = "'+ ls_niv1 + '" AND '+&
		            'niv2 = "'+ ls_niv2 + '"'
		idw_Child_n3.SetFilter(ls_filter)
		idw_Child_n3.Filter()
	end if
	
	this.event ue_output(currentrow)
end if
end event

type st_campo from statictext within w_pt002_cnta_presupuestal
integer x = 18
integer y = 28
integer width = 535
integer height = 76
boolean bringtotop = true
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

type dw_1 from datawindow within w_pt002_cnta_presupuestal
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 594
integer y = 32
integer width = 891
integer height = 80
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_lista.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_lista.scrollnextrow()	
end if
ll_row = dw_lista.Getrow()

//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
return 1
end event

event type long dwnenter();//Send(Handle(this),256,9,Long(0,0))
dw_lista.triggerevent(doubleclicked!)
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
	
		ll_fila = dw_lista.find(ls_comando, 1, dw_lista.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_lista.selectrow(0, false)
			dw_lista.selectrow(ll_fila,true)
			dw_lista.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)

dw_lista.event clicked(0,0,dw_lista.getrow(), dwo)
end event

