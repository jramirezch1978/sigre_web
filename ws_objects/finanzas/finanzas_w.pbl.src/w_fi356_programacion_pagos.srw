$PBExportHeader$w_fi356_programacion_pagos.srw
forward
global type w_fi356_programacion_pagos from w_abc
end type
type tab_1 from tab within w_fi356_programacion_pagos
end type
type tabpage_cxp from userobject within tab_1
end type
type tab_2 from tab within tabpage_cxp
end type
type tabpage_prov from userobject within tab_2
end type
type rb_3 from radiobutton within tabpage_prov
end type
type rb_2 from radiobutton within tabpage_prov
end type
type rb_1 from radiobutton within tabpage_prov
end type
type cb_1 from commandbutton within tabpage_prov
end type
type uo_fechas_cxp from u_ingreso_rango_fechas within tabpage_prov
end type
type dw_cxp_prov_cuotas from u_dw_abc within tabpage_prov
end type
type dw_cxp_prov from u_dw_abc within tabpage_prov
end type
type gb_1 from groupbox within tabpage_prov
end type
type tabpage_prov from userobject within tab_2
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cb_1 cb_1
uo_fechas_cxp uo_fechas_cxp
dw_cxp_prov_cuotas dw_cxp_prov_cuotas
dw_cxp_prov dw_cxp_prov
gb_1 gb_1
end type
type tab_2 from tab within tabpage_cxp
tabpage_prov tabpage_prov
end type
type tabpage_cxp from userobject within tab_1
tab_2 tab_2
end type
type tabpage_3 from userobject within tab_1
end type
type ddlb_reporte from dropdownlistbox within tabpage_3
end type
type st_1 from statictext within tabpage_3
end type
type cb_2 from commandbutton within tabpage_3
end type
type uo_fec_rpt_prog_pagos from u_ingreso_rango_fechas within tabpage_3
end type
type dw_rpt_prog_pagos from u_dw_rpt within tabpage_3
end type
type gb_2 from groupbox within tabpage_3
end type
type tabpage_3 from userobject within tab_1
ddlb_reporte ddlb_reporte
st_1 st_1
cb_2 cb_2
uo_fec_rpt_prog_pagos uo_fec_rpt_prog_pagos
dw_rpt_prog_pagos dw_rpt_prog_pagos
gb_2 gb_2
end type
type tab_1 from tab within w_fi356_programacion_pagos
tabpage_cxp tabpage_cxp
tabpage_3 tabpage_3
end type
end forward

global type w_fi356_programacion_pagos from w_abc
integer width = 3657
integer height = 2480
string title = "[FI356] Programación de Pagos"
string menuname = "m_prog_pagos"
tab_1 tab_1
end type
global w_fi356_programacion_pagos w_fi356_programacion_pagos

type variables
u_dw_abc						idw_cxp_prov, idw_cxp_cuotas, idw_cxp_dpd
u_dw_rpt						idw_rpt_prog_pagos
u_ingreso_rango_fechas	iuo_fechas_cxp, iuo_fec_rpt_prog_pagos
m_rbutton_pagos 			im_cuotas
Integer						ii_index_rpt
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function boolean of_creacioncuotas ()
public function boolean of_cuotas_cxp (long al_row, str_parametros astr_param)
public subroutine of_retrieve_cxp_prov ()
public subroutine of_refresh_tab2 ()
end prototypes

public subroutine of_asigna_dws ();iuo_fechas_cxp		= tab_1.tabpage_cxp.tab_2.tabpage_prov.uo_fechas_cxp

idw_cxp_prov	= tab_1.tabpage_cxp.tab_2.tabpage_prov.dw_cxp_prov
idw_cxp_cuotas = tab_1.tabpage_cxp.tab_2.tabpage_prov.dw_cxp_prov_cuotas

iuo_fec_rpt_prog_pagos 	= tab_1.tabPage_3.uo_fec_rpt_prog_pagos
idw_rpt_prog_pagos		= tab_1.tabPage_3.dw_rpt_prog_pagos
end subroutine

public function boolean of_creacioncuotas ();Long 				ll_row, ll_row_proc = 0
String 			ls_proveedor, ls_tipo_doc, ls_nro_doc
Date				ld_fecha
str_parametros	lstr_param

