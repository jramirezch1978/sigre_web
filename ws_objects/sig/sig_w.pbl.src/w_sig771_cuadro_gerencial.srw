$PBExportHeader$w_sig771_cuadro_gerencial.srw
forward
global type w_sig771_cuadro_gerencial from w_rpt
end type
type rb_2 from radiobutton within w_sig771_cuadro_gerencial
end type
type rb_1 from radiobutton within w_sig771_cuadro_gerencial
end type
type st_2 from statictext within w_sig771_cuadro_gerencial
end type
type sle_mes from singlelineedit within w_sig771_cuadro_gerencial
end type
type sle_year from singlelineedit within w_sig771_cuadro_gerencial
end type
type st_1 from statictext within w_sig771_cuadro_gerencial
end type
type cb_2 from commandbutton within w_sig771_cuadro_gerencial
end type
type uo_fecha from u_ingreso_rango_fechas within w_sig771_cuadro_gerencial
end type
type dw_report from u_dw_rpt within w_sig771_cuadro_gerencial
end type
end forward

global type w_sig771_cuadro_gerencial from w_rpt
integer width = 3785
integer height = 2608
string title = "[SIG771] Cuadro de Mando Gerencial"
string menuname = "m_impresion"
rb_2 rb_2
rb_1 rb_1
st_2 st_2
sle_mes sle_mes
sle_year sle_year
st_1 st_1
cb_2 cb_2
uo_fecha uo_fecha
dw_report dw_report
end type
global w_sig771_cuadro_gerencial w_sig771_cuadro_gerencial

type variables
boolean  ib_retrieve = FALSE
end variables

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

on w_sig771_cuadro_gerencial.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_2=create st_2
this.sle_mes=create sle_mes
this.sle_year=create sle_year
this.st_1=create st_1
this.cb_2=create cb_2
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_mes
this.Control[iCurrent+5]=this.sle_year
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.uo_fecha
this.Control[iCurrent+9]=this.dw_report
end on

on w_sig771_cuadro_gerencial.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_2)
destroy(this.sle_mes)
destroy(this.sle_year)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.uo_fecha)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_open_pre;call super::ue_open_pre;Date 		ld_hoy, ld_fecha1, ld_fecha2, ld_fecha_inicio
Integer 	li_year, li_semana
Long l_Semanas 

ld_hoy = Date(gnvo_app.of_fecha_Actual())

sle_year.text = String(ld_hoy, 'yyyy')
sle_mes.text = String(ld_hoy, 'mm')

idw_1 = dw_report


end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;date 		ld_fecha1, ld_fecha2
string	ls_mensaje, ls_filtro
Long		ll_year, ll_mes

ld_fecha1 	 = uo_fecha.of_get_fecha1( )
ld_fecha2	 = uo_fecha.of_get_fecha2( )

if rb_1.checked then
	ls_filtro = '1'
	ll_year		 = Long(sle_year.text)
	ll_mes		 = Long(sle_mes.text)

else
	ls_filtro = '2'
	ll_year		 = year(ld_fecha1)
	ll_mes		 = Month(ld_fecha2)
	
end if

idw_1.SetTransObject(SQLCA)

ib_preview = false
event ue_preview()
idw_1.ii_zoom_actual = 100
idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))

//if of_procedure1(ld_fecha1, ld_fecha2, ls_prorrateo) = false then return

idw_1.Retrieve(ll_year, ll_mes, ld_fecha1, ld_fecha2, ls_filtro)
ib_retrieve = true
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

type rb_2 from radiobutton within w_sig771_cuadro_gerencial
integer x = 14
integer y = 124
integer width = 690
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtrar por Rango Fechas:"
end type

type rb_1 from radiobutton within w_sig771_cuadro_gerencial
integer x = 23
integer y = 20
integer width = 553
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtrar por Periodo :"
boolean checked = true
end type

type st_2 from statictext within w_sig771_cuadro_gerencial
integer x = 1262
integer y = 20
integer width = 256
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_sig771_cuadro_gerencial
integer x = 1531
integer y = 8
integer width = 146
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_year from singlelineedit within w_sig771_cuadro_gerencial
integer x = 1033
integer y = 8
integer width = 215
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_sig771_cuadro_gerencial
integer x = 709
integer y = 20
integer width = 256
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_sig771_cuadro_gerencial
integer x = 2080
integer y = 28
integer width = 462
integer height = 176
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

type uo_fecha from u_ingreso_rango_fechas within w_sig771_cuadro_gerencial
integer x = 709
integer y = 116
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

type dw_report from u_dw_rpt within w_sig771_cuadro_gerencial
event ue_display ( string as_columna,  long al_row )
integer y = 220
integer width = 3598
integer height = 1536
string dataobject = "d_rpt_cuadro_gerencial_cmp"
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

event doubleclicked;call super::doubleclicked;sg_parametros 	lstr_param
w_rpt_preview	lw_1
if ib_Retrieve = false then return

Open(w_detalle_cg)
if IsNull(Message.PowerObjectParm) or &
	Not IsValid(Message.PowerObjectParm) then return

lstr_param = Message.Powerobjectparm
if lstr_param.titulo = 'n' then return

choose case left(lstr_param.string1,1)
	case '1'
		lstr_param.dw1 = 'd_rpt_cg_cc1_tbl'
		lstr_param.date1 = uo_fecha.of_get_fecha1( )
		lstr_param.date2 = uo_fecha.of_get_fecha2( )
		lstr_param.tipo = ''
		lstr_param.titulo = mid(lstr_param.string1,5)
		OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )

	case '2'
		lstr_param.dw1 = 'd_rpt_cg_cc2_tbl'
		lstr_param.date1 = uo_fecha.of_get_fecha1( )
		lstr_param.date2 = uo_fecha.of_get_fecha2( )
		lstr_param.tipo = ''
		lstr_param.titulo = mid(lstr_param.string1,5)
		OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )

	case '5'
		lstr_param.dw1 = 'd_rpt_cg_cc5_tbl'
		lstr_param.date1 = uo_fecha.of_get_fecha1( )
		lstr_param.date2 = uo_fecha.of_get_fecha2( )
		lstr_param.tipo = ''
		lstr_param.titulo = mid(lstr_param.string1,5)
		OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )
		
	case '6'
		lstr_param.dw1 = 'd_rpt_cg_cc7_tbl'
		lstr_param.date1 = uo_fecha.of_get_fecha2( )
		lstr_param.tipo = ''
		lstr_param.titulo = mid(lstr_param.string1,5)
		OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )
end choose


end event

