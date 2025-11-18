$PBExportHeader$w_cam708_rend_molienda.srw
forward
global type w_cam708_rend_molienda from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas within w_cam708_rend_molienda
end type
type cb_reporte from commandbutton within w_cam708_rend_molienda
end type
type sle_propietario from singlelineedit within w_cam708_rend_molienda
end type
type sle_nom_propietario from singlelineedit within w_cam708_rend_molienda
end type
type sle_ingenio from singlelineedit within w_cam708_rend_molienda
end type
type sle_desc_ingenio from singlelineedit within w_cam708_rend_molienda
end type
type cbx_propietarios from checkbox within w_cam708_rend_molienda
end type
type cbx_ingenios from checkbox within w_cam708_rend_molienda
end type
end forward

global type w_cam708_rend_molienda from w_report_smpl
integer width = 2811
integer height = 1704
string title = "[CAM708] Reporte de Molienda, Laboratorio y Producción por Participación"
string menuname = "m_rpt_smpl"
uo_fechas uo_fechas
cb_reporte cb_reporte
sle_propietario sle_propietario
sle_nom_propietario sle_nom_propietario
sle_ingenio sle_ingenio
sle_desc_ingenio sle_desc_ingenio
cbx_propietarios cbx_propietarios
cbx_ingenios cbx_ingenios
end type
global w_cam708_rend_molienda w_cam708_rend_molienda

on w_cam708_rend_molienda.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_fechas=create uo_fechas
this.cb_reporte=create cb_reporte
this.sle_propietario=create sle_propietario
this.sle_nom_propietario=create sle_nom_propietario
this.sle_ingenio=create sle_ingenio
this.sle_desc_ingenio=create sle_desc_ingenio
this.cbx_propietarios=create cbx_propietarios
this.cbx_ingenios=create cbx_ingenios
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_reporte
this.Control[iCurrent+3]=this.sle_propietario
this.Control[iCurrent+4]=this.sle_nom_propietario
this.Control[iCurrent+5]=this.sle_ingenio
this.Control[iCurrent+6]=this.sle_desc_ingenio
this.Control[iCurrent+7]=this.cbx_propietarios
this.Control[iCurrent+8]=this.cbx_ingenios
end on

on w_cam708_rend_molienda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_reporte)
destroy(this.sle_propietario)
destroy(this.sle_nom_propietario)
destroy(this.sle_ingenio)
destroy(this.sle_desc_ingenio)
destroy(this.cbx_propietarios)
destroy(this.cbx_ingenios)
end on

event ue_retrieve;call super::ue_retrieve;date ld_fecha1, ld_fecha2
string ls_propietario, ls_ingenio

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()


if cbx_propietarios.checked then
	ls_propietario = "%%"
else
	ls_propietario = trim(sle_propietario.text) +"%"
end if

if cbx_ingenios.checked then
	ls_ingenio = "%%"
else
	ls_ingenio = trim(sle_ingenio.text) +"%"
end if

idw_1.Retrieve(ls_propietario, ls_ingenio, ld_fecha1, ld_Fecha2)
idw_1.object.DataWindow.Print.Orientation = 1
idw_1.object.DataWindow.Print.Paper.Size = 9

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_usuario.text = gs_user
idw_1.Object.t_objeto.text = this.ClassName( )
idw_1.Object.t_titulo1.text = 'Del: ' + string(ld_fecha1, 'dd/mm/yyyy') + ' al ' &
									 +	string(ld_fecha2, 'dd/mm/yyyy')

if cbx_propietarios.checked then
	idw_1.Object.t_titulo2.text = "Todos los propietarios"
end if

if cbx_ingenios.checked then
	idw_1.Object.t_titulo3.text = "Todos los ingenios"
end if

									 
end event

type dw_report from w_report_smpl`dw_report within w_cam708_rend_molienda
integer x = 0
integer y = 308
integer width = 2711
integer height = 1056
string dataobject = "d_rpt_rend_molienda_tbl"
end type

type uo_fechas from u_ingreso_rango_fechas within w_cam708_rend_molienda
integer taborder = 40
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton

of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


date ld_fecha, ld_Fecha1, ld_fecha2

ld_fecha = date(f_fecha_actual())

ld_fecha1 = Date(string(ld_fecha, "yyyy-mm-") + "01")
ld_fecha2 = RelativeDate(ld_fecha1, 30)

of_set_fecha(ld_fecha1, ld_fecha2) //para setear la fecha inicial
end event

type cb_reporte from commandbutton within w_cam708_rend_molienda
integer x = 2437
integer y = 20
integer width = 325
integer height = 184
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

type sle_propietario from singlelineedit within w_cam708_rend_molienda
event dobleclick pbm_lbuttondblclk
integer x = 754
integer y = 112
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
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select distinct c.representante as codigo_representante, " &
		 + "       p.nom_proveedor as nombre_representante, " &
		 + "		  p.nro_doc_ident as dni_representante, " &
		 + "       p.ruc as ruc_representante " &
		 + "from campo_molienda cm, " &
		 + "     campo          c, " &
		 + "     proveedor      p " &
		 + "where cm.cod_campo = c.cod_campo " &
		 + "  and c.representante = p.proveedor " &
		 + "   and p.flag_estado = '1'" 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 					= ls_codigo
	sle_nom_propietario.text 	= ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Campaña')
	return
end if

SELECT nom_proveedor 
	INTO :ls_desc
FROM proveedor
where proveedor = :ls_codigo 
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Código de proveedor no existe o esta activo, por favor verifique')
	this.text = ''
	sle_nom_propietario.text = ''
	return
end if

sle_nom_propietario.text = ls_desc

end event

type sle_nom_propietario from singlelineedit within w_cam708_rend_molienda
integer x = 1138
integer y = 112
integer width = 1211
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

type sle_ingenio from singlelineedit within w_cam708_rend_molienda
event dobleclick pbm_lbuttondblclk
integer x = 754
integer y = 208
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
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_campaña


ls_sql = "select distinct cm.cod_ingenio as codigo_ingenio, " &
		 + "       ci.desc_ingenio as descripcion_ingenio " &
		 + "from campo_molienda cm, " &
		 + "     campo_ingenio  ci " &
		 + "where cm.cod_ingenio = ci.cod_ingenio" 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 				= ls_codigo
	sle_desc_ingenio.text 	= ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Ingenio')
	return
end if

SELECT desc_ingenio 
	INTO :ls_desc
FROM campo_ingenio
where cod_ingenio = :ls_codigo 
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Ingenio no existe o esta activo, por favor verifique')
	this.text = ''
	sle_desc_ingenio.text = ''
	return
end if

sle_desc_ingenio.text = ls_desc

end event

type sle_desc_ingenio from singlelineedit within w_cam708_rend_molienda
integer x = 1138
integer y = 208
integer width = 1211
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

type cbx_propietarios from checkbox within w_cam708_rend_molienda
integer x = 46
integer y = 120
integer width = 709
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
string text = "Todos los propietarios"
boolean checked = true
end type

event clicked;if this.checked then
	sle_propietario.enabled = false
	sle_nom_propietario.text = ''
else
	sle_propietario.enabled = true
end if
end event

type cbx_ingenios from checkbox within w_cam708_rend_molienda
integer x = 46
integer y = 216
integer width = 709
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
string text = "Todos los Ingenios"
boolean checked = true
end type

event clicked;if this.checked then
	sle_ingenio.enabled = false
	sle_ingenio.text = ''
else
	sle_ingenio.enabled = true
end if
end event

