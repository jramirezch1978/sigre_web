$PBExportHeader$w_ope500_opersec.srw
forward
global type w_ope500_opersec from w_abc
end type
type dw_orden from datawindow within w_ope500_opersec
end type
type dw_oper from datawindow within w_ope500_opersec
end type
type st_1 from statictext within w_ope500_opersec
end type
type sle_codigo from u_sle_codigo within w_ope500_opersec
end type
type cb_1 from commandbutton within w_ope500_opersec
end type
type tab_1 from tab within w_ope500_opersec
end type
type tabpage_1 from userobject within tab_1
end type
type dw_material from u_dw_cns within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_material dw_material
end type
type tabpage_2 from userobject within tab_1
end type
type dw_parte from u_dw_cns within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_parte dw_parte
end type
type tabpage_3 from userobject within tab_1
end type
type dw_programa from u_dw_cns within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_programa dw_programa
end type
type tabpage_4 from userobject within tab_1
end type
type dw_servicio from u_dw_cns within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_servicio dw_servicio
end type
type tabpage_5 from userobject within tab_1
end type
type dw_vale from u_dw_cns within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_vale dw_vale
end type
type tab_1 from tab within w_ope500_opersec
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
end forward

global type w_ope500_opersec from w_abc
integer width = 3758
integer height = 2376
string title = "[OPE500] Consultas por OperSec"
string menuname = "m_cns"
dw_orden dw_orden
dw_oper dw_oper
st_1 st_1
sle_codigo sle_codigo
cb_1 cb_1
tab_1 tab_1
end type
global w_ope500_opersec w_ope500_opersec

type variables
Integer 	ii_tabpos
Long		il_tab2, il_tab3, il_tab4, il_tab5, il_tab6, il_tab7, il_tab8, il_tab9
String	is_articulo, is_doc_oc
Decimal	idc_saldo_fisico
end variables

forward prototypes
public subroutine of_get_opersec (string as_opersec)
public subroutine wf_reset_dw ()
end prototypes

public subroutine of_get_opersec (string as_opersec);Long ll_count

Select count(oper_sec) into :ll_count from operaciones where 
    oper_sec = :as_opersec;
if ll_count = 0 then
	Messagebox( "Error", "OperSec no existe")		
	Return
end if

is_articulo = as_opersec

tab_1.SelectTab(1)

dw_orden.Retrieve(as_opersec)
dw_oper.Retrieve(as_opersec)
tab_1.tabpage_1.dw_material.Retrieve(as_opersec)
tab_1.tabpage_2.dw_parte.Retrieve(as_opersec)
tab_1.tabpage_3.dw_programa.Retrieve(as_opersec)
tab_1.tabpage_4.dw_servicio.Retrieve(as_opersec)
tab_1.tabpage_5.dw_vale.Retrieve(as_opersec)

il_tab2 = 0
il_tab3 = 0
il_tab4 = 0
il_tab5 = 0

end subroutine

public subroutine wf_reset_dw ();dw_orden.Reset()
dw_oper.Reset()
tab_1.tabpage_1.dw_material.Reset()
tab_1.tabpage_2.dw_parte.Reset()
tab_1.tabpage_3.dw_programa.Reset()
tab_1.tabpage_4.dw_servicio.Reset()
tab_1.tabpage_5.dw_vale.Reset()

end subroutine

on w_ope500_opersec.create
int iCurrent
call super::create
if this.MenuName = "m_cns" then this.MenuID = create m_cns
this.dw_orden=create dw_orden
this.dw_oper=create dw_oper
this.st_1=create st_1
this.sle_codigo=create sle_codigo
this.cb_1=create cb_1
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_orden
this.Control[iCurrent+2]=this.dw_oper
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_codigo
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.tab_1
end on

on w_ope500_opersec.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_orden)
destroy(this.dw_oper)
destroy(this.st_1)
destroy(this.sle_codigo)
destroy(this.cb_1)
destroy(this.tab_1)
end on

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

im_1 = CREATE m_rButton      				// crear menu de boton derecho del mouse

dw_orden.SetTransObject(sqlca)
dw_oper.SetTransObject(sqlca)
tab_1.tabpage_1.dw_material.SetTransObject(sqlca)
tab_1.tabpage_2.dw_parte.SetTransObject(sqlca)
tab_1.tabpage_3.dw_programa.SetTransObject(sqlca)
tab_1.tabpage_4.dw_servicio.SetTransObject(sqlca)
tab_1.tabpage_5.dw_vale.SetTransObject(sqlca)


idw_query = tab_1.tabpage_1.dw_material

wf_reset_dw()
of_position_window(0,0)       			// Posicionar la ventana en forma fija


end event

event resize;call super::resize;tab_1.tabpage_1.dw_material.width  = newwidth  - tab_1.tabpage_1.dw_material.x - 10
tab_1.tabpage_1.dw_material.height = newheight - tab_1.tabpage_1.dw_material.y - 10

tab_1.tabpage_2.dw_parte.width  = tab_1.tabpage_2.width  - 50
tab_1.tabpage_2.dw_parte.height = tab_1.tabpage_2.height - 50  

