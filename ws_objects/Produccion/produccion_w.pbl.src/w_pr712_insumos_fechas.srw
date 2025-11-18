$PBExportHeader$w_pr712_insumos_fechas.srw
forward
global type w_pr712_insumos_fechas from w_ap500_base
end type
type sle_ot_adm from sle_text within w_pr712_insumos_fechas
end type
type st_ot_adm from statictext within w_pr712_insumos_fechas
end type
type st_1 from statictext within w_pr712_insumos_fechas
end type
type cbx_turno from cbx_origen within w_pr712_insumos_fechas
end type
type ddlb_turno from u_ddlb within w_pr712_insumos_fechas
end type
type st_2 from statictext within w_pr712_insumos_fechas
end type
end forward

global type w_pr712_insumos_fechas from w_ap500_base
integer width = 3095
integer height = 2032
string title = "Insumos Consumidos (PR712)"
sle_ot_adm sle_ot_adm
st_ot_adm st_ot_adm
st_1 st_1
cbx_turno cbx_turno
ddlb_turno ddlb_turno
st_2 st_2
end type
global w_pr712_insumos_fechas w_pr712_insumos_fechas

on w_pr712_insumos_fechas.create
int iCurrent
call super::create
this.sle_ot_adm=create sle_ot_adm
this.st_ot_adm=create st_ot_adm
this.st_1=create st_1
this.cbx_turno=create cbx_turno
this.ddlb_turno=create ddlb_turno
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ot_adm
this.Control[iCurrent+2]=this.st_ot_adm
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cbx_turno
this.Control[iCurrent+5]=this.ddlb_turno
this.Control[iCurrent+6]=this.st_2
end on

on w_pr712_insumos_fechas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ot_adm)
destroy(this.st_ot_adm)
destroy(this.st_1)
destroy(this.cbx_turno)
destroy(this.ddlb_turno)
destroy(this.st_2)
end on

event ue_retrieve;Date		ld_fecha1, ld_fecha2
string	ls_ot_adm, ls_origen, ls_turno

ld_fecha1 	= uo_fecha.of_get_fecha1( )
ld_fecha2 	= uo_fecha.of_get_fecha2( )
ls_ot_adm	= sle_ot_adm.Text

