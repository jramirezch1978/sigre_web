$PBExportHeader$w_rsp_pry_costos.srw
forward
global type w_rsp_pry_costos from window
end type
type cb_2 from commandbutton within w_rsp_pry_costos
end type
type cb_1 from commandbutton within w_rsp_pry_costos
end type
type dw_1 from u_dw_abc within w_rsp_pry_costos
end type
end forward

global type w_rsp_pry_costos from window
integer width = 2062
integer height = 1232
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
end type
global w_rsp_pry_costos w_rsp_pry_costos

type variables
str_pry_activ_costo istr_1

end variables

on w_rsp_pry_costos.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_1}
end on

on w_rsp_pry_costos.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;String ls_tipcst_mo, ls_tipcst_equipo, ls_tipcst_material
String ls_tipcst_servicio, ls_tipcst_otro
String ls_tipcst, ls_nro_pry, ls_tipo[2]
Long ll_nro_actv
Datawindow ldw_origen
//Valores de los parametros
select tipo_gasto_mo      , tipo_gasto_equipo, tipo_gasto_material,
		 tipo_gasto_servicio, tipo_gasto_otro
  into :ls_tipcst_mo      , :ls_tipcst_equipo, :ls_tipcst_material,
		 :ls_tipcst_servicio, :ls_tipcst_otro
  from pry_param
 where reckey = '1';
 
istr_1 = Message.PowerObjectParm 

ldw_origen = istr_1.dw_origen
ls_nro_pry = istr_1.nro_proyecto
ll_nro_actv = istr_1.nro_actividad
ls_tipcst = istr_1.tipo_costo

If ls_tipcst = ls_tipcst_mo then
	ls_tipo[1] = ls_tipcst_mo
	ls_tipo[2] = ls_tipcst_equipo
end if

dw_1.Retrieve(ls_nro_pry,ls_tipo[])
end event

type cb_2 from commandbutton within w_rsp_pry_costos
integer x = 978
integer y = 1004
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;Close(Parent)
end event

type cb_1 from commandbutton within w_rsp_pry_costos
integer x = 535
integer y = 1008
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Long ll_row, ll_i
for ll_i = 1 to dw_1.RowCount()
	if dw_1.IsSelected(ll_i) then
		ll_row = istr_1.dw_origen.InsertRow(0)
		istr_1.dw_origen.Object.nro_proyecto[ll_row] = istr_1.nro_proyecto
		istr_1.dw_origen.Object.nro_actividad[ll_row] = istr_1.nro_actividad		
		istr_1.dw_origen.Object.nro_item_costo[ll_row] = dw_1.Object.nro_item_costo[ll_i]
		istr_1.dw_origen.Object.desc_costo[ll_row] = dw_1.Object.desc_costo[ll_i]
	end if
next
Close(Parent)
end event

type dw_1 from u_dw_abc within w_rsp_pry_costos
integer x = 37
integer y = 56
integer width = 1970
integer height = 908
string dataobject = "d_lis_pry_activ_costo"
end type

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	   
ii_ss = 0
end event

