$PBExportHeader$w_pr720_costo_produccion.srw
forward
global type w_pr720_costo_produccion from w_rpt
end type
type st_4 from statictext within w_pr720_costo_produccion
end type
type ddlb_encab from dropdownlistbox within w_pr720_costo_produccion
end type
type cb_2 from commandbutton within w_pr720_costo_produccion
end type
type st_3 from statictext within w_pr720_costo_produccion
end type
type st_2 from statictext within w_pr720_costo_produccion
end type
type st_1 from statictext within w_pr720_costo_produccion
end type
type sle_aprobador from singlelineedit within w_pr720_costo_produccion
end type
type st_plantilla from statictext within w_pr720_costo_produccion
end type
type cb_1 from commandbutton within w_pr720_costo_produccion
end type
type sle_plantilla from singlelineedit within w_pr720_costo_produccion
end type
type uo_fecha from u_ingreso_rango_fechas within w_pr720_costo_produccion
end type
type dw_report from u_dw_rpt within w_pr720_costo_produccion
end type
type gb_4 from groupbox within w_pr720_costo_produccion
end type
end forward

global type w_pr720_costo_produccion from w_rpt
integer width = 3694
integer height = 2008
string title = "Costo de Produccion(PR720)"
string menuname = "m_reporte"
long backcolor = 67108864
boolean clientedge = true
st_4 st_4
ddlb_encab ddlb_encab
cb_2 cb_2
st_3 st_3
st_2 st_2
st_1 st_1
sle_aprobador sle_aprobador
st_plantilla st_plantilla
cb_1 cb_1
sle_plantilla sle_plantilla
uo_fecha uo_fecha
dw_report dw_report
gb_4 gb_4
end type
global w_pr720_costo_produccion w_pr720_costo_produccion

forward prototypes
public function integer of_costo_comedor (string as_plantilla, long al_item)
public function integer of_costo_materiales (string as_plantilla, long al_item)
public function integer of_costo_servicios (string as_plantilla, long al_item)
public function integer of_costo_gd (string as_plantilla, long al_item)
public function integer of_costo_personal (string as_plantilla, long al_item)
public function integer of_costo_elect (string as_plantilla)
public function integer of_costo_transporte (string as_plantilla, long al_item)
end prototypes

public function integer of_costo_comedor (string as_plantilla, long al_item);string 	ls_mensaje
Date		ld_fecha1, ld_fecha2

//create or replace procedure USP_PROD_DET_COSTO_COMEDOR(
//       asi_plantilla IN plantilla_costo.cod_plantilla%TYPE,
//       ani_nro_item  IN plantilla_costo_det.nro_item%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE
//) IS

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()

DECLARE 	USP_PROD_DET_COSTO_COMEDOR PROCEDURE FOR
			USP_PROD_DET_COSTO_COMEDOR( :as_plantilla,
												 :al_item,
												 :ld_fecha1,
												 :ld_fecha2 );

EXECUTE 	USP_PROD_DET_COSTO_COMEDOR;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_DET_COSTO_COMEDOR: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_PROD_DET_COSTO_COMEDOR;

return 1

end function

public function integer of_costo_materiales (string as_plantilla, long al_item);string 	ls_mensaje
Date		ld_fecha1, ld_fecha2

//create or replace procedure USP_PROD_DET_COSTO_MAT(
//       asi_plantilla IN plantilla_costo.cod_plantilla%TYPE,
//       ani_nro_item  IN plantilla_costo_det.nro_item%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE
//) IS

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()

DECLARE 	USP_PROD_DET_COSTO_MAT PROCEDURE FOR
			USP_PROD_DET_COSTO_MAT( :as_plantilla,
											:al_item,
											:ld_fecha1,
											:ld_fecha2 );

EXECUTE 	USP_PROD_DET_COSTO_MAT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_DET_COSTO_MAT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_PROD_DET_COSTO_MAT;

return 1
end function

public function integer of_costo_servicios (string as_plantilla, long al_item);string 	ls_mensaje
Date		ld_fecha1, ld_fecha2

//create or replace procedure USP_PROD_DET_COSTO_SERV(
//       asi_plantilla IN plantilla_costo.cod_plantilla%TYPE,
//       ani_nro_item  IN plantilla_costo_det.nro_item%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE
//) IS

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()

