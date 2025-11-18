$PBExportHeader$w_rh604_rpt_estado_liquidaciones.srw
forward
global type w_rh604_rpt_estado_liquidaciones from w_report_smpl
end type
type cb_1 from commandbutton within w_rh604_rpt_estado_liquidaciones
end type
type em_fec_desde from editmask within w_rh604_rpt_estado_liquidaciones
end type
type em_fec_hasta from editmask within w_rh604_rpt_estado_liquidaciones
end type
type st_1 from statictext within w_rh604_rpt_estado_liquidaciones
end type
type st_2 from statictext within w_rh604_rpt_estado_liquidaciones
end type
type rb_tipo_trabajador from radiobutton within w_rh604_rpt_estado_liquidaciones
end type
type rb_centro_costo from radiobutton within w_rh604_rpt_estado_liquidaciones
end type
type gb_1 from groupbox within w_rh604_rpt_estado_liquidaciones
end type
type gb_2 from groupbox within w_rh604_rpt_estado_liquidaciones
end type
end forward

global type w_rh604_rpt_estado_liquidaciones from w_report_smpl
integer width = 3552
integer height = 1524
string title = "(RH604) Estado de las Liquidaciones de Créditos Laborales"
string menuname = "m_impresion"
cb_1 cb_1
em_fec_desde em_fec_desde
em_fec_hasta em_fec_hasta
st_1 st_1
st_2 st_2
rb_tipo_trabajador rb_tipo_trabajador
rb_centro_costo rb_centro_costo
gb_1 gb_1
gb_2 gb_2
end type
global w_rh604_rpt_estado_liquidaciones w_rh604_rpt_estado_liquidaciones

on w_rh604_rpt_estado_liquidaciones.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_fec_desde=create em_fec_desde
this.em_fec_hasta=create em_fec_hasta
this.st_1=create st_1
this.st_2=create st_2
this.rb_tipo_trabajador=create rb_tipo_trabajador
this.rb_centro_costo=create rb_centro_costo
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_fec_desde
this.Control[iCurrent+3]=this.em_fec_hasta
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.rb_tipo_trabajador
this.Control[iCurrent+7]=this.rb_centro_costo
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_rh604_rpt_estado_liquidaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_fec_desde)
destroy(this.em_fec_hasta)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.rb_tipo_trabajador)
destroy(this.rb_centro_costo)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string ls_mensaje
date   ld_fec_desde, ld_fec_hasta

ld_fec_desde = date(em_fec_desde.text)
ld_fec_hasta = date(em_fec_hasta.text)

if isnull(ld_fec_desde) or ld_fec_desde = date(string('01/01/1900','dd/mm/yyyy')) then
	MessageBox('Aviso','Debe ingresar fecha de inicio')
	return
end if

if isnull(ld_fec_hasta) or ld_fec_hasta = date(string('01/01/1900','dd/mm/yyyy')) then
	MessageBox('Aviso','Debe ingresar fecha final')
	return
end if

if ld_fec_desde > ld_fec_hasta then
	MessageBox('Atención','Error al digitar rango de fechas, Verifique')
	return
end if

DECLARE pb_usp_rh_liq_rpt_liquidaciones PROCEDURE FOR USP_RH_LIQ_RPT_LIQUIDACIONES
        ( :ld_fec_desde, :ld_fec_hasta ) ;
EXECUTE pb_usp_rh_liq_rpt_liquidaciones ;

if rb_tipo_trabajador.checked = true then

	idw_1.DataObject='d_liq_rpt_estado_liquidaciones_tbl'
	triggerevent('ue_preview')
	dw_report.SetTransObject(sqlca)
	dw_report.retrieve()

elseif rb_centro_costo.checked = true then

	idw_1.DataObject='d_liq_rpt_estado_liq_cencos_tbl'
	triggerevent('ue_preview')
	dw_report.SetTransObject(sqlca)
	dw_report.retrieve()

end if

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error", ls_mensaje)
  MessageBox('Atención','Proceso de reporte de liquidación, Falló', Exclamation! )
END IF

end event

type dw_report from w_report_smpl`dw_report within w_rh604_rpt_estado_liquidaciones
integer x = 0
integer y = 248
integer width = 3456
integer height = 988
integer taborder = 50
end type

type cb_1 from commandbutton within w_rh604_rpt_estado_liquidaciones
integer x = 2112
integer y = 84
integer width = 293
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;parent.event ue_preview()
Parent.Event ue_retrieve()
end event

type em_fec_desde from editmask within w_rh604_rpt_estado_liquidaciones
integer x = 1074
integer y = 88
integer width = 320
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type em_fec_hasta from editmask within w_rh604_rpt_estado_liquidaciones
integer x = 1618
integer y = 88
integer width = 320
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_rh604_rpt_estado_liquidaciones
integer x = 873
integer y = 96
integer width = 178
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh604_rpt_estado_liquidaciones
integer x = 1440
integer y = 96
integer width = 151
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type rb_tipo_trabajador from radiobutton within w_rh604_rpt_estado_liquidaciones
integer x = 69
integer y = 60
integer width = 603
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Tipo de Trabajador"
end type

type rb_centro_costo from radiobutton within w_rh604_rpt_estado_liquidaciones
integer x = 69
integer y = 140
integer width = 603
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Centro de Costo"
end type

type gb_1 from groupbox within w_rh604_rpt_estado_liquidaciones
integer x = 800
integer y = 16
integer width = 1225
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Rango de Fechas de Liquidaciones "
end type

type gb_2 from groupbox within w_rh604_rpt_estado_liquidaciones
integer width = 722
integer height = 240
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Seleccionar "
end type

