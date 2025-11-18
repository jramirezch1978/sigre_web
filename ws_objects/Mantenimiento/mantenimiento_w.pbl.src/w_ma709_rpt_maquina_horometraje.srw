$PBExportHeader$w_ma709_rpt_maquina_horometraje.srw
forward
global type w_ma709_rpt_maquina_horometraje from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas within w_ma709_rpt_maquina_horometraje
end type
type cb_procesar from commandbutton within w_ma709_rpt_maquina_horometraje
end type
type st_2 from statictext within w_ma709_rpt_maquina_horometraje
end type
type gb_1 from groupbox within w_ma709_rpt_maquina_horometraje
end type
end forward

global type w_ma709_rpt_maquina_horometraje from w_report_smpl
integer width = 3552
integer height = 1952
string title = "Consumo de combustible por maquina (MA709)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
uo_fechas uo_fechas
cb_procesar cb_procesar
st_2 st_2
gb_1 gb_1
end type
global w_ma709_rpt_maquina_horometraje w_ma709_rpt_maquina_horometraje

on w_ma709_rpt_maquina_horometraje.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_fechas=create uo_fechas
this.cb_procesar=create cb_procesar
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_procesar
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.gb_1
end on

on w_ma709_rpt_maquina_horometraje.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_procesar)
destroy(this.st_2)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;date ld_fecha
String ls_fecha

ld_fecha = today()
ls_fecha = String(Year(ld_fecha),  '0000') + '-' + &
           String(Month(ld_fecha), '00') + '-01' 
ld_fecha = date(ls_fecha)

// parametros para u_ingreso_rango_fechas
uo_fechas.of_set_label('Desde:','Hasta:')
uo_fechas.of_set_rango_inicio(Date('01/01/1900'))
uo_fechas.of_set_rango_fin(Date('31/12/9999'))
uo_fechas.of_set_fecha(ld_fecha,today())
//ii_help = 704             				// help topic

end event

event ue_retrieve();call super::ue_retrieve;date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

//ls_ejecutor = ddlb_1.ia_id

SetPointer(hourglass!)

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = 'Del ' + STRING(ld_fec_ini,'dd/mm/yyyy') + ' al ' + STRING(ld_fec_fin,'dd/mm/yyyy')
idw_1.Object.t_user.text = gs_user
idw_1.Retrieve(ld_fec_ini, ld_fec_fin)

SetPointer(Arrow!)


end event

type dw_report from w_report_smpl`dw_report within w_ma709_rpt_maquina_horometraje
integer x = 23
integer y = 412
integer width = 3442
integer height = 1336
string dataobject = "d_rpt_maquina_horometraje"
end type

type uo_fechas from u_ingreso_rango_fechas within w_ma709_rpt_maquina_horometraje
integer x = 142
integer y = 204
integer taborder = 20
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_procesar from commandbutton within w_ma709_rpt_maquina_horometraje
integer x = 3003
integer y = 204
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
string text = "Procesar"
end type

event clicked;Parent.event ue_retrieve( )
end event

type st_2 from statictext within w_ma709_rpt_maquina_horometraje
integer x = 645
integer y = 24
integer width = 2350
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Consumo de combustible por maquinaria"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_ma709_rpt_maquina_horometraje
integer x = 101
integer y = 128
integer width = 1390
integer height = 228
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Argumentos"
borderstyle borderstyle = stylelowered!
end type

