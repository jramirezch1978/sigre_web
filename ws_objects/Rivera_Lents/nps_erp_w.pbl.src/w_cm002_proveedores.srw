$PBExportHeader$w_cm002_proveedores.srw
forward
global type w_cm002_proveedores from w_abc_master_tab
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_6 from userobject within tab_1
end type
type dw_direccion from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_direccion dw_direccion
end type
type tabpage_7 from userobject within tab_1
end type
type dw_telefonos from u_dw_abc within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_telefonos dw_telefonos
end type
type tabpage_8 from userobject within tab_1
end type
type dw_subcateg from u_dw_abc within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_subcateg dw_subcateg
end type
type tabpage_9 from userobject within tab_1
end type
type dw_evaluacion from u_dw_abc within tabpage_9
end type
type tabpage_9 from userobject within tab_1
dw_evaluacion dw_evaluacion
end type
type tabpage_10 from userobject within tab_1
end type
type dw_representante from u_dw_abc within tabpage_10
end type
type tabpage_10 from userobject within tab_1
dw_representante dw_representante
end type
type tabpage_11 from userobject within tab_1
end type
type dw_campos from u_dw_abc within tabpage_11
end type
type tabpage_11 from userobject within tab_1
dw_campos dw_campos
end type
type tabpage_12 from userobject within tab_1
end type
type dw_nave from u_dw_abc within tabpage_12
end type
type tabpage_12 from userobject within tab_1
dw_nave dw_nave
end type
type tabpage_13 from userobject within tab_1
end type
type dw_ctas_bco from u_dw_abc within tabpage_13
end type
type tabpage_13 from userobject within tab_1
dw_ctas_bco dw_ctas_bco
end type
end forward

global type w_cm002_proveedores from w_abc_master_tab
integer width = 4453
integer height = 8400
string title = "[CM002] Proveedores "
string menuname = "m_mtto_lista"
end type
global w_cm002_proveedores w_cm002_proveedores

type variables
u_dw_abc  	idw_nave     , idw_direccion, idw_telefonos, &
				idw_subcateg , idw_evaluacion, idw_representante, &
				idw_campos   , idw_cta_bcos 
end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_asigna_dws ()
public subroutine of_retrieve (string as_proveedor)
end prototypes

public function integer of_set_numera ();// Numera documento
Long ll_nro, j
String ls_nro, ls_ceros, ls_origen = 'XX', ls_mensaje

if is_Action = 'new' then
	Select ult_nro 
		into :ll_nro 
	from num_proveedor 
	where origen = :ls_origen for update;	
	
	if SQLCA.SQLCode = 100 then

		insert into num_proveedor( origen, ult_nro)
		values( :ls_origen, 1);
		
		IF SQLCA.SQLCODE <> 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MESSAGEBOX( 'ERROR', ' No se puede insertar numerados: ' &
				+ ls_mensaje)
			return 0
		END IF
		
		ll_nro = 1
	end if

	IF SQLCA.SQLCODE = -1 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MESSAGEBOX( 'ERROR', ls_mensaje)
		return 0
	END IF
	
	ls_nro = TRIM(String( ll_nro))
	ls_ceros = 'E'
	for j = 1 to 7 - LEN( ls_nro)
		ls_ceros = ls_ceros + "0" 
	next
	ls_nro = ls_ceros + ls_nro

	// Asigna numero a cabecera
	dw_master.object.proveedor[dw_master.getrow()] = ls_nro
	
	// Incrementa contador	
	Update num_proveedor 
		set ult_nro = ult_nro + 1 
	where origen = :ls_origen;
end if
return 1
end function

public subroutine of_asigna_dws ();idw_nave 		= tab_1.tabpage_12.dw_nave
idw_direccion 	= tab_1.tabpage_6.dw_direccion
idw_telefonos 	= tab_1.tabpage_7.dw_telefonos
idw_subcateg	= tab_1.tabpage_8.dw_subcateg
idw_evaluacion	= tab_1.tabpage_9.dw_evaluacion
idw_representante = tab_1.tabpage_10.dw_representante
idw_campos			= tab_1.tabpage_11.dw_campos
idw_cta_bcos 		= tab_1.tabpage_13.dw_ctas_bco 	
end subroutine