DECLARE 	USP_PROD_DET_COSTO_SERV PROCEDURE FOR
			USP_PROD_DET_COSTO_SERV( :as_plantilla,
											:al_item,
											:ld_fecha1,
											:ld_fecha2 );

EXECUTE 	USP_PROD_DET_COSTO_SERV;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_DET_COSTO_SERV: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_PROD_DET_COSTO_SERV;

return 1
end function

public function integer of_costo_gd (string as_plantilla, long al_item);string 	ls_mensaje
Date		ld_fecha1, ld_fecha2

//create or replace procedure USP_PROD_DET_COSTO_GD(
//       asi_plantilla IN plantilla_costo.cod_plantilla%TYPE,
//       ani_nro_item  IN plantilla_costo_det.nro_item%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE
//) IS

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()

DECLARE 	USP_PROD_DET_COSTO_GD PROCEDURE FOR
			USP_PROD_DET_COSTO_GD( :as_plantilla,
											:al_item,
											:ld_fecha1,
											:ld_fecha2 );

EXECUTE 	USP_PROD_DET_COSTO_GD;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_DET_COSTO_GD: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_PROD_DET_COSTO_GD;

return 1
end function

public function integer of_costo_personal (string as_plantilla, long al_item);string 	ls_mensaje
Date		ld_fecha1, ld_fecha2

//create or replace procedure USP_PROD_DET_COSTO_PERSONAL(
//       asi_plantilla IN plantilla_costo.cod_plantilla%TYPE,
//       ani_nro_item  IN plantilla_costo_det.nro_item%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE
//) IS

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()

DECLARE 	USP_PROD_DET_COSTO_PERSONAL PROCEDURE FOR
			USP_PROD_DET_COSTO_PERSONAL( :as_plantilla,
											:al_item,
											:ld_fecha1,
											:ld_fecha2 );

EXECUTE 	USP_PROD_DET_COSTO_PERSONAL;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_DET_COSTO_PERSONAL: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_PROD_DET_COSTO_PERSONAL;

return 1
end function

public function integer of_costo_elect (string as_plantilla);string 	ls_mensaje
Date		ld_fecha1, ld_fecha2

//create or replace procedure USP_PROD_DET_COSTO_ELECT(
//       asi_plantilla IN plantilla_costo.cod_plantilla%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE
//) IS

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()

DECLARE 	USP_PROD_DET_COSTO_ELECT PROCEDURE FOR
			USP_PROD_DET_COSTO_ELECT( :as_plantilla,
											:ld_fecha1,
											:ld_fecha2 );

EXECUTE 	USP_PROD_DET_COSTO_ELECT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_DET_COSTO_ELECT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_PROD_DET_COSTO_ELECT;

return 1
end function

public function integer of_costo_transporte (string as_plantilla, long al_item);string 	ls_mensaje
Date		ld_fecha1, ld_fecha2

//create or replace procedure USP_PROD_DET_COSTO_TRANSP(
//       asi_plantilla IN plantilla_costo.cod_plantilla%TYPE,
//       ani_nro_item  IN plantilla_costo_det.nro_item%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE
//) IS

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()

DECLARE 	USP_PROD_DET_COSTO_TRANSP PROCEDURE FOR
			USP_PROD_DET_COSTO_TRANSP( :as_plantilla,
												 :al_item,
												 :ld_fecha1,
												 :ld_fecha2 );

EXECUTE 	USP_PROD_DET_COSTO_TRANSP;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_DET_COSTO_TRANSP: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_PROD_DET_COSTO_TRANSP;

return 1

end function

on w_pr720_costo_produccion.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_4=create st_4
this.ddlb_encab=create ddlb_encab
this.cb_2=create cb_2
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_aprobador=create sle_aprobador
this.st_plantilla=create st_plantilla
this.cb_1=create cb_1
this.sle_plantilla=create sle_plantilla
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.ddlb_encab
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_aprobador
this.Control[iCurrent+8]=this.st_plantilla
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.sle_plantilla
this.Control[iCurrent+11]=this.uo_fecha
this.Control[iCurrent+12]=this.dw_report
this.Control[iCurrent+13]=this.gb_4
end on

