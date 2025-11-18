$PBExportHeader$w_saldo_cnta_cte.srw
forward
global type w_saldo_cnta_cte from w_report_smpl
end type
type cb_1 from commandbutton within w_saldo_cnta_cte
end type
type uo_1 from u_ingreso_fecha within w_saldo_cnta_cte
end type
type gb_2 from groupbox within w_saldo_cnta_cte
end type
end forward

global type w_saldo_cnta_cte from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Contabilidad  -  Balance de Comprobación (CN712)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
uo_1 uo_1
gb_2 gb_2
end type
global w_saldo_cnta_cte w_saldo_cnta_cte

on w_saldo_cnta_cte.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.uo_1=create uo_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.gb_2
end on

on w_saldo_cnta_cte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;DateTime ldt_fecha

ldt_fecha = DateTime(uo_1.of_get_fecha())

DECLARE pb_usp_cnt_saldo_cnta_cte PROCEDURE FOR usp_cnt_saldo_cnta_cte
        ( :ldt_fecha) ;
Execute pb_usp_cnt_saldo_cnta_cte ;

IF sqlca.sqlcode = -1 THEN
	MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	RollBack ;
	Return
END IF

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_texto.text = 'AL '+String(ldt_fecha,'dd/mm/yyyy')
end event

type dw_report from w_report_smpl`dw_report within w_saldo_cnta_cte
integer x = 27
integer y = 228
integer width = 3291
integer height = 1112
integer taborder = 70
string dataobject = "d_rpt_saldo_cnta_cte"
end type

type cb_1 from commandbutton within w_saldo_cnta_cte
integer x = 736
integer y = 92
integer width = 265
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type uo_1 from u_ingreso_fecha within w_saldo_cnta_cte
integer x = 59
integer y = 92
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Fecha:') // para seatear el titulo del boton
 of_set_fecha(today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha()  para leer las fechas
end event

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

type gb_2 from groupbox within w_saldo_cnta_cte
integer x = 23
integer y = 20
integer width = 681
integer height = 188
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Seleccione "
end type

