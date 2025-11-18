$PBExportHeader$w_cam433_ab4_bbb.srw
forward
global type w_cam433_ab4_bbb from w_abc_master
end type
type tab_1 from tab within w_cam433_ab4_bbb
end type
type tabpage_1 from userobject within tab_1
end type
type dw_reg1 from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_reg1 dw_reg1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_reg2 from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_reg2 dw_reg2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_reg3 from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_reg3 dw_reg3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_reg4 from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_reg4 dw_reg4
end type
type tab_1 from tab within w_cam433_ab4_bbb
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
end forward

global type w_cam433_ab4_bbb from w_abc_master
integer width = 3337
integer height = 3280
string title = "[CM433] AB4 - BBB"
string menuname = "m_abc_anular_lista"
tab_1 tab_1
end type
global w_cam433_ab4_bbb w_cam433_ab4_bbb

type variables
u_dw_abc idw_reg1, idw_reg2, idw_reg3, idw_reg4
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
end prototypes

public subroutine of_asigna_dws ();idw_reg1 			= tab_1.tabpage_1.dw_reg1
idw_reg2				= tab_1.tabpage_2.dw_reg2
idw_reg3 			= tab_1.tabpage_3.dw_reg3
idw_reg4				= tab_1.tabpage_4.dw_reg4

end subroutine

public function integer of_set_numera ();// Numera documento
Long 	ll_ult_nro, ll_j
string	ls_mensaje, ls_nro, ls_table

if is_action = 'new' then

	ls_table = 'LOCK TABLE NUM_SIC_AB4_BBB_010511 IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_ult_nro 
	from NUM_SIC_AB4_BBB_010511
	where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into NUM_SIC_AB4_BBB_010511 (cod_origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		ll_ult_nro = 1
	end if
	
	// Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))

	dw_master.object.nro_registro[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update NUM_SIC_AB4_BBB_010511 
		set ult_nro = ult_nro + 1
	 where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_registro[dw_master.getrow()] 
end if

// Asigna numero a detalle
dw_master.object.nro_registro[dw_master.getrow()] = ls_nro
for ll_j = 1 to idw_reg1.RowCount()	
	idw_reg1.object.nro_registro		[ll_j] = ls_nro	
next

for ll_j = 1 to idw_reg2.RowCount()	
	idw_reg2.object.nro_registro		[ll_j] = ls_nro	
next

for ll_j = 1 to idw_reg3.RowCount()	
	idw_reg3.object.nro_registro		[ll_j] = ls_nro	
next

for ll_j = 1 to idw_reg4.RowCount()	
	idw_reg4.object.nro_registro		[ll_j] = ls_nro	
next
return 1
end function

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	// Fuerza a leer detalle
	idw_reg1.retrieve(as_nro)
	idw_reg2.retrieve(as_nro)
	idw_reg3.retrieve(as_nro)
	idw_reg4.retrieve(as_nro)
	
	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	idw_reg1.ii_protect = 0
	idw_reg1.ii_update	= 0
	idw_reg1.of_protect()
	idw_reg1.ResetUpdate()
	
	idw_reg2.ii_protect = 0
	idw_reg2.ii_update	= 0
	idw_reg2.of_protect()
	idw_reg2.ResetUpdate()

	idw_reg3.ii_protect = 0
	idw_reg3.ii_update	= 0
	idw_reg3.of_protect()
	idw_reg3.ResetUpdate()
	
	idw_reg4.ii_protect = 0
	idw_reg4.ii_update	= 0
	idw_reg4.of_protect()
	idw_reg4.ResetUpdate()
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	is_action = 'open'
end if

return 
end subroutine

event resize;//Override
of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_reg1.width  = tab_1.tabpage_1.width  - tab_1.tabpage_1.x - 10
idw_reg1.height = tab_1.tabpage_1.height  - tab_1.tabpage_1.y - 10

idw_reg2.width  = tab_1.tabpage_2.width  - tab_1.tabpage_2.x - 10
idw_reg2.height = tab_1.tabpage_2.height  - tab_1.tabpage_2.y - 10

idw_reg3.width  = tab_1.tabpage_3.width  - tab_1.tabpage_3.x - 10
idw_reg3.height = tab_1.tabpage_3.height  - tab_1.tabpage_3.y - 10

idw_reg4.width  = tab_1.tabpage_4.width  - tab_1.tabpage_4.x - 10
idw_reg4.height = tab_1.tabpage_4.height  - tab_1.tabpage_4.y - 10
end event

on w_cam433_ab4_bbb.create
int iCurrent
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_cam433_ab4_bbb.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)

dw_master.AcceptText()
idw_reg1.AcceptText()
idw_reg2.AcceptText()
idw_reg3.AcceptText()
idw_reg4.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	idw_reg1.of_create_log()
	idw_reg2.of_create_log()
	idw_reg3.of_create_log()
	idw_reg4.of_create_log()
END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF idw_reg1.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_reg1.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_reg1", ls_msg, StopSign!)
	END IF
END IF
IF idw_reg2.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_reg2.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion registro de idw_reg2", ls_msg, StopSign!)
	END IF
END IF

IF idw_reg3.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_reg3.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion registro de idw_reg3", ls_msg, StopSign!)
	END IF
END IF

IF idw_reg4.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_reg4.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion registro de idw_reg4", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_reg1.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_reg2.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_reg3.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_reg4.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_reg1.ii_update = 0
	idw_reg2.ii_update = 0
	idw_reg3.ii_update = 0
	idw_reg4.ii_update = 0
	
	dw_master.il_totdel = 0
	idw_reg1.il_totdel = 0
	idw_reg2.il_totdel = 0
	idw_reg3.il_totdel = 0
	idw_reg4.il_totdel = 0
	
	dw_master.ResetUpdate()
	idw_reg1.ResetUpdate()
	idw_reg2.ResetUpdate()
	idw_reg3.ResetUpdate()
	idw_reg4.ResetUpdate()

	if dw_master.getRow() > 0 then
		of_retrieve(dw_master.object.nro_registro[dw_master.getRow()])
	end if
	
END IF
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_reg1, idw_reg1.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_reg2, idw_reg2.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_reg3, idw_reg3.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_reg4, idw_reg4.is_dwform) <> true then	return

