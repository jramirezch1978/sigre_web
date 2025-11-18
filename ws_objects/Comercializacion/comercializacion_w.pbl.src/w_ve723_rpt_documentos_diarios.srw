$PBExportHeader$w_ve723_rpt_documentos_diarios.srw
forward
global type w_ve723_rpt_documentos_diarios from w_report_smpl
end type
type cbx_origenes from checkbox within w_ve723_rpt_documentos_diarios
end type
type sle_origen from singlelineedit within w_ve723_rpt_documentos_diarios
end type
type sle_desc from singlelineedit within w_ve723_rpt_documentos_diarios
end type
type uo_fechas from u_ingreso_rango_fechas within w_ve723_rpt_documentos_diarios
end type
type cb_1 from commandbutton within w_ve723_rpt_documentos_diarios
end type
type gb_1 from groupbox within w_ve723_rpt_documentos_diarios
end type
end forward

global type w_ve723_rpt_documentos_diarios from w_report_smpl
integer width = 3511
integer height = 1500
string title = "(VE723) Reporte de Documentos Diarios de Ventas"
string menuname = "m_reporte"
cbx_origenes cbx_origenes
sle_origen sle_origen
sle_desc sle_desc
uo_fechas uo_fechas
cb_1 cb_1
gb_1 gb_1
end type
global w_ve723_rpt_documentos_diarios w_ve723_rpt_documentos_diarios

on w_ve723_rpt_documentos_diarios.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_origenes=create cbx_origenes
this.sle_origen=create sle_origen
this.sle_desc=create sle_desc
this.uo_fechas=create uo_fechas
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_origenes
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.sle_desc
this.Control[iCurrent+4]=this.uo_fechas
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.gb_1
end on

on w_ve723_rpt_documentos_diarios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_origenes)
destroy(this.sle_origen)
destroy(this.sle_desc)
destroy(this.uo_fechas)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_desc_origen
date 		ld_fec_desde, ld_fec_hasta

if cbx_origenes.checked then
	ls_origen = '%'
	ls_desc_origen = ' Todos los Origenes'
else
	ls_origen =  sle_origen.text + "%"
	ls_desc_origen = sle_desc.text
end if

ld_fec_desde = uo_fechas.of_get_fecha1( )
ld_fec_hasta = uo_fechas.of_get_fecha2( )

if ld_fec_desde > ld_fec_hasta then
	MessageBox('Aviso','Verificar Rangos de Fechas')
	return
end if

dw_report.retrieve(ld_fec_desde, ld_fec_hasta, ls_origen)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_desc_origen.text = ls_desc_origen

end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)


end event

type dw_report from w_report_smpl`dw_report within w_ve723_rpt_documentos_diarios
integer x = 14
integer y = 312
integer width = 3438
integer height = 1000
integer taborder = 40
string dataobject = "d_rpt_documentos_diarios_tbl"
end type

type cbx_origenes from checkbox within w_ve723_rpt_documentos_diarios
integer x = 27
integer y = 188
integer width = 599
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes "
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_origen.enabled = false
	sle_origen.text = ""
	sle_desc.text = "TODAS"
else
	sle_origen.enabled = true
	sle_desc.text = ""
end if
end event

type sle_origen from singlelineedit within w_ve723_rpt_documentos_diarios
event dobleclick pbm_lbuttondblclk
integer x = 640
integer y = 180
integer width = 233
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
boolean enabled = false
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO ,'&
				      				 +'ORIGEN.NOMBRE AS DESCRIPCION '&
				   					 +'FROM ORIGEN '

														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
   this.text 		 =  lstr_seleccionar.param1[1]
   sle_desc.text   =  lstr_seleccionar.param2[1]
END IF

end event

event modified;String ls_origen,ls_desc
Long   ll_count


ls_origen = this.text


select count(*) into :ll_count 
  from origen 
 where cod_origen = :ls_origen ;
 
IF ll_count > 0 THEN
	select nombre into :ls_desc from origen 
	 where cod_origen = :ls_origen ;
	 
	sle_desc.text = ls_desc
ELSE
	Setnull(ls_desc)
	sle_desc.text = ls_desc
END IF
 

end event

type sle_desc from singlelineedit within w_ve723_rpt_documentos_diarios
integer x = 887
integer y = 180
integer width = 942
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type uo_fechas from u_ingreso_rango_fechas within w_ve723_rpt_documentos_diarios
event destroy ( )
integer x = 27
integer y = 64
integer taborder = 110
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_Actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cb_1 from commandbutton within w_ve723_rpt_documentos_diarios
integer x = 1888
integer y = 72
integer width = 448
integer height = 168
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type gb_1 from groupbox within w_ve723_rpt_documentos_diarios
integer width = 3442
integer height = 296
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

