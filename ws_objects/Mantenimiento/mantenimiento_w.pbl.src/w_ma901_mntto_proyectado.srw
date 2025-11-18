$PBExportHeader$w_ma901_mntto_proyectado.srw
forward
global type w_ma901_mntto_proyectado from w_rpt
end type
type rb_2 from radiobutton within w_ma901_mntto_proyectado
end type
type cbx_1 from checkbox within w_ma901_mntto_proyectado
end type
type sle_origen from singlelineedit within w_ma901_mntto_proyectado
end type
type st_3 from statictext within w_ma901_mntto_proyectado
end type
type rb_1 from radiobutton within w_ma901_mntto_proyectado
end type
type uo_fecha_inicial from u_ingreso_fecha within w_ma901_mntto_proyectado
end type
type cb_impresion from commandbutton within w_ma901_mntto_proyectado
end type
type sle_und from singlelineedit within w_ma901_mntto_proyectado
end type
type rb_articulos from radiobutton within w_ma901_mntto_proyectado
end type
type rb_labores from radiobutton within w_ma901_mntto_proyectado
end type
type cb_generar from commandbutton within w_ma901_mntto_proyectado
end type
type cb_reporte from commandbutton within w_ma901_mntto_proyectado
end type
type st_2 from statictext within w_ma901_mntto_proyectado
end type
type em_hasta from editmask within w_ma901_mntto_proyectado
end type
type em_desde from editmask within w_ma901_mntto_proyectado
end type
type st_1 from statictext within w_ma901_mntto_proyectado
end type
type uo_fecha from u_ingreso_rango_fechas within w_ma901_mntto_proyectado
end type
type dw_report from u_dw_rpt within w_ma901_mntto_proyectado
end type
type gb_1 from groupbox within w_ma901_mntto_proyectado
end type
type cb_equipos from commandbutton within w_ma901_mntto_proyectado
end type
end forward

global type w_ma901_mntto_proyectado from w_rpt
integer width = 3890
integer height = 2644
string title = "Manetnimiento Proyectados (MA901)"
string menuname = "m_impresion"
long backcolor = 67108864
event ue_properties ( )
event ue_generar ( )
event ue_labores ( )
event ue_articulos_proyect ( )
event ue_impresion ( )
event ue_articulos_generados ( )
event ue_servicios_proyect ( )
rb_2 rb_2
cbx_1 cbx_1
sle_origen sle_origen
st_3 st_3
rb_1 rb_1
uo_fecha_inicial uo_fecha_inicial
cb_impresion cb_impresion
sle_und sle_und
rb_articulos rb_articulos
rb_labores rb_labores
cb_generar cb_generar
cb_reporte cb_reporte
st_2 st_2
em_hasta em_hasta
em_desde em_desde
st_1 st_1
uo_fecha uo_fecha
dw_report dw_report
gb_1 gb_1
cb_equipos cb_equipos
end type
global w_ma901_mntto_proyectado w_ma901_mntto_proyectado

type variables
integer ii_update = 0
end variables

forward prototypes
public function boolean of_revertir_ot (string as_nro_ot)
public function boolean of_generar_ot (string as_cod_proceso, string as_cencos_slc, string as_cencos_rsp, string as_centro_benef, string as_ot_adm, string as_ot_tipo, string as_prog_mnt, date ad_prox_mtto, decimal adc_prox_mtto, string as_window, date ad_ult_mtto, decimal adc_ult_mtto, ref string as_nro_ot, date ad_fec_inicio)
end prototypes

event ue_properties();sg_parametros lstr_param

lstr_param.dw_d = dw_report

OpenWithParm(w_print_properties, lstr_param)

end event

event ue_generar();Long 		ll_row
string	ls_cod_proceso, ls_cencos_slc, ls_ot_adm, &
			ls_ot_tipo, ls_prog_mnt, ls_window, &
			ls_nro_ot, ls_flag_generar, ls_cencos_rsp, &
			ls_centro_benef