//AutoNumeración de Registro
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
idw_reg1.of_set_flag_replicacion()
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_sic_ab4_bbb_tbl'
sl_param.titulo = 'Registros AB4-BBB'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_insert;//Override
Long  ll_row

if idw_1 <> dw_master then
	if dw_master.getRow() = 0 then
		MessageBox('Error', 'No esta permitido insertar un detalle de Cuaderno del productor sin antes haber insertado la cabecera, por favor verifique')
		return
	elseif f_row_Processing( dw_master, dw_master.is_dwform) <> true then	
		return
	end if
end if


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

type dw_master from w_abc_master`dw_master within w_cam433_ab4_bbb
integer width = 3150
integer height = 1008
string dataobject = "d_abc_sic_reg_ab4_bbb_cab_ff"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dateTime ldt_fec_oracle

ldt_fec_oracle = f_fecha_actual()

this.object.fec_registro 		[al_row] = ldt_fec_oracle
this.object.flag_estado 		[al_row] = '1'
this.object.cod_usr 			[al_row] = gs_user

is_action = 'new'
end event

event dw_master::constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  idw_reg1

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
	case "nro_certificacion"
		ls_sql = "SELECT a.nro_certificacion AS certificacion_productor, " &
				 + "a.has as area_has, " &
				 + "p.nro_doc_ident AS nro_doc_ident, " &
				 + "p.nom_proveedor AS nombre_productor, " &
				 + "p.ruc AS ruc_productor " &
				 + "FROM AP_PROVEEDOR_CERTIF a, " &
				 +"      ap_proveedor_mp mp, " &
				 + "     proveedor p " &
				 + "WHERE a.proveedor = p.proveedor " &
				 + "  and a.proveedor = mp.proveedor " &
				 + "  and p.FLAG_ESTADO = '1' " &
				 + "  and mp.flag_estado = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.nro_certificacion	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data3
			this.ii_update = 1
		end if
		
end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1
decimal	ldc_has
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name

	case "nro_certificacion"

		SELECT p.nom_proveedor 
				into :ls_desc1
			FROM AP_PROVEEDOR_CERTIF a, 
				 	ap_proveedor_mp mp, 
				     proveedor p 
				 WHERE a.proveedor = p.proveedor 
				 and a.nro_certificacion = :data
				 and a.proveedor = mp.proveedor 
				 and p.FLAG_ESTADO = '1' 
				 and mp.flag_estado = '1';
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Numero de Certificado o el productor no se encuentra activo, por favor verifique")
			this.object.nro_certificacion	[row] = ls_null
			this.object.nom_proveedor		[row] = ls_null
			return 1
		end if
		
	this.object.nro_certificacion	[row] = data
	this.object.nom_proveedor		[row] = ls_desc1
	
END CHOOSE
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tab_1 from tab within w_cam433_ab4_bbb
integer y = 1016
integer width = 3232
integer height = 1968
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean perpendiculartext = true
tabposition tabposition = tabsonright!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2437
integer height = 1936
long backcolor = 79741120
string text = "Procesamiento Contratado"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_reg1 dw_reg1
end type

on tabpage_1.create
this.dw_reg1=create dw_reg1
this.Control[]={this.dw_reg1}
end on

on tabpage_1.destroy
destroy(this.dw_reg1)
end on

type dw_reg1 from u_dw_abc within tabpage_1
integer width = 2153
integer height = 1360
integer taborder = 20
string dataobject = "d_abc_sic_reg_ab4_bbb_reg1_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 		[al_row] = of_nro_item(this)
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = 	dw_master

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2437
integer height = 1936
long backcolor = 79741120
string text = "Productos Usados"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_reg2 dw_reg2
end type

on tabpage_2.create
this.dw_reg2=create dw_reg2
this.Control[]={this.dw_reg2}
end on

on tabpage_2.destroy
destroy(this.dw_reg2)
end on

type dw_reg2 from u_dw_abc within tabpage_2
integer width = 2162
integer height = 1224
string dataobject = "d_abc_sic_ab4_bbb_reg2_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item			[al_Row] = of_nro_item(this)
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2437
integer height = 1936
long backcolor = 79741120
string text = "Equipos Utilizados"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_reg3 dw_reg3
end type

on tabpage_3.create
this.dw_reg3=create dw_reg3
this.Control[]={this.dw_reg3}
end on

on tabpage_3.destroy
destroy(this.dw_reg3)
end on

type dw_reg3 from u_dw_abc within tabpage_3
integer width = 1664
integer height = 1108
integer taborder = 30
string dataobject = "d_abc_sic_reg_ab4_bbb_reg3_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item			[al_Row] = of_nro_item(this)

end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2437
integer height = 1936
long backcolor = 79741120
string text = "Almacenamiento"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_reg4 dw_reg4
end type

on tabpage_4.create
this.dw_reg4=create dw_reg4
this.Control[]={this.dw_reg4}
end on

on tabpage_4.destroy
destroy(this.dw_reg4)
end on

type dw_reg4 from u_dw_abc within tabpage_4
integer width = 2153
integer height = 1360
string dataobject = "d_abc_sic_ab4_bbb_reg4_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = 	dw_master

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 		[al_row] = of_nro_item(this)

end event

