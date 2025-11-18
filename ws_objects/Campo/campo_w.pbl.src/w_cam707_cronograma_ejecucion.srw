$PBExportHeader$w_cam707_cronograma_ejecucion.srw
forward
global type w_cam707_cronograma_ejecucion from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas within w_cam707_cronograma_ejecucion
end type
type cb_reporte from commandbutton within w_cam707_cronograma_ejecucion
end type
type sle_campana from singlelineedit within w_cam707_cronograma_ejecucion
end type
type sle_desc_campana from singlelineedit within w_cam707_cronograma_ejecucion
end type
type st_1 from statictext within w_cam707_cronograma_ejecucion
end type
type st_3 from statictext within w_cam707_cronograma_ejecucion
end type
type sle_lote from singlelineedit within w_cam707_cronograma_ejecucion
end type
type sle_desc_lote from singlelineedit within w_cam707_cronograma_ejecucion
end type
end forward

global type w_cam707_cronograma_ejecucion from w_report_smpl
integer width = 3657
integer height = 1704
string title = "[CAM706] Cronograma de Ejecución"
string menuname = "m_rpt_smpl"
uo_fechas uo_fechas
cb_reporte cb_reporte
sle_campana sle_campana
sle_desc_campana sle_desc_campana
st_1 st_1
st_3 st_3
sle_lote sle_lote
sle_desc_lote sle_desc_lote
end type
global w_cam707_cronograma_ejecucion w_cam707_cronograma_ejecucion

on w_cam707_cronograma_ejecucion.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_fechas=create uo_fechas
this.cb_reporte=create cb_reporte
this.sle_campana=create sle_campana
this.sle_desc_campana=create sle_desc_campana
this.st_1=create st_1
this.st_3=create st_3
this.sle_lote=create sle_lote
this.sle_desc_lote=create sle_desc_lote
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_reporte
this.Control[iCurrent+3]=this.sle_campana
this.Control[iCurrent+4]=this.sle_desc_campana
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_lote
this.Control[iCurrent+8]=this.sle_desc_lote
end on

on w_cam707_cronograma_ejecucion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_reporte)
destroy(this.sle_campana)
destroy(this.sle_desc_campana)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.sle_lote)
destroy(this.sle_desc_lote)
end on

event ue_retrieve;call super::ue_retrieve;date ld_fecha1, ld_fecha2
string ls_campaña, ls_lote

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()

ls_campaña = sle_campana.text
ls_lote = sle_lote.text

idw_1.object.dataWindow.Print.Orientation	= 1
idw_1.Retrieve(ls_lote, ld_fecha1, ld_Fecha2)

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_usuario.text = gs_user
idw_1.Object.t_objeto.text = this.ClassName( )
idw_1.Object.t_titulo1.text = 'Del: ' + string(ld_fecha1, 'dd/mm/yyyy') + ' al ' &
									 +	string(ld_fecha2, 'dd/mm/yyyy')
idw_1.Object.t_titulo2.text = sle_desc_campana.text
idw_1.Object.t_titulo3.text = "Lote " + sle_lote.text
									 
end event

type dw_report from w_report_smpl`dw_report within w_cam707_cronograma_ejecucion
integer x = 0
integer y = 328
integer width = 2711
integer height = 1036
string dataobject = "d_rpt_cronograma_ejecucion_cst"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	f_select_current_row(this)
end if
end event

type uo_fechas from u_ingreso_rango_fechas within w_cam707_cronograma_ejecucion
integer taborder = 40
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton

of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final



end event

type cb_reporte from commandbutton within w_cam707_cronograma_ejecucion
integer x = 1906
integer y = 24
integer width = 334
integer height = 296
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve( )
end event

type sle_campana from singlelineedit within w_cam707_cronograma_ejecucion
event dobleclick pbm_lbuttondblclk
integer x = 398
integer y = 104
integer width = 384
integer height = 88
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT campana AS CODIGO_campaña, " &
	  	 + "descripcion AS DESCRIPCION_campana " &
	    + "FROM campanas " &
		 + "where flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 					= ls_codigo
	sle_desc_campana.text 	= ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Campaña')
	return
end if

SELECT descripcion 
	INTO :ls_desc
FROM campanas
where campana = :ls_codigo 
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Campaña no existe o esta activo, por favor verifique')
	this.text = ''
	sle_desc_campana.text = ''
	return
end if

sle_desc_campana.text = ls_desc

end event

type sle_desc_campana from singlelineedit within w_cam707_cronograma_ejecucion
integer x = 782
integer y = 104
integer width = 1111
integer height = 88
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cam707_cronograma_ejecucion
integer x = 18
integer y = 112
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Campaña:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cam707_cronograma_ejecucion
integer x = 27
integer y = 208
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lote:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_lote from singlelineedit within w_cam707_cronograma_ejecucion
event dobleclick pbm_lbuttondblclk
integer x = 398
integer y = 200
integer width = 384
integer height = 88
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_campaña
date 		ld_fecha1, ld_fecha2, ld_fec_inicio, ld_fec_fin

ls_campaña = sle_campana.text

if ls_campaña = '' or IsNull(ls_campaña) then
	MessageBox('Error', 'Debe Seleccionar primero una campaña')
	sle_campana.setFocus( )
	return
end if

select fec_inicio, fec_fin
	into :ld_fec_inicio, :ld_fec_fin
from campanas
where campana = :ls_campaña;

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )


ls_sql = "select distinct lc.nro_lote as codigo_lote, " &
	    + "lc.descripcion as descripcion_lote " &
		 + "from pd_jornal_campo p, " &
		 + "     pd_jornal_campo_lote pd, " &
		 + "     lote_campo           lc " &
		 + "where p.fecha     = pd.fecha " &
		 + "  and p.cod_trabajador = pd.cod_trabajador " &
		 + "  and p.nro_item       = pd.nro_item " &
		 + "  and pd.nro_lote      = lc.nro_lote " &
		 + "  and p.rendimiento > 0   " &
		 + "  and trunc(p.fecha) between to_date('" + string(ld_fec_inicio, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') and to_date('" + string(ld_fec_fin, 'dd/mm/yyyy') + "', 'dd/mm/yyyy')  " &
		 + "  and trunc(p.fecha) between to_date('" + string(ld_fecha1, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') and to_date('" + string(ld_fecha2, 'dd/mm/yyyy') + "', 'dd/mm/yyyy')"
			
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 				= ls_codigo
	sle_desc_lote.text 	= ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Lote')
	return
end if

SELECT descripcion 
	INTO :ls_desc
FROM lote_campo
where nro_lote = :ls_codigo 
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Lote no existe o esta activo, por favor verifique')
	this.text = ''
	sle_desc_lote.text = ''
	return
end if

sle_desc_lote.text = ls_desc

end event

type sle_desc_lote from singlelineedit within w_cam707_cronograma_ejecucion
integer x = 782
integer y = 200
integer width = 1097
integer height = 88
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

