$PBExportHeader$w_fl903_presupuesto_mod.srw
forward
global type w_fl903_presupuesto_mod from w_abc
end type
type ddlb_end from u_ddlb within w_fl903_presupuesto_mod
end type
type ddlb_begin from u_ddlb within w_fl903_presupuesto_mod
end type
type st_mes_act from statictext within w_fl903_presupuesto_mod
end type
type cbx_1 from checkbox within w_fl903_presupuesto_mod
end type
type st_4 from statictext within w_fl903_presupuesto_mod
end type
type ddlb_nave from u_ddlb within w_fl903_presupuesto_mod
end type
type rb_3 from radiobutton within w_fl903_presupuesto_mod
end type
type rb_2 from radiobutton within w_fl903_presupuesto_mod
end type
type rb_1 from radiobutton within w_fl903_presupuesto_mod
end type
type cb_1 from commandbutton within w_fl903_presupuesto_mod
end type
type ddlb_year from u_ddlb within w_fl903_presupuesto_mod
end type
type st_3 from statictext within w_fl903_presupuesto_mod
end type
type st_2 from statictext within w_fl903_presupuesto_mod
end type
type st_1 from statictext within w_fl903_presupuesto_mod
end type
type gb_1 from groupbox within w_fl903_presupuesto_mod
end type
type gb_2 from groupbox within w_fl903_presupuesto_mod
end type
end forward

global type w_fl903_presupuesto_mod from w_abc
integer width = 1582
integer height = 1480
string title = "Registro de las varaciones en el presupuesto"
string menuname = "m_mto_smpl"
boolean maxbox = false
boolean resizable = false
ddlb_end ddlb_end
ddlb_begin ddlb_begin
st_mes_act st_mes_act
cbx_1 cbx_1
st_4 st_4
ddlb_nave ddlb_nave
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cb_1 cb_1
ddlb_year ddlb_year
st_3 st_3
st_2 st_2
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_fl903_presupuesto_mod w_fl903_presupuesto_mod

on w_fl903_presupuesto_mod.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.ddlb_end=create ddlb_end
this.ddlb_begin=create ddlb_begin
this.st_mes_act=create st_mes_act
this.cbx_1=create cbx_1
this.st_4=create st_4
this.ddlb_nave=create ddlb_nave
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_1=create cb_1
this.ddlb_year=create ddlb_year
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_end
this.Control[iCurrent+2]=this.ddlb_begin
this.Control[iCurrent+3]=this.st_mes_act
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.ddlb_nave
this.Control[iCurrent+7]=this.rb_3
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.ddlb_year
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
end on

on w_fl903_presupuesto_mod.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_end)
destroy(this.ddlb_begin)
destroy(this.st_mes_act)
destroy(this.cbx_1)
destroy(this.st_4)
destroy(this.ddlb_nave)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_1)
destroy(this.ddlb_year)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type ddlb_end from u_ddlb within w_fl903_presupuesto_mod
integer x = 507
integer y = 628
integer width = 530
integer height = 676
integer taborder = 30
integer textsize = -8
integer accelerator = 52
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_psc_pry_vrc_mes_dddw'


ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 12                     // Longitud del campo 1
ii_lc2 = 4

end event

event ue_item_add;Integer	li_index, li_x, li_year, li_inicio
Long     ll_rows
Any  		la_id
String	ls_item

li_inicio = integer(right(trim(ddlb_begin.text),2))

li_year = integer(ddlb_year.text)
ll_rows = ids_Data.Retrieve(li_year,li_inicio)


FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

ddlb_end.selectitem(ddlb_end.totalitems())
end event

type ddlb_begin from u_ddlb within w_fl903_presupuesto_mod
integer x = 507
integer y = 544
integer width = 530
integer height = 676
integer taborder = 20
integer textsize = -8
integer accelerator = 51
end type

event selectionchanged;call super::selectionchanged;if right(trim(this.text),2) = '12' then
	ddlb_end.reset()
	ddlb_end.enabled = false
	rb_3.checked = true
	rb_1.enabled = false
	rb_2.enabled = false
	rb_3.enabled = true
else
	rb_1.checked = true
	rb_1.enabled = true
	rb_2.enabled = true
	rb_3.enabled = true
	if rb_1.checked = true then
		ddlb_end.reset()
		ddlb_end.enabled = true
		ddlb_end.event ue_populate()
	else
		ddlb_end.reset()
		ddlb_end.enabled = false
	end if
end if
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_psc_pry_vrc_mes_dddw'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 12                     // Longitud del campo 1
ii_lc2 = 4
end event

event ue_item_add;Integer	li_index, li_x, li_year, li_inicio
Long     ll_rows
Any  		la_id
String	ls_item, ls_mes

select to_number(to_char(sysdate, 'mm')) into :li_inicio from dual;

li_year = integer(ddlb_year.text)
ll_rows = ids_Data.Retrieve(li_year,li_inicio)

