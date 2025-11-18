$PBExportHeader$w_fl702_posibles_arribos.srw
forward
global type w_fl702_posibles_arribos from w_report_smpl
end type
type st_1 from statictext within w_fl702_posibles_arribos
end type
type ddlb_ano from u_ddlb within w_fl702_posibles_arribos
end type
type st_2 from statictext within w_fl702_posibles_arribos
end type
type ddlb_mes from u_ddlb within w_fl702_posibles_arribos
end type
type st_3 from statictext within w_fl702_posibles_arribos
end type
type ddlb_inicio from u_ddlb within w_fl702_posibles_arribos
end type
type st_4 from statictext within w_fl702_posibles_arribos
end type
type ddlb_fin from u_ddlb within w_fl702_posibles_arribos
end type
type st_status from statictext within w_fl702_posibles_arribos
end type
end forward

global type w_fl702_posibles_arribos from w_report_smpl
integer width = 3470
integer height = 1288
string title = "Posibles Arribos"
string menuname = "m_rep_grf"
windowstate windowstate = maximized!
long backcolor = 67108864
st_1 st_1
ddlb_ano ddlb_ano
st_2 st_2
ddlb_mes ddlb_mes
st_3 st_3
ddlb_inicio ddlb_inicio
st_4 st_4
ddlb_fin ddlb_fin
st_status st_status
end type
global w_fl702_posibles_arribos w_fl702_posibles_arribos

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()

// ii_help = 101           // help topic

dw_report.Object.Datawindow.Print.Orientation = 1    // 0=default,1=Landscape, 2=Portrait
end event

on w_fl702_posibles_arribos.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.st_1=create st_1
this.ddlb_ano=create ddlb_ano
this.st_2=create st_2
this.ddlb_mes=create ddlb_mes
this.st_3=create st_3
this.ddlb_inicio=create ddlb_inicio
this.st_4=create st_4
this.ddlb_fin=create ddlb_fin
this.st_status=create st_status
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_ano
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.ddlb_mes
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.ddlb_inicio
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.ddlb_fin
this.Control[iCurrent+9]=this.st_status
end on

on w_fl702_posibles_arribos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.ddlb_ano)
destroy(this.st_2)
destroy(this.ddlb_mes)
destroy(this.st_3)
destroy(this.ddlb_inicio)
destroy(this.st_4)
destroy(this.ddlb_fin)
destroy(this.st_status)
end on

event ue_retrieve;call super::ue_retrieve;string ls_inicio, ls_fin

ls_inicio = trim(ddlb_inicio.text)+':00'
ls_fin = trim(ddlb_fin.text)+':00'
idw_1.Retrieve(ls_inicio, ls_fin)
idw_1.Object.p_1.filename = gs_logo

st_status.text = 'Modificando'
end event

type dw_report from w_report_smpl`dw_report within w_fl702_posibles_arribos
integer x = 9
integer y = 224
integer width = 3397
string dataobject = "d_posibles_arribos_tbl"
end type

type st_1 from statictext within w_fl702_posibles_arribos
integer x = 37
integer y = 84
integer width = 155
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
string text = "Año:"
boolean focusrectangle = false
end type

type ddlb_ano from u_ddlb within w_fl702_posibles_arribos
integer x = 201
integer y = 72
integer width = 251
integer height = 1020
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_posib_arribo_ano_dddw'

ii_cn1 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1
end event

event ue_item_add;call super::ue_item_add;long ll_row
ll_row = this.totalitems()
this.selectitem(ll_row)
end event

event selectionchanged;call super::selectionchanged;ddlb_mes.reset()
ddlb_mes.event constructor()
ddlb_inicio.reset()
ddlb_inicio.event constructor()
ddlb_fin.reset()
ddlb_fin.event constructor()
end event

type st_2 from statictext within w_fl702_posibles_arribos
integer x = 475
integer y = 84
integer width = 155
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
string text = "Mes:"
boolean focusrectangle = false
end type

type ddlb_mes from u_ddlb within w_fl702_posibles_arribos
integer x = 640
integer y = 72
integer width = 699
integer height = 1024
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_posib_arribos_mes_dddw'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 10                     // Longitud del campo 1
ii_lc2 = 2                     // Longitud del campo 1


end event

event ue_item_add;Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item, ls_ano

ls_ano = trim(ddlb_ano.text)
ll_rows = ids_Data.Retrieve(ls_ano)

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

this.selectitem(ll_rows)
end event

event selectionchanged;call super::selectionchanged;ddlb_inicio.reset()
ddlb_inicio.event constructor()
ddlb_fin.reset()
ddlb_fin.event constructor()
end event

type st_3 from statictext within w_fl702_posibles_arribos
integer x = 1413
integer y = 84
integer width = 238
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
string text = "Desde:"
boolean focusrectangle = false
end type

type ddlb_inicio from u_ddlb within w_fl702_posibles_arribos
integer x = 1646
integer y = 72
integer width = 699
integer height = 1048
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_posib_arribos_fecha_dddw'

ii_cn1 = 2                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 16                     // Longitud del campo 1



end event

event ue_item_add;Integer	li_index, li_x
Long     ll_rows, ll_filas
Any  		la_id
String	ls_item, ls_ano, ls_mes, ls_fecha

ls_ano = trim(ddlb_ano.text)
ls_mes = right(ddlb_mes.text,2)

ls_fecha = '01/'+ls_mes+'/'+ls_ano+' 00:00:00'

ll_rows = ids_Data.Retrieve(ls_fecha)

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

if ll_rows > 1 then
	ll_filas = ll_rows - 1
else
	ll_filas = ll_rows
end if
this.selectitem(ll_filas)
end event

event selectionchanged;call super::selectionchanged;ddlb_fin.reset()
ddlb_fin.event constructor()
end event

type st_4 from statictext within w_fl702_posibles_arribos
integer x = 2405
integer y = 84
integer width = 206
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
string text = "Hasta:"
boolean focusrectangle = false
end type

type ddlb_fin from u_ddlb within w_fl702_posibles_arribos
integer x = 2597
integer y = 72
integer width = 699
integer height = 1048
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_posib_arribos_fecha_dddw'

ii_cn1 = 2                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 16                     // Longitud del campo 1



end event

event ue_item_add;Integer	li_index, li_x
Long     ll_rows, ll_filas
Any  		la_id
String	ls_item, ls_ano, ls_fecha



ls_fecha = trim(ddlb_inicio.text)+':00'
ll_rows = ids_Data.Retrieve(ls_fecha)

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT
this.selectitem(ll_rows)

if st_status.text = 'Modificando' then
	parent.event ue_retrieve()
end if
end event

event selectionchanged;call super::selectionchanged;parent.event ue_retrieve()
end event

type st_status from statictext within w_fl702_posibles_arribos
boolean visible = false
integer x = 631
integer y = 164
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

