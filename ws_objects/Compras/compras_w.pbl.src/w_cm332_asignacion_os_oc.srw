$PBExportHeader$w_cm332_asignacion_os_oc.srw
forward
global type w_cm332_asignacion_os_oc from w_abc
end type
type cb_1 from commandbutton within w_cm332_asignacion_os_oc
end type
type cbx_1 from checkbox within w_cm332_asignacion_os_oc
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm332_asignacion_os_oc
end type
type st_3 from statictext within w_cm332_asignacion_os_oc
end type
type st_2 from statictext within w_cm332_asignacion_os_oc
end type
type dw_oc_det from u_dw_abc within w_cm332_asignacion_os_oc
end type
type dw_detail from u_dw_abc within w_cm332_asignacion_os_oc
end type
type dw_master from u_dw_abc within w_cm332_asignacion_os_oc
end type
end forward

global type w_cm332_asignacion_os_oc from w_abc
integer width = 2839
integer height = 2916
string title = "[CM332] Asignación de OS a OC"
string menuname = "m_mantto_smpl"
event ue_prorrateo ( )
cb_1 cb_1
cbx_1 cbx_1
uo_fecha uo_fecha
st_3 st_3
st_2 st_2
dw_oc_det dw_oc_det
dw_detail dw_detail
dw_master dw_master
end type
global w_cm332_asignacion_os_oc w_cm332_asignacion_os_oc

type variables
string is_doc_oc, is_salir
m_prorrateo im_p1

end variables

forward prototypes
public function integer of_get_param ()
public function integer of_retrieve (date ad_fecha1, date ad_fecha2, string as_flag)
end prototypes

event ue_prorrateo();Long 		ll_row, ll_item_os
string	ls_nro_os, ls_org_os, ls_mensaje

if dw_oc_det.ii_update = 1 then
	MessageBox('Aviso', 'Antes de prorratear debe grabar todos los cambios')
	return
end if

ll_row = dw_detail.GetSelectedRow(0)

Do While ll_row <> 0
	
	ls_org_os	= dw_detail.object.cod_origen		[ll_row]
	ls_nro_os	= dw_detail.object.nro_os			[ll_row]
	ll_item_os	= Long(dw_detail.object.nro_item	[ll_row])

	//	create or replace procedure USP_CMP_PRORRATEA_OS(
	//       asi_org_os           in orden_servicio_det.cod_origen%TYPE,
	//       asi_nro_os           in orden_servicio_det.nro_os%TYPE,
	//       ani_item_os          in orden_servicio_det.nro_item%TYPE
	//	)is

	DECLARE USP_CMP_PRORRATEA_OS PROCEDURE FOR
		USP_CMP_PRORRATEA_OS( :ls_org_os, :ls_nro_os, :ll_item_os );
	
	EXECUTE USP_CMP_PRORRATEA_OS;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE USP_CMP_PRORRATEA_OS:" &
				  + SQLCA.SQLErrText
		Rollback;
		MessageBox('Aviso', ls_mensaje)
		Return
	END IF
	
	CLOSE USP_CMP_PRORRATEA_OS;
	
	ll_row = dw_oc_det.GetSelectedRow(ll_row)
Loop

MessageBox('Aviso', 'Proceso Efectuado satisfactoriamente')

dw_detail.event ue_output( dw_detail.GetRow())
end event

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

// busca tipos de movimiento definidos
SELECT 	doc_oc
	INTO 	:is_doc_oc
FROM logparam 
where reckey = '1';

if sqlca.sqlcode = 100 then
	Messagebox( "Error", "no ha definido parametros en Logparam")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", ls_mensaje)
	return 0
end if

if ISNULL( is_doc_oc ) or TRIM( is_doc_oc ) = '' then
	Messagebox("Error", "Defina Documento de Orden de Compra en logparam")
	return 0
end if

return 1
end function

public function integer of_retrieve (date ad_fecha1, date ad_fecha2, string as_flag);dw_master.Retrieve(ad_fecha1, ad_fecha2, as_flag)
dw_detail.Reset( )
dw_oc_Det.Reset( )

dw_master.ii_protect = 0
dw_master.of_protect( )

dw_oc_det.ii_protect = 0
dw_oc_det.of_protect( )

return 1
end function

