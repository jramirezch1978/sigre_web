$PBExportHeader$w_al745_sldo_valor_grp_cencos.srw
forward
global type w_al745_sldo_valor_grp_cencos from w_report_smpl
end type
type cb_1 from commandbutton within w_al745_sldo_valor_grp_cencos
end type
type cbx_grupo from checkbox within w_al745_sldo_valor_grp_cencos
end type
type st_3 from statictext within w_al745_sldo_valor_grp_cencos
end type
type sle_grupo from singlelineedit within w_al745_sldo_valor_grp_cencos
end type
type sle_desc_grupo from singlelineedit within w_al745_sldo_valor_grp_cencos
end type
end forward

global type w_al745_sldo_valor_grp_cencos from w_report_smpl
integer width = 3570
integer height = 1808
string title = "Saldo Valorizado por Grupo de Centros de Costo (AL745)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
cb_1 cb_1
cbx_grupo cbx_grupo
st_3 st_3
sle_grupo sle_grupo
sle_desc_grupo sle_desc_grupo
end type
global w_al745_sldo_valor_grp_cencos w_al745_sldo_valor_grp_cencos

type variables

end variables

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al745_sldo_valor_grp_cencos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.cbx_grupo=create cbx_grupo
this.st_3=create st_3
this.sle_grupo=create sle_grupo
this.sle_desc_grupo=create sle_desc_grupo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_grupo
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_grupo
this.Control[iCurrent+5]=this.sle_desc_grupo
end on

on w_al745_sldo_valor_grp_cencos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cbx_grupo)
destroy(this.st_3)
destroy(this.sle_grupo)
destroy(this.sle_desc_grupo)
end on

event ue_retrieve;call super::ue_retrieve;string	ls_mensaje, ls_grupo

if cbx_grupo.checked then
	ls_grupo = '%%'
else
	if trim(sle_grupo.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un Centro de Costo')
		return
	end if
	ls_grupo = trim(sle_grupo.text) + '%'
end if

//create or replace procedure USP_ALM_SLDO_VAL_GRP_CENCOS(
//       asi_grupo          IN centro_costo_grupo.grupo%TYPE
//) IS

DECLARE USP_ALM_SLDO_VAL_GRP_CENCOS PROCEDURE FOR
	USP_ALM_SLDO_VAL_GRP_CENCOS( :ls_grupo);
	
EXECUTE USP_ALM_SLDO_VAL_GRP_CENCOS;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_ALM_SLDO_VAL_GRP_CENCOS:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return
END IF

CLOSE USP_ALM_SLDO_VAL_GRP_CENCOS;



ib_preview=false
this.event ue_preview()
dw_report.visible = true
dw_report.SetTransObject( sqlca)
dw_report.retrieve(ls_grupo)	
dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.object.t_user.text 		= gs_user
dw_report.object.t_objeto.text 	= this.classname( )
dw_report.Object.p_logo.filename = gs_logo

	

end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.DataWindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_al745_sldo_valor_grp_cencos
integer x = 0
integer y = 172
integer width = 3429
integer height = 1348
string dataobject = "d_rpt_saldo_valor_grp_cencos_tbl"
end type

type cb_1 from commandbutton within w_al745_sldo_valor_grp_cencos
integer x = 3045
integer y = 36
integer width = 471
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Genera Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type cbx_grupo from checkbox within w_al745_sldo_valor_grp_cencos
integer x = 18
integer y = 20
integer width = 640
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los Grupos"
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_grupo.enabled = false
else
	sle_grupo.enabled = true
end if
end event

type st_3 from statictext within w_al745_sldo_valor_grp_cencos
integer x = 677
integer y = 28
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Grupo"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_grupo from singlelineedit within w_al745_sldo_valor_grp_cencos
event dobleclick pbm_lbuttondblclk
integer x = 992
integer y = 16
integer width = 439
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
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT distinct cc.GRUPO AS CODIGO_GRUPO, " &
	  	 + "cc.descripcion AS DESCRIPCION_GRUPO " &
	    + "FROM centro_costo_grupo cc " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
if ls_codigo <> '' then
	this.text 			  = ls_codigo
	sle_desc_grupo.text = ls_data
end if

end event

event modified;String 	ls_code, ls_desc

ls_code = this.text
if ls_code = '' or IsNull(ls_code) then
	MessageBox('Aviso', 'Debe Ingresar un grupo de Centro de costo')
	return
end if

SELECT DESCRIPCION
	INTO :ls_desc
FROM centro_costo_grupo
where grupo = :ls_code;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Grupo de Centro de Costo no existe')
	return
end if

sle_desc_grupo.text = ls_desc

end event

type sle_desc_grupo from singlelineedit within w_al745_sldo_valor_grp_cencos
integer x = 1445
integer y = 16
integer width = 1426
integer height = 88
integer taborder = 80
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

