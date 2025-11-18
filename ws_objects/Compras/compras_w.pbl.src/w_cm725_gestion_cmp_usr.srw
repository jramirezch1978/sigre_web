$PBExportHeader$w_cm725_gestion_cmp_usr.srw
forward
global type w_cm725_gestion_cmp_usr from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_cm725_gestion_cmp_usr
end type
type cb_3 from commandbutton within w_cm725_gestion_cmp_usr
end type
type em_menor_ini from editmask within w_cm725_gestion_cmp_usr
end type
type em_menor_fin from editmask within w_cm725_gestion_cmp_usr
end type
type em_medio_ini from editmask within w_cm725_gestion_cmp_usr
end type
type em_medio_fin from editmask within w_cm725_gestion_cmp_usr
end type
type em_mayor_ini from editmask within w_cm725_gestion_cmp_usr
end type
type em_mayor_fin from editmask within w_cm725_gestion_cmp_usr
end type
type st_1 from statictext within w_cm725_gestion_cmp_usr
end type
type st_2 from statictext within w_cm725_gestion_cmp_usr
end type
type st_3 from statictext within w_cm725_gestion_cmp_usr
end type
type gb_1 from groupbox within w_cm725_gestion_cmp_usr
end type
end forward

global type w_cm725_gestion_cmp_usr from w_report_smpl
integer width = 3077
integer height = 1504
string title = "(CM725) Gestión de compras por usuario "
string menuname = "m_impresion"
long backcolor = 12632256
uo_1 uo_1
cb_3 cb_3
em_menor_ini em_menor_ini
em_menor_fin em_menor_fin
em_medio_ini em_medio_ini
em_medio_fin em_medio_fin
em_mayor_ini em_mayor_ini
em_mayor_fin em_mayor_fin
st_1 st_1
st_2 st_2
st_3 st_3
gb_1 gb_1
end type
global w_cm725_gestion_cmp_usr w_cm725_gestion_cmp_usr

type variables
String is_doc_oc

end variables

on w_cm725_gestion_cmp_usr.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
this.em_menor_ini=create em_menor_ini
this.em_menor_fin=create em_menor_fin
this.em_medio_ini=create em_medio_ini
this.em_medio_fin=create em_medio_fin
this.em_mayor_ini=create em_mayor_ini
this.em_mayor_fin=create em_mayor_fin
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.em_menor_ini
this.Control[iCurrent+4]=this.em_menor_fin
this.Control[iCurrent+5]=this.em_medio_ini
this.Control[iCurrent+6]=this.em_medio_fin
this.Control[iCurrent+7]=this.em_mayor_ini
this.Control[iCurrent+8]=this.em_mayor_fin
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.gb_1
end on

on w_cm725_gestion_cmp_usr.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.em_menor_ini)
destroy(this.em_menor_fin)
destroy(this.em_medio_ini)
destroy(this.em_medio_fin)
destroy(this.em_mayor_ini)
destroy(this.em_mayor_fin)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;em_menor_ini.text = '-1'
em_menor_fin.text = '15'
em_medio_ini.text = '15'
em_medio_fin.text = '30'
em_mayor_ini.text = '30'
em_mayor_fin.text = '90'


end event

event ue_retrieve;call super::ue_retrieve;Date ld_desde, ld_hasta
Long ll_menor_ini, ll_menor_fin, ll_medio_ini, ll_medio_fin, ll_mayor_ini, ll_mayor_fin 
String ls_msg

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

ll_menor_ini = LONG(em_menor_ini.text)
ll_menor_fin = LONG(em_menor_fin.text)
ll_medio_ini = LONG(em_medio_ini.text)
ll_medio_fin = LONG(em_medio_fin.text)
ll_mayor_ini = LONG(em_mayor_ini.text)
ll_mayor_fin = LONG(em_mayor_fin.text)

//messagebox('Desde', string(ld_desde))
//messagebox('Hasta', string(ld_hasta))

DECLARE PB_USP_CMP PROCEDURE FOR 
		USP_CMP_RPT_GEST_COMPRA_USR( :ll_menor_ini, :ll_menor_fin, 
											  :ll_medio_ini, :ll_medio_fin, 
											  :ll_mayor_ini, :ll_mayor_fin, 
											  :ld_desde, :ld_hasta ) 
EXECUTE PB_USP_CMP;

IF SQLCA.SQLCODE = -1 THEN
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_CMP_RPT_GEST_COMPRA_USR", ls_msg)
	Return
END IF

//CLOSE PB_USP_CMP;

idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"

idw_1.Retrieve()
ib_preview = false
idw_1.Visible = true


idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text     = gs_user
idw_1.object.t_empresa.text  = gs_empresa
idw_1.object.t_objeto.text   = dw_report.dataobject
idw_1.object.t_texto.text    = string(ld_desde, 'dd/mm/yyyy') + ' AL ' + string(ld_hasta, 'dd/mm/yyyy')


end event

event ue_preview();call super::ue_preview;ib_preview = FALSE

end event

type dw_report from w_report_smpl`dw_report within w_cm725_gestion_cmp_usr
integer x = 9
integer y = 360
integer width = 2999
integer height = 948
string dataobject = "d_rpt_gestion_compra_x_usr_tbl"
end type

type uo_1 from u_ingreso_rango_fechas within w_cm725_gestion_cmp_usr
integer x = 905
integer y = 40
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_3 from commandbutton within w_cm725_gestion_cmp_usr
integer x = 914
integer y = 164
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;parent.Event ue_retrieve()
end event

type em_menor_ini from editmask within w_cm725_gestion_cmp_usr
integer x = 315
integer y = 64
integer width = 224
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type em_menor_fin from editmask within w_cm725_gestion_cmp_usr
integer x = 608
integer y = 64
integer width = 224
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type em_medio_ini from editmask within w_cm725_gestion_cmp_usr
integer x = 315
integer y = 156
integer width = 224
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type em_medio_fin from editmask within w_cm725_gestion_cmp_usr
integer x = 608
integer y = 156
integer width = 224
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type em_mayor_ini from editmask within w_cm725_gestion_cmp_usr
integer x = 315
integer y = 252
integer width = 224
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type em_mayor_fin from editmask within w_cm725_gestion_cmp_usr
integer x = 608
integer y = 252
integer width = 224
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_1 from statictext within w_cm725_gestion_cmp_usr
integer x = 64
integer y = 64
integer width = 178
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Menor :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm725_gestion_cmp_usr
integer x = 64
integer y = 156
integer width = 178
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Medio :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cm725_gestion_cmp_usr
integer x = 64
integer y = 252
integer width = 178
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mayor:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cm725_gestion_cmp_usr
integer x = 37
integer width = 818
integer height = 352
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Rango de dias"
end type

