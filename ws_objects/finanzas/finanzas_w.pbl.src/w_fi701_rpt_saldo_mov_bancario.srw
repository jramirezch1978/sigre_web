$PBExportHeader$w_fi701_rpt_saldo_mov_bancario.srw
forward
global type w_fi701_rpt_saldo_mov_bancario from w_rpt
end type
type dw_arg from datawindow within w_fi701_rpt_saldo_mov_bancario
end type
type cb_2 from commandbutton within w_fi701_rpt_saldo_mov_bancario
end type
type dw_report from u_dw_rpt within w_fi701_rpt_saldo_mov_bancario
end type
type cb_1 from commandbutton within w_fi701_rpt_saldo_mov_bancario
end type
type gb_1 from groupbox within w_fi701_rpt_saldo_mov_bancario
end type
end forward

global type w_fi701_rpt_saldo_mov_bancario from w_rpt
integer width = 3589
integer height = 1364
string title = "Reporte de Saldo de Mov. Bancario (FI701)"
string menuname = "m_reporte"
dw_arg dw_arg
cb_2 cb_2
dw_report dw_report
cb_1 cb_1
gb_1 gb_1
end type
global w_fi701_rpt_saldo_mov_bancario w_fi701_rpt_saldo_mov_bancario

on w_fi701_rpt_saldo_mov_bancario.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_arg=create dw_arg
this.cb_2=create cb_2
this.dw_report=create dw_report
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_arg
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.gb_1
end on

on w_fi701_rpt_saldo_mov_bancario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_arg)
destroy(this.cb_2)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()


// ii_help = 101           // help topic


end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type dw_arg from datawindow within w_fi701_rpt_saldo_mov_bancario
integer x = 69
integer y = 108
integer width = 763
integer height = 188
integer taborder = 20
string title = "none"
string dataobject = "d_ext_fechas_tbl"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Accepttext()
end event

event constructor;Insertrow(0)
end event

event doubleclicked;Datawindow		 ldw	
str_seleccionar lstr_seleccionar



CHOOSE CASE dwo.name
		 CASE 'ad_fecha_inicio'
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)		
		 CASE 'ad_fecha_final'				
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)					
							
END CHOOSE


end event

type cb_2 from commandbutton within w_fi701_rpt_saldo_mov_bancario
integer x = 3049
integer y = 40
integer width = 471
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cuentas de Bancos"
end type

event clicked;Long ll_count
str_parametros sl_param 

Rollback ;

sl_param.dw1		= 'd_abc_cnta_bco_help_rpt_tbl'
sl_param.titulo	= 'Cuenta de Banco'
sl_param.opcion   = 8
sl_param.db1 		= 1600
sl_param.string1 	= '1RPP'

OpenWithParm( w_abc_seleccion_lista_search, sl_param)
end event

type dw_report from u_dw_rpt within w_fi701_rpt_saldo_mov_bancario
integer x = 18
integer y = 360
integer width = 3511
integer height = 800
integer taborder = 20
string dataobject = "d_rpt_saldo_mov_bancario_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_fi701_rpt_saldo_mov_bancario
integer x = 3049
integer y = 164
integer width = 471
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;String 	ls_mensaje
Date 		ld_fecha_inicio,ld_fecha_final

dw_arg.Accepttext()

ld_fecha_inicio = dw_arg.object.ad_fecha_inicio [1]
ld_fecha_final  = dw_arg.object.ad_fecha_final  [1]

//create or replace procedure USP_FIN_RPT_SALDO_MOV_BANCARIO
//(
//       ad_fecha_inicio in cntbl_asiento_det.fec_cntbl%type,
//       ad_fecha_final  in cntbl_asiento_det.fec_cntbl%TYPE
// )

DECLARE USP_FIN_RPT_SALDO_MOV_BANCARIO PROCEDURE FOR 
	USP_FIN_RPT_SALDO_MOV_BANCARIO(	:ld_fecha_inicio,
												:ld_fecha_final);
EXECUTE USP_FIN_RPT_SALDO_MOV_BANCARIO ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox('Error USP_FIN_RPT_SALDO_MOV_BANCARIO', ls_mensaje)
	Return
END IF

CLOSE USP_FIN_RPT_SALDO_MOV_BANCARIO;

dw_report.Retrieve(String(ld_fecha_inicio,'dd/mm/yyyy'),String(ld_fecha_final,'dd/mm/yyyy'),gs_empresa,gs_user)
dw_report.Object.p_logo.filename = gs_logo


end event

type gb_1 from groupbox within w_fi701_rpt_saldo_mov_bancario
integer x = 37
integer y = 32
integer width = 827
integer height = 300
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