try 
	if IsNull(idw_1) then return false
	
	if idw_1.getSelectedrow(0) = 0 then return false
	
	if idw_1 = idw_cxp_prov or idw_1 = idw_cxp_dpd then
		
		//Obtengo la fecha de vencimiento mas alta
		ld_fecha = Date(gnvo_App.of_fecha_actual())
		ll_row = idw_1.getSelectedrow( 0 )
		do while ll_row > 0
			if Date(idw_1.object.vencimiento [ll_row]) > ld_fecha then
				ld_Fecha = Date(idw_1.object.vencimiento [ll_row])
			end if
			ll_row = idw_1.getSelectedrow( ll_row )
		loop
		
		//Obtener el codigo de Flujo de Caja
		lstr_param.fecha1 = ld_fecha
		OpenWithParm(w_pop_prog_pagos, lstr_param)
		if isNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return false
		
		lstr_param = Message.PowerObjectParm
		if lstr_param.i_return = -1 then return false
		
		ll_row = idw_1.getSelectedrow( 0 )
		do while ll_row > 0
			ll_row_proc ++
			if idw_1 = idw_cxp_prov or idw_1 = idw_cxp_dpd then
				if not this.of_Cuotas_cxp( ll_row, lstr_param ) then return false
			end if
			ll_row = idw_1.getSelectedrow( ll_row )
		loop
		
	end if
	
	//Aplico los cambios sin problemas
	commit;
	
	//refresco la información en pantalla
	if idw_1 = idw_cxp_prov then
		of_retrieve_cxp_prov()
	end if
	
	f_mensaje("Proceso de Creación de cuotas realizado satisfactoriamente, se han procesado " + string(ll_row_proc) + " registros.", "")
	

	return true

catch ( Exception ex )
	ROLLBACK;
	MessageBox('Error', ex.GetMessage())
	return false
	
finally
	/*statementBlock*/
end try


end function

public function boolean of_cuotas_cxp (long al_row, str_parametros astr_param);string 	ls_proveedor, ls_tipo_doc, ls_nro_doc, ls_descripcion, &
			ls_cod_moneda, ls_flujo_caja, ls_nro_flujo
Integer	li_nro_cuota, li_ult_nro, li_count, li_item, li_i, li_cuotas, li_dias
Decimal	ldc_importe, ldc_imp_cuota, ldc_diferencia, ldc_imp_total
Date		ld_fec_programada, ld_next, ld_fec_vence
boolean	lb_fec_vence, lb_prov_flujo
Long		ll_nro_proceso

//Parametros de la estructura
ld_fec_programada = astr_param.fecha1
ls_flujo_caja		= astr_param.string1
li_cuotas			= Integer(astr_param.long1)
li_dias				= Integer(astr_param.long2)
lb_prov_flujo		= astr_param.boolean1
lb_fec_vence		= astr_param.boolean2

//Obtengo el numero de proceso
select nvl(max(nro_proceso), 0)
	into :ll_nro_proceso
from flujo_caja_proy
where cod_origen = :gs_origen;

//Obtengo el siguiente Id
ll_nro_proceso ++

//Obtengo el siguiente numero
select count(*)
	into :li_count
from num_flujo_caja_proy
where origen = :gs_origen;

if li_count = 0 then
	insert into num_flujo_caja_proy(origen, ult_nro)
	values(:gs_origen, 1);
	
	if gnvo_app.of_Existserror( SQLCA, "Insert num_flujo_caja_proy") then
		rollback;
		return false;
	end if
end if

select ult_nro
	into :li_ult_nro
from num_flujo_caja_proy
where origen = :gs_origen for update;

//Obtengo los datos 
ls_proveedor 	= idw_cxp_prov.object.cod_relacion 			[al_row]
ls_tipo_doc		= idw_cxp_prov.object.tipo_doc 				[al_row]
ls_nro_doc		= idw_cxp_prov.object.nro_doc 				[al_row]
ldc_importe		= Dec(idw_cxp_prov.object.imp_pendiente 	[al_row])
ls_cod_moneda	= idw_cxp_prov.object.cod_moneda				[al_row]
ls_Descripcion	= idw_cxp_prov.object.descripcion			[al_row]
ld_fec_vence	= Date(idw_cxp_prov.object.vencimiento		[al_row])

//Obtengo el ultimo nro de Item para la siguiente cuota
select nvl(max(nro_cuota),0)	
	into :li_item
from flujo_Caja_proy
where proveedor_cxp 	= :ls_proveedor
  and tipo_doc_cxp	= :ls_tipo_doc
  and nro_doc_cxp		= :ls_nro_doc;

// Ahora procedo a calcular el importe de acuerdo al numero de cuotas
ldc_imp_cuota 	= ldc_importe / li_cuotas