public subroutine of_retrieve (string as_proveedor);u_dw_abc ldw_det
string ls_tipo_doc_ident

ldw_det = tab_1.tabpage_1.dw_1

dw_master.Retrieve(as_proveedor)
idw_direccion.retrieve( as_proveedor )
idw_telefonos.retrieve( as_proveedor )
idw_subcateg.retrieve( as_proveedor )
idw_evaluacion.retrieve( as_proveedor )
idw_representante.retrieve( as_proveedor )
idw_campos.retrieve( as_proveedor )
idw_nave.retrieve(as_proveedor)
idw_cta_bcos.retrieve(as_proveedor)

dw_master.ii_protect = 0
ldw_det.ii_protect = 0
idw_direccion.ii_protect = 0
idw_telefonos.ii_protect = 0
idw_subcateg.ii_protect = 0
idw_evaluacion.ii_protect = 0
idw_representante.ii_protect = 0
idw_campos.ii_protect = 0
idw_nave.ii_protect = 0
idw_cta_bcos.ii_protect = 0

dw_master.of_protect()
ldw_det.of_protect( )
idw_direccion.of_protect()
idw_telefonos.of_protect()
idw_subcateg.of_protect()
idw_evaluacion.of_protect()
idw_representante.of_protect()
idw_campos.of_protect()
idw_nave.of_protect( )
idw_cta_bcos.of_protect( )

ls_tipo_doc_ident = ldw_det.object.tipo_doc_ident [ldw_det.GetRow()]

if ls_tipo_doc_ident = '6' then
	ldw_det.object.nro_doc_ident.visible = '0'
	ldw_det.object.nro_doc_ident [ldw_det.GetRow()] = ''
	ldw_det.object.ruc_t.Visible = '1'
	ldw_det.object.ruc.Visible = '1'
else
	ldw_det.object.nro_doc_ident.visible = '1'
	ldw_det.object.ruc_t.Visible = '0'
	ldw_det.object.ruc.Visible = '0'
end if
end subroutine

on w_cm002_proveedores.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_lista" then this.MenuID = create m_mtto_lista
end on

on w_cm002_proveedores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;String ls_proveedor, ls_flag_personeria
Long ll_row

of_asigna_dws()

im_1 = CREATE m_rButton      				// crear menu de boton derecho del mouse

idw_1 = dw_master
dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
idw_direccion.SetTransObject(sqlca)
idw_telefonos.SetTransObject(sqlca)
idw_subcateg.SetTransObject(sqlca)
idw_evaluacion.SetTransObject(sqlca)
idw_representante.SetTransObject(sqlca)
idw_campos.SetTransObject(sqlca)
idw_nave.SetTransObject(SQLCA)
idw_cta_bcos.SetTransObject(SQLCA)

ii_help = 101           					// help topic
ii_pregunta_delete = 1   					// 1 = si pregunta, 0 = no pregunta (default)

// Busco registro menor
Select Min( proveedor ) 
	into :ls_proveedor 
from proveedor;

of_retrieve( ls_proveedor )

is_action = 'open'

tab_1.tabpage_1.dw_1.enabled = TRUE
tab_1.tabpage_2.dw_2.enabled = TRUE
tab_1.tabpage_3.dw_3.enabled = TRUE
tab_1.tabpage_4.dw_4.enabled = TRUE
end event

event ue_dw_share;call super::ue_dw_share;Integer li_share_status

li_share_status = dw_master.ShareData (tab_1.tabpage_5.dw_5)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW5",exclamation!)
	RETURN
END IF

end event

event ue_update_pre;Long j

