$PBExportHeader$w_pr708_prod_fin.srw
forward
global type w_pr708_prod_fin from w_rpt_general
end type
type uo_fecha from u_ingreso_rango_fechas within w_pr708_prod_fin
end type
type cb_1 from cb_aceptar within w_pr708_prod_fin
end type
type sle_ot_adm from sle_text within w_pr708_prod_fin
end type
type st_ot_adm from statictext within w_pr708_prod_fin
end type
type st_1 from statictext within w_pr708_prod_fin
end type
type ddlb_param from u_ddlb within w_pr708_prod_fin
end type
type ddlb_turno from u_ddlb within w_pr708_prod_fin
end type
type cbx_origen from checkbox within w_pr708_prod_fin
end type
type cbx_turno from checkbox within w_pr708_prod_fin
end type
end forward

global type w_pr708_prod_fin from w_rpt_general
integer width = 3168
integer height = 2076
string title = "Producción Por Fechas (PR708)"
uo_fecha uo_fecha
cb_1 cb_1
sle_ot_adm sle_ot_adm
st_ot_adm st_ot_adm
st_1 st_1
ddlb_param ddlb_param
ddlb_turno ddlb_turno
cbx_origen cbx_origen
cbx_turno cbx_turno
end type
global w_pr708_prod_fin w_pr708_prod_fin

on w_pr708_prod_fin.create
int iCurrent
call super::create
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.sle_ot_adm=create sle_ot_adm
this.st_ot_adm=create st_ot_adm
this.st_1=create st_1
this.ddlb_param=create ddlb_param
this.ddlb_turno=create ddlb_turno
this.cbx_origen=create cbx_origen
this.cbx_turno=create cbx_turno
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_ot_adm
this.Control[iCurrent+4]=this.st_ot_adm
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.ddlb_param
this.Control[iCurrent+7]=this.ddlb_turno
this.Control[iCurrent+8]=this.cbx_origen
this.Control[iCurrent+9]=this.cbx_turno
end on

on w_pr708_prod_fin.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.sle_ot_adm)
destroy(this.st_ot_adm)
destroy(this.st_1)
destroy(this.ddlb_param)
destroy(this.ddlb_turno)
destroy(this.cbx_origen)
destroy(this.cbx_turno)
end on

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_fecha2
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
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = 'Usuario: ' + gs_user
end event

type dw_report from w_rpt_general`dw_report within w_pr708_prod_fin
integer y = 348
integer width = 3040
integer height = 1372
string dataobject = "d_rpt_prod_final_fechas_tbl"
end type

type uo_fecha from u_ingreso_rango_fechas within w_pr708_prod_fin
integer x = 942
integer y = 36
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;date ld_fecha1, ld_fecha2

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999') )// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( month( today() ) + 1 ,'00' ) &
	+ '/' + string( year( today() ), '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

this.of_set_fecha( ld_fecha1, ld_fecha2 )
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from cb_aceptar within w_pr708_prod_fin
integer x = 2491
integer y = 184
integer width = 544
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
boolean default = true
end type

event ue_procesar;call super::ue_procesar;SetPointer(HourGlass!)
parent.event dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type sle_ot_adm from sle_text within w_pr708_prod_fin
integer x = 361
integer y = 160
integer width = 270
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
end type

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

end event

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

type st_ot_adm from statictext within w_pr708_prod_fin
integer x = 635
integer y = 160
integer width = 1161
integer height = 80
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

type st_1 from statictext within w_pr708_prod_fin
integer x = 69
integer y = 172
integer width = 261
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ot Adm"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_param from u_ddlb within w_pr708_prod_fin
integer x = 357
integer y = 32
integer width = 567
integer height = 1560
integer taborder = 30
boolean bringtotop = true
string pointer = "SizeNS!"
boolean enabled = false
boolean sorted = true
end type

event ddlb_param::constructor;THIS.Event ue_constructor()

THIS.Event ue_open_pre()

THIS.Event ue_populate()
end event

event ddlb_param::ue_open_pre;call super::ue_open_pre;// Todos los origenes de los partes diarios
is_dataobject = 'ds_origen_pd_ot_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 10                   // Longitud del campo 1
ii_lc2 = 0							 // Longitud del campo 2
end event

type ddlb_turno from u_ddlb within w_pr708_prod_fin
integer x = 2473
integer y = 28
integer width = 567
integer height = 1560
integer taborder = 40
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

type cbx_origen from checkbox within w_pr708_prod_fin
integer x = 73
integer y = 44
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen"
end type

event clicked;if this.checked = true then
	ddlb_param.enabled = true
	ddlb_param.reset()
	ddlb_param.event constructor()
else
	ddlb_param.enabled = false
	ddlb_param.reset()
end if
end event

type cbx_turno from checkbox within w_pr708_prod_fin
integer x = 2226
integer y = 32
integer width = 238
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Turno"
end type

event clicked;if this.checked = true then
	ddlb_turno.enabled = true
	ddlb_turno.reset()
	ddlb_turno.event constructor()
else
	ddlb_turno.enabled = false
	ddlb_turno.reset()
end if
end event

