$PBExportHeader$w_sig720_rpt_cana_sucia.srw
forward
global type w_sig720_rpt_cana_sucia from w_report_smpl
end type
type cb_generar from commandbutton within w_sig720_rpt_cana_sucia
end type
type uo_fechas from u_ingreso_rango_fechas within w_sig720_rpt_cana_sucia
end type
type st_1 from statictext within w_sig720_rpt_cana_sucia
end type
type em_hora from editmask within w_sig720_rpt_cana_sucia
end type
type gb_1 from groupbox within w_sig720_rpt_cana_sucia
end type
end forward

global type w_sig720_rpt_cana_sucia from w_report_smpl
integer width = 3319
integer height = 2072
string title = "TM de caña sucia ingresada a balanza (SIG720)"
string menuname = "m_rpt_simple"
long backcolor = 12632256
cb_generar cb_generar
uo_fechas uo_fechas
st_1 st_1
em_hora em_hora
gb_1 gb_1
end type
global w_sig720_rpt_cana_sucia w_sig720_rpt_cana_sucia

on w_sig720_rpt_cana_sucia.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_generar=create cb_generar
this.uo_fechas=create uo_fechas
this.st_1=create st_1
this.em_hora=create em_hora
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_generar
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_hora
this.Control[iCurrent+5]=this.gb_1
end on

on w_sig720_rpt_cana_sucia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_generar)
destroy(this.uo_fechas)
destroy(this.st_1)
destroy(this.em_hora)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;em_hora.text = '06:00:00'

// ii_help = 101           // help topic

end event

event ue_retrieve;call super::ue_retrieve;DateTime ldt_fecha1, ldt_fecha2
Date	ld_fecha1, ld_fecha2
Time	lt_fecha1, lt_fecha2
String ls_texto, ls_msj

SetPointer(hourGlass!)

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()
lt_fecha1 = Time(em_hora.text)
lt_fecha2 = Relativetime(lt_fecha1, -1)

ldt_fecha1=DateTime(ld_fecha1, lt_fecha1)
ldt_fecha2=DateTime(ld_fecha2, lt_fecha2)
ls_texto = 'Del ' + string(ldt_fecha1, 'dd/mm/yyyy hh:mm:ss') + ' al ' + string(ldt_fecha2, 'dd/mm/yyyy hh:mm:ss')

IF Isnull(ldt_fecha1) OR Isnull(ldt_fecha2) THEN
	Messagebox('Aviso','Fechas nulas a procesar')	
	Return
END IF	

cb_generar.enabled = false

//Parent.TriggerEvent('ue_retrieve')
idw_1.ii_zoom_actual = 100

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = ls_texto
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_objeto.text = 'SIG720'
idw_1.retrieve(ldt_fecha1, ldt_fecha2)
ib_preview = FALSE
THIS.Event ue_preview()
idw_1.Visible = true

SetPointer(Arrow!)

cb_generar.enabled = true

end event

type dw_report from w_report_smpl`dw_report within w_sig720_rpt_cana_sucia
integer x = 27
integer y = 224
integer width = 3227
integer height = 1608
string dataobject = "d_rpt_cana_sucia_campo_tbl"
end type

type cb_generar from commandbutton within w_sig720_rpt_cana_sucia
integer x = 2907
integer y = 28
integer width = 329
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;Parent.TriggerEvent('ue_retrieve')

end event

type uo_fechas from u_ingreso_rango_fechas within w_sig720_rpt_cana_sucia
integer x = 55
integer y = 84
integer height = 96
integer taborder = 30
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
of_set_fecha(RelativeDate(Today(),-1), Today()) //para setear la fecha inicial

end event

type st_1 from statictext within w_sig720_rpt_cana_sucia
integer x = 1422
integer y = 96
integer width = 288
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Hora Inicio"
boolean border = true
borderstyle borderstyle = StyleRaised!
boolean focusrectangle = false
end type

type em_hora from editmask within w_sig720_rpt_cana_sucia
integer x = 1733
integer y = 84
integer width = 242
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = timemask!
string mask = "hh:mm:ss"
end type

type gb_1 from groupbox within w_sig720_rpt_cana_sucia
integer x = 23
integer y = 20
integer width = 1970
integer height = 184
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Parametros de Lectura"
end type

