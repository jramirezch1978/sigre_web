$PBExportHeader$w_cn763_plla_gtos_movilidad.srw
forward
global type w_cn763_plla_gtos_movilidad from w_report_smpl
end type
type cb_1 from commandbutton within w_cn763_plla_gtos_movilidad
end type
type gb_1 from groupbox within w_cn763_plla_gtos_movilidad
end type
type gb_2 from groupbox within w_cn763_plla_gtos_movilidad
end type
type dw_origen from datawindow within w_cn763_plla_gtos_movilidad
end type
type uo_1 from u_ingreso_rango_fechas within w_cn763_plla_gtos_movilidad
end type
end forward

global type w_cn763_plla_gtos_movilidad from w_report_smpl
integer width = 3511
integer height = 1560
string title = "(CN763) Planilla de gastos de movilidad"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
dw_origen dw_origen
uo_1 uo_1
end type
global w_cn763_plla_gtos_movilidad w_cn763_plla_gtos_movilidad

on w_cn763_plla_gtos_movilidad.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.dw_origen=create dw_origen
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.dw_origen
this.Control[iCurrent+5]=this.uo_1
end on

on w_cn763_plla_gtos_movilidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.dw_origen)
destroy(this.uo_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_origen, ls_desc_origen, ls_desc_origen_rpt, ls_estado, ls_doc_ce, ls_cnta_prsp_mov
Date ld_fec_desde, ld_fec_hasta

if dw_origen.GetItemString(1,'flag') = '1'  then
	ls_origen = '%'
	ls_desc_origen  = ' Todos los Origenes'
	ls_desc_origen_rpt = ls_desc_origen
else
	ls_origen =  dw_origen.GetItemString(dw_origen.getrow(),'cod_origen')
	select r.nombre into :ls_desc_origen from origen r where r.cod_origen = : ls_origen ; 	
	ls_desc_origen_rpt = ls_origen+' - '+ls_desc_origen
end if

ld_fec_desde = uo_1.of_get_fecha1()
ld_fec_hasta = uo_1.of_get_fecha2()

IF ld_fec_desde > ld_fec_hasta then
	MessageBox('Aviso','Verificar Rangos de Fechas')
	RETURN
END IF

ls_estado = '5' // OG liquidadas

SELECT comprobante_egr INTO :ls_doc_ce FROM finparam WHERE reckey='1' ;

ls_cnta_prsp_mov = 'MOVILOC001'  // Ya se pidio parametro en PRESUP_PARAM

dw_report.retrieve(ls_estado, ls_doc_ce, ls_cnta_prsp_mov, ls_origen, ld_fec_desde, ld_fec_hasta)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_texto.text = TRIM(ls_desc_origen_rpt) + ' - del ' + STRING(ld_fec_desde,'dd/mm/yyyy') + ' al ' + STRING(ld_fec_hasta,'dd/mm/yyyy')

end event

event ue_open_pre;call super::ue_open_pre;//idw_1 = dw_report
//idw_1.Visible = true
//idw_1.SetTransObject(sqlca)
//
dw_origen.SetTransObject(sqlca)
dw_origen.retrieve()
dw_origen.insertrow(0)

////Event ue_preview()
//
end event

type dw_report from w_report_smpl`dw_report within w_cn763_plla_gtos_movilidad
integer x = 14
integer y = 272
integer width = 3438
integer height = 1040
integer taborder = 40
string dataobject = "d_rpt_plla_gtos_movilidad_tbl"
end type

type cb_1 from commandbutton within w_cn763_plla_gtos_movilidad
integer x = 3077
integer y = 124
integer width = 293
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type gb_1 from groupbox within w_cn763_plla_gtos_movilidad
integer x = 1655
integer y = 52
integer width = 1358
integer height = 192
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 12632256
string text = " Seleccione Rangos de Fechas "
end type

type gb_2 from groupbox within w_cn763_plla_gtos_movilidad
integer x = 59
integer y = 52
integer width = 1550
integer height = 192
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 12632256
string text = " Seleccionar "
end type

type dw_origen from datawindow within w_cn763_plla_gtos_movilidad
integer x = 142
integer y = 124
integer width = 1399
integer height = 84
boolean bringtotop = true
string dataobject = "d_ext_origen"
boolean border = false
boolean livescroll = true
end type

event itemchanged;CHOOSE CASE GetColumnName()
	CASE 'flag'
		IF data = '1' THEN
			SetItem(1,'cod_origen','')
		END IF
END CHOOSE
end event

type uo_1 from u_ingreso_rango_fechas within w_cn763_plla_gtos_movilidad
integer x = 1687
integer y = 124
integer taborder = 30
boolean bringtotop = true
long backcolor = 134217738
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