on w_pr720_costo_produccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_4)
destroy(this.ddlb_encab)
destroy(this.cb_2)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_aprobador)
destroy(this.st_plantilla)
destroy(this.cb_1)
destroy(this.sle_plantilla)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.gb_4)
end on

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
ddlb_encab.text='0'
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;date 		ld_fecha1, ld_fecha2
string	ls_aprobador, ls_plantilla, ls_origen, &
			ls_mensaje, ls_cabecera
Decimal	ldc_cambio

ls_plantilla = sle_plantilla.text
ls_aprobador = sle_aprobador.text
ld_fecha1 	 = uo_fecha.of_get_fecha1( )
ld_fecha2	 = uo_fecha.of_get_fecha2( )
ls_cabecera  = left(ddlb_encab.text, 1)

if ls_cabecera = '' then
	MessageBox('Aviso', 'Debe Seleccionar una cabecera')
	return
end if

if ls_cabecera = '0' then
	idw_1.dataobject = 'd_rpt_costo_prod_sin_cabec'
elseif ls_cabecera = '1' then
	idw_1.dataobject = 'd_rpt_costo_prod_cmp_hp'
elseif ls_cabecera = '2' then
	idw_1.dataobject = 'd_rpt_costo_prod_cmp_cong'
end if

idw_1.SetTransObject(SQLCA)
ib_preview = false
event ue_preview()
idw_1.ii_zoom_actual = 100
idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))

//create or replace procedure USP_PROD_RPT_COSTO_HP(
//       asi_plantilla  IN plantilla_costo.cod_plantilla%TYPE,
//       adi_fecha1     IN DATE,
//       adi_fecha2     IN DATE,
//       asi_encabezado IN VARCHAR2
//) is

DECLARE USP_PROD_RPT_COSTO_HP PROCEDURE FOR
	USP_PROD_RPT_COSTO_HP( :ls_plantilla,
							  	  :ld_fecha1,
							  	  :ld_fecha2,
								  :ls_cabecera);

EXECUTE USP_PROD_RPT_COSTO_HP;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_RPT_COSTO_HP:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return
END IF

CLOSE USP_PROD_RPT_COSTO_HP;

select VTA_DOL_PROM
	into:ldc_cambio
from calendario
where trunc(fecha) = trunc(:ld_fecha2);

select o.nombre
  into :ls_origen
  from origen o,
  		 tg_plantas tp,
		 plantilla_costo pc
where o.cod_origen = tp.cod_origen
  and pc.cod_planta = tp.cod_planta
  and pc.cod_plantilla = :ls_plantilla;

idw_1.Retrieve(ls_plantilla, ld_fecha1, ld_fecha2)
idw_1.Visible = True
idw_1.Object.p_logo.filename 		= gs_logo
idw_1.Object.t_empresa.text		= gs_empresa
idw_1.Object.t_desde.text			= string(ld_fecha1, 'dd/mm/yyyy')
idw_1.Object.t_hasta.text			= string(ld_fecha2, 'dd/mm/yyyy')
idw_1.Object.t_aprobado_por.text	= ls_aprobador
idw_1.Object.t_tipo_cambio.text	= string(ldc_cambio, '###,##0.0000')
idw_1.Object.t_titulo1.text		= st_plantilla.text
idw_1.Object.t_titulo2.text		= 'U.O. ' + ls_origen

idw_1.object.Datawindow.Print.Orientation = 2



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

type st_4 from statictext within w_pr720_costo_produccion
integer x = 1728
integer y = 220
integer width = 315
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Encabezado:"
boolean focusrectangle = false
end type

type ddlb_encab from dropdownlistbox within w_pr720_costo_produccion
integer x = 2057
integer y = 204
integer width = 526
integer height = 352
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"0 - Sin Cabecera","1 - Formato PPTT 01","2 - Formato PPTT 02"}
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_pr720_costo_produccion
integer x = 2597
integer y = 200
integer width = 462
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type st_3 from statictext within w_pr720_costo_produccion
integer x = 160
integer y = 196
integer width = 256
integer height = 108
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Rango de Fechas"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pr720_costo_produccion
integer x = 2249
integer y = 108
integer width = 370
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Aprobado Por:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pr720_costo_produccion
integer x = 160
integer y = 80
integer width = 256
integer height = 112
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Plantilla Costo"
boolean focusrectangle = false
end type