if ld_fecha2 < ld_fecha1 then
	MessageBox('PRODUCCION', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

if ls_ot_adm = '' or IsNull(ls_ot_adm) then
	MessageBox('PRODUCCION', 'OT_ADM ESTA EN BLANCO, POR FAVOR VERFIQUE', StopSign!)
	return
end if

if cbx_origen.checked then
	ls_origen = string(ddlb_param.ia_id)
else
	ls_origen = '%%'
end if

if cbx_turno.checked then
	ls_turno = string(ddlb_turno.ia_id)
else
	ls_turno = '%%'
end if


idw_1.Retrieve(ld_fecha1, ld_fecha2, ls_ot_adm, ls_origen, ls_turno)
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = 'Usuario: ' + gs_user

idw_1.Visible = True

end event

event ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
end event

type dw_report from w_ap500_base`dw_report within w_pr712_insumos_fechas
integer y = 368
integer width = 3026
integer height = 1420
string dataobject = "d_rpt_insumos_consumidos_tbl"
end type

event dw_report::ue_mousemove;//int		li_Rtn, li_Series, li_Category
//string 	ls_serie, ls_categ, ls_cantidad, ls_mensaje
//long ll_row
//grObjectType	MouseMoveObject
//	
//MouseMoveObject = this.ObjectAtPointer('gr_1', li_Series, li_category)
//
//if MouseMoveObject = TypeData! or MouseMoveObject = TypeCategory! then
//	
//	if st_etiqueta.x = xpos and &
//		st_etiqueta.y = (ypos + this.Y - 60) then
//		return
//	end if
//
//	This.SetRedraw(false)
//	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías
//	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo
//	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
//
//	ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
//
//	st_etiqueta.BringToTop = TRUE
//	st_etiqueta.x = xpos
//	st_etiqueta.y = ypos + this.Y - 60
//	st_etiqueta.text = ls_mensaje
//	st_etiqueta.width = len(ls_mensaje) * 30	
//	
//	if (st_etiqueta.X + st_etiqueta.width ) > this.width then
//		st_etiqueta.x = this.width - st_etiqueta.width - 30
//	end if
//	
//	st_etiqueta.visible = true
//	This.SetRedraw(true)
//else
//	st_etiqueta.visible = false
//end if
end event

type uo_fecha from w_ap500_base`uo_fecha within w_pr712_insumos_fechas
integer x = 14
integer y = 92
end type

type ddlb_param from w_ap500_base`ddlb_param within w_pr712_insumos_fechas
integer x = 1312
integer y = 96
integer width = 567
end type

event ddlb_param::constructor;THIS.Event ue_constructor()

THIS.Event ue_open_pre()

//THIS.Event ue_populate()
end event

event ddlb_param::ue_open_pre;call super::ue_open_pre;// Todos los origenes de los partes diarios
is_dataobject = 'ds_origen_pd_ot_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 10                   // Longitud del campo 1
ii_lc2 = 0							 // Longitud del campo 2
end event

type cbx_origen from w_ap500_base`cbx_origen within w_pr712_insumos_fechas
integer x = 1307
integer y = 16
long textcolor = 8388608
string text = "Origen"
end type

event cbx_origen::clicked;if this.checked = true then
	ddlb_param.enabled = true
	ddlb_param.reset()
	ddlb_param.event ue_populate()
else
	ddlb_param.enabled = false
	ddlb_param.reset()
end if

end event

type st_title from w_ap500_base`st_title within w_pr712_insumos_fechas
integer x = 850
integer y = 1792
integer height = 84
end type

type st_confirm from w_ap500_base`st_confirm within w_pr712_insumos_fechas
end type

type st_etiqueta from w_ap500_base`st_etiqueta within w_pr712_insumos_fechas
integer x = 2345
integer y = 1808
end type

type cb_1 from w_ap500_base`cb_1 within w_pr712_insumos_fechas
integer x = 2523
integer y = 88
integer height = 100
end type

event cb_1::ue_procesar;call super::ue_procesar;SetPointer(HourGlass!)
parent.event dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type sle_ot_adm from sle_text within w_pr712_insumos_fechas
integer x = 261
integer y = 236
integer width = 270
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
end type

event modified;call super::modified;string ls_codigo, ls_data

ls_codigo = trim(this.text)

SetNull(ls_data)
SELECT DESCRIPCION  
	into :ls_data
FROM  VW_CAM_USR_ADM 
WHERE COD_USR = :gs_user
  and ot_adm  = :ls_codigo;
  
if ls_data = "" or IsNull(ls_data) then
	Messagebox('Error', "OT_ADM NO EXISTE O NO ESTA AUTORIZADO", StopSign!)
	this.text = ""
	st_ot_adm.text = ""
	parent.event dynamic ue_reset( )
	return
end if
		
st_ot_adm.text = ls_data

parent.event dynamic ue_retrieve()

end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

ls_sql = 'SELECT OT_ADM AS CODIGO, '&   
		 + 'DESCRIPCION  AS DESCR_OT_ADM  '&   
		 + 'FROM  VW_CAM_USR_ADM '&
		 + 'WHERE COD_USR = '+"'"+gs_user+"'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
if ls_codigo <> '' then
	this.Text 		= ls_codigo
	st_ot_adm.Text = ls_data
end if

parent.event dynamic ue_retrieve()

end event

type st_ot_adm from statictext within w_pr712_insumos_fechas
integer x = 526
integer y = 240
integer width = 1349
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_pr712_insumos_fechas
integer x = 27
integer y = 236
integer width = 229
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Ot Adm."
boolean focusrectangle = false
end type

type cbx_turno from cbx_origen within w_pr712_insumos_fechas
integer x = 1879
integer y = 20
integer width = 251
string text = "Turno"
end type

event clicked;if this.checked = true then
	ddlb_turno.enabled = true
	ddlb_turno.reset()
	ddlb_turno.event ue_populate()
else
	ddlb_turno.enabled = false
	ddlb_turno.reset()
end if
end event

type ddlb_turno from u_ddlb within w_pr712_insumos_fechas
integer x = 1883
integer y = 96
integer width = 567
integer height = 1556
integer taborder = 30
boolean bringtotop = true
string pointer = "SizeNS!"
boolean enabled = false
boolean sorted = true
end type

event ue_open_pre;call super::ue_open_pre;// Todos los origenes de los partes diarios
is_dataobject = 'ds_turno_pd_ot_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 15                   // Longitud del campo 1
ii_lc2 = 0							 // Longitud del campo 2
end event

event constructor;THIS.Event ue_constructor()

THIS.Event ue_open_pre()

//THIS.Event ue_populate()
end event

type st_2 from statictext within w_pr712_insumos_fechas
integer x = 18
integer y = 12
integer width = 475
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Rango de Fechas:"
boolean focusrectangle = false
end type

