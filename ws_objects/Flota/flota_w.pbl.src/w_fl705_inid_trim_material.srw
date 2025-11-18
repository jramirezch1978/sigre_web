$PBExportHeader$w_fl705_inid_trim_material.srw
forward
global type w_fl705_inid_trim_material from w_report_smpl
end type
type ddlb_articulo from u_ddlb within w_fl705_inid_trim_material
end type
type st_1 from statictext within w_fl705_inid_trim_material
end type
type st_2 from statictext within w_fl705_inid_trim_material
end type
type ddlb_ano from u_ddlb within w_fl705_inid_trim_material
end type
type st_3 from statictext within w_fl705_inid_trim_material
end type
type ddlb_ini from u_ddlb within w_fl705_inid_trim_material
end type
type st_4 from statictext within w_fl705_inid_trim_material
end type
type ddlb_fin from u_ddlb within w_fl705_inid_trim_material
end type
type st_status from statictext within w_fl705_inid_trim_material
end type
end forward

global type w_fl705_inid_trim_material from w_report_smpl
integer width = 3470
integer height = 1960
string title = "Indicadores de materiales"
string menuname = "m_rep_grf"
windowstate windowstate = maximized!
long backcolor = 67108864
ddlb_articulo ddlb_articulo
st_1 st_1
st_2 st_2
ddlb_ano ddlb_ano
st_3 st_3
ddlb_ini ddlb_ini
st_4 st_4
ddlb_fin ddlb_fin
st_status st_status
end type
global w_fl705_inid_trim_material w_fl705_inid_trim_material

on w_fl705_inid_trim_material.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.ddlb_articulo=create ddlb_articulo
this.st_1=create st_1
this.st_2=create st_2
this.ddlb_ano=create ddlb_ano
this.st_3=create st_3
this.ddlb_ini=create ddlb_ini
this.st_4=create st_4
this.ddlb_fin=create ddlb_fin
this.st_status=create st_status
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_articulo
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.ddlb_ano
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.ddlb_ini
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.ddlb_fin
this.Control[iCurrent+9]=this.st_status
end on

on w_fl705_inid_trim_material.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_articulo)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.ddlb_ano)
destroy(this.st_3)
destroy(this.ddlb_ini)
destroy(this.st_4)
destroy(this.ddlb_fin)
destroy(this.st_status)
end on

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()

 ii_help = 101           // help topic

dw_report.Object.Datawindow.Print.Orientation = 1    // 0=default,1=Landscape, 2=Portrait
end event

event ue_retrieve;call super::ue_retrieve;string ls_inicio, ls_fin, ls_cod_art, ls_date, ls_title
integer li_cuenta, li_tipo


li_tipo = 1
ls_inicio = trim(ddlb_ini.text)
ls_fin = trim(ddlb_fin.text)
ls_cod_art = trim(right(ddlb_articulo.text,12))

select to_char(sysdate,'dd/mm/yyyy hh24:mi') into :ls_date from dual;

declare usp_fl_ind_mat_trim procedure for
	usp_fl_ind_mat_trim(:li_tipo, :ls_inicio,:ls_fin, :ls_cod_art);

execute usp_fl_ind_mat_trim;

fetch usp_fl_ind_mat_trim into :li_cuenta;

idw_1.Retrieve()

close usp_fl_ind_mat_trim;
commit;

if ls_inicio = ls_fin then
	ls_title = 'EL DÍA ' + trim(ls_inicio)
else
	ls_title = 'EL PERIODO '+trim(ls_inicio)+' - '+trim(ls_fin)
end if

idw_1.Object.p_1.filename = gs_logo
idw_1.object.t_user.text = 'Usuario : ' + trim(gs_user)
idw_1.Object.t_date.text = 'Fecha / Hora de impresión : ' + trim(ls_date)
idw_1.object.t_title.text = 'INDICADOR DE MATERIALES PARA ' + ls_title

