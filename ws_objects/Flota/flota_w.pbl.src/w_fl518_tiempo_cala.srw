$PBExportHeader$w_fl518_tiempo_cala.srw
forward
global type w_fl518_tiempo_cala from w_report_smpl
end type
type st_1 from statictext within w_fl518_tiempo_cala
end type
type ddlb_ano_inicio from u_ddlb within w_fl518_tiempo_cala
end type
type ddlb_mes_inicio from u_ddlb within w_fl518_tiempo_cala
end type
type st_2 from statictext within w_fl518_tiempo_cala
end type
type ddlb_ano_fin from u_ddlb within w_fl518_tiempo_cala
end type
type ddlb_mes_fin from u_ddlb within w_fl518_tiempo_cala
end type
end forward

global type w_fl518_tiempo_cala from w_report_smpl
integer width = 2400
integer height = 1352
string title = "Reportes"
string menuname = "m_rep_grf"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_copiar ( )
st_1 st_1
ddlb_ano_inicio ddlb_ano_inicio
ddlb_mes_inicio ddlb_mes_inicio
st_2 st_2
ddlb_ano_fin ddlb_ano_fin
ddlb_mes_fin ddlb_mes_fin
end type
global w_fl518_tiempo_cala w_fl518_tiempo_cala

event ue_copiar();dw_report.Clipboard("gr_1")

end event

on w_fl518_tiempo_cala.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.st_1=create st_1
this.ddlb_ano_inicio=create ddlb_ano_inicio
this.ddlb_mes_inicio=create ddlb_mes_inicio
this.st_2=create st_2
this.ddlb_ano_fin=create ddlb_ano_fin
this.ddlb_mes_fin=create ddlb_mes_fin
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_ano_inicio
this.Control[iCurrent+3]=this.ddlb_mes_inicio
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.ddlb_ano_fin
this.Control[iCurrent+6]=this.ddlb_mes_fin
end on

on w_fl518_tiempo_cala.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.ddlb_ano_inicio)
destroy(this.ddlb_mes_inicio)
destroy(this.st_2)
destroy(this.ddlb_ano_fin)
destroy(this.ddlb_mes_fin)
end on

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()

// ii_help = 101           // help topic

dw_report.Object.Datawindow.Print.Orientation = 1    // 0=default,1=Landscape, 2=Portrait
end event

event ue_retrieve;call super::ue_retrieve;string ls_inicio, ls_fin
long ll_perinicio, ll_perfin 

ll_perinicio = long(trim(trim(ddlb_ano_inicio.text))+left(trim(ddlb_mes_inicio.text),2))
ll_perfin = long(trim(trim(ddlb_ano_fin.text))+left(trim(ddlb_mes_fin.text),2))

ls_inicio = trim(right(ddlb_mes_inicio.text,9))+'('+left(trim(ddlb_mes_inicio.text),2)+')'+'/'+trim(ddlb_ano_inicio.text)

ls_fin = trim(right(ddlb_mes_fin.text,9))+'('+left(trim(ddlb_mes_fin.text),2)+')'+'/'+trim(ddlb_ano_fin.text)
if ls_inicio = ls_fin then
	ls_fin = ''
else
	ls_fin = ' - '+ls_fin
end if

idw_1.Retrieve(ll_perinicio,ll_perfin)

dw_report.object.gr_1.title = Upper('tiempo promedio de cala de flota propia para el periodo '+ls_inicio+ls_fin)

dw_report.Object.p_1.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_fl518_tiempo_cala
integer x = 0
integer y = 200
integer width = 2327
integer height = 908
string dataobject = "d_tiempo_cala_grf"
end type

type st_1 from statictext within w_fl518_tiempo_cala
integer x = 55
integer y = 44
integer width = 320
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
string text = "Periodo Inicio"
boolean focusrectangle = false
end type

type ddlb_ano_inicio from u_ddlb within w_fl518_tiempo_cala
integer x = 366
integer y = 36
integer height = 1044
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_eficiencia_cala_ano_dddw'

ii_cn1 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1



end event

event ue_populate;call super::ue_populate;integer li_total
li_total = this.totalitems()
if li_total > 1 then
	li_total = li_total - 1
end if
this.selectitem(li_total)
end event

event selectionchanged;call super::selectionchanged;parent.event ue_retrieve()
end event

type ddlb_mes_inicio from u_ddlb within w_fl518_tiempo_cala
integer x = 617
integer y = 36
integer width = 558
integer height = 1044
boolean bringtotop = true
integer textsize = -8
end type

event selectionchanged;call super::selectionchanged;parent.event ue_retrieve()
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_eficiencia_cala_mes_dddw'
ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1
ii_lc2 = 9							// Longitud del campo 2



end event

event ue_item_add;Integer	li_index, li_x, li_total
Long     ll_rows
Any  		la_id
String	ls_item

ll_rows = ids_Data.Retrieve(trim(ddlb_ano_inicio.text))

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

li_total = this.totalitems()
if li_total > 1 then
	li_total = li_total - 1
end if
this.selectitem(li_total)
end event

type st_2 from statictext within w_fl518_tiempo_cala
integer x = 1225
integer y = 48
integer width = 270
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
string text = "Periodo Fin"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_ano_fin from u_ddlb within w_fl518_tiempo_cala
integer x = 1513
integer y = 40
integer height = 1044
boolean bringtotop = true
integer textsize = -8
end type

event selectionchanged;call super::selectionchanged;parent.event ue_retrieve()
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_eficiencia_cala_ano_dddw'

ii_cn1 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1



end event

event ue_populate;call super::ue_populate;this.selectitem(this.totalitems())
end event

type ddlb_mes_fin from u_ddlb within w_fl518_tiempo_cala
integer x = 1765
integer y = 40
integer width = 558
integer height = 1044
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

event selectionchanged;call super::selectionchanged;parent.event ue_retrieve()
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_eficiencia_cala_mes_dddw'
ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1
ii_lc2 = 9							// Longitud del campo 2



end event

event ue_item_add;Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item

ll_rows = ids_Data.Retrieve(trim(ddlb_ano_fin.text))

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

this.selectitem(this.totalitems())
end event

