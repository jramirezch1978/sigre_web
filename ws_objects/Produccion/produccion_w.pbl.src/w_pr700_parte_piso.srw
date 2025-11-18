$PBExportHeader$w_pr700_parte_piso.srw
forward
global type w_pr700_parte_piso from w_rpt_general
end type
type cb_buscar from cb_aceptar within w_pr700_parte_piso
end type
type sle_parte from singlelineedit within w_pr700_parte_piso
end type
type st_1 from statictext within w_pr700_parte_piso
end type
end forward

global type w_pr700_parte_piso from w_rpt_general
integer width = 2103
integer height = 1628
string title = "Parte de Piso (PR700)"
windowstate windowstate = maximized!
cb_buscar cb_buscar
sle_parte sle_parte
st_1 st_1
end type
global w_pr700_parte_piso w_pr700_parte_piso

on w_pr700_parte_piso.create
int iCurrent
call super::create
this.cb_buscar=create cb_buscar
this.sle_parte=create sle_parte
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.sle_parte
this.Control[iCurrent+3]=this.st_1
end on

on w_pr700_parte_piso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.sle_parte)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_parte, ls_tipo
long 		ll_count
ls_parte = sle_parte.text

if ls_parte = '' or IsNull(ls_parte) then
	MessageBox('PRODUCCION', 'NUMERO DE PARTE INDEFINIDO',StopSign!)
	return
end if

select count(*)
	into :ll_count
from tg_parte_piso
where nro_parte = :ls_parte;

if ll_count = 0 then 
	MessageBox('PRODUCCION', 'NUMERO DE PARTE NO EXISTE',StopSign!)
	return
end if

select flag_tipo
	into :ls_tipo
from tg_parte_piso
where nro_parte = :ls_parte;

if ls_tipo = 'PH' then
	ls_tipo = 'PRODUCCION HARINA'
elseif ls_tipo ='PC' then
	ls_tipo = 'PRODUCCION CONSERVAS'
elseif ls_tipo ='PG' then
	ls_tipo = 'PRODUCCION CONGELADO'
elseif ls_tipo ='AP' then
	ls_tipo = 'APROVISIONAMIENTO'
elseif ls_tipo ='CO' then
	ls_tipo = 'COMEDORES'
elseif ls_tipo ='MT' then
	ls_tipo = 'MANTENIMIENTO'
end if

idw_1.Retrieve(ls_parte)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.cabecera_t.text  = 'PARTE DE PISO DE ' + ls_tipo

end event

type dw_report from w_rpt_general`dw_report within w_pr700_parte_piso
integer y = 152
integer width = 2034
integer height = 1244
string dataobject = "d_rpt_parte_piso_composite"
end type

type cb_buscar from cb_aceptar within w_pr700_parte_piso
integer x = 905
integer y = 28
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
boolean default = true
end type

event ue_procesar;call super::ue_procesar;parent.event ue_retrieve()
end event

type sle_parte from singlelineedit within w_pr700_parte_piso
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
event ue_reset ( )
integer x = 475
integer y = 28
integer width = 416
integer height = 88
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event dynamic ue_display()
end event

event ue_display();// Asigna valores a structura 
str_parametros sl_param

sl_param.dw1    = 'ds_partes_piso_grid'
sl_param.titulo = "PARTE DE PISO"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	this.text = sl_param.field_ret[1]
	parent.event ue_retrieve()
END IF
end event

event ue_keydwn;if Key = KeyF2! then
	this.event dynamic ue_display()	
end if
end event

event modified;//string ls_codigo, ls_data
//
//ls_codigo = trim(this.text)
//
//SetNull(ls_data)
//select descr_especie
//	into :ls_data
//from tg_especies
//where especie = :ls_codigo;
//
//if ls_data = "" or IsNull(ls_data) then
//	Messagebox('Error', "CODIGO DE ESPECIE NO EXISTE", StopSign!)
//	this.text = ""
//	st_especie.text = ""
//	this.event dynamic ue_reset( )
//	return
//end if
//		
//st_especie.text = ls_data
//
//parent.event dynamic ue_retrieve()
end event

type st_1 from statictext within w_pr700_parte_piso
integer x = 110
integer y = 40
integer width = 343
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Nro Parte:"
alignment alignment = right!
boolean focusrectangle = false
end type