//Tomar la Fecha de vencimiento de acuerdo al check indicado
if lb_fec_vence then
	ld_next			= ld_fec_vence
else
	ld_next 			= ld_fec_programada
end if

//Sacamos el codigo de Flujo de Caja
if lb_prov_flujo then
	select cod_flujo_caja
		into :ls_flujo_caja
	from prov_flujo_Caja
	where proveedor = :ls_proveedor;
	
	if SQLCA.SQLCOde = 100 then
		rollback;
		MessageBox('Error', 'El Proveedor ' + ls_proveedor + ' no tiene especificado un concepto de flujo de caja, por favor verifique')
		return false
	end if
	
else
	ls_flujo_caja = astr_param.string1
end if

//Registrar uno por uno las cuotas de la programación
for li_i = 1 to li_cuotas
	li_item += 1
	ls_nro_flujo = gs_origen + trim(string(li_ult_nro, '00000000'))
	li_ult_nro ++
	
	insert into flujo_caja_proy(
		nro_flujo_caja, cod_origen, cod_flujo_caja, proveedor_cxp, tipo_doc_cxp, 
		nro_doc_cxp, nro_cuota, descripcion, fec_programada, cod_moneda, importe,
		flag_estado, fec_registro, cod_usr, nro_proceso)
	values(
		:ls_nro_flujo, :gs_origen, :ls_flujo_caja, :ls_proveedor, :ls_tipo_doc,
		:ls_nro_doc, :li_item, :ls_Descripcion, :ld_next, :ls_cod_moneda, :ldc_imp_cuota,
		'1', sysdate, :gs_user, :ll_nro_proceso);
		
	if gnvo_app.of_Existserror( SQLCA, "Insert flujo_caja_proy") then
		rollback;
		return false;
	end if
	
	//Calculo la siguiente fecha programada
	ld_next = RelativeDate(ld_next, li_dias)

next

//Ahora pongo la diferencia, solo si es mayor a una cuota
if li_cuotas > 1 then
	//Obtengo el ultimo nro de Item para la siguiente cuota
	select nvl(sum(importe),0)	
		into :ldc_imp_total
	from flujo_Caja_proy
	where proveedor_cxp 	= :ls_proveedor
	  and tipo_doc_cxp	= :ls_tipo_doc
	  and nro_doc_cxp		= :ls_nro_doc
	  and cod_origen		= :gs_origen
	  and nro_proceso		= :ll_nro_proceso;
	
	if ldc_imp_total <> ldc_importe then
		ldc_diferencia = ldc_importe - ldc_imp_total
		
		if ldc_diferencia <> 0 then
			update flujo_caja_proy
			   set importe = importe + :ldc_diferencia
			 where proveedor_cxp 	= :ls_proveedor
			   and tipo_doc_cxp		= :ls_tipo_doc
			   and nro_doc_cxp		= :ls_nro_doc
				and nro_cuota			= :li_item;
				
			if gnvo_app.of_Existserror( SQLCA, "update flujo_caja_proy") then
				rollback;
				return false;
			end if
		end if
		
	end if

end if

// Actualizo el numerador
update num_flujo_caja_proy
	set ult_nro = :li_ult_nro + 1
where origen = :gs_origen;

if gnvo_app.of_Existserror( SQLCA, "Update num_flujo_caja_proy") then
	rollback;
	return false;
end if

return true
end function

public subroutine of_retrieve_cxp_prov ();date		ld_Fecha1, ld_fecha2
String	ls_flag

ld_Fecha1 = iuo_fechas_cxp.of_get_fecha1( )
ld_Fecha2 = iuo_fechas_cxp.of_get_fecha2( )

if tab_1.tabpage_cxp.tab_2.tabpage_prov.rb_1.checked then
	ls_flag = '1'
elseif tab_1.tabpage_cxp.tab_2.tabpage_prov.rb_2.checked then
	ls_flag = '2'
elseif tab_1.tabpage_cxp.tab_2.tabpage_prov.rb_3.checked then
	ls_flag = '3'
end if

idw_cxp_prov.Retrieve(ld_fecha1, ld_fecha2, ls_flag)

if idw_cxp_prov.RowCount() > 0 then
	idw_cxp_prov.SetRow(1)
	idw_cxp_prov.SelectRow(0, false)
	idw_cxp_prov.SelectRow(1, true)
	idw_cxp_prov.ScrollToRow(1)
	idw_cxp_cuotas.Retrieve()
	idw_cxp_prov.event ue_output(1)
