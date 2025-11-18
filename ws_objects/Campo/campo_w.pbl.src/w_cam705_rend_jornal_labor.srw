$PBExportHeader$w_cam705_rend_jornal_labor.srw
forward
global type w_cam705_rend_jornal_labor from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas within w_cam705_rend_jornal_labor
end type
type cb_reporte from commandbutton within w_cam705_rend_jornal_labor
end type
type sle_campana from singlelineedit within w_cam705_rend_jornal_labor
end type
type sle_desc_campana from singlelineedit within w_cam705_rend_jornal_labor
end type
type st_1 from statictext within w_cam705_rend_jornal_labor
end type
type st_2 from statictext within w_cam705_rend_jornal_labor
end type
type sle_labor from singlelineedit within w_cam705_rend_jornal_labor
end type
type sle_desc_labor from singlelineedit within w_cam705_rend_jornal_labor
end type
type rb_1 from radiobutton within w_cam705_rend_jornal_labor
end type
type rb_2 from radiobutton within w_cam705_rend_jornal_labor
end type
type gb_1 from groupbox within w_cam705_rend_jornal_labor
end type
end forward

global type w_cam705_rend_jornal_labor from w_report_smpl
integer width = 3657
integer height = 1704
string title = "[CAM704] Rendimiento Jornalereos x Labor y Lote"
string menuname = "m_rpt_smpl"
uo_fechas uo_fechas
cb_reporte cb_reporte
sle_campana sle_campana
sle_desc_campana sle_desc_campana
st_1 st_1
st_2 st_2
sle_labor sle_labor
sle_desc_labor sle_desc_labor
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_cam705_rend_jornal_labor w_cam705_rend_jornal_labor

on w_cam705_rend_jornal_labor.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_fechas=create uo_fechas
this.cb_reporte=create cb_reporte
this.sle_campana=create sle_campana
this.sle_desc_campana=create sle_desc_campana
this.st_1=create st_1
this.st_2=create st_2
this.sle_labor=create sle_labor
this.sle_desc_labor=create sle_desc_labor
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_reporte
this.Control[iCurrent+3]=this.sle_campana
this.Control[iCurrent+4]=this.sle_desc_campana
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_labor
this.Control[iCurrent+8]=this.sle_desc_labor
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.rb_2
this.Control[iCurrent+11]=this.gb_1
end on

on w_cam705_rend_jornal_labor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_reporte)
destroy(this.sle_campana)
destroy(this.sle_desc_campana)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_labor)
destroy(this.sle_desc_labor)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;date ld_fecha1, ld_fecha2
string ls_campaña, ls_labor

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()

ls_campaña = sle_campana.text
ls_labor = sle_labor.text

if rb_1.checked then
	idw_1.DataObject = 'd_rpt_rend_jornal_labor_tbl'
	idw_1.object.dataWindow.Print.Orientation	= 2
elseif rb_2.checked then
	idw_1.DataObject = 'd_rpt_rend_jornal_labor_cst'
	idw_1.object.dataWindow.Print.Orientation	= 1
end if

idw_1.SetTransObject(SQLCA)
ib_preview = false
this.event ue_preview( )
idw_1.Retrieve(ls_labor, ld_fecha1, ld_Fecha2)

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_usuario.text = gs_user
idw_1.Object.t_objeto.text = this.ClassName( )
idw_1.Object.t_titulo1.text = 'Del: ' + string(ld_fecha1, 'dd/mm/yyyy') + ' al ' &
									 +	string(ld_fecha2, 'dd/mm/yyyy')
idw_1.Object.t_titulo2.text = sle_desc_campana.text
idw_1.Object.t_titulo3.text = "Totos los LOTES -  Labor: " + sle_desc_labor.text
									 
end event

type dw_report from w_report_smpl`dw_report within w_cam705_rend_jornal_labor
integer x = 0
integer y = 328
integer width = 2711
integer height = 1036
string dataobject = "d_rpt_rend_jornal_labor_tbl"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	f_select_current_row(this)
end if
end event

type uo_fechas from u_ingreso_rango_fechas within w_cam705_rend_jornal_labor
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

type cb_reporte from commandbutton within w_cam705_rend_jornal_labor
integer x = 2683
integer y = 16
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

type sle_campana from singlelineedit within w_cam705_rend_jornal_labor
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

type sle_desc_campana from singlelineedit within w_cam705_rend_jornal_labor
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

type st_1 from statictext within w_cam705_rend_jornal_labor
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

type st_2 from statictext within w_cam705_rend_jornal_labor
integer x = 27
integer y = 204
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
string text = "Labor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_labor from singlelineedit within w_cam705_rend_jornal_labor
event dobleclick pbm_lbuttondblclk
integer x = 398
integer y = 196
integer width = 384
integer height = 88
integer taborder = 120
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

ls_sql = "select distinct l.cod_labor as codigo_labor, " &
		 + "l.desc_labor as descripcion_labor " &
		 + "from labor l, " &
		 + "     pd_jornal_campo p " &
		 + "where p.cod_labor = l.cod_labor " &
		 + "  and p.rendimiento > 0     " &
		 + "  and l.flag_estado = '1' " &
		 + "  and trunc(p.fecha) between to_date('" + string(ld_fec_inicio, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') and to_date('" + string(ld_fec_fin, 'dd/mm/yyyy') + "', 'dd/mm/yyyy')  " &
		 + "  and trunc(p.fecha) between to_date('" + string(ld_fecha1, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') and to_date('" + string(ld_fecha2, 'dd/mm/yyyy') + "', 'dd/mm/yyyy')"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 				= ls_codigo
	sle_desc_labor.text 	= ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Labor')
	return
end if

SELECT desc_labor 
	INTO :ls_desc
FROM labor
where cod_labor = :ls_codigo 
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Labor no existe o esta activo, por favor verifique')
	this.text = ''
	sle_desc_labor.text = ''
	return
end if

sle_desc_labor.text = ls_desc

end event

type sle_desc_labor from singlelineedit within w_cam705_rend_jornal_labor
integer x = 782
integer y = 196
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

type rb_1 from radiobutton within w_cam705_rend_jornal_labor
integer x = 1934
integer y = 96
integer width = 681
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen General"
boolean checked = true
end type

type rb_2 from radiobutton within w_cam705_rend_jornal_labor
integer x = 1934
integer y = 172
integer width = 681
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detallado por Lote"
end type

type gb_1 from groupbox within w_cam705_rend_jornal_labor
integer x = 1897
integer width = 754
integer height = 316
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Reporte"
end type