decimal	ldc_prox_mtto, ldc_ult_mtto
date		ld_ult_mtto, ld_prox_mtto, ld_fec_inicio
sg_parametros sl_param

ls_window = This.ClassName()
ls_cod_proceso = trim(gs_origen) + '11'

Open(w_ma902_generar_ot)

if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return

if Message.PowerObjectParm.ClassName() <> 'sg_parametros' then
	MessageBox('Aviso', 'La ventana a devuelto parametros incorrectos', StopSign!)
	return
end if

sl_param = Message.PowerObjectParm

if sl_param.titulo = 'n' then return

ls_ot_adm		 = sl_param.string1
ls_ot_tipo		 = sl_param.string2
ls_cencos_slc	 = sl_param.string3
ls_cencos_rsp	 = sl_param.string4
ls_centro_benef = sl_param.string5

for ll_row = 1 to idw_1.RowCount()
	ls_flag_generar 	= idw_1.object.flag_generar	[ll_row]
	ls_nro_ot			= idw_1.object.nro_ot			[ll_row]
	
	if IsNull(ls_nro_ot) then ls_nro_ot = ''
	
	if ls_flag_generar = '1' AND ls_nro_ot = ''  then
		
		// Se va generar una orden de trabajo nueva
		ls_prog_mnt 	= idw_1.object.prog_mnt[ll_row]
		ld_prox_mtto 	= Date(idw_1.object.fec_prox_mantto	[ll_row])
		ld_ult_mtto 	= Date(idw_1.object.fec_ult_mantto	[ll_row])
		ld_fec_inicio 	= Date(idw_1.object.fec_inicio		[ll_row])
		ldc_prox_mtto	= idw_1.object.prox_mantto[ll_row]
		ldc_ult_mtto	= idw_1.object.ult_mantto[ll_row]
		
		if of_generar_ot(	ls_cod_proceso, 	ls_cencos_slc, 	ls_cencos_rsp,	ls_centro_benef, &
								ls_ot_adm, 			ls_ot_tipo, 		ls_prog_mnt, 	ld_prox_mtto, 	&
								ldc_prox_mtto,		ls_window, 			ld_ult_mtto,	ldc_ult_mtto,	&
								ls_nro_ot,			ld_fec_inicio ) = true then
								
			idw_1.object.nro_ot[ll_row] = ls_nro_ot
			
		end if
	elseif ls_flag_generar = '0' AND ls_nro_ot <> ''  then
//		//Se va a proceder a revertir la Orden de Trabajo, es decir anularla
//		if of_revertir_ot(ls_nro_ot) = true then
//			SetNull(ls_nro_ot)
//			idw_1.object.nro_ot[ll_row] = ls_nro_ot
//		end if
//		
	end if
next
end event

event ue_labores();Long ll_count
date		ld_fecha1, ld_fecha2, ld_Today
decimal	ldc_hora1, ldc_hora2

idw_1.DataObject = 'd_rpt_mantto_proyectado_grd'
idw_1.SetTransObject(SQLCA)
	
select count(*)
	into :ll_count
from TT_MTT_PROYECTADO;
	
