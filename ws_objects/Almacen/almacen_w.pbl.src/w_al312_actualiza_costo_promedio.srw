$PBExportHeader$w_al312_actualiza_costo_promedio.srw
forward
global type w_al312_actualiza_costo_promedio from w_abc_master_smpl
end type
type em_codigo from editmask within w_al312_actualiza_costo_promedio
end type
type cb_1 from commandbutton within w_al312_actualiza_costo_promedio
end type
type st_1 from statictext within w_al312_actualiza_costo_promedio
end type
end forward

global type w_al312_actualiza_costo_promedio from w_abc_master_smpl
integer x = 306
integer y = 108
integer width = 2249
integer height = 984
string title = "Actualización del Costo Promedio del Articulo (AL312)"
string menuname = "m_only_grabar"
boolean minbox = false
boolean maxbox = false
em_codigo em_codigo
cb_1 cb_1
st_1 st_1
end type
global w_al312_actualiza_costo_promedio w_al312_actualiza_costo_promedio

type variables

end variables

on w_al312_actualiza_costo_promedio.create
int iCurrent
call super::create
if this.MenuName = "m_only_grabar" then this.MenuID = create m_only_grabar
this.em_codigo=create em_codigo
this.cb_1=create cb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_codigo
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
end on

on w_al312_actualiza_costo_promedio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_codigo)
destroy(this.cb_1)
destroy(this.st_1)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_art.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_art')
END IF
ls_protect=dw_master.Describe("nom_articulo.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('nom_articulo')
END IF
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

ii_help = 3           					// help topic

ii_lec_mst = 0
end event

event resize;// override
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_al312_actualiza_costo_promedio
integer x = 73
integer y = 236
integer width = 2053
integer height = 488
integer taborder = 30
string dataobject = "d_abc_actualiza_costo_promedio_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;//f_select_current_row(this)
end event

event dw_master::clicked;// Override
end event

type em_codigo from editmask within w_al312_actualiza_costo_promedio
integer x = 1147
integer y = 80
integer width = 357
integer height = 76
integer taborder = 10
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
string mask = "xxxxxxxxxxxx"
end type

type cb_1 from commandbutton within w_al312_actualiza_costo_promedio
integer x = 1559
integer y = 80
integer width = 315
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;string ls_cod_articulo

ls_cod_articulo = string(em_codigo.text)
dw_master.Retrieve(ls_cod_articulo)
end event

type st_1 from statictext within w_al312_actualiza_costo_promedio
integer x = 311
integer y = 88
integer width = 800
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
string text = "Ingresar el Código del Artículo"
alignment alignment = center!
boolean focusrectangle = false
end type

