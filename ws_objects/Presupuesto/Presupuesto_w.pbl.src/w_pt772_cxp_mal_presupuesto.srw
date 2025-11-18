$PBExportHeader$w_pt772_cxp_mal_presupuesto.srw
$PBExportComments$Control presupuestario por centro de costo
forward
global type w_pt772_cxp_mal_presupuesto from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_pt772_cxp_mal_presupuesto
end type
type cb_10 from commandbutton within w_pt772_cxp_mal_presupuesto
end type
type gb_1 from groupbox within w_pt772_cxp_mal_presupuesto
end type
end forward

global type w_pt772_cxp_mal_presupuesto from w_report_smpl
integer width = 3182
integer height = 2136
string title = "[PT772] Cuentas x Pagar probablemente mal presupuestadas"
string menuname = "m_impresion"
long backcolor = 67108864
uo_fecha uo_fecha
cb_10 cb_10
gb_1 gb_1
end type
global w_pt772_cxp_mal_presupuesto w_pt772_cxp_mal_presupuesto

on w_pt772_cxp_mal_presupuesto.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.cb_10=create cb_10
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_10
this.Control[iCurrent+3]=this.gb_1
end on

on w_pt772_cxp_mal_presupuesto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_10)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;//ii_help = 514       				// help topic

uo_fecha.event ue_output()
end event

event ue_retrieve;call super::ue_retrieve;String ls_soles, ls_dolares
Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_fecha.of_get_fecha1()
ld_fec_fin = uo_fecha.of_get_fecha2()

SELECT l.cod_soles, l.cod_dolares 
  INTO :ls_soles, :ls_dolares 
  FROM logparam l 
 WHERE reckey='1' ;

ib_preview = false
this.Event ue_preview()

dw_report.retrieve(ls_soles, ls_dolares, ld_fec_ini, ld_fec_fin)
dw_report.object.t_user.text = gs_user
dw_report.object.t_texto.text = "Del :" + STRING( ld_fec_ini, 'DD/MM/YYYY') + &
      ' Al: ' + STRING( ld_fec_fin, 'DD/MM/YYYY')
dw_report.object.p_logo.filename = gs_logo

end event

type dw_report from w_report_smpl`dw_report within w_pt772_cxp_mal_presupuesto
integer x = 0
integer y = 212
integer height = 560
string dataobject = "d_rpt_cxp_prob_mal_ppto_tbl"
end type

type uo_fecha from u_ingreso_rango_fechas within w_pt772_cxp_mal_presupuesto
integer x = 9
integer y = 68
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor; string ls_inicio 

 of_set_label('Desde','Hasta') //para setear la fecha inicial

//Obtenemos el Primer dia del Mes

ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 of_set_fecha(date(ls_inicio),today())
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas
 
//Controles a Observar en el Windows

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_10 from commandbutton within w_pt772_cxp_mal_presupuesto
integer x = 1431
integer y = 56
integer width = 306
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;parent.event ue_retrieve()

end event

type gb_1 from groupbox within w_pt772_cxp_mal_presupuesto
integer width = 1317
integer height = 188
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
end type