tab_1.tabpage_1.dw_1.AcceptText()
tab_1.tabpage_2.dw_2.AcceptText()
tab_1.tabpage_3.dw_3.AcceptText()
tab_1.tabpage_4.dw_4.AcceptText()
tab_1.tabpage_5.dw_5.AcceptText()
idw_direccion.AcceptText()
idw_telefonos.AcceptText()
idw_subcateg.AcceptText()
idw_evaluacion.AcceptText()
idw_representante.AcceptText()
idw_cta_bcos.AcceptText()



ib_update_check = False	
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then		
	return
end if

IF is_action = 'new' then
	if of_set_numera() = 0 then
		return	
	end if	
end if

ib_update_check = true

dw_master.of_Set_flag_replicacion( )
tab_1.tabpage_1.dw_1.of_Set_flag_replicacion( )
tab_1.tabpage_2.dw_2.AcceptText()
tab_1.tabpage_3.dw_3.AcceptText()
tab_1.tabpage_4.dw_4.AcceptText()
tab_1.tabpage_5.dw_5.AcceptText()
idw_direccion.AcceptText()
idw_telefonos.AcceptText()
idw_subcateg.AcceptText()
idw_evaluacion.AcceptText()
idw_representante.AcceptText()
idw_cta_bcos.AcceptText()

end event

event ue_update;// Override
Boolean lbo_ok = TRUE

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF idw_cta_bcos.ii_update = 1 THEN
	IF idw_cta_bcos.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF	

IF idw_representante.ii_update = 1 THEN
	IF idw_representante.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_evaluacion.ii_update = 1 THEN
	IF idw_evaluacion.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF
IF idw_subcateg.ii_update = 1 THEN
	IF idw_subcateg.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF
IF idw_telefonos.ii_update = 1 THEN
	IF idw_telefonos.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF
IF idw_direccion.ii_update = 1 THEN
	IF idw_direccion.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_direccion.ii_update = 0
	idw_telefonos.ii_update = 0
	idw_subcateg.ii_update = 0
	idw_evaluacion.ii_update = 0
	idw_representante.ii_update = 0
	idw_cta_bcos.ii_update = 0
	is_action = ''
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_modify;// Ancestor Script has been Override
string 	ls_proveedor, ls_flag_estado
Integer	li_row

if dw_master.GetRow() = 0 then return

li_row = dw_master.GetRow( )

idw_1.of_protect()

if is_action <> 'new' then
	is_action = 'edit'
end if	

ls_proveedor = dw_master.object.proveedor[li_row]

select flag_estado
	into :ls_flag_estado
from maestro
where cod_trabajador = :ls_proveedor;

if SQLCA.SQLCode <> 100 then
	if string(dw_master.object.flag_estado[li_row]) <> ls_flag_estado then
		dw_master.object.flag_estado[li_row] = ls_flag_estado
		dw_master.ii_update = 1
	end if
	dw_master.object.flag_estado.protect = '1'
	return
end if


end event

event ue_print;// Override

String ls_proveedor

ls_proveedor = dw_master.object.proveedor[dw_master.getrow()]
OpenSheetWithParm(w_cm002_proveedor_ficha, ls_proveedor, This, 2, Layered!)
end event

event ue_insert;// Overr

Long  ll_row

if idw_1 = idw_campos or idw_1 = idw_nave then return

if idw_1 = dw_master then
	event ue_update_request( )
	idw_1.Reset()
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event resize;call super::resize;of_asigna_dws()
u_dw_abc ldw_1

dw_master.width  = newwidth  - dw_master.x - 10

ldw_1 = tab_1.tabpage_1.dw_1
ldw_1.Width = tab_1.width - ldw_1.x - 520
ldw_1.height= tab_1.height - ldw_1.y - 50

ldw_1 = tab_1.tabpage_2.dw_2
ldw_1.Width = tab_1.width - ldw_1.x - 520
ldw_1.height= tab_1.height - ldw_1.y - 50

ldw_1 = tab_1.tabpage_3.dw_3
ldw_1.Width = tab_1.width - ldw_1.x - 520
ldw_1.height= tab_1.height - ldw_1.y - 50

