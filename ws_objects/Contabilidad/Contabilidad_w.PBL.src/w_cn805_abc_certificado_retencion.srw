$PBExportHeader$w_cn805_abc_certificado_retencion.srw
forward
global type w_cn805_abc_certificado_retencion from w_abc_master_smpl
end type
type em_codigo from editmask within w_cn805_abc_certificado_retencion
end type
type cb_1 from commandbutton within w_cn805_abc_certificado_retencion
end type
type st_1 from statictext within w_cn805_abc_certificado_retencion
end type
type em_ano from editmask within w_cn805_abc_certificado_retencion
end type
type em_mes from editmask within w_cn805_abc_certificado_retencion
end type
type st_2 from statictext within w_cn805_abc_certificado_retencion
end type
type st_3 from statictext within w_cn805_abc_certificado_retencion
end type
type em_descripcion from editmask within w_cn805_abc_certificado_retencion
end type
type cb_2 from commandbutton within w_cn805_abc_certificado_retencion
end type
type gb_1 from groupbox within w_cn805_abc_certificado_retencion
end type
end forward

global type w_cn805_abc_certificado_retencion from w_abc_master_smpl
integer x = 306
integer y = 108
integer width = 3072
integer height = 1492
string title = "Mantenimiento a Documentos de Certificados de Retenciones (CN805)"
string menuname = "m_master_smpl"
boolean minbox = false
boolean maxbox = false
em_codigo em_codigo
cb_1 cb_1
st_1 st_1
em_ano em_ano
em_mes em_mes
st_2 st_2
st_3 st_3
em_descripcion em_descripcion
cb_2 cb_2
gb_1 gb_1
end type
global w_cn805_abc_certificado_retencion w_cn805_abc_certificado_retencion

type variables
string as_proveedor
end variables

on w_cn805_abc_certificado_retencion.create
int iCurrent
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
this.em_codigo=create em_codigo
this.cb_1=create cb_1
this.st_1=create st_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_2=create st_2
this.st_3=create st_3
this.em_descripcion=create em_descripcion
this.cb_2=create cb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_codigo
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.em_mes
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.em_descripcion
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.gb_1
end on

on w_cn805_abc_certificado_retencion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_codigo)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_descripcion)
destroy(this.cb_2)
destroy(this.gb_1)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("proveedor.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('proveedor')
END IF
ls_protect=dw_master.Describe("doc_tipo_ref.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('doc_tipo_ref')
END IF
ls_protect=dw_master.Describe("nro_doc_ref.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('nro_doc_ref')
END IF
ls_protect=dw_master.Describe("flag_estado.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('flag_estado')
END IF
end event

event resize;// override
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

ii_help = 3           					// help topic

ii_lec_mst = 0
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn805_abc_certificado_retencion
integer x = 69
integer y = 436
integer width = 2898
integer height = 812
integer taborder = 0
string dataobject = "d_abc_certificado_retencion_tbl"
integer ii_sort = 1
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;// Datos que se ingresan automáticamente
this.setitem(al_row,"flag_estado",'D')
this.setitem(al_row,"proveedor",as_proveedor)

end event

type em_codigo from editmask within w_cn805_abc_certificado_retencion
integer x = 507
integer y = 136
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "xxxxxxxxxxxx"
end type

type cb_1 from commandbutton within w_cn805_abc_certificado_retencion
integer x = 1349
integer y = 312
integer width = 315
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;string ls_proveedor
integer li_ano, li_mes

ls_proveedor = string(em_codigo.text)
li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)
as_proveedor = ls_proveedor

dw_master.Retrieve(ls_proveedor, li_ano, li_mes)
end event

type st_1 from statictext within w_cn805_abc_certificado_retencion
integer x = 215
integer y = 144
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Proveedor"
boolean focusrectangle = false
end type

type em_ano from editmask within w_cn805_abc_certificado_retencion
integer x = 2240
integer y = 136
integer width = 224
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes from editmask within w_cn805_abc_certificado_retencion
integer x = 2638
integer y = 136
integer width = 146
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_2 from statictext within w_cn805_abc_certificado_retencion
integer x = 2103
integer y = 152
integer width = 110
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn805_abc_certificado_retencion
integer x = 2505
integer y = 152
integer width = 110
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type em_descripcion from editmask within w_cn805_abc_certificado_retencion
integer x = 965
integer y = 136
integer width = 1093
integer height = 76
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
maskdatatype maskdatatype = stringmask!
string mask = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
end type

type cb_2 from commandbutton within w_cn805_abc_certificado_retencion
integer x = 841
integer y = 132
integer width = 87
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_cntbl_proveedor_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_codigo.text = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type gb_1 from groupbox within w_cn805_abc_certificado_retencion
integer x = 142
integer y = 60
integer width = 2725
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Seleccione Opciones "
end type

