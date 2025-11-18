$PBExportHeader$w_sig795_cuadro_integral.srw
forward
global type w_sig795_cuadro_integral from w_rpt
end type
type cbx_1 from checkbox within w_sig795_cuadro_integral
end type
type cb_2 from commandbutton within w_sig795_cuadro_integral
end type
type st_3 from statictext within w_sig795_cuadro_integral
end type
type uo_fecha from u_ingreso_rango_fechas within w_sig795_cuadro_integral
end type
type dw_report from u_dw_rpt within w_sig795_cuadro_integral
end type
end forward

global type w_sig795_cuadro_integral from w_rpt
integer width = 3785
integer height = 2608
string title = "Cuadro de Control Gerencial (SIG795)"
string menuname = "m_rpt_simple"
long backcolor = 67108864
cbx_1 cbx_1
cb_2 cb_2
st_3 st_3
uo_fecha uo_fecha
dw_report dw_report
end type
global w_sig795_cuadro_integral w_sig795_cuadro_integral

forward prototypes
public function boolean of_procedure1 (date ad_fecha1, date ad_fecha2, string as_prorrateo)
end prototypes

public function boolean of_procedure1 (date ad_fecha1, date ad_fecha2, string as_prorrateo);string ls_mensaje

//create or replace procedure USP_CCG_RPT_PROD(
//       adi_fecha1    IN DATE,
//       adi_Fecha2    IN DATE,
//       asi_prorrateo IN VARCHAR2
//) is

DECLARE USP_CCG_RPT_PROD PROCEDURE FOR
	USP_CCG_RPT_PROD( :ad_fecha1,
							  	:ad_fecha2,
								:as_prorrateo);

EXECUTE USP_CCG_RPT_PROD;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_CCG_RPT_PROD:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE USP_CCG_RPT_PROD;


//cntas por cobrar
DECLARE USP_SIGH_RPT_GERENCIAL_COBRAR PROCEDURE FOR
        USP_SIGH_RPT_GERENCIAL_COBRAR(:ad_fecha1,:ad_fecha2);
EXECUTE USP_SIGH_RPT_GERENCIAL_COBRAR ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_SIGH_RPT_GERENCIAL_COBRAR :" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE USP_SIGH_RPT_GERENCIAL_COBRAR ;

//cntas por pagar
DECLARE USP_SIGH_RPT_GERENCIAL_PAGAR PROCEDURE FOR
        USP_SIGH_RPT_GERENCIAL_PAGAR(:ad_fecha1,:ad_fecha2);
EXECUTE USP_SIGH_RPT_GERENCIAL_PAGAR ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_SIGH_RPT_GERENCIAL_PAGAR :" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE USP_SIGH_RPT_GERENCIAL_PAGAR ;

//caja bancos en US
DECLARE USP_SIG_SALDO_BANCARIO_US PROCEDURE FOR
        USP_SIG_SALDO_BANCARIO_US(:ad_fecha1,:ad_fecha2);
EXECUTE USP_SIG_SALDO_BANCARIO_US ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_SIG_SALDO_BANCARIO_US :" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE USP_SIG_SALDO_BANCARIO_US ;



return true

end function

on w_sig795_cuadro_integral.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cbx_1=create cbx_1
this.cb_2=create cb_2
this.st_3=create st_3
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.dw_report
end on

on w_sig795_cuadro_integral.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.cb_2)
destroy(this.st_3)
destroy(this.uo_fecha)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;date 		ld_fecha1, ld_fecha2
string	ls_mensaje, ls_prorrateo

ld_fecha1 	 = uo_fecha.of_get_fecha1( )
ld_fecha2	 = uo_fecha.of_get_fecha2( )

if cbx_1.checked then
	ls_prorrateo = '1'
else
	ls_prorrateo = '0'
end if

idw_1.SetTransObject(SQLCA)
ib_preview = false
event ue_preview()
idw_1.ii_zoom_actual = 100
idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))

if of_procedure1(ld_fecha1, ld_fecha2, ls_prorrateo) = false then return

idw_1.Retrieve()
idw_1.Visible = True
idw_1.Object.p_logo.filename 		= gs_logo
idw_1.Object.t_empresa.text		= gs_empresa
idw_1.Object.t_desde.text			= string(ld_fecha1, 'dd/mm/yyyy')
idw_1.Object.t_hasta.text			= string(ld_fecha2, 'dd/mm/yyyy')

idw_1.object.Datawindow.Print.Orientation = 1



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

type cbx_1 from checkbox within w_sig795_cuadro_integral
integer x = 1655
integer y = 40
integer width = 937
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Proyecciones Prorrateados"
end type

type cb_2 from commandbutton within w_sig795_cuadro_integral
integer x = 3104
integer y = 12
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

type st_3 from statictext within w_sig795_cuadro_integral
integer x = 46
integer y = 16
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

type uo_fecha from u_ingreso_rango_fechas within w_sig795_cuadro_integral
integer x = 338
integer y = 36
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

type dw_report from u_dw_rpt within w_sig795_cuadro_integral
event ue_display ( string as_columna,  long al_row )
integer y = 156
integer width = 3598
integer height = 1180
string dataobject = "d_rpt_cuadro_imtegral_cmp"
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
					 
		//lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.labor			[al_row] = ls_codigo
			this.object.desc_labor	[al_row] = ls_data
		end if
		
		return
end choose
end event