ldw_1 = tab_1.tabpage_4.dw_4
ldw_1.Width = tab_1.width - ldw_1.x - 520
ldw_1.height= tab_1.height - ldw_1.y - 50

ldw_1 = tab_1.tabpage_5.dw_5
ldw_1.Width = tab_1.width - ldw_1.x - 520
ldw_1.height= tab_1.height - ldw_1.y - 50

idw_direccion.Width = tab_1.width - idw_direccion.x - 520
idw_direccion.height= tab_1.height - idw_direccion.y - 50

idw_telefonos.Width = tab_1.width - idw_telefonos.x - 520
idw_telefonos.height= tab_1.height - idw_telefonos.y - 50

idw_subcateg.Width = tab_1.width - idw_subcateg.x - 520
idw_subcateg.height= tab_1.height - idw_subcateg.y - 50

idw_evaluacion.Width = tab_1.width - idw_evaluacion.x - 520
idw_evaluacion.height= tab_1.height - idw_evaluacion.y - 50

idw_representante.Width = tab_1.width - idw_representante.x - 520
idw_representante.height= tab_1.height - idw_representante.y - 50

idw_campos.Width = tab_1.width - idw_campos.x - 520
idw_campos.height= tab_1.height - idw_campos.y - 50

idw_nave.Width = tab_1.width - idw_nave.x - 520
idw_nave.height= tab_1.height - idw_nave.y - 50

idw_cta_bcos.Width = tab_1.width - idw_nave.x - 520
idw_cta_bcos.height= tab_1.height - idw_nave.y - 50
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a estructura 
str_parametros sl_param

sl_param.dw1 = "d_sel_proveedores"
sl_param.titulo = "Proveedores"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[1])
	is_action = 'open'
END IF
end event

type ole_skin from w_abc_master_tab`ole_skin within w_cm002_proveedores
end type

type st_filter from w_abc_master_tab`st_filter within w_cm002_proveedores
end type

type uo_filter from w_abc_master_tab`uo_filter within w_cm002_proveedores
end type

type st_box from w_abc_master_tab`st_box within w_cm002_proveedores
end type

type uo_h from w_abc_master_tab`uo_h within w_cm002_proveedores
end type

type dw_master from w_abc_master_tab`dw_master within w_cm002_proveedores
integer x = 507
integer y = 156
integer width = 2779
integer height = 556
string dataobject = "d_abc_proveedor_id_ff"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;u_dw_abc ldw_det

ldw_det = tab_1.tabpage_1.dw_1

this.object.flag_estado		[al_row] = '1'
this.object.cod_usr			[al_row] = gnvo_app.is_user
this.object.flag_nac_ext	[al_row] = 'N'

tab_1.tabpage_1.dw_1.Scrolltorow( al_row)
tab_1.tabpage_2.dw_2.Scrolltorow( al_row)
tab_1.tabpage_3.dw_3.Scrolltorow( al_row)
tab_1.tabpage_4.dw_4.Scrolltorow( al_row)
tab_1.tabpage_5.dw_5.Scrolltorow( al_row)
idw_direccion.Reset()
idw_telefonos.Reset()
idw_subcateg.Reset()
idw_evaluacion.Reset()
idw_cta_bcos.Reset()

tab_1.tabpage_1.dw_1.enabled = TRUE
tab_1.tabpage_2.dw_2.enabled = TRUE
tab_1.tabpage_3.dw_3.enabled = TRUE
tab_1.tabpage_4.dw_4.enabled = TRUE

is_action = 'new'

this.Setcolumn('nom_proveedor')
end event