choose case li_inicio
	case 1
		ls_mes  = 'ENERO'
	case 2
		ls_mes  = 'FEBRERO'
	case 3
		ls_mes  = 'MARZO'
	case 4
		ls_mes  = 'ABRIL'
	case 5
		ls_mes  = 'MAYO'
	case 6
		ls_mes  = 'JUNIO'
	case 7
		ls_mes  = 'JULIO'
	case 8
		ls_mes  = 'AGOSTO'
	case 9
		ls_mes  = 'SETIEMBRE'
	case 10
		ls_mes  = 'OCTUBRE'
	case 11
		ls_mes  = 'NOVIEMBRE'
	case 12
		ls_mes  = 'DICIEMBRE'
end choose

st_mes_act.text = 'MES ACTUAL: ' + ls_mes

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

ddlb_begin.selectitem(1)
ddlb_end.event constructor()
end event

type st_mes_act from statictext within w_fl903_presupuesto_mod
integer x = 306
integer y = 472
integer width = 759
integer height = 56
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

type cbx_1 from checkbox within w_fl903_presupuesto_mod
integer x = 430
integer y = 224
integer width = 535
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Una única nave"
boolean checked = true
end type

type st_4 from statictext within w_fl903_presupuesto_mod
integer x = 256
integer y = 76
integer width = 174
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nave:"
boolean focusrectangle = false
end type

type ddlb_nave from u_ddlb within w_fl903_presupuesto_mod
integer x = 494
integer y = 64
integer width = 686
integer height = 1044
integer textsize = -8
integer accelerator = 49
end type

event selectionchanged;call super::selectionchanged;ddlb_begin.reset()
ddlb_begin.event constructor()
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_naves_prop_tbl'

ii_ck  = 1                     // Nro del campo key

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 1

ii_lc1 = 15                     // Longitud del campo 1
ii_lc2 = 10                     // Longitud del campo 1

end event

event ue_item_add;call super::ue_item_add;this.SelectItem(1)
end event

type rb_3 from radiobutton within w_fl903_presupuesto_mod
integer x = 393
integer y = 824
integer width = 489
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Único mes"
end type

event clicked;if rb_1.checked = true then
	ddlb_end.reset()
	ddlb_end.enabled = true
	ddlb_end.event ue_populate()
else
	ddlb_end.reset()
	ddlb_end.enabled = false
end if
end event

type rb_2 from radiobutton within w_fl903_presupuesto_mod
integer x = 393
integer y = 980
integer width = 539
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hasta fin de perioro"
end type

event clicked;if rb_1.checked = true then
	ddlb_end.reset()
	ddlb_end.enabled = true
	ddlb_end.event ue_populate()
else
	ddlb_end.reset()
	ddlb_end.enabled = false
end if
end event

type rb_1 from radiobutton within w_fl903_presupuesto_mod
integer x = 393
integer y = 904
integer width = 503
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de meses"
boolean checked = true
end type

event clicked;if rb_1.checked = true then
	ddlb_end.reset()
	ddlb_end.enabled = true
	ddlb_end.event ue_populate()
else
	ddlb_end.reset()
	ddlb_end.enabled = false
end if
end event

type cb_1 from commandbutton within w_fl903_presupuesto_mod
integer x = 389
integer y = 1124
integer width = 558
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar Variaciones"
end type

event clicked;integer li_year, li_mes_inicio, li_variacion, li_inicio, li_fin
string ls_nave
long ll_ano, ll_cuenta

li_year = integer(trim(ddlb_year.text))

if rb_1.checked = true then //rango de meses
else
	if rb_2.checked = true then //hasta fin de periodo
	else
		if rb_3.checked = true then //sólo el mes seleccionado
			li_mes_inicio = integer(left(trim(ddlb_begin.text),2))
			if cbx_1.checked = true then
				ls_nave = left(trim(ddlb_nave.text),8)
				ll_ano = long(ddlb_year.text)
				li_inicio = integer(ddlb_begin.text)
				li_fin = integer(ddlb_begin.text)
				declare usp_fl_presup_variacion procedure for
					usp_fl_presup_variacion(:ls_nave, :ll_ano, :li_inicio, :li_fin, :gs_user);
				execute usp_fl_presup_variacion;
				fetch usp_fl_presup_variacion into :ll_cuenta;
				close usp_fl_presup_variacion;
			end if
		end if
	end if
end if
end event

type ddlb_year from u_ddlb within w_fl903_presupuesto_mod
integer x = 549
integer y = 364
integer width = 274
integer height = 928
integer textsize = -8
integer accelerator = 50
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_pesca_proy_var_ano'

ii_cn1 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1

end event

event selectionchanged;call super::selectionchanged;ddlb_begin.event constructor()

end event

event ue_item_add;Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item


ll_rows = ids_Data.Retrieve(trim(right(ddlb_nave.text,10)))

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

this.selectItem(ll_rows)
ddlb_begin.event constructor()
end event

type st_3 from statictext within w_fl903_presupuesto_mod
integer x = 311
integer y = 376
integer width = 174
integer height = 56
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

type st_2 from statictext within w_fl903_presupuesto_mod
integer x = 311
integer y = 632
integer width = 210
integer height = 64
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

type st_1 from statictext within w_fl903_presupuesto_mod
integer x = 311
integer y = 548
integer width = 238
integer height = 64
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

type gb_1 from groupbox within w_fl903_presupuesto_mod
integer x = 297
integer y = 768
integer width = 754
integer height = 320
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_fl903_presupuesto_mod
integer x = 302
integer y = 176
integer width = 745
integer height = 140
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

