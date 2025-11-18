$PBExportHeader$w_rh468_p_pago_alimentistas.srw
forward
global type w_rh468_p_pago_alimentistas from w_report_smpl
end type
type cb_2 from commandbutton within w_rh468_p_pago_alimentistas
end type
type em_origen from editmask within w_rh468_p_pago_alimentistas
end type
type em_descripcion from editmask within w_rh468_p_pago_alimentistas
end type
type st_2 from statictext within w_rh468_p_pago_alimentistas
end type
type em_fecha from editmask within w_rh468_p_pago_alimentistas
end type
type cb_1 from commandbutton within w_rh468_p_pago_alimentistas
end type
type em_nro_plla from editmask within w_rh468_p_pago_alimentistas
end type
type st_1 from statictext within w_rh468_p_pago_alimentistas
end type
type st_3 from statictext within w_rh468_p_pago_alimentistas
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh468_p_pago_alimentistas
end type
end forward

global type w_rh468_p_pago_alimentistas from w_report_smpl
integer width = 3474
integer height = 1512
string title = "(RH468) Genera Pagos de Alimentistas - Judiciales"
string menuname = "m_impresion"
long backcolor = 12632256
cb_2 cb_2
em_origen em_origen
em_descripcion em_descripcion
st_2 st_2
em_fecha em_fecha
cb_1 cb_1
em_nro_plla em_nro_plla
st_1 st_1
st_3 st_3
uo_1 uo_1
end type
global w_rh468_p_pago_alimentistas w_rh468_p_pago_alimentistas

on w_rh468_p_pago_alimentistas.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_2=create cb_2
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.st_2=create st_2
this.em_fecha=create em_fecha
this.cb_1=create cb_1
this.em_nro_plla=create em_nro_plla
this.st_1=create st_1
this.st_3=create st_3
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.em_origen
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.em_fecha
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.em_nro_plla
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.uo_1
end on

on w_rh468_p_pago_alimentistas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.st_2)
destroy(this.em_fecha)
destroy(this.cb_1)
destroy(this.em_nro_plla)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.uo_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_mensaje, ls_nro_plla, ls_tipo_trabaj
date ld_fecha

ls_origen   = string(em_origen.text)
ls_nro_plla = string(em_nro_plla.text)
ld_fecha    = date(em_fecha.text)

ls_tipo_trabaj = uo_1.of_get_value()

if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

DECLARE pb_usp_rh_pago_alimentista PROCEDURE FOR USP_RH_PAGO_ALIMENTISTA
        ( :ls_origen, :ld_fecha, :ls_nro_plla, :ls_tipo_trabaj ) ;
EXECUTE pb_usp_rh_pago_alimentista ;

dw_report.retrieve()

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error", ls_mensaje)
  MessageBox('Atención','Proceso de pagos de Alimentistas falló', Exclamation! )
ELSE
  commit ;
END IF

end event

type dw_report from w_report_smpl`dw_report within w_rh468_p_pago_alimentistas
integer x = 9
integer y = 392
integer width = 3397
integer height = 932
integer taborder = 60
string dataobject = "d_txt_telecredito_tbl"
end type

type cb_2 from commandbutton within w_rh468_p_pago_alimentistas
integer x = 430
integer y = 160
integer width = 87
integer height = 68
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_origen from editmask within w_rh468_p_pago_alimentistas
integer x = 247
integer y = 160
integer width = 151
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_descripcion from editmask within w_rh468_p_pago_alimentistas
integer x = 238
integer y = 260
integer width = 805
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type st_2 from statictext within w_rh468_p_pago_alimentistas
integer x = 247
integer y = 60
integer width = 430
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Seleccione Origen"
boolean focusrectangle = false
end type

type em_fecha from editmask within w_rh468_p_pago_alimentistas
integer x = 2642
integer y = 160
integer width = 306
integer height = 56
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type cb_1 from commandbutton within w_rh468_p_pago_alimentistas
integer x = 3077
integer y = 148
integer width = 293
integer height = 76
integer taborder = 50
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

type em_nro_plla from editmask within w_rh468_p_pago_alimentistas
integer x = 2149
integer y = 156
integer width = 293
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "11034"
alignment alignment = center!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_rh468_p_pago_alimentistas
integer x = 2080
integer y = 60
integer width = 430
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Número de Planilla"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh468_p_pago_alimentistas
integer x = 2578
integer y = 60
integer width = 434
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Fecha de Proceso"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh468_p_pago_alimentistas
integer x = 1120
integer y = 112
integer taborder = 20
boolean bringtotop = true
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