on w_cm332_asignacion_os_oc.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.cb_1=create cb_1
this.cbx_1=create cbx_1
this.uo_fecha=create uo_fecha
this.st_3=create st_3
this.st_2=create st_2
this.dw_oc_det=create dw_oc_det
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.dw_oc_det
this.Control[iCurrent+7]=this.dw_detail
this.Control[iCurrent+8]=this.dw_master
end on

on w_cm332_asignacion_os_oc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cbx_1)
destroy(this.uo_fecha)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_oc_det)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10

dw_detail.width  = newwidth/2  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

dw_oc_det.x = dw_detail.width + 20
dw_oc_det.width  = newwidth  - dw_oc_det.x - 10
dw_oc_det.height = newheight - dw_oc_det.y - 10

st_2.x = dw_oc_det.x
end event

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)
dw_oc_det.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente

dw_oc_det.of_protect()

cb_1.event clicked( )
end event

event ue_insert;call super::ue_insert;Long  ll_row
str_parametros lstr_param

IF idw_1 = dw_detail THEN return

if idw_1 = dw_master then return

if idw_1 = dw_oc_det then

	lstr_param.tipo = 'OC_DET_OS_DET'
	SetNull(lstr_param.fecha1)
	SetNull(lstr_param.fecha2)
	
	OpenWithParm( w_abc_datos_ot, lstr_param )
	
	if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return
	
	lstr_param = Message.PowerObjectParm
	if lstr_param.titulo = 'n' then return
	
	lstr_param.tipo		= 'OC_DET_OS_DET'
	lstr_param.opcion	 	= 15         //Ordenes de Compra
	lstr_param.titulo 	= 'Selección de Ordenes de Compra'
	lstr_param.dw_master = 'd_abc_lista_oc_det_os_det_tbl'
	lstr_param.dw1		 	= 'd_abc_art_mov_oc_det_os_det_tbl'
	lstr_param.dw_m		= dw_detail
	lstr_param.dw_d		= dw_oc_det
	
	OpenWithParm( w_abc_seleccion_md, lstr_param)
	
end if
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_update;call super::ue_update;Boolean 	lbo_ok = TRUE
string	ls_flag
date		ld_fecha1, ld_Fecha2
Long 		ll_row1, ll_row2

dw_oc_det.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_oc_det.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_oc_det.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_oc_det.ii_update = 0
	
	dw_oc_det.ii_protect = 0
	dw_oc_det.of_protect()
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.event ue_output(dw_detail.GetRow())
	
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_oc_det.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_oc_det.ii_update = 0
	END IF
END IF

end event

event ue_modify;call super::ue_modify;if idw_1 = dw_oc_Det then
	idw_1.of_protect( )
end if
end event

event ue_delete;// Overriding Ancestor Script

Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

if idw_1 = dw_oc_det then
	ll_row = idw_1.Event ue_delete()
	
	IF ll_row = 1 THEN
		THIS.Event ue_delete_list()
		THIS.Event ue_delete_pos(ll_row)
	END IF
	idw_1.Groupcalc( )
end if
end event

type cb_1 from commandbutton within w_cm332_asignacion_os_oc
integer x = 1957
integer y = 8
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;string 	ls_flag
Date		ld_Fecha1, ld_fecha2
ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()
if cbx_1.checked then
	ls_flag = '1'
else
	ls_flag = '0'
end if
of_retrieve(ld_fecha1, ld_Fecha2, ls_flag)
end event

type cbx_1 from checkbox within w_cm332_asignacion_os_oc
integer x = 27
integer y = 24
integer width = 603
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo Rango Fechas"
boolean checked = true
end type

type uo_fecha from u_ingreso_rango_fechas within w_cm332_asignacion_os_oc
integer x = 663
integer y = 20
integer taborder = 40
end type

event constructor;call super::constructor;DAte ld_hoy
ld_hoy = Date(f_fecha_actual())

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
of_set_fecha(RelativeDate(ld_hoy,-15), ld_hoy) //para setear la fecha inicial



end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type st_3 from statictext within w_cm332_asignacion_os_oc
integer y = 1684
integer width = 1065
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle de orden de Servicio"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm332_asignacion_os_oc
integer x = 1321
integer y = 1684
integer width = 1143
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OC Amarrados x Servicio"
boolean focusrectangle = false
end type