event dw_master::ue_output(long al_row);call super::ue_output;//IF al_row > 0 then
//	messagebox( '', al_row)
//	THIS.EVENT ue_retrieve_det(al_row)
//	idw_det.ScrollToRow(al_row)
//end if
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tab_1 from w_abc_master_tab`tab_1 within w_cm002_proveedores
integer x = 507
integer y = 724
integer width = 3031
integer height = 1260
integer textsize = -8
long backcolor = 67108864
boolean boldselectedtext = true
boolean perpendiculartext = true
tabposition tabposition = tabsonright!
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_9 tabpage_9
tabpage_10 tabpage_10
tabpage_11 tabpage_11
tabpage_12 tabpage_12
tabpage_13 tabpage_13
end type

on tab_1.create
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
this.tabpage_9=create tabpage_9
this.tabpage_10=create tabpage_10
this.tabpage_11=create tabpage_11
this.tabpage_12=create tabpage_12
this.tabpage_13=create tabpage_13
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_5
this.Control[iCurrent+2]=this.tabpage_6
this.Control[iCurrent+3]=this.tabpage_7
this.Control[iCurrent+4]=this.tabpage_8
this.Control[iCurrent+5]=this.tabpage_9
this.Control[iCurrent+6]=this.tabpage_10
this.Control[iCurrent+7]=this.tabpage_11
this.Control[iCurrent+8]=this.tabpage_12
this.Control[iCurrent+9]=this.tabpage_13
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
destroy(this.tabpage_9)
destroy(this.tabpage_10)
destroy(this.tabpage_11)
destroy(this.tabpage_12)
destroy(this.tabpage_13)
end on

type tabpage_1 from w_abc_master_tab`tabpage_1 within tab_1
integer y = 16
integer width = 2473
integer height = 1228
long backcolor = 79741120
string text = "Datos Generales"
long tabbackcolor = 79741120
end type

type dw_1 from w_abc_master_tab`dw_1 within tabpage_1
integer y = 0
integer width = 2505
integer height = 940
boolean bringtotop = true
string dataobject = "d_abc_proveedor_datosgenerales_ff"
borderstyle borderstyle = styleraised!
end type

event dw_1::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_1::itemchanged;call super::itemchanged;String ls_null
Long ll_count
SetNull(ls_null)

if lower(dwo.name) = 'RUC' then
	select count(*)
		into :ll_count
	from proveedor
	where ruc = :data;
	
	if ll_count > 0 then
		if MessageBox('Aviso', 'El Numero de RUC ya existe en Maestro de proveedor, ' &
				+ 'Desea Continuar?', Information!, YesNo!,1 ) = 2 then 
			this.object.ruc[row] = ls_null
			return
		end if
	end if
	
elseif dwo.name = 'tipo_doc_ident' then
	if data = '6' then
		this.object.nro_doc_ident.visible = '0'
		this.object.nro_doc_ident [row] = ''
		this.object.ruc_t.Visible = 'yes'
		this.object.ruc.Visible = '1'
	else
		this.object.nro_doc_ident.visible = '1'
		this.object.ruc_t.Visible = '0'
		this.object.ruc.Visible = '0'
	end if
end if
end event

event dw_1::ue_insert_pre;call super::ue_insert_pre;this.object.tipo_doc_ident [al_row] = '6'
end event

type tabpage_2 from w_abc_master_tab`tabpage_2 within tab_1
boolean visible = false
integer y = 16
integer width = 2473
integer height = 1228
boolean enabled = false
string text = "Referencias"
end type

type dw_2 from w_abc_master_tab`dw_2 within tabpage_2
integer y = 0
integer width = 2478
integer height = 1044
boolean bringtotop = true
string dataobject = "d_abc_proveedor_referencias_ff"
borderstyle borderstyle = styleraised!
end type

event dw_2::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_3 from w_abc_master_tab`tabpage_3 within tab_1
boolean visible = false
integer y = 16
integer width = 2473
integer height = 1228
boolean enabled = false
string text = "Datos Técnicos"
end type

type dw_3 from w_abc_master_tab`dw_3 within tabpage_3
integer y = 0
integer width = 2501
integer height = 1020
boolean bringtotop = true
string dataobject = "d_abc_proveedor_datostecnicos_ff"
borderstyle borderstyle = styleraised!
end type

event dw_3::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_4 from w_abc_master_tab`tabpage_4 within tab_1
integer y = 16
integer width = 2473
integer height = 1228
string text = "Post Venta"
end type