end if

idw_cxp_cuotas.modify( "fec_programada.protect='1~tif(flag_estado=~~'1~~',0,1)")
idw_cxp_cuotas.modify( "importe.protect='1~tif(flag_estado=~~'1~~',0,1)")
end subroutine

public subroutine of_refresh_tab2 ();Date ld_fecha1, ld_fecha2

ld_fecha1 = iuo_fec_rpt_prog_pagos.of_get_fecha1( )
ld_fecha2 = iuo_fec_rpt_prog_pagos.of_get_fecha2( )

if ii_index_rpt = 1 then
	idw_rpt_prog_pagos.DataObject = 'd_rpt_programa_pago_crt'
elseif 	ii_index_rpt = 2 then
	idw_rpt_prog_pagos.DataObject = 'd_rpt_programa_pagos_res_crt'
end if

idw_rpt_prog_pagos.SetTransObject(SQLCA)

idw_rpt_prog_pagos.Retrieve(ld_fecha1, ld_fecha2)
end subroutine

on w_fi356_programacion_pagos.create
int iCurrent
call super::create
if this.MenuName = "m_prog_pagos" then this.MenuID = create m_prog_pagos
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_fi356_programacion_pagos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_cxp.tab_2.width  = tab_1.tabpage_cxp.width  - tab_1.tabpage_cxp.tab_2.x - 10
tab_1.tabpage_cxp.tab_2.height  = tab_1.tabpage_cxp.height  - tab_1.tabpage_cxp.tab_2.y - 10

//tab_1.tabpage_cxp.tab_2.tabpage_prov
//idw_cxp_cuotas
idw_cxp_cuotas.height = tab_1.tabpage_cxp.tab_2.tabpage_prov.height / 3
idw_cxp_cuotas.width = tab_1.tabpage_cxp.tab_2.tabpage_prov.width  - idw_cxp_cuotas.x - 10
idw_cxp_cuotas.y  	= tab_1.tabpage_cxp.tab_2.tabpage_prov.height  - idw_cxp_cuotas.height - 10


idw_cxp_prov.width  = tab_1.tabpage_cxp.tab_2.tabpage_prov.width  - idw_cxp_prov.x - 10
idw_cxp_prov.height  = idw_cxp_cuotas.y - idw_cxp_prov.y  - 10

//Reporte de Programa de Pagos
idw_rpt_prog_pagos.width  = tab_1.tabpage_3.width - idw_rpt_prog_pagos.x - 10
idw_rpt_prog_pagos.height  = tab_1.tabpage_3.height - idw_rpt_prog_pagos.y  - 10


end event

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

idw_1 = idw_cxp_prov

idw_cxp_prov.setTransObject(SQLCA)
idw_cxp_cuotas.setTransObject(SQLCA)
idw_rpt_prog_pagos.setTransObject(SQLCA)

//Cntas X Pagar 
of_retrieve_cxp_prov()

im_cuotas = create m_rbutton_pagos

end event

event ue_filter_avanzado;//Override
IF idw_1.is_dwform <> 'tabular' THEN return

if idw_1 = idw_cxp_prov then
	idw_1.Event ue_filter_avanzado()
end if
end event

event close;call super::close;destroy im_cuotas
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( idw_cxp_cuotas ) <> true then return

ib_update_check = true
end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = idw_cxp_prov or idw_1 = idw_cxp_cuotas THEN
	MessageBox("Error", "No esta permitido insertar registros en estos paneles, por favor verifique!")
	RETURN
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_modify;call super::ue_modify;idw_1.of_protect()
end event

event ue_delete;//Override
Long  ll_row

if idw_1 = idw_cxp_cuotas then
	if idw_1.GetRow() > 0 then
		if idw_1.object.flag_estado [idw_1.GetRow()] <> '1' then	
			MessageBox('Error', 'El registro no se puede eliminar porque no esta activo, por favor verifique!')
			return
		end if
	end if
end if

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_anular;call super::ue_anular;Long ll_row
if idw_1.GetRow() = 0 then return

ll_Row = idw_1.GetRow()

if idw_1 = idw_cxp_cuotas then
	if idw_1.object.flag_estado [ll_row] <> '1' then
		MessageBox('Error', 'Es imposible anular la cuota ' + idw_1.object.nro_flujo_caja[ll_row] + ' ya que no esta activa. Por favor verifique!')
		return
	end if
	
	idw_1.object.flag_estado [ll_row] = '0'
	idw_1.ii_update = 1