type sle_aprobador from singlelineedit within w_pr720_costo_produccion
integer x = 2674
integer y = 92
integer width = 384
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_plantilla from statictext within w_pr720_costo_produccion
integer x = 914
integer y = 92
integer width = 1248
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pr720_costo_produccion
integer x = 800
integer y = 92
integer width = 110
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo

ls_sql = "SELECT cod_plantilla AS CODIGO_plantilla, " &
		  + "observaciones AS DESCRIPCION_plantilla " &
		  + "FROM plantilla_costo " &
		  + "where flag_estado = '1' " 
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_plantilla.text = ls_codigo
	st_plantilla.text = ls_data
end if
		

end event

type sle_plantilla from singlelineedit within w_pr720_costo_produccion
integer x = 421
integer y = 92
integer width = 375
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_data, ls_desc

ls_data = this.text

select observaciones
	into:ls_desc
	from plantilla_costo
where cod_plantilla = :ls_data;

st_plantilla.text = ls_desc
end event

type uo_fecha from u_ingreso_rango_fechas within w_pr720_costo_produccion
integer x = 421
integer y = 204
integer taborder = 20
end type

event constructor;call super::constructor; of_set_label('Del:','Al:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 
 of_get_fecha1()
 of_get_fecha2()
 



end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_pr720_costo_produccion
event ue_display ( string as_columna,  long al_row )
integer x = 14
integer y = 352
integer width = 3598
integer height = 1180
string dataobject = "d_rpt_costo_prod_sin_cabec"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_labor"
		ls_sql = "SELECT cod_labor AS CODIGO_labor, " &
				  + "desc_labor AS DESCRIPCION_labor " &
				  + "FROM labor " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.labor			[al_row] = ls_codigo
			this.object.desc_labor	[al_row] = ls_data
		end if
		
		return
end choose
end event

event doubleclicked;call super::doubleclicked;if row= 0 then return

string 	ls_plantilla, ls_flag_tipo_flota, ls_flag_tipo_nave, &
			ls_flag_mat_servicios, ls_flag_comedores, &
			ls_flag_transporte, ls_flag_gastos_drctos, &
			ls_flag_energia_electrica, ls_flag_personal, &
			ls_mensaje, ls_fecha
Long		ll_nro_item, ll_rc
Date		ld_fecha1, ld_fecha2
str_parametros 		lstr_param
w_rpt_general 		lw_1

ld_fecha1 = uo_fecha.of_get_fecha1( )
ld_fecha2 = uo_fecha.of_get_fecha2( )

ls_plantilla = this.object.cod_plantilla [row]
ll_nro_item	 = Long(this.object.nro_item [row])

SELECT p.flag_tipo_flota,
		 p.flag_tipo_nave,
		 p.flag_energia_electrica,
		 p.flag_transporte,
		 NVL(p.flag_comedores, '0'),
		 NVL(p.flag_gastos_drctos, '0'),
		 p.flag_mat_servicios,
		 p.flag_personal
 into :ls_flag_tipo_flota, 
 	   :ls_flag_tipo_nave, 
 		:ls_flag_energia_electrica, 
		:ls_flag_transporte,
		:ls_flag_comedores, 
		:ls_flag_gastos_drctos, 
		:ls_flag_mat_servicios,
		:ls_flag_personal
 FROM plantilla_costo_det p
WHERE p.cod_plantilla = :ls_plantilla
  and p.nro_item		 = :ll_nro_item
  AND p.flag_estado = '1';

if SQLCA.SQLCode = -1 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error al recuperar Datos', ls_mensaje, Exclamation!)
	return
end if

if SQLCA.SQLCode = 100 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', 'Registro de Busqueda no encontrado, por favor verifique', Exclamation!)
	return
end if

SetPointer(HOURGLASS!)

IF Not IsNull(ls_flag_tipo_flota) OR &
	Not IsNull(ls_flag_tipo_nave) THEN

	//USP_PROD_RPT_COSTO_FLOTA(asi_plantilla, lc_reg.nro_item, ln_cant_pptt, adi_fecha1, adi_fecha2);
ELSEIF ls_flag_mat_servicios = 'M' THEN

	ll_rc = of_costo_materiales (ls_plantilla, ll_nro_item)
	if ll_rc = 1 then
		lstr_param.dw1 	   = 'd_rpt_detalle_materiales_tbl'
		lstr_param.titulo3   = 'Detalle de Consumo de Materiales'
		lstr_param.titulo    = 'Detalle de Consumo de Materiales (w_rpt_general)'
		lstr_param.campo	   = 'cod_art'
		lstr_param.detalle   = '1'
		lstr_param.fecha[1]  = ld_fecha1
		lstr_param.fecha[2]  = ld_fecha2
		lstr_param.plantilla = ls_plantilla
		lstr_param.nro_item  = ll_nro_item
	end if

ELSEIF ls_flag_mat_servicios = 'S' THEN

	ll_rc = of_costo_servicios (ls_plantilla, ll_nro_item)
	if ll_rc = 1 then
		lstr_param.dw1 	   = 'd_rpt_detalle_servicios_tbl'
		lstr_param.titulo3   = 'Detalle de Consumo de Servicios'
		lstr_param.titulo    = 'Detalle de Consumo de Servicios (w_rpt_general)'
		lstr_param.campo	   = 'servicio'
		lstr_param.detalle   = '1'
		lstr_param.fecha[1]  = ld_fecha1
		lstr_param.fecha[2]  = ld_fecha2
		lstr_param.plantilla = ls_plantilla
		lstr_param.nro_item  = ll_nro_item
	end if

ELSEIF ls_flag_comedores <> '0' THEN
	
	ll_rc = of_costo_comedor(ls_plantilla, ll_nro_item)
	if ll_rc = 1 then
		lstr_param.dw1 = 'd_rpt_detalle_costo_comedores_tbl'
		lstr_param.titulo3 = 'Detalle de Costos de Comedores'
		lstr_param.titulo = 'Detalle de Costos de Comedores (w_rpt_general)'
	end if

ELSEIF ls_flag_transporte <> '0' THEN

	ll_rc = of_costo_transporte(ls_plantilla, ll_nro_item)
	if ll_rc = 1 then
		lstr_param.dw1 = 'd_rpt_detalle_costo_transporte_tbl'
		lstr_param.titulo3 = 'Detalle de Costos de Transporte'
		lstr_param.titulo = 'Detalle de Costos de Transporte (w_rpt_general)'
	end if

ELSEIF ls_flag_gastos_drctos <> '0' THEN

	ll_rc = of_costo_gd(ls_plantilla, ll_nro_item)
	if ll_rc = 1 then
		lstr_param.dw1 = 'd_rpt_detalle_costo_gd_tbl'
		lstr_param.titulo3 = 'Detalle de Gastos Directos'
		lstr_param.titulo = 'Detalle de Gastos Directos (w_rpt_general)'
	end if

ELSEIF ls_flag_energia_electrica <> '0' THEN
	
	ll_rc = of_costo_elect(ls_plantilla)
	if ll_rc = 1 then
		lstr_param.dw1 = 'd_rpt_detalle_costo_elect_tbl'
		lstr_param.titulo3 = 'Detalle de Consumo de Electricidad'
		lstr_param.titulo = 'Detalle de Consumo de Electricidad (w_rpt_general)'
	end if

ELSEIF ls_flag_personal <> '0' THEN
	
	ll_rc = of_costo_personal(ls_plantilla, ll_nro_item)
	if ll_rc = 1 then
		lstr_param.dw1 = 'd_rpt_detalle_costo_personal_tbl'
		lstr_param.titulo3 = 'Detalle de Gastos Directos'
		lstr_param.titulo = 'Detalle de Gastos Directos (w_rpt_general)'
	end if

END IF

SetPointer(Arrow!)

if ll_rc = 1 then
	lstr_param.titulo1 		= this.object.t_titulo1.text
	lstr_param.titulo2 		= this.object.t_titulo2.text
	
	//MessageBox('',string(this.object.t_desde.text) + " " + string(this.object.t_hasta.text))
	
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
end event

type gb_4 from groupbox within w_pr720_costo_produccion
integer x = 27
integer y = 20
integer width = 3095
integer height = 324
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Parámetros "
end type

