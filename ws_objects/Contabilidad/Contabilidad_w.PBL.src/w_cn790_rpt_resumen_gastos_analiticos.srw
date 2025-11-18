$PBExportHeader$w_cn790_rpt_resumen_gastos_analiticos.srw
forward
global type w_cn790_rpt_resumen_gastos_analiticos from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn790_rpt_resumen_gastos_analiticos
end type
type cb_1 from commandbutton within w_cn790_rpt_resumen_gastos_analiticos
end type
type st_4 from statictext within w_cn790_rpt_resumen_gastos_analiticos
end type
type cb_2 from commandbutton within w_cn790_rpt_resumen_gastos_analiticos
end type
type gb_1 from groupbox within w_cn790_rpt_resumen_gastos_analiticos
end type
end forward

global type w_cn790_rpt_resumen_gastos_analiticos from w_report_smpl
integer width = 2551
integer height = 1640
string title = "Resumen de Gastos Analiticos (w_cn790)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
cb_1 cb_1
st_4 st_4
cb_2 cb_2
gb_1 gb_1
end type
global w_cn790_rpt_resumen_gastos_analiticos w_cn790_rpt_resumen_gastos_analiticos

on w_cn790_rpt_resumen_gastos_analiticos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.cb_1=create cb_1
this.st_4=create st_4
this.cb_2=create cb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.gb_1
end on

on w_cn790_rpt_resumen_gastos_analiticos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.cb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Integer li_ano

li_ano       = integer(sle_ano.text)

If isnull(li_ano) or li_ano = 0 then
	MessageBox('Aviso','Debe seleccionar año de proceso')
	Return
End if

SetPointer(hourglass!)
  
DECLARE pb_usp_cnt_com_c9_c6 PROCEDURE FOR usp_cnt_com_c9_c6
        ( :li_ano );
Execute pb_usp_cnt_com_c9_c6;

dw_report.retrieve()

Rollback;


end event

type dw_report from w_report_smpl`dw_report within w_cn790_rpt_resumen_gastos_analiticos
integer x = 18
integer y = 220
integer width = 2487
integer height = 1224
integer taborder = 70
string dataobject = "d_resumen_gastos_analiticos_cr"
end type

type sle_ano from singlelineedit within w_cn790_rpt_resumen_gastos_analiticos
integer x = 219
integer y = 92
integer width = 192
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn790_rpt_resumen_gastos_analiticos
integer x = 507
integer y = 76
integer width = 265
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type st_4 from statictext within w_cn790_rpt_resumen_gastos_analiticos
integer x = 50
integer y = 96
integer width = 155
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_cn790_rpt_resumen_gastos_analiticos
integer x = 2121
integer y = 80
integer width = 370
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Analisis C9-C6"
end type

event clicked;Datastore lds_analisis_cuentas
Integer li_ano

lds_analisis_cuentas = Create DataStore 

lds_analisis_cuentas.dataobject = 'd_tt_analisis_cuenta'

lds_analisis_cuentas.SettransObject( SQLCA )

//-- Declaración de procedimiento
Declare sp_analisis_cuentas Procedure For usp_cnt_dsc_c9_c6( :li_ano );

//-- Ejecución de procedimiento
Execute sp_analisis_cuentas;

lds_analisis_cuentas.Retrieve()

f_print_data( lds_analisis_cuentas, "Cuentas Analizadas Observadas", 3000, 1500)

Rollback;



end event

type gb_1 from groupbox within w_cn790_rpt_resumen_gastos_analiticos
integer x = 18
integer y = 16
integer width = 457
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Periodo Contable "
end type