end if
end event

event ue_update;//Override
Boolean lbo_ok = TRUE

idw_cxp_cuotas.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

if ib_log then
	idw_cxp_cuotas.of_create_log( )
end if


IF idw_cxp_cuotas.ii_update = 1 THEN
	IF idw_cxp_cuotas.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Datawindow idw_cxp_cuotas","Se ha procedido al rollback",exclamation!)
	END IF
END IF

if lbo_ok and ib_log then
	lbo_ok = idw_cxp_cuotas.of_save_log()
end if


IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_cxp_cuotas.ii_update = 0
	idw_cxp_cuotas.ResetUpdate( )
	
	event ue_refresh()
	
	f_mensaje("Cambios Guardados satisfactoriamente, por favor verifique!", "")
else
	ROLLBACK;
END IF

end event

event ue_refresh;call super::ue_refresh;of_retrieve_cxp_prov()
end event

type tab_1 from tab within w_fi356_programacion_pagos
integer width = 3241
integer height = 2240
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_cxp tabpage_cxp
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_cxp=create tabpage_cxp
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_cxp,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_cxp)
destroy(this.tabpage_3)
end on

event selectionchanged;if this.Selectedtab = 2 then
	of_refresh_tab2()
end if
end event

type tabpage_cxp from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3205
integer height = 2112
long backcolor = 79741120
string text = "Cntas x Pagar"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
tab_2 tab_2
end type

on tabpage_cxp.create
this.tab_2=create tab_2
this.Control[]={this.tab_2}
end on

on tabpage_cxp.destroy
destroy(this.tab_2)
end on

type tab_2 from tab within tabpage_cxp
integer width = 2953
integer height = 1716
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_prov tabpage_prov
end type

on tab_2.create
this.tabpage_prov=create tabpage_prov
this.Control[]={this.tabpage_prov}
end on

on tab_2.destroy
destroy(this.tabpage_prov)
end on

type tabpage_prov from userobject within tab_2
integer x = 18
integer y = 112
integer width = 2917
integer height = 1588
long backcolor = 79741120
string text = "Provision"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cb_1 cb_1
uo_fechas_cxp uo_fechas_cxp
dw_cxp_prov_cuotas dw_cxp_prov_cuotas
dw_cxp_prov dw_cxp_prov
gb_1 gb_1
end type

on tabpage_prov.create
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_1=create cb_1
this.uo_fechas_cxp=create uo_fechas_cxp
this.dw_cxp_prov_cuotas=create dw_cxp_prov_cuotas
this.dw_cxp_prov=create dw_cxp_prov
this.gb_1=create gb_1
this.Control[]={this.rb_3,&
this.rb_2,&
this.rb_1,&
this.cb_1,&
this.uo_fechas_cxp,&
this.dw_cxp_prov_cuotas,&
this.dw_cxp_prov,&
this.gb_1}
end on

on tabpage_prov.destroy
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_1)
destroy(this.uo_fechas_cxp)
destroy(this.dw_cxp_prov_cuotas)
destroy(this.dw_cxp_prov)
destroy(this.gb_1)
end on

type rb_3 from radiobutton within tabpage_prov
integer x = 50
integer y = 192
integer width = 562
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No filtrar por fecha"
boolean checked = true
end type

type rb_2 from radiobutton within tabpage_prov
integer x = 50
integer y = 56
integer width = 562
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha de Emisión"
end type

type rb_1 from radiobutton within tabpage_prov
integer x = 50
integer y = 124
integer width = 562
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha de Registro"
end type

type cb_1 from commandbutton within tabpage_prov
integer x = 1925
integer y = 80
integer width = 402
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;of_retrieve_cxp_prov()
end event

type uo_fechas_cxp from u_ingreso_rango_fechas within tabpage_prov
integer x = 590
integer y = 84
integer taborder = 40
end type

on uo_fechas_cxp.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual
//
ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))
//
of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type dw_cxp_prov_cuotas from u_dw_abc within tabpage_prov
integer x = 5
integer y = 1132
integer width = 1403
integer height = 432
integer taborder = 40
string dataobject = "d_abc_flujo_cxp_cuotas_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_user 		[al_row] = gs_user
this.object.fec_registro	[al_row] = f_fecha_actual()
this.object.flag_nuevo		[al_row] = '1'
this.object.fec_programada	[al_row] = Date(f_fecha_actual())
this.object.nro_item			[al_row] = this.of_nro_item()
this.object.importe			[al_row] = 0.00
this.object.imp_soles		[al_row] = 0.00
this.object.imp_dolares		[al_row] = 0.00
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

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cod_flujo_caja"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor " &
				  + "FROM proveedor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.prov_almacen	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

