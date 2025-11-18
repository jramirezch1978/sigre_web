$PBExportHeader$w_ca745_rpt_cana_sucia.srw
forward
global type w_ca745_rpt_cana_sucia from w_report_smpl
end type
type cb_generar from commandbutton within w_ca745_rpt_cana_sucia
end type
type uo_1 from u_ingreso_rango_fechas_horas within w_ca745_rpt_cana_sucia
end type
type gb_1 from groupbox within w_ca745_rpt_cana_sucia
end type
end forward

global type w_ca745_rpt_cana_sucia from w_report_smpl
integer width = 3319
integer height = 2072
string title = "TM de caña sucia ingresada a balanza (CA745)"
long backcolor = 12632256
cb_generar cb_generar
uo_1 uo_1
gb_1 gb_1
end type
global w_ca745_rpt_cana_sucia w_ca745_rpt_cana_sucia

on w_ca745_rpt_cana_sucia.create
int iCurrent
call super::create
this.cb_generar=create cb_generar
this.uo_1=create uo_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_generar
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_ca745_rpt_cana_sucia.destroy
call super::destroy
destroy(this.cb_generar)
destroy(this.uo_1)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;// ii_help = 101           // help topic

end event

event ue_retrieve;call super::ue_retrieve;DateTime ldt_fecha1, ldt_fecha2
String ls_texto, ls_msj

SetPointer(hourGlass!)

ldt_fecha1=uo_1.of_get_fecha1()
ldt_fecha2=uo_1.of_get_fecha2()
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
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')
idw_1.retrieve(ldt_fecha1, ldt_fecha2)
ib_preview = FALSE
THIS.Event ue_preview()
idw_1.Visible = true

SetPointer(Arrow!)

cb_generar.enabled = true

end event

type dw_report from w_report_smpl`dw_report within w_ca745_rpt_cana_sucia
integer x = 14
integer y = 300
integer width = 3227
integer height = 1528
string dataobject = "d_rpt_cana_sucia_campo_tbl"
end type

type cb_generar from commandbutton within w_ca745_rpt_cana_sucia
integer x = 1970
integer y = 80
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir"
end type

event clicked;Parent.TriggerEvent('ue_retrieve')

end event

type uo_1 from u_ingreso_rango_fechas_horas within w_ca745_rpt_cana_sucia
integer x = 91
integer y = 116
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:')// para seatear el titulo del boton 
of_set_fecha(DateTime('01/01/1900'), DateTime('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(datetime('01/01/1900')) // rango inicial
of_set_rango_fin(datetime('31/12/9999')) // rango final
end event

on uo_1.destroy
call u_ingreso_rango_fechas_horas::destroy
end on

type gb_1 from groupbox within w_ca745_rpt_cana_sucia
integer x = 32
integer y = 20
integer width = 1742
integer height = 240
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

