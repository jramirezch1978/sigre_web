$PBExportHeader$w_al511_ctacte_transportista.srw
forward
global type w_al511_ctacte_transportista from w_report_smpl
end type
type cb_3 from commandbutton within w_al511_ctacte_transportista
end type
type uo_fechas from u_ingreso_rango_fechas_horas within w_al511_ctacte_transportista
end type
type gb_1 from groupbox within w_al511_ctacte_transportista
end type
end forward

global type w_al511_ctacte_transportista from w_report_smpl
integer width = 3099
integer height = 1488
string title = "Cuenta corriente de transportista (AL511)"
string menuname = "m_impresion"
long backcolor = 12632256
cb_3 cb_3
uo_fechas uo_fechas
gb_1 gb_1
end type
global w_al511_ctacte_transportista w_al511_ctacte_transportista

on w_al511_ctacte_transportista.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.uo_fechas=create uo_fechas
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.gb_1
end on

on w_al511_ctacte_transportista.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.uo_fechas)
destroy(this.gb_1)
end on

type dw_report from w_report_smpl`dw_report within w_al511_ctacte_transportista
integer x = 37
integer y = 268
integer width = 2990
integer height = 1016
string dataobject = "d_rpt_ctacte_transportista_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_proveedor

Str_cns_pop lstr_cns_pop

ls_proveedor = this.object.proveedor[row]
//ls_proveedor	 = this.GetItemString(this.GetRow(), 'proveedor' )
lstr_cns_pop.arg[1] = ls_proveedor

IF row = 0 THEN RETURN

CHOOSE CASE dwo.Name
	CASE "precio_cana"  
		OpenSheetWithParm(w_al511_rpt_transporte_cana_tarifa, lstr_cns_pop, parent, 2, Layered!)
	CASE 'precio_comb'
		//OpenSheet(w_alm421_rpt_transporte_combustible, parent, 2, Layered!)
		OpenSheetWithParm(w_al511_rpt_transporte_combustible, lstr_cns_pop, parent, 2, Layered!)
END CHOOSE

end event

type cb_3 from commandbutton within w_al511_ctacte_transportista
integer x = 1934
integer y = 100
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consulta"
end type

event clicked;String ls_proveedor
DateTime ld_fecha_inicio, ld_fecha_final

SetPointer( Hourglass!)

idw_1.Reset()
ls_proveedor = ''
//ls_proveedor = sle_proveedor.text
ld_fecha_inicio = uo_fechas.of_get_fecha1()
ld_fecha_final  = uo_fechas.of_get_fecha2()

DECLARE PB_USP_ALM_RPT_TRANSP_COSECHA PROCEDURE FOR 
    USP_ALM_RPT_TRANSP_COSECHA(:ls_proveedor, :ld_fecha_inicio, :ld_fecha_final);
execute PB_USP_ALM_RPT_TRANSP_COSECHA ;

SetPointer( Arrow!)

if sqlca.sqlcode = 0 then
	messagebox( "Error", sqlca.sqlerrtext)
end if

idw_1.Retrieve()
idw_1.visible = true

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = 'DEL: ' + STRING( ld_fecha_inicio, 'dd/mm/yyyy') + &
    ' AL: ' + STRING( ld_fecha_final, 'dd/mm/yyyy')

end event

type uo_fechas from u_ingreso_rango_fechas_horas within w_al511_ctacte_transportista
integer x = 96
integer y = 120
integer taborder = 50
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_horas::destroy
end on

type gb_1 from groupbox within w_al511_ctacte_transportista
integer x = 23
integer y = 52
integer width = 1792
integer height = 176
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = "Parámetros"
end type

