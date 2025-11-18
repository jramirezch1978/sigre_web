$PBExportHeader$w_cns_general.srw
forward
global type w_cns_general from w_rpt
end type
type dw_report from u_dw_rpt within w_cns_general
end type
end forward

global type w_cns_general from w_rpt
integer width = 2272
integer height = 1648
string title = ""
string menuname = "m_impresion"
boolean center = true
event ue_copiar ( )
event ue_reset ( )
dw_report dw_report
end type
global w_cns_general w_cns_general

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

on w_cns_general.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_cns_general.destroy
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

if ISNULL( Message.PowerObjectParm ) or NOT IsValid(Message.PowerObjectParm) THEN
	MessageBox('Aviso', 'Parametros enviados estan en blanco', StopSign!)
	return
end if

If Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Aviso', 'Parametros enviados no son del Tipo str_parametros', StopSign!)
	return
end if

istr_param = Message.PowerObjectParm

idw_1.dataObject 						= istr_param.dw1

this.title = istr_param.titulo

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

if istr_param.tipo = '1S1D2S3S' then
	
	idw_1.Retrieve(istr_param.string1, istr_param.fecha1, &
						istr_param.string2, istr_param.string3)

elseif istr_param.tipo = '1S1D2D' then
	
	idw_1.Retrieve(istr_param.string1, istr_param.date1, istr_param.date2)

elseif istr_param.tipo = '1S' then
	
	idw_1.Retrieve(istr_param.string1)
						
elseif istr_param.tipo = '1S1D2S1N' then
	
	idw_1.Retrieve(istr_param.string1, istr_param.fecha1, &
						istr_param.string2, istr_param.decimal1)

elseif istr_param.tipo = '1S1D2S3S1N' then
	
	idw_1.Retrieve(istr_param.string1, istr_param.fecha1, &
						istr_param.string2, istr_param.string3, &
						istr_param.decimal1)

elseif istr_param.tipo = '1S1D2S' then
	
	idw_1.Retrieve(istr_param.string1, istr_param.fecha1, &
						istr_param.string2)

else
	idw_1.Retrieve()
end if

idw_1.Visible = True
idw_1.Object.Datawindow.Print.Orientation = 1

try 
	idw_1.Object.p_logo.filename = gs_logo
	idw_1.object.t_empresa.text = gs_empresa
catch ( Exception ex )
	
end try


end event

type dw_report from u_dw_rpt within w_cns_general
integer width = 2066
integer height = 1216
end type