if ll_count > 0 then
	ld_fecha1 	= uo_fecha.of_get_fecha1( )
	ld_fecha2 	= uo_fecha.of_get_fecha2( )
	
	if ld_fecha2 < ld_fecha1 then
		MessageBox('Aviso', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
		return
	end if

	idw_1.Retrieve()
	idw_1.Object.p_logo.filename = gs_logo
	idw_1.Object.t_empresa.text = gs_empresa
	idw_1.object.usuario_t.text = 'Usuario : ' + trim(gs_user)
	idw_1.Object.Datawindow.Print.Orientation = 1
	idw_1.Object.Datawindow.Print.Paper.Size = 9
	ib_preview = true
	idw_1.Modify("DataWindow.Print.Preview=Yes")

	idw_1.Object.subtitulo_t.text = 'Del: ' + string(ld_fecha1, 'dd/mm/yyyy') &
	+ ' al ' + string(ld_fecha1, 'dd/mm/yyyy')

	if idw_1.RowCount() > 0 then
		cb_generar.enabled = true
	else
		cb_generar.enabled = false
	end if
end if
end event

event ue_articulos_proyect();Long ll_count
date		ld_fecha1, ld_fecha2, ld_Today
decimal	ldc_hora1, ldc_hora2

dw_report.DataObject = 'd_rpt_mat_proyectados_grd'
dw_report.SetTransObject(SQLCA)
	
select count(*)
	into :ll_count
from TT_MTT_PROYECTADO;
	
if ll_count > 0 then
	ld_fecha1 	= uo_fecha.of_get_fecha1( )
	ld_fecha2 	= uo_fecha.of_get_fecha2( )
	
	if ld_fecha2 < ld_fecha1 then
		MessageBox('Aviso', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
		return
	end if

	dw_report.Retrieve()
	
	dw_report.Object.p_logo.filename = gs_logo
	dw_report.Object.t_empresa.text = gs_empresa
	dw_report.object.usuario_t.text = 'Usuario : ' + trim(gs_user)
	dw_report.Object.Datawindow.Print.Orientation = 2
	dw_report.Object.Datawindow.Print.Paper.Size = 9
	ib_preview = true
	dw_report.Modify("DataWindow.Print.Preview=Yes")


	dw_report.Object.subtitulo_t.text = 'Del: ' + string(ld_fecha1, 'dd/mm/yyyy') &
	+ ' al ' + string(ld_fecha1, 'dd/mm/yyyy')

end if
cb_generar.enabled = false

end event

event ue_impresion();u_ds_base lds_rpt_ot
string	ls_nro_orden
Long		ll_i

lds_rpt_ot = CREATE u_ds_base
lds_rpt_ot.DataObject = 'd_rpt_formato_ot_corr_tbl'
lds_rpt_ot.SetTransObject(SQLCA)

for ll_i = 1 to idw_1.RowCount()
	if idw_1.object.imprimir [ll_i] = '1' then
		ls_nro_orden = idw_1.object.nro_ot [ll_i]
		SetMicrohelp('Progreso: ' + string(ll_i/idw_1.RowCount() * 100, '00.000') + '%')
		
		if ls_nro_orden <> '' or Not IsNull(ls_nro_orden) then
			lds_rpt_ot.Retrieve(ls_nro_orden)
			lds_rpt_ot.Print(True)
		end if
	end if
next

Destroy lds_rpt_ot

SetMicrohelp('Listo')
end event

event ue_articulos_generados();Long ll_count
date		ld_fecha1, ld_fecha2, ld_Today
decimal	ldc_hora1, ldc_hora2

dw_report.DataObject = 'd_rpt_mat_generados_grd'
dw_report.SetTransObject(SQLCA)
	
select count(*)
	into :ll_count
from TT_MTT_PROYECTADO;
	
if ll_count > 0 then
	ld_fecha1 	= uo_fecha.of_get_fecha1( )
	ld_fecha2 	= uo_fecha.of_get_fecha2( )
	
	if ld_fecha2 < ld_fecha1 then
		MessageBox('Aviso', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
		return
	end if

	dw_report.Retrieve()
	
	dw_report.Object.p_logo.filename = gs_logo
	dw_report.Object.t_empresa.text = gs_empresa
	dw_report.object.usuario_t.text = 'Usuario : ' + trim(gs_user)
	dw_report.Object.Datawindow.Print.Orientation = 2
	dw_report.Object.Datawindow.Print.Paper.Size = 9
	ib_preview = true
	dw_report.Modify("DataWindow.Print.Preview=Yes")


	dw_report.Object.subtitulo_t.text = 'Del: ' + string(ld_fecha1, 'dd/mm/yyyy') &
	+ ' al ' + string(ld_fecha1, 'dd/mm/yyyy')

end if
cb_generar.enabled = false

end event

event ue_servicios_proyect();Long ll_count
date		ld_fecha1, ld_fecha2, ld_Today
decimal	ldc_hora1, ldc_hora2

dw_report.DataObject = 'd_rpt_servicios_terc_proyect'
dw_report.SetTransObject(SQLCA)
	
select count(*)
	into :ll_count
from TT_MTT_PROYECTADO;
	
if ll_count > 0 then
	ld_fecha1 	= uo_fecha.of_get_fecha1( )
	ld_fecha2 	= uo_fecha.of_get_fecha2( )
	
	if ld_fecha2 < ld_fecha1 then
		MessageBox('Aviso', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
		return
	end if

	dw_report.Retrieve()
	
	dw_report.Object.p_logo.filename = gs_logo
	dw_report.Object.t_empresa.text = gs_empresa
	dw_report.object.usuario_t.text = 'Usuario : ' + trim(gs_user)
	dw_report.Object.Datawindow.Print.Orientation = 2
	dw_report.Object.Datawindow.Print.Paper.Size = 9
	ib_preview = true
	dw_report.Modify("DataWindow.Print.Preview=Yes")


	dw_report.Object.subtitulo_t.text = 'Del: ' + string(ld_fecha1, 'dd/mm/yyyy') &
	+ ' al ' + string(ld_fecha1, 'dd/mm/yyyy')

end if
cb_generar.enabled = false

end event

public function boolean of_revertir_ot (string as_nro_ot);Integer 	li_ok
string	ls_mensaje

//create or replace procedure USP_MT_REVERTIR_OT(
//       asi_nro_ot           in  orden_trabajo.nro_orden%TYPE,
//       aso_mensaje          out varchar2,
//       aio_ok               out number 
//) is

DECLARE USP_MT_REVERTIR_OT PROCEDURE FOR
	USP_MT_REVERTIR_OT( :as_nro_ot );

EXECUTE USP_MT_REVERTIR_OT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_MT_REVERTIR_OT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

FETCH USP_MT_REVERTIR_OT INTO :ls_mensaje, :li_ok;
	
CLOSE USP_MT_REVERTIR_OT;

if li_ok <> 1 then
	MessageBox('Error PROCEDURE USP_MT_REVERTIR_OT', ls_mensaje, StopSign!)	
	return false
end if

return true

end function

public function boolean of_generar_ot (string as_cod_proceso, string as_cencos_slc, string as_cencos_rsp, string as_centro_benef, string as_ot_adm, string as_ot_tipo, string as_prog_mnt, date ad_prox_mtto, decimal adc_prox_mtto, string as_window, date ad_ult_mtto, decimal adc_ult_mtto, ref string as_nro_ot, date ad_fec_inicio);Integer 	li_ok
string	ls_mensaje
date		ld_fec_reg

ld_fec_reg = Date(f_fecha_actual())

//create or replace procedure usp_mt_generar_ot(
//       asi_origen           in  origen.cod_origen%TYPE,        -- Codigo de Origen de la O.T.
//       adi_fec_reg          in  date,                          -- Fecha de registro
//       adi_prox_mtto        in  date,                          -- Fecha Estimada de Inicio
//       asi_cencos_slc       in  orden_trabajo.cencos_slc%TYPE, -- Centros de Costo solicitante
//       asi_cencos_rsp       in  orden_trabajo.cencos_rsp%TYPE, -- Centros de Costo Responsable
//       asi_centro_benef     IN  orden_trabajo.centro_benef%TYPE, -- Centro de Beneficio
//       asi_ot_adm           in  orden_trabajo.ot_adm%TYPE,     -- O.T. Administrador
//       asi_ot_tipo          in  orden_trabajo.ot_tipo%TYPE,    -- Tipo de O.T.
//       asi_prog_mnt         in  mt_prog_ciclo_mantto.prog_mnt%TYPE, -- Item de Prog. Mnt.
//       ani_prox_mtto        in  orden_trabajo.mnt_und_act_proy%TYPE, -- Proximo Mantto
//       asi_cod_usr          in  usuario.cod_usr%TYPE,          -- Codigo de Usuario
//       asi_cod_proceso      in  oper_procesos.cod_proceso%TYPE,   -- Codigo de Proceso
//       asi_window           in  oper_procesos.window%TYPE,        -- Nombre de la Ventana
//       adi_ult_mtto         in  date,                             -- Fecha del ultimo mantenimiento
//       ani_ult_mtto         in  mt_prog_ciclo_mantto.ultimo_mnt%TYPE, -- Ultimo mantenimiento
//       aso_nro_ot           out varchar2,  -- Numero de la OT
//  	   aso_mensaje          out varchar2,
//       aio_ok               out number
//) is


DECLARE usp_mt_generar_ot PROCEDURE FOR
	usp_mt_generar_ot( :gs_origen, 		
							 :ld_fec_reg, 		
							 :ad_prox_mtto,
							 :as_cencos_slc, 	
							 :as_cencos_rsp,	
							 :as_centro_benef,
							 :as_ot_adm, 		
							 :as_ot_tipo, 	 	
							 :as_prog_mnt, 		
							 :adc_prox_mtto, 	
							 :gs_user,			
							 :as_cod_proceso, 	
							 :as_window,			
							 :ad_ult_mtto,	 	
							 :adc_ult_mtto);

EXECUTE usp_mt_generar_ot;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_mt_generar_ot: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

FETCH usp_mt_generar_ot INTO :as_nro_ot, :ls_mensaje, :li_ok;
	
CLOSE usp_mt_generar_ot;

if li_ok <> 1 then
	ROLLBACK;
	SetNull(as_nro_ot)
	MessageBox('Error PROCEDURE usp_mt_generar_ot', ls_mensaje, StopSign!)	
	return false
end if

return true
end function

on w_ma901_mntto_proyectado.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_2=create rb_2
this.cbx_1=create cbx_1
this.sle_origen=create sle_origen
this.st_3=create st_3
this.rb_1=create rb_1
this.uo_fecha_inicial=create uo_fecha_inicial
this.cb_impresion=create cb_impresion
this.sle_und=create sle_und
this.rb_articulos=create rb_articulos
this.rb_labores=create rb_labores
this.cb_generar=create cb_generar
this.cb_reporte=create cb_reporte
this.st_2=create st_2
this.em_hasta=create em_hasta
this.em_desde=create em_desde
this.st_1=create st_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.gb_1=create gb_1
this.cb_equipos=create cb_equipos
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.sle_origen
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.uo_fecha_inicial
this.Control[iCurrent+7]=this.cb_impresion
this.Control[iCurrent+8]=this.sle_und
this.Control[iCurrent+9]=this.rb_articulos
this.Control[iCurrent+10]=this.rb_labores
this.Control[iCurrent+11]=this.cb_generar
this.Control[iCurrent+12]=this.cb_reporte
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.em_hasta
this.Control[iCurrent+15]=this.em_desde
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.uo_fecha
this.Control[iCurrent+18]=this.dw_report
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.cb_equipos
end on

on w_ma901_mntto_proyectado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.cbx_1)
destroy(this.sle_origen)
destroy(this.st_3)
destroy(this.rb_1)
destroy(this.uo_fecha_inicial)
destroy(this.cb_impresion)
destroy(this.sle_und)
destroy(this.rb_articulos)
destroy(this.rb_labores)
destroy(this.cb_generar)
destroy(this.cb_reporte)
destroy(this.st_2)
destroy(this.em_hasta)
destroy(this.em_desde)
destroy(this.st_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.cb_equipos)
end on

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.object.usuario_t.text = 'Usuario : ' + trim(gs_user)
idw_1.Object.Datawindow.Print.Orientation = 1
idw_1.Object.Datawindow.Print.Paper.Size = 9
THIS.Event ue_preview()

sle_origen.text = gs_origen

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

ii_help = 101           // help topic
end event

event ue_retrieve;call super::ue_retrieve;Integer 	li_ok, li_i
string	ls_mensaje, ls_cod_proceso, ls_und
date		ld_fecha1, ld_fecha2, ld_fecha_inicial
decimal	ldc_hora1, ldc_hora2

ld_fecha1 	= uo_fecha.of_get_fecha1( )
ld_fecha2 	= uo_fecha.of_get_fecha2( )
ld_fecha_inicial = uo_fecha_inicial.of_get_fecha( )

if ld_fecha2 < ld_fecha1 then
	MessageBox('Aviso', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

ldc_hora1 = Dec(em_desde.text)
ldc_hora2 = Dec(em_hasta.text)

if ldc_hora2 < ldc_hora1 or (ldc_hora2 = 0.00 and ldc_hora2 = 0.00) then
	MessageBox('Aviso', 'RANGO DE HORAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

ls_und = sle_und.text

if IsNull(ls_und) or ls_und = '' then
	MessageBox('Aviso', 'FALTA CÓDIGO DE UNIDAD, POR FAVOR VERIFIQUE', StopSign!)
	return
end if


ls_cod_proceso = trim(gs_origen) + '11'

//create or replace procedure usp_mt_mantto_proyectado (
//       ani_und_inicio       in  number,
//       ani_und_fin          in  number,
//       adi_fecha_inicio     in  date,
//       adi_fecha_fin        in  date,
//       adi_fecha_arranque   in  date,
//       asi_cod_proceso      in  oper_procesos.cod_proceso%TYPE,
//       asi_und              in  unidad.und%TYPE,
//  	   aso_mensaje          out varchar2,
//       aio_ok               out number
//
//) is


DECLARE USP_MT_MANTTO_PROYECTADO PROCEDURE FOR
	USP_MT_MANTTO_PROYECTADO( 	:ldc_hora1,
										:ldc_hora2,
										:ld_fecha1,
										:ld_fecha2,
										:ld_fecha_inicial,
										:ls_cod_proceso,
										:ls_und);

EXECUTE USP_MT_MANTTO_PROYECTADO;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_MT_MANTTO_PROYECTADO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_MT_MANTTO_PROYECTADO INTO :ls_mensaje, :li_ok;
	
CLOSE USP_MT_MANTTO_PROYECTADO;

if li_ok <> 1 then
	MessageBox('Error PROCEDURE USP_MT_MANTTO_PROYECTADO', ls_mensaje, StopSign!)	
	return
end if

idw_1.Retrieve()
idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.object.usuario_t.text 	= 'Usuario : ' + trim(gs_user)
idw_1.Object.Datawindow.Print.Orientation = 1
idw_1.Object.Datawindow.Print.Paper.Size = 9

idw_1.Object.subtitulo_t.text = 'Del: ' + string(ld_fecha1, 'dd/mm/yyyy') &
		+ ' al ' + string(ld_fecha2, 'dd/mm/yyyy')
		
idw_1.Object.subtitulo2_t.text = 'Del: ' + string(ldc_hora1) &
		+ ' al ' + string(ldc_hora2) + ' ' + ls_und

idw_1.Object.subtitulo3_t.text = 'Cantidad de Registros: ' + string(idw_1.RowCount())

if rb_labores.checked = true then
	if idw_1.RowCount() > 0 then
		cb_generar.enabled = true
	else
		cb_generar.enabled = false
	end if
elseif rb_articulos.checked = true then
	cb_generar.enabled = false
end if

for li_i =1 to idw_1.RowCount() 
	idw_1.object.imprimir [li_i] = '1' // Por defecto todas las OT se imprimen
next
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type rb_2 from radiobutton within w_ma901_mntto_proyectado
integer x = 2112
integer y = 120
integer width = 576
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Servicios Proyectados"
end type

event clicked;if this.checked = true then
	parent.event dynamic ue_servicios_proyect()
end if
end event

type cbx_1 from checkbox within w_ma901_mntto_proyectado
integer x = 585
integer y = 236
integer width = 1289
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar los Equipos de todos los origenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_origen.enabled = false
else
	sle_origen.enabled = true
end if
end event

type sle_origen from singlelineedit within w_ma901_mntto_proyectado
event ue_dblclick pbm_lbuttondblclk
integer x = 338
integer y = 240
integer width = 219
integer height = 76
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\Cur\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
	    + "nombre AS DESCRIPCION_origen " &
		 + "FROM origen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text	= ls_codigo
end if

end event

type st_3 from statictext within w_ma901_mntto_proyectado
integer x = 114
integer y = 244
integer width = 215
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_ma901_mntto_proyectado
integer x = 3237
integer y = 48
integer width = 553
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mat/Ins. Generados"
end type

event clicked;if this.checked = true then
	parent.event dynamic ue_articulos_generados()
end if
end event

type uo_fecha_inicial from u_ingreso_fecha within w_ma901_mntto_proyectado
integer x = 1431
integer y = 128
integer taborder = 70
end type

event constructor;call super::constructor;of_set_label('Inicio:') // para seatear el titulo del boton
of_set_fecha(Today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_fecha_inicial.destroy
call u_ingreso_fecha::destroy
end on

type cb_impresion from commandbutton within w_ma901_mntto_proyectado
integer x = 3090
integer y = 236
integer width = 517
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Imp. Masiva de OT~'s"
end type

event clicked;SetPointer(HourGlass!)
parent.event dynamic ue_impresion()
SetPointer(Arrow!)
end event

type sle_und from singlelineedit within w_ma901_mntto_proyectado
event dobleclick pbm_lbuttondblclk
integer x = 1225
integer y = 136
integer width = 192
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT UND AS CODIGO, " &
		  + "DESC_UNIDAD AS DESCRIPCION " &
		  + "FROM UNIDAD " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type rb_articulos from radiobutton within w_ma901_mntto_proyectado
integer x = 2683
integer y = 48
integer width = 553
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mat/Ins. Proyectados"
end type

event clicked;if this.checked = true then
	parent.event dynamic ue_articulos_proyect()
end if
end event

type rb_labores from radiobutton within w_ma901_mntto_proyectado
integer x = 2112
integer y = 48
integer width = 576
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Labores Proyectados"
boolean checked = true
end type

event clicked;if this.checked = true then
	parent.event dynamic ue_labores()
end if
end event

type cb_generar from commandbutton within w_ma901_mntto_proyectado
integer x = 2747
integer y = 236
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Generar"
end type

event clicked;SetPointer(HourGlass!)
parent.event dynamic ue_generar()
SetPointer(Arrow!)
end event

type cb_reporte from commandbutton within w_ma901_mntto_proyectado
integer x = 2405
integer y = 236
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;SetPointer(HourGlass!)
parent.event dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type st_2 from statictext within w_ma901_mntto_proyectado
integer x = 32
integer y = 140
integer width = 425
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango Und"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_hasta from editmask within w_ma901_mntto_proyectado
integer x = 855
integer y = 136
integer width = 366
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "###,###.000"
boolean spin = true
double increment = 1
end type

type em_desde from editmask within w_ma901_mntto_proyectado
integer x = 489
integer y = 144
integer width = 366
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "###,###.000"
boolean spin = true
double increment = 1
end type

type st_1 from statictext within w_ma901_mntto_proyectado
integer x = 32
integer y = 44
integer width = 425
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango Fechas"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas within w_ma901_mntto_proyectado
integer x = 489
integer y = 32
integer taborder = 40
end type

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999')) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
	+ '/' + string(li_ano, '0000') )

ld_fecha2 = RelativeDate( ld_fecha2, -1 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_ma901_mntto_proyectado
integer y = 348
integer width = 3502
integer height = 1360
string dataobject = "d_rpt_mantto_proyectado_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;string 	ls_flag_generar, ls_nro_ot, ls_tipo_ciclo
decimal 	ldc_reprog, ldc_prom_dia, ldc_ult_mtto, ldc_frecuencia, &
			ldc_prox_mtto
Integer 	li_dias
date		ld_fec_ult_mtto, ld_fec_prox_mtto

//this.AcceptText()

if row <= 0 then
	return
end if

ii_update = 1

choose case lower(dwo.name)
	case "reprog"
		ls_flag_generar 	= this.object.flag_generar	[row]
		ls_nro_ot			= this.object.nro_ot			[row]
		
		if Not IsNull(ls_nro_ot) and ls_nro_ot <> '' then
			MessageBox('Aviso', 'El item ya tiene una orden de trabajo generada, ' &
				+ 'no puede reprogramar', StopSign!)
			return 1
		end if
		
		if  ls_flag_generar = '1' then
			if MessageBox('Aviso', 'Si va reprograma esta labor, ' &
				+ 'Desea aun generar la Orden de Trabajo??', Information!, &
				YesNo!, 1) = 2 then
				
				this.object.flag_generar[row] = '0'
				
			end if
		end if
		
		ls_tipo_ciclo = this.object.flag_tipo_ciclo [row]
		ld_fec_ult_mtto = Date(this.object.fec_ult_mantto[row])

		
		if ls_tipo_ciclo = 'F' then	//Ciclo x funcionamiento
		
			ldc_reprog 		= dec(data)
			ldc_frecuencia = this.object.frecuencia[row]
			ldc_ult_mtto	= this.object.ult_mantto[row]
			ldc_prox_mtto 	= ldc_ult_mtto + ldc_frecuencia + ldc_reprog
			ldc_prom_dia 	= this.object.prom_dia	[row]
			
			li_dias			= Int((ldc_ult_mtto - ldc_prox_mtto)/ldc_prom_dia)
			
			ld_fec_prox_mtto = RelativeDate(ld_fec_ult_mtto, li_dias)
			
			this.object.prox_mantto		[row] = ldc_prox_mtto
			this.object.fec_prox_mantto[row] = ld_fec_prox_mtto
			
		elseif ls_tipo_ciclo = 'C' then	//Ciclo x dias calendario
			
			li_dias = Integer(data)
			ld_fec_prox_mtto = RelativeDate(ld_fec_ult_mtto, li_dias)
			ldc_prox_mtto = 0
			
			this.object.prox_mantto		[row] = ldc_prox_mtto
			this.object.fec_prox_mantto[row] = ld_fec_prox_mtto
			
		end if
		
		
end choose
end event

type gb_1 from groupbox within w_ma901_mntto_proyectado
integer x = 2043
integer y = 4
integer width = 1778
integer height = 216
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type cb_equipos from commandbutton within w_ma901_mntto_proyectado
integer x = 2062
integer y = 236
integer width = 343
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Equipos"
end type

event clicked;string ls_origen, ls_und
sg_parametros sl_param

ls_und = sle_und.text

if ls_und = '' or IsNull(ls_und) then
	MessageBox('Aviso', 'Debe indicar una unidad')
	return
end if

if cbx_1.checked then
	ls_origen = '%%'
else
	if sle_origen.text = '' then
		MessageBox('Aviso', 'Debe especificar un origen para mostrar los equipos')
		return
	end if
	ls_origen = trim(sle_origen.text) + '%'
end if

// Asigna valores a structura 
sl_param.dw1 = "d_list_equipos_mantto_grid"	
sl_param.tipo = '1S'	
sl_param.titulo = "Lista de Equipos"
sl_param.opcion = 4
sl_param.string1 = ls_origen

OpenWithParm( w_abc_seleccion, sl_param)

end event