type dw_cxp_prov from u_dw_abc within tabpage_prov
integer y = 304
integer width = 1486
integer height = 624
integer taborder = 30
string dataobject = "d_list_cntas_pagar_prov_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event rbuttondown;//Override
im_cuotas.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event rowfocuschanged;//Override
if currentrow <= 0 then return

if currentrow = il_Row then return

il_row = currentrow              // fila corriente

IF this.is_dwform <> 'form' and ii_ss = 1 THEN		        // solo para seleccion individual			
	THIS.SetRow(currentrow)
	this.event ue_output(currentrow)
	RETURN
END IF
end event

event ue_output;call super::ue_output;String ls_proveedor, ls_tipo_doc, ls_nro_doc, ls_expresion

ls_proveedor 	= this.object.cod_relacion [al_row]
ls_tipo_doc 	= this.object.tipo_doc		[al_row]
ls_nro_doc		= this.object.nro_doc		[al_row]

ls_expresion = "proveedor_cxp = '" + ls_proveedor + "' and tipo_doc_cxp = '" + ls_tipo_doc + "' and nro_doc_cxp = '" + ls_nro_doc + "'"

idw_cxp_cuotas.SetFilter( ls_expresion )
idw_cxp_cuotas.filter( )

if idw_cxp_cuotas.RowCount() > 0 then
	idw_cxp_cuotas.SetRow(1)
	idw_cxp_cuotas.SelectRow( 0, false)
	idw_cxp_cuotas.SelectRow(1, true)
end if
end event

event clicked;call super::clicked;if row > 0 then
	THIS.Event ue_output(row)
end if
end event

type gb_1 from groupbox within tabpage_prov
integer width = 2391
integer height = 300
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtros por fecha"
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3205
integer height = 2112
long backcolor = 79741120
string text = "Programa de Pagos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
ddlb_reporte ddlb_reporte
st_1 st_1
cb_2 cb_2
uo_fec_rpt_prog_pagos uo_fec_rpt_prog_pagos
dw_rpt_prog_pagos dw_rpt_prog_pagos
gb_2 gb_2
end type

on tabpage_3.create
this.ddlb_reporte=create ddlb_reporte
this.st_1=create st_1
this.cb_2=create cb_2
this.uo_fec_rpt_prog_pagos=create uo_fec_rpt_prog_pagos
this.dw_rpt_prog_pagos=create dw_rpt_prog_pagos
this.gb_2=create gb_2
this.Control[]={this.ddlb_reporte,&
this.st_1,&
this.cb_2,&
this.uo_fec_rpt_prog_pagos,&
this.dw_rpt_prog_pagos,&
this.gb_2}
end on

on tabpage_3.destroy
destroy(this.ddlb_reporte)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.uo_fec_rpt_prog_pagos)
destroy(this.dw_rpt_prog_pagos)
destroy(this.gb_2)
end on

type ddlb_reporte from dropdownlistbox within tabpage_3
integer x = 581
integer y = 60
integer width = 1403
integer height = 456
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean hscrollbar = true
string item[] = {"Detalle por Factura","Resumen por Proveedor","Resumen por Semana"}
borderstyle borderstyle = stylelowered!
end type

event constructor;this.selectitem( 1 )
ii_index_rpt = 1
end event

event selectionchanged;ii_index_rpt = index
end event

type st_1 from statictext within tabpage_3
integer x = 23
integer y = 68
integer width = 553
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Elija el reporte:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within tabpage_3
integer x = 2011
integer y = 56
integer width = 402
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;of_refresh_tab2()
end event

type uo_fec_rpt_prog_pagos from u_ingreso_rango_fechas within tabpage_3
integer x = 23
integer y = 172
integer taborder = 50
end type

event constructor;call super::constructor;Date	ld_fecha_actual
//
ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))
//
of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

on uo_fec_rpt_prog_pagos.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_rpt_prog_pagos from u_dw_rpt within tabpage_3
integer y = 280
integer width = 3077
integer height = 1396
integer taborder = 20
string dataobject = "d_rpt_programa_pago_crt"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_2 from groupbox within tabpage_3
integer width = 2798
integer height = 276
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtros por fecha"
end type