type dw_4 from w_abc_master_tab`dw_4 within tabpage_4
integer y = 0
integer width = 2519
integer height = 1056
boolean bringtotop = true
string dataobject = "d_abc_proveedor_postventa_ff"
borderstyle borderstyle = styleraised!
end type

event dw_4::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2473
integer height = 1228
long backcolor = 79741120
string text = "Sistema Calidad"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from u_dw_abc within tabpage_5
integer width = 2505
integer height = 1072
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_proveedor_sistema_calidad_ff"
borderstyle borderstyle = styleraised!
end type

event clicked;//Override
idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;//override
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2473
integer height = 1228
long backcolor = 79741120
string text = "Dirección"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_direccion dw_direccion
end type

on tabpage_6.create
this.dw_direccion=create dw_direccion
this.Control[]={this.dw_direccion}
end on

on tabpage_6.destroy
destroy(this.dw_direccion)
end on

type dw_direccion from u_dw_abc within tabpage_6
integer width = 2496
integer height = 856
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_proveedor_direccion_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'tabular'	
end event

event itemchanged;call super::itemchanged;String ls_pais, ls_departamento, ls_provincia, ls_distrito, ls_ciudad

idw_1 = this

		idw_1.GetText()
		idw_1.AcceptText()
		
Choose Case this.GetColumnName()
	Case 'dir_pais'
		ls_pais  = this.GetItemString(row, "dir_pais")
		if ls_pais = "" or isnull(ls_pais) then
			idw_1.ii_update = 0
			Messagebox("Validación", "Ingresar el valor del Pais")
			this.SetColumn("dir_pais")
			this.SetFocus()
		End If
		
	Case 'dir_dep_estado'
		ls_departamento= this.GetItemString(row, "dir_dep_estado")
		if ls_departamento = "" or isnull(ls_departamento) then
			idw_1.ii_update = 0
			Messagebox("Validación", "Ingresar el valor del Departamento")
			this.SetColumn("dir_dep_estado")
			this.SetFocus()
		End If
		
	Case 'dir_provincia'
		ls_provincia  = this.GetItemString(row, "dir_provincia")
		if ls_provincia = "" or isnull(ls_provincia) then
			idw_1.ii_update = 0
			Messagebox("Validación", "Ingresar el valor de la Provincia")
			this.SetColumn("dir_provincia")
			this.SetFocus()
		End If
		
	Case 'dir_ciudad'
		ls_ciudad  = this.GetItemString(row, "dir_ciudad")
		if ls_ciudad = "" or isnull(ls_ciudad) then
			idw_1.ii_update = 0
			Messagebox("Validación", "Ingresar el valor de la Ciudad")
			this.SetColumn("dir_ciudad")
			this.SetFocus()
		End If
		
	Case 'dir_distrito'
		ls_distrito  = this.GetItemString(row, "dir_distrito")
		if ls_distrito = "" or isnull(ls_distrito) then
			idw_1.ii_update = 0
			Messagebox("Validación", "Ingresar el valor del Distrito")
			this.SetColumn("dir_distrito")
			this.SetFocus()
		End If
End Choose
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Int j, ln_num = 0

this.object.codigo[al_row] = dw_master.Object.proveedor[dw_master.getrow()]

For j = 1 to this.rowcount()
	if this.object.item[j] > ln_num then
		ln_num = this.object.item[j]
	end if
Next

this.object.item[al_row] = ln_num + 1
end event

event itemerror;call super::itemerror;RETURN 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2473
integer height = 1228
long backcolor = 79741120
string text = "Teléfonos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_telefonos dw_telefonos
end type

on tabpage_7.create
this.dw_telefonos=create dw_telefonos
this.Control[]={this.dw_telefonos}
end on

on tabpage_7.destroy
destroy(this.dw_telefonos)
end on

type dw_telefonos from u_dw_abc within tabpage_7
integer width = 2414
integer height = 836
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_proveedor_telefono_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;ii_ck[1] = 1				// columnas de lectura de este dw
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Int j, ln_num = 0

this.object.codigo[al_row] = dw_master.Object.proveedor[dw_master.getrow()]

For j = 1 to this.rowcount()
	if this.object.item[j] > ln_num then
		ln_num = this.object.item[j]
	end if
Next

this.object.item[al_row] = ln_num + 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2473
integer height = 1228
long backcolor = 12632256
string text = "Sub. Categ."
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_subcateg dw_subcateg
end type

on tabpage_8.create
this.dw_subcateg=create dw_subcateg
this.Control[]={this.dw_subcateg}
end on

on tabpage_8.destroy
destroy(this.dw_subcateg)
end on

type dw_subcateg from u_dw_abc within tabpage_8
event ue_display ( string as_columna,  long al_row )
integer width = 2487
integer height = 860
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_proveedor_subcategoria_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);// Abre ventana de ayuda 
str_parametros sl_param

CHOOSE CASE lower(as_columna)
	CASE 'cod_sub_cat' 
		// Asigna valores a structura 
		sl_param.dw1 = "d_dddw_sub_categoria"
		sl_param.titulo = "Sub Categorias"
		sl_param.field_ret_i[1] = 1	
		sl_param.field_ret_i[2] = 2

		OpenWithParm( w_search, sl_param)
		
		sl_param = MESSAGE.POWEROBJECTPARM
		
		if sl_param.titulo <> 'n' then			
			this.object.cod_sub_cat[al_row] = sl_param.field_ret[1]	
			this.object.desc_sub_cat[al_row] = sl_param.field_ret[2]	
			
			this.ii_update = 1
		END IF	
END CHOOSE
end event

event constructor;ii_ck[1] = 1				// columnas de lectura de este dw
end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_row_mas
ll_row_mas = dw_master.GetRow()

if ll_row_mas = 0 then 
	MessageBox('Aviso', 'No se ha definido cabecera de Proveedor', StopSign!)
	return
end if

this.object.proveedor				[al_row] = dw_master.Object.proveedor[ll_row_mas]
this.object.fecha_calificacion 	[al_row] = Today()
this.object.cod_usr					[al_row] = gnvo_app.is_user
this.object.flag_calificacion		[al_row] = '1'


end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' &
	and upper(dwo.name) <> 'ESPECIE' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data

this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "cod_sub_cat"
		
		ls_codigo = this.object.cod_sub_cat[row]

		// Verifica que sub categoria exista
		Select desc_sub_cat 
			into :ls_data
		from articulo_sub_categ
		Where cod_sub_cat = :data;
		
		if IsNull(ls_data) or ls_data = '' then
			Messagebox( "Error", "Sub categoria no existe", Exclamation!)
			SetNull(ls_codigo)
			this.object.cod_sub_cat		[row] = ls_codigo
			this.object.desc_sub_cat	[row] = ls_data
			return 1
		end if
		
		this.object.desc_sub_cat [row] = ls_data
		
	case 'flag_calificacion'
		
		this.object.fecha_calificacion	[row] = DateTime(TODAY(), Now())
		this.object.cod_usr					[row] = gnvo_app.is_user

		
end choose

end event

event itemerror;call super::itemerror;return 1
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

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

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_9 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2473
integer height = 1228
long backcolor = 12632256
string text = "Evaluacion"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_evaluacion dw_evaluacion
end type

on tabpage_9.create
this.dw_evaluacion=create dw_evaluacion
this.Control[]={this.dw_evaluacion}
end on

on tabpage_9.destroy
destroy(this.dw_evaluacion)
end on

type dw_evaluacion from u_dw_abc within tabpage_9
integer width = 2491
integer height = 860
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_proveedor_criterio_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;ii_ck[1] = 1				// columnas de lectura de este dw
end event

event doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
str_parametros sl_param
String ls_name, ls_prot

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if
CHOOSE CASE dwo.name 
	CASE 'cod_sub_cat' 
		// Asigna valores a structura 
		sl_param.dw1 = "d_dddw_sub_categoria"
		sl_param.titulo = "Sub Categorias"
		sl_param.field_ret_i[1] = 1		

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			this.object.cod_sub_cat[this.getrow()] = sl_param.field_ret[1]			
		END IF
	
END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_proveedor[al_row] = dw_master.Object.proveedor[dw_master.getrow()]
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_10 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2473
integer height = 1228
long backcolor = 12632256
string text = "Representante"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_representante dw_representante
end type

on tabpage_10.create
this.dw_representante=create dw_representante
this.Control[]={this.dw_representante}
end on

on tabpage_10.destroy
destroy(this.dw_representante)
end on

type dw_representante from u_dw_abc within tabpage_10
integer width = 2496
integer height = 860
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_abc_representante_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;ii_ck[1] = 1				// columnas de lectura de este dw
end event

event doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
str_parametros sl_param
String ls_name, ls_prot

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if
CHOOSE CASE dwo.name 
	CASE 'cod_sub_cat' 
		// Asigna valores a structura 
		sl_param.dw1 = "d_dddw_sub_categoria"
		sl_param.titulo = "Sub Categorias"
		sl_param.field_ret_i[1] = 1		

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			this.object.cod_sub_cat[this.getrow()] = sl_param.field_ret[1]			
		END IF
	
END CHOOSE
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Int j, ln_num = 0

this.object.cod_proveedor[al_row] = dw_master.Object.proveedor[dw_master.getrow()]

For j = 1 to this.rowcount()
	if this.object.nro_item[j] > ln_num then
		ln_num = this.object.nro_item[j]
	end if
Next

this.object.nro_item[al_row] = ln_num + 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_11 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2473
integer height = 1228
long backcolor = 12632256
string text = "Campos"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_campos dw_campos
end type

on tabpage_11.create
this.dw_campos=create dw_campos
this.Control[]={this.dw_campos}
end on

on tabpage_11.destroy
destroy(this.dw_campos)
end on

type dw_campos from u_dw_abc within tabpage_11
integer width = 2491
integer height = 860
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_dddw_campos"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;ii_ck[1] = 1				// columnas de lectura de este dw
end event

event doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
str_parametros sl_param
String ls_name, ls_prot

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if
CHOOSE CASE dwo.name 
	CASE 'cod_sub_cat' 
		// Asigna valores a structura 
		sl_param.dw1 = "d_dddw_sub_categoria"
		sl_param.titulo = "Sub Categorias"
		sl_param.field_ret_i[1] = 1		

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			this.object.cod_sub_cat[this.getrow()] = sl_param.field_ret[1]			
		END IF
	
END CHOOSE
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_12 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2473
integer height = 1228
long backcolor = 12632256
string text = "Armador - Nave"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_nave dw_nave
end type

on tabpage_12.create
this.dw_nave=create dw_nave
this.Control[]={this.dw_nave}
end on

on tabpage_12.destroy
destroy(this.dw_nave)
end on

type dw_nave from u_dw_abc within tabpage_12
integer width = 2459
integer height = 1072
integer taborder = 20
string dataobject = "d_naves_ff"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1
end event

type tabpage_13 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2473
integer height = 1228
long backcolor = 67108864
string text = "Cuentas Bancarias"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_ctas_bco dw_ctas_bco
end type

on tabpage_13.create
this.dw_ctas_bco=create dw_ctas_bco
this.Control[]={this.dw_ctas_bco}
end on

on tabpage_13.destroy
destroy(this.dw_ctas_bco)
end on

type dw_ctas_bco from u_dw_abc within tabpage_13
integer width = 2377
integer height = 1004
integer taborder = 20
string dataobject = "d_abc_proveedor_cnta_bco_tbl"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2





end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.proveedor[al_row] = dw_master.Object.proveedor[dw_master.getrow()]
end event

