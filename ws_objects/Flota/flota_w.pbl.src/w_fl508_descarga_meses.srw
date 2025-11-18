$PBExportHeader$w_fl508_descarga_meses.srw
forward
global type w_fl508_descarga_meses from w_report_smpl
end type
type st_1 from statictext within w_fl508_descarga_meses
end type
type st_2 from statictext within w_fl508_descarga_meses
end type
type ddlb_ano from u_ddlb within w_fl508_descarga_meses
end type
type ddlb_nave from u_ddlb within w_fl508_descarga_meses
end type
end forward

global type w_fl508_descarga_meses from w_report_smpl
integer width = 2117
integer height = 1352
string title = "Descargar por meses (FL508)"
string menuname = "m_rep_grf"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_copiar ( )
st_1 st_1
st_2 st_2
ddlb_ano ddlb_ano
ddlb_nave ddlb_nave
end type
global w_fl508_descarga_meses w_fl508_descarga_meses

event ue_copiar();dw_report.Clipboard("gr_1")

end event

on w_fl508_descarga_meses.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.st_1=create st_1
this.st_2=create st_2
this.ddlb_ano=create ddlb_ano
this.ddlb_nave=create ddlb_nave
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.ddlb_ano
this.Control[iCurrent+4]=this.ddlb_nave
end on

on w_fl508_descarga_meses.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.ddlb_ano)
destroy(this.ddlb_nave)
end on

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()

// ii_help = 101           // help topic

dw_report.Object.Datawindow.Print.Orientation = 1    // 0=default,1=Landscape, 2=Portrait
end event

event ue_retrieve;call super::ue_retrieve;string ls_ano, ls_nave

ls_ano = trim(ddlb_ano.text)
ls_nave = trim(ddlb_nave.text)


idw_1.Retrieve(ls_nave,ls_ano)

dw_report.object.gr_1.title = Upper('Descarga de la nave '+ls_nave+', para el año '+ls_ano)
dw_report.Object.p_1.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_fl508_descarga_meses
integer x = 0
integer y = 200
integer width = 2016
integer height = 908
string dataobject = "d_captura_mes_grf"
end type

type st_1 from statictext within w_fl508_descarga_meses
integer x = 55
integer y = 44
integer width = 457
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione año:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl508_descarga_meses
integer x = 855
integer y = 44
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione mes:"
boolean focusrectangle = false
end type

type ddlb_ano from u_ddlb within w_fl508_descarga_meses
integer x = 498
integer y = 32
integer height = 1044
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_captura_nave_ano'

ii_cn1 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1



end event

event ue_populate;call super::ue_populate;this.selectitem(this.totalitems())
end event

event selectionchanged;call super::selectionchanged;ddlb_nave.event ue_item_add()
parent.event ue_retrieve()
end event

type ddlb_nave from u_ddlb within w_fl508_descarga_meses
integer x = 1248
integer y = 36
integer width = 622
integer height = 1016
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_captura_nave'
ii_cn1 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 20                     // Longitud del campo 1

end event

event ue_item_add;Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item

ll_rows = ids_Data.Retrieve(trim(ddlb_ano.text))

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

this.selectitem(1)
end event

event selectionchanged;call super::selectionchanged;parent.event ue_retrieve()
end event