st_status.text = 'Cambiando'
end event

type dw_report from w_report_smpl`dw_report within w_fl705_inid_trim_material
integer y = 148
integer width = 3406
integer height = 1548
string dataobject = "d_indicador_material_cmp"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type ddlb_articulo from u_ddlb within w_fl705_inid_trim_material
integer x = 462
integer y = 32
integer width = 1038
integer height = 1600
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_inidcador_articulos_tbl'
ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 40                     // Longitud del campo 1
ii_lc2 = 12							// Longitud del campo 2


end event

event ue_item_add;call super::ue_item_add;this.selectitem(1)
end event

event selectionchanged;call super::selectionchanged;ddlb_ano.reset()
ddlb_ini.reset()
ddlb_fin.reset()
ddlb_ano.event constructor()
ddlb_ini.event constructor()
ddlb_fin.event constructor()
end event

event ue_output;call super::ue_output;//Parent.Event ue_retrieve( )
end event

type st_1 from statictext within w_fl705_inid_trim_material
integer x = 37
integer y = 44
integer width = 425
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
string text = "Artículo / Material:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl705_inid_trim_material
integer x = 1911
integer y = 44
integer width = 133
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
string text = "Inicio:"
boolean focusrectangle = false
end type

type ddlb_ano from u_ddlb within w_fl705_inid_trim_material
integer x = 1641
integer y = 32
integer width = 251
integer height = 1604
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_inidcador_ano'

ii_cn1 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4							// Longitud del campo 2

end event

event ue_item_add;Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item,ls_cod_art

ls_cod_art = trim(right(ddlb_articulo.text,12))
ll_rows = ids_Data.Retrieve(ls_cod_art)

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

event selectionchanged;call super::selectionchanged;ddlb_ini.reset()
ddlb_fin.reset()
ddlb_ini.event constructor()
ddlb_fin.event constructor()
end event

type st_3 from statictext within w_fl705_inid_trim_material
integer x = 2491
integer y = 44
integer width = 87
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
string text = "Fin:"
boolean focusrectangle = false
end type

type ddlb_ini from u_ddlb within w_fl705_inid_trim_material
integer x = 2039
integer y = 32
integer width = 453
integer height = 1604
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_inidcador_fecha'

ii_cn1 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 10                     // Longitud del campo 1

end event

event ue_item_add;Integer	li_index, li_x
Long     ll_rows, ll_fila
Any  		la_id
String	ls_item, ls_ano, ls_cod_art

ls_cod_art = trim(right(ddlb_articulo.text,12))
ls_ano = trim(ddlb_ano.text)
ll_rows = ids_Data.Retrieve(ls_cod_art,ls_ano)

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT
if ll_rows > 1 then
	ll_fila = ll_rows - 1
else
	ll_fila = 1
end if
this.selectitem(ll_fila)
end event

event selectionchanged;call super::selectionchanged;ddlb_fin.reset()
ddlb_fin.event constructor()
end event

type st_4 from statictext within w_fl705_inid_trim_material
integer x = 1527
integer y = 44
integer width = 110
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

type ddlb_fin from u_ddlb within w_fl705_inid_trim_material
integer x = 2583
integer y = 32
integer width = 453
integer height = 1604
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_inidcador_fecha'

ii_cn1 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 10                     // Longitud del campo 1

end event

event ue_item_add;Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item, ls_ano, ls_cod_art

ls_cod_art = trim(right(ddlb_articulo.text,12))
ls_ano = trim(ddlb_ano.text)
ll_rows = ids_Data.Retrieve(ls_cod_art,ls_ano)

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

this.selectitem(ll_rows)

if st_status.text = 'Cambiando' then
	parent.event ue_retrieve()
end if
end event

type st_status from statictext within w_fl705_inid_trim_material
integer x = 3095
integer y = 64
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
string text = "none"
boolean focusrectangle = false
end type