type dw_oc_det from u_dw_abc within w_cm332_asignacion_os_oc
integer x = 1326
integer y = 1764
integer width = 1253
integer height = 724
integer taborder = 30
string dataobject = "d_abc_asign_os_oc_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.importe [al_row] = 0.00
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "matriz_cntbl"
		ls_sql = "select m.matriz as matriz, " &
				 + "m.descripcion as desc_matriz " &
				 + "  from matriz_cntbl_finan m " &
				 + " where m.flag_estado = '1' " &
				 + "   and m.matriz like 'OS%'"


		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.matriz_cntbl	[al_row] = ls_codigo
			this.object.desc_matriz		[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'matriz_cntbl'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_data
		  from matriz_cntbl_finan
		 Where matriz 		 = :data 
		   and flag_estado = '1'
			and matriz		 like 'OS%';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.matriz_cntbl	[row] = gnvo_app.is_null
			this.object.desc_matriz		[row] = gnvo_app.is_null
			MessageBox('Error', 'Matriz Contable ' + trim(data) &
									+ ' no existe, no esta activo o no corresponde' &
									+ ' a la Orden de Servicio, por favor verifique')
			return 1
		end if

		this.object.desc_matriz			[row] = ls_data

END CHOOSE
end event

type dw_detail from u_dw_abc within w_cm332_asignacion_os_oc
integer y = 1764
integer width = 1253
integer height = 724
integer taborder = 20
string dataobject = "d_abc_asign_os_oc_det_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

im_p1 = create m_prorrateo

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_output;call super::ue_output;string 	ls_nro_os, ls_org_os
Long		ll_item_os

ls_nro_os 	= this.object.nro_os 		[al_row]
ls_org_os 	= this.object.cod_origen 	[al_row]
ll_item_os	= this.object.nro_item	 	[al_row]

dw_oc_Det.Retrieve( ls_org_os, ls_nro_os, ll_item_os )
dw_oc_det.SetSort("tipo_doc A, nro_doc A")
dw_oc_det.Sort()
dw_oc_det.GroupCalc()

end event

event destructor;call super::destructor;DESTROY im_p1 
end event

event rbuttondown;//Overriding Ancestor Script

String ls_name, ls_title

ls_name = dwo.name
ls_title = Right(ls_name, 2)
IF ls_name = 'datawindow' or ls_title = '_t' THEN RETURN

is_colname = dwo.name
is_coltype = dwo.coltype
il_row     = row

im_p1.popmenu( w_main.PointerX(), w_main.PointerY() )
end event

event clicked;call super::clicked;if row > 0 then
	THIS.Event ue_output(row)
end if
end event

type dw_master from u_dw_abc within w_cm332_asignacion_os_oc
integer y = 132
integer width = 2565
integer height = 1524
boolean bringtotop = true
string dataobject = "d_abc_asign_os_oc_cab_tbl"
end type

event ue_output;call super::ue_output;dw_detail.retrieve( this.object.nro_os[al_row])

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;string 	ls_flag_estado, ls_fec_registro, ls_proveedor, &
			ls_nom_proveedor, ls_forma_pago, ls_desc_fp, &
			ls_moneda, ls_nro_os, ls_null
DateTime	ldt_fecha			
			
SetNull(ls_null)

if dwo.name = 'nro_os' then
	ls_nro_os = data
	
	select distinct a.flag_estado, a.proveedor, p.nom_proveedor, a.fec_registro,
       a.forma_pago, fp.desc_forma_pago, a.cod_moneda
	into 	:ls_flag_estado, :ls_proveedor, :ls_nom_proveedor, :ldt_fecha,
			:ls_forma_pago, :ls_desc_fp, :ls_moneda
	from orden_servicio a,
		  proveedor      p,
		  forma_pago     fp
	where p.proveedor 	= a.proveedor
	  and fp.forma_pago 	= a.forma_pago	
	  and a.nro_os 		= :ls_nro_os;
	
	if SQLCA.SQlCode = 100 then
		MessageBox('Aviso', 'Nro de OS no existe')
		this.object.nro_os [row] = ls_null		
		return 1
	end if
	
	this.object.flag_estado 	[row] = ls_flag_Estado
	this.object.fec_registro 	[row] = ldt_fecha
	this.object.proveedor	 	[row] = ls_proveedor
	this.object.nom_proveedor 	[row] = ls_nom_proveedor
	this.object.forma_pago	 	[row] = ls_forma_pago
	this.object.desc_forma_pago[row] = ls_desc_fp
	this.object.cod_moneda		[row] = ls_moneda
end if
end event