tab_1.tabpage_3.dw_programa.width  = tab_1.tabpage_3.width  - 50
tab_1.tabpage_3.dw_programa.height = tab_1.tabpage_3.height - 50  

tab_1.tabpage_4.dw_servicio.width  = tab_1.tabpage_4.width - 50  
tab_1.tabpage_4.dw_servicio.height = tab_1.tabpage_4.height - 50  

tab_1.tabpage_5.dw_vale.width  = tab_1.tabpage_5.width - 50  
tab_1.tabpage_5.dw_vale.height = tab_1.tabpage_5.height - 50 


end event

type dw_orden from datawindow within w_ope500_opersec
integer x = 37
integer y = 160
integer width = 1262
integer height = 600
integer taborder = 30
string title = "none"
string dataobject = "d_cns_ot_ff"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_oper from datawindow within w_ope500_opersec
integer x = 1317
integer y = 32
integer width = 2354
integer height = 728
integer taborder = 40
string title = "none"
string dataobject = "d_list_operacion_ot_ff"
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ope500_opersec
integer x = 64
integer y = 44
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Oper Sec:"
boolean focusrectangle = false
end type

type sle_codigo from u_sle_codigo within w_ope500_opersec
integer x = 366
integer y = 32
integer taborder = 50
integer textsize = -8
integer weight = 700
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type cb_1 from commandbutton within w_ope500_opersec
integer x = 914
integer y = 36
integer width = 306
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String ls_cod

ls_cod = sle_codigo.text

//ls_cod = dw_master.object.oper_sec[dw_master.getrow()]
of_get_opersec( ls_cod )
end event

type tab_1 from tab within w_ope500_opersec
integer x = 73
integer y = 776
integer width = 3593
integer height = 1380
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
tabposition tabposition = tabsonbottomandtop!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

event selectionchanged;ii_tabpos = newindex 

CHOOSE CASE ii_tabpos
	CASE 2
		IF il_tab2 < 1 THEN il_tab2 = tab_1.tabpage_2.dw_parte.Retrieve(is_articulo)
	CASE 3
		IF il_tab3 < 1 THEN il_tab3 = tab_1.tabpage_3.dw_programa.Retrieve(is_articulo)
	CASE 4
		IF il_tab4 < 1 THEN il_tab4 = tab_1.tabpage_4.dw_servicio.Retrieve(is_articulo)
	CASE 5
		IF il_tab4 < 1 THEN il_tab4 = tab_1.tabpage_5.dw_vale.Retrieve(is_articulo)
END CHOOSE


end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3557
integer height = 1156
long backcolor = 79741120
string text = "Materiales "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_material dw_material
end type

on tabpage_1.create
this.dw_material=create dw_material
this.Control[]={this.dw_material}
end on

on tabpage_1.destroy
destroy(this.dw_material)
end on

type dw_material from u_dw_cns within tabpage_1
integer x = 23
integer y = 20
integer width = 3461
integer height = 928
integer taborder = 20
string dataobject = "d_lista_insumo_ot_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3557
integer height = 1156
long backcolor = 79741120
string text = "Parte Diario"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_parte dw_parte
end type

on tabpage_2.create
this.dw_parte=create dw_parte
this.Control[]={this.dw_parte}
end on

on tabpage_2.destroy
destroy(this.dw_parte)
end on

type dw_parte from u_dw_cns within tabpage_2
integer x = 64
integer y = 36
integer width = 3369
integer height = 956
string dataobject = "d_cns_pd_ot_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3557
integer height = 1156
long backcolor = 79741120
string text = "Programa"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_programa dw_programa
end type

on tabpage_3.create
this.dw_programa=create dw_programa
this.Control[]={this.dw_programa}
end on

on tabpage_3.destroy
destroy(this.dw_programa)
end on

type dw_programa from u_dw_cns within tabpage_3
integer x = 91
integer y = 76
integer width = 2848
integer height = 928
integer taborder = 20
string dataobject = "d_cns_prog_rh_det_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3557
integer height = 1156
long backcolor = 79741120
string text = "Orden de Servicio"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_servicio dw_servicio
end type

on tabpage_4.create
this.dw_servicio=create dw_servicio
this.Control[]={this.dw_servicio}
end on

on tabpage_4.destroy
destroy(this.dw_servicio)
end on

type dw_servicio from u_dw_cns within tabpage_4
integer x = 87
integer y = 60
integer width = 3333
integer height = 1016
integer taborder = 20
string dataobject = "d_cns_opersec_os_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3557
integer height = 1156
long backcolor = 79741120
string text = "Vale de Almacen"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_vale dw_vale
end type

on tabpage_5.create
this.dw_vale=create dw_vale
this.Control[]={this.dw_vale}
end on

on tabpage_5.destroy
destroy(this.dw_vale)
end on

type dw_vale from u_dw_cns within tabpage_5
integer x = 87
integer y = 64
integer width = 2766
integer height = 1036
integer taborder = 20
string dataobject = "d_cns_opersec_vale_alm_grd"
boolean vscrollbar = true
end type

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

