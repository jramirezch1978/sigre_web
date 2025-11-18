$PBExportHeader$w_rpt_general.srw
forward
global type w_rpt_general from w_rpt
end type
type dw_report from u_dw_rpt within w_rpt_general
end type
end forward

global type w_rpt_general from w_rpt
integer width = 2272
integer height = 1648
string title = ""
string menuname = "m_reporte"
boolean center = true
event ue_copiar ( )
event ue_reset ( )
dw_report dw_report
end type
global w_rpt_general w_rpt_general

type variables
str_parametros istr_param
end variables

forward prototypes
public function integer of_det_mov_almacen (string as_cod_art)
public function integer of_detalle_servicio (string as_servicio)
end prototypes

event ue_reset();idw_1.Reset()
end event

public function integer of_det_mov_almacen (string as_cod_art);string 	ls_mensaje, ls_plantilla
Date		ld_fecha1, ld_fecha2
Long		ll_nro_item

//create or replace procedure USP_PROD_DET_MOV_ALMACEN(
//       asi_plantilla IN plantilla_costo.cod_plantilla%TYPE,
//       ani_nro_item  IN plantilla_costo_det.nro_item%TYPE,
//       asi_cod_art   IN articulo.cod_art%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE
//) IS

ld_fecha1 = istr_param.fecha[1]
ld_fecha2 = istr_param.fecha[2]
ll_nro_item = istr_param.nro_item
ls_plantilla = istr_param.plantilla

DECLARE 	USP_PROD_DET_MOV_ALMACEN PROCEDURE FOR
			USP_PROD_DET_MOV_ALMACEN( :ls_plantilla,
												 :ll_nro_item,
												 :as_cod_art,
												 :ld_fecha1,
												 :ld_fecha2 );

EXECUTE 	USP_PROD_DET_MOV_ALMACEN;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_DET_MOV_ALMACEN: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_PROD_DET_MOV_ALMACEN;

return 1
end function

public function integer of_detalle_servicio (string as_servicio);string 	ls_mensaje, ls_plantilla
Date		ld_fecha1, ld_fecha2
Long		ll_nro_item

//create or replace procedure USP_PROD_DET_SERVICIOS(
//       asi_plantilla IN plantilla_costo.cod_plantilla%TYPE,
//       ani_nro_item  IN plantilla_costo_det.nro_item%TYPE,
//       asi_servicio  IN servicios.servicio%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE
//) IS

ld_fecha1 = istr_param.fecha[1]
ld_fecha2 = istr_param.fecha[2]
ll_nro_item = istr_param.nro_item
ls_plantilla = istr_param.plantilla

DECLARE 	USP_PROD_DET_SERVICIOS PROCEDURE FOR
			USP_PROD_DET_SERVICIOS( :ls_plantilla,
											:ll_nro_item,
											:as_servicio,
											:ld_fecha1,
											:ld_fecha2 );

EXECUTE 	USP_PROD_DET_SERVICIOS;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_DET_SERVICIOS: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_PROD_DET_SERVICIOS;

return 1
end function

on w_rpt_general.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_rpt_general.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

if Not IsNull(Message.Powerobjectparm) and IsValid(Message.PowerObjectParm) &
	and Message.PowerObjectParm.ClassName() = 'str_parametros' then
	
	istr_param = Message.PowerObjectParm
	
	if istr_param.opcion = 1 then
		idw_1.dataObject 						= istr_param.dw1
		idw_1.object.t_titulo1.text		= istr_param.titulo1
		idw_1.object.t_titulo2.text		= istr_param.titulo2
		idw_1.object.t_titulo3.text		= istr_param.titulo3
		idw_1.object.t_desde.text 			= string(istr_param.desde, 'dd/mm/yyyy')
		idw_1.object.t_hasta.text 			= string(istr_param.hasta, 'dd/mm/yyyy')
		idw_1.object.t_tipo_cambio.text	= string(istr_param.tipo_cambio, "###,##0.0000")
		idw_1.object.t_aprobado_por.text	= istr_param.aprobado_por
	end if
	
	this.title = istr_param.titulo
end if

idw_1.Visible = False
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
this.event ue_retrieve( )
end event

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

event ue_retrieve;call super::ue_retrieve;idw_1.ii_zoom_actual = 120

idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))
idw_1.title = "Reporte " + "(Zoom: " + String(idw_1.ii_zoom_actual) + "%)"

idw_1.Retrieve()
idw_1.Visible = True

try 
	idw_1.Object.p_logo.filename = gs_logo
	idw_1.object.t_empresa.text = gs_empresa
catch ( Exception ex )
	
end try


end event

type dw_report from u_dw_rpt within w_rpt_general
integer width = 2066
integer height = 1216
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;if istr_param.detalle <> '1' or row = 0 then return
Long 		ll_rc, ll_nro_item
String 	ls_cod_art, ls_servicio, ls_fecha
str_parametros 	lstr_param
w_rpt_general 	lw_1


if lower(dwo.name) = istr_param.campo then
	
	if istr_param.campo = 'cod_art' then
		
		ls_cod_art = this.object.cod_art[row]
		ll_rc = of_det_mov_almacen (ls_cod_art)
		if ll_rc = 1 then
			lstr_param.dw1 	 = 'd_rpt_detalle_mov_almacen_tbl'
			lstr_param.titulo3 = 'Detalle de Movimiento de Almacen'
			lstr_param.titulo  = 'Detalle de Movimiento de Almacen (w_rpt_general)'
		end if
		
	elseif istr_param.campo = 'servicio' then
		
		ls_servicio = this.object.servicio[row]
		ll_rc = of_detalle_servicio (ls_servicio)
		if ll_rc = 1 then
			lstr_param.dw1 	 = 'd_rpt_detalle_os_tbl'
			lstr_param.titulo3 = 'Detalle de Ordenes de Servicio'
			lstr_param.titulo  = 'Detalle de Ordenes de Servicio (w_rpt_general)'
		end if
		
	end if

	if ll_rc = 1 then
		lstr_param.titulo1 		= this.object.t_titulo1.text
		lstr_param.titulo2 		= this.object.t_titulo2.text

		ls_fecha = String(this.object.t_desde.text)
		ls_fecha = mid(ls_fecha, 7,4) + "/" + mid(ls_fecha, 4,2) + "/" + mid(ls_fecha,1,2)
		lstr_param.desde 	 		= Date(ls_fecha)
	
		ls_fecha = String(this.object.t_hasta.text)
		ls_fecha = mid(ls_fecha, 7,4) + "/" + mid(ls_fecha, 4,2) + "/" + mid(ls_fecha,1,2)
		lstr_param.hasta 	 		= Date(ls_fecha)
	
		lstr_param.tipo_cambio 	= Dec(this.object.t_tipo_cambio.text)

		lstr_param.aprobado_por	= this.object.t_aprobado_por.text
		lstr_param.opcion			= 1
		
		OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered!)
	end if

end if

end event

