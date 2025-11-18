$PBExportHeader$w_ma707_rpt_costos_x_ejec_anual.srw
forward
global type w_ma707_rpt_costos_x_ejec_anual from w_report_smpl
end type
type st_1 from statictext within w_ma707_rpt_costos_x_ejec_anual
end type
type uo_fechas from u_ingreso_rango_fechas within w_ma707_rpt_costos_x_ejec_anual
end type
type cb_procesar from commandbutton within w_ma707_rpt_costos_x_ejec_anual
end type
type st_2 from statictext within w_ma707_rpt_costos_x_ejec_anual
end type
type ddlb_1 from u_ddlb within w_ma707_rpt_costos_x_ejec_anual
end type
type gb_1 from groupbox within w_ma707_rpt_costos_x_ejec_anual
end type
end forward

global type w_ma707_rpt_costos_x_ejec_anual from w_report_smpl
integer width = 3552
integer height = 1952
string title = "Costo valorizado de ordenes de trabajo por ejecutor (MA707)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
st_1 st_1
uo_fechas uo_fechas
cb_procesar cb_procesar
st_2 st_2
ddlb_1 ddlb_1
gb_1 gb_1
end type
global w_ma707_rpt_costos_x_ejec_anual w_ma707_rpt_costos_x_ejec_anual

on w_ma707_rpt_costos_x_ejec_anual.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.st_1=create st_1
this.uo_fechas=create uo_fechas
this.cb_procesar=create cb_procesar
this.st_2=create st_2
this.ddlb_1=create ddlb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.cb_procesar
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.ddlb_1
this.Control[iCurrent+6]=this.gb_1
end on

on w_ma707_rpt_costos_x_ejec_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_fechas)
destroy(this.cb_procesar)
destroy(this.st_2)
destroy(this.ddlb_1)
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
idw_1.Object.t_12.text = 'COSTOS POR EJECUTOR DE ORDENES DE TRABAJO'
end event

event ue_retrieve();call super::ue_retrieve;string ls_ejecutor
date ld_fec_ini, ld_fec_fin
ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

ls_ejecutor = ddlb_1.ia_id

//Parent.SetRedraw(FALSE)
SetPointer(hourglass!)

//Rollback;

DECLARE PB_USP_MTT_RPT_COSTOS_EJECUTOR PROCEDURE FOR USP_MTT_RPT_COSTOS_EJECUTOR(:ls_ejecutor,:ld_fec_ini,:ld_fec_fin);
EXECUTE PB_USP_MTT_RPT_COSTOS_EJECUTOR ;

if sqlca.sqlcode = -1 Then
	MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	rollback ;
else
	MessageBox( 'Mensaje', "Proceso terminado" )
End If

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = 'Ejecutor : ' + ls_ejecutor
idw_1.Retrieve()


SetPointer(Arrow!)
//Parent.SetRedraw(TRUE)

end event

type dw_report from w_report_smpl`dw_report within w_ma707_rpt_costos_x_ejec_anual
integer x = 23
integer y = 480
integer width = 3442
integer height = 1268
string dataobject = "d_rpt_costos_x_ejec_ano_tbl"
end type

type st_1 from statictext within w_ma707_rpt_costos_x_ejec_anual
integer x = 187
integer y = 212
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ejecutor:"
boolean focusrectangle = false
end type

type uo_fechas from u_ingreso_rango_fechas within w_ma707_rpt_costos_x_ejec_anual
integer x = 1618
integer y = 204
integer taborder = 20
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_procesar from commandbutton within w_ma707_rpt_costos_x_ejec_anual
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

type st_2 from statictext within w_ma707_rpt_costos_x_ejec_anual
integer x = 649
integer y = 12
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
string text = "Resumen de costo valorizado de Ordenes de Trabajo por ejecutor"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_1 from u_ddlb within w_ma707_rpt_costos_x_ejec_anual
integer x = 494
integer y = 204
integer width = 1019
integer height = 428
integer taborder = 20
boolean bringtotop = true
end type

event ue_open_pre();call super::ue_open_pre;is_dataobject = 'd_dddw_ejecutor'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1
ii_lc2 = 12							// Longitud del campo 2

end event

type gb_1 from groupbox within w_ma707_rpt_costos_x_ejec_anual
integer x = 101
integer y = 128
integer width = 2857
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

