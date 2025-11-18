$PBExportHeader$w_al756_fotosselect.srw
forward
global type w_al756_fotosselect from w_rpt_list
end type
type cb_seleccionar from commandbutton within w_al756_fotosselect
end type
type uo_search from n_cst_search within w_al756_fotosselect
end type
end forward

global type w_al756_fotosselect from w_rpt_list
integer width = 5714
integer height = 2508
string title = "[AL756] Sotcks con listado de Fotos"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
cb_seleccionar cb_seleccionar
uo_search uo_search
end type
global w_al756_fotosselect w_al756_fotosselect

type variables
String is_almacen, is_col = '', is_type
Integer  ii_clase

end variables

on w_al756_fotosselect.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_seleccionar=create cb_seleccionar
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_seleccionar
this.Control[iCurrent+2]=this.uo_search
end on

on w_al756_fotosselect.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_seleccionar)
destroy(this.uo_search)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10

pb_1.x = newwidth / 2 - pb_1.width
pb_2.x = pb_1.x

dw_1.height = newheight - dw_1.y - 10
dw_1.width 	= pb_1.x - dw_1.x - 10

dw_2.height = newheight - dw_2.y
dw_2.x		= pb_1.x + pb_1.width + 10
dw_2.width	= newWidth - dw_2.x



end event

event ue_open_pre;call super::ue_open_pre;
dw_1.retrieve('')
end event

type dw_report from w_rpt_list`dw_report within w_al756_fotosselect
boolean visible = false
integer x = 0
integer y = 300
integer width = 3319
integer height = 1960
integer taborder = 30
string dataobject = "d_rpt_fotoslabel"
end type

type dw_1 from w_rpt_list`dw_1 within w_al756_fotosselect
integer x = 5
integer y = 204
integer width = 1431
integer height = 1340
integer taborder = 100
string dataobject = "d_rpt_fotos"
end type

event dw_1::constructor;call super::constructor;this.SettransObject( sqlca)
ii_ck[1] = 1 
ii_ck[2] = 2
ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3

end event

type pb_1 from w_rpt_list`pb_1 within w_al756_fotosselect
integer x = 1449
integer y = 884
integer taborder = 110
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type pb_2 from w_rpt_list`pb_2 within w_al756_fotosselect
integer x = 1449
integer y = 1052
integer taborder = 130
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_al756_fotosselect
integer x = 1632
integer y = 204
integer width = 1381
integer height = 1348
integer taborder = 120
string dataobject = "d_rpt_fotos"
end type

event dw_2::constructor;call super::constructor;this.SettransObject( sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3

dw_1.retrieve( '')
end event

type cb_report from w_rpt_list`cb_report within w_al756_fotosselect
integer x = 3045
integer y = 88
integer width = 370
integer height = 88
integer taborder = 80
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;Date ld_desde
double ln_saldo

Long 	ll_row
String ls_cod 

SetPointer( Hourglass!)


if dw_2.rowcount() = 0 then return	

// Llena datos de dw seleccionados a tabla temporal
delete from tt_alm_seleccion;
FOR ll_row = 1 to dw_2.rowcount()
	ls_cod = dw_2.object.abrev_articulo[ll_row]		
	Insert into tt_alm_seleccion( desc_art) 
		values ( :ls_cod);		
	If sqlca.sqlcode = -1 then
		messagebox("Error al insertar registro",sqlca.sqlerrtext)
	END IF
NEXT			
	
dw_1.visible = false
dw_2.visible = false		
pb_1.visible = false
pb_2.visible = false

	
dw_report.SetTransObject( sqlca)
parent.Event ue_preview()
dw_report.retrieve()	

dw_report.visible = true
		
//this.enabled = false
cb_seleccionar.enabled = true
cb_seleccionar.visible = true

end event

type cb_seleccionar from commandbutton within w_al756_fotosselect
boolean visible = false
integer x = 3045
integer y = 4
integer width = 366
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccionar"
end type

event clicked;

dw_1.visible = true
dw_2.visible = true
pb_1.visible = true
pb_2.visible = true
dw_report.visible = false
uo_search.visible = true

dw_1.reset()
dw_2.reset()

dw_1.retrieve('' )




end event

type uo_search from n_cst_search within w_al756_fotosselect
event destroy ( )
integer x = 18
integer y = 28
integer width = 3003
integer taborder = 20
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_buscar;call super::ue_buscar;String ls_buscar

ls_buscar = this.of_get_filtro()

dw_1.retrieve(ls_buscar)
end event

