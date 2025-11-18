$PBExportHeader$w_cm506_articulos.srw
$PBExportComments$Muestra el pasado, presente y futuro de un articulo
forward
global type w_cm506_articulos from w_abc
end type
type tab_1 from tab within w_cm506_articulos
end type
type tabpage_1 from userobject within tab_1
end type
type dw_saldos from u_dw_cns within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_saldos dw_saldos
end type
type tabpage_2 from userobject within tab_1
end type
type dw_hist from u_dw_cns within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_hist dw_hist
end type
type tabpage_3 from userobject within tab_1
end type
type dw_proy from u_dw_cns within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_proy dw_proy
end type
type tabpage_5 from userobject within tab_1
end type
type dw_devoluciones from u_dw_cns within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_devoluciones dw_devoluciones
end type
type tabpage_6 from userobject within tab_1
end type
type dw_prestamo from u_dw_cns within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_prestamo dw_prestamo
end type
type tab_1 from tab within w_cm506_articulos
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
type dw_master from u_dw_abc within w_cm506_articulos
end type
end forward

global type w_cm506_articulos from w_abc
integer x = 9
integer y = 4
integer width = 3639
integer height = 2048
string title = "Consulta Especializada de Articulos (CM506)"
string menuname = "m_consulta"
tab_1 tab_1
dw_master dw_master
end type
global w_cm506_articulos w_cm506_articulos

type variables
Integer ii_tabpos
end variables

forward prototypes
public subroutine wf_reset_dw ()
public subroutine of_get_codigo (string as_cod_art)
end prototypes

public subroutine wf_reset_dw ();
tab_1.tabpage_1.dw_saldos.Reset()
tab_1.tabpage_2.dw_hist.Reset()
tab_1.tabpage_3.dw_proy.Reset()
//tab_1.tabpage_4.dw_saldos_x_almacen.Reset()
tab_1.tabpage_5.dw_devoluciones.Reset()
tab_1.tabpage_6.dw_prestamo.Reset()
tab_1.tabpage_1.dw_saldos.Insertrow(0)

end subroutine

public subroutine of_get_codigo (string as_cod_art);// Verifica si articulo existe
Long ll_count

Select count( cod_art) into :ll_count from articulo where 
    cod_art = :as_cod_art;
if ll_count = 0 then
	Messagebox( "Error", "Codigo no existe")		
	dw_master.SetColumn('cod_art')
	dw_master.SetFocus()
	Return
end if

dw_master.Retrieve(as_cod_art)
				dw_master.ShareData(tab_1.tabpage_1.dw_saldos)
//				IF dw_master.Rowcount() = 0 THEN
//					TriggerEvent('ue_insert')
//					wf_reset_dw()
//					Messagebox('Aviso','Codigo de Articulo no existe!')
//					dw_master.SetFocus()
//					dw_master.Setrow(dw_master.getrow())
//					dw_master.SetColumn('cod_art')
//					
//					Return 
//				ELSE
					tab_1.tabpage_2.dw_hist.Retrieve(as_cod_Art)
					tab_1.tabpage_3.dw_proy.Retrieve(as_cod_Art)
//					tab_1.tabpage_4.dw_saldos_x_almacen.retrieve(as_cod_Art)
					tab_1.tabpage_5.dw_devoluciones.Retrieve(as_cod_Art)
					tab_1.tabpage_6.dw_prestamo.Retrieve(as_cod_Art)					
//				END IF
end subroutine

on w_cm506_articulos.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_master
end on

on w_cm506_articulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.dw_saldos.width  = newwidth  - tab_1.tabpage_1.dw_saldos.x - 10
tab_1.tabpage_1.dw_saldos.height = newheight - tab_1.tabpage_1.dw_saldos.y - 10

tab_1.tabpage_2.dw_hist.width  = tab_1.tabpage_2.width  - 50
tab_1.tabpage_2.dw_hist.height = tab_1.tabpage_2.height - 50  

tab_1.tabpage_3.dw_proy.width  = tab_1.tabpage_3.width  - 50
tab_1.tabpage_3.dw_proy.height = tab_1.tabpage_3.height - 50  

// tab_1.tabpage_4 Ha sido Eliminado

tab_1.tabpage_5.dw_devoluciones.width  = tab_1.tabpage_5.width - 50  
tab_1.tabpage_5.dw_devoluciones.height = tab_1.tabpage_5.height - 50  

tab_1.tabpage_6.dw_prestamo.width  = tab_1.tabpage_6.width - 50  
tab_1.tabpage_6.dw_prestamo.height = tab_1.tabpage_6.height - 50  

end event

event ue_open_pre();call super::ue_open_pre;im_1 = CREATE m_rButton      				// crear menu de boton derecho del mouse


dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos

tab_1.tabpage_1.dw_saldos.SetTransObject(sqlca)
tab_1.tabpage_2.dw_hist.SetTransObject(sqlca)
tab_1.tabpage_3.dw_proy.SetTransObject(sqlca)
//tab_1.tabpage_4.dw_saldos_x_almacen.SetTransObject(sqlca)
tab_1.tabpage_5.dw_devoluciones.SetTransObject(sqlca)
tab_1.tabpage_6.dw_prestamo.SetTransObject(sqlca)
//--
dw_master.TriggerEvent('ue_insert')
wf_reset_dw()
idw_1 = dw_master              		// asignar dw corriente
of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event ue_print;call super::ue_print;String      ls_cadena
Str_cns_pop lstr_cns_pop

IF dw_master.getrow() = 0 THEN RETURN

ls_cadena = Trim(String(dw_master.Object.articulo_cod_art[1]))



IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN RETURN

lstr_cns_pop.arg[1] = ls_cadena
lstr_cns_pop.arg[2] = Trim(String(ii_tabpos - 1)) 
lstr_cns_pop.arg[3] = gs_empresa
lstr_cns_pop.arg[4] = gs_user




lstr_cns_pop.dataobject = 'd_rpt_especializado_x_articulo_com'
lstr_cns_pop.title = 'Consulta Epecializada Por Articulo'
lstr_cns_pop.width  = 3650
lstr_cns_pop.height = 1950

OpenSheetWithParm(w_rpt_pop, lstr_cns_pop, This, 2, Layered!)



end event

type tab_1 from tab within w_cm506_articulos
integer x = 5
integer y = 492
integer width = 3054
integer height = 988
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

event selectionchanging;ii_tabpos = newindex 
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3017
integer height = 860
long backcolor = 79741120
string text = "Saldos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Form!"
long picturemaskcolor = 553648127
dw_saldos dw_saldos
end type

on tabpage_1.create
this.dw_saldos=create dw_saldos
this.Control[]={this.dw_saldos}
end on

on tabpage_1.destroy
destroy(this.dw_saldos)
end on

type dw_saldos from u_dw_cns within tabpage_1
integer x = 14
integer y = 36
integer width = 1435
integer height = 496
boolean bringtotop = true
string dataobject = "d_cns_art_saldos_ff"
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3017
integer height = 860
long backcolor = 79741120
string text = "Mov.Historico"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ComputeToday5!"
long picturemaskcolor = 553648127
dw_hist dw_hist
end type

on tabpage_2.create
this.dw_hist=create dw_hist
this.Control[]={this.dw_hist}
end on

on tabpage_2.destroy
destroy(this.dw_hist)
end on

type dw_hist from u_dw_cns within tabpage_2
integer x = 14
integer y = 36
integer width = 517
integer height = 236
boolean bringtotop = true
string dataobject = "d_cns_articulo_movimiento_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3017
integer height = 860
long backcolor = 79741120
string text = "Mov.Proyectado"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "BrowseClasses!"
long picturemaskcolor = 553648127
dw_proy dw_proy
end type

on tabpage_3.create
this.dw_proy=create dw_proy
this.Control[]={this.dw_proy}
end on

on tabpage_3.destroy
destroy(this.dw_proy)
end on

type dw_proy from u_dw_cns within tabpage_3
integer x = 14
integer y = 36
integer width = 517
integer height = 236
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_articulo_movimiento_proy_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3017
integer height = 860
long backcolor = 79741120
string text = "Devoluciones"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Properties!"
long picturemaskcolor = 553648127
dw_devoluciones dw_devoluciones
end type

on tabpage_5.create
this.dw_devoluciones=create dw_devoluciones
this.Control[]={this.dw_devoluciones}
end on

on tabpage_5.destroy
destroy(this.dw_devoluciones)
end on

type dw_devoluciones from u_dw_cns within tabpage_5
integer x = 14
integer y = 36
integer width = 517
integer height = 236
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_articulo_devoluciones_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3017
integer height = 860
long backcolor = 79741120
string text = "Prestamos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Move!"
long picturemaskcolor = 553648127
dw_prestamo dw_prestamo
end type

on tabpage_6.create
this.dw_prestamo=create dw_prestamo
this.Control[]={this.dw_prestamo}
end on

on tabpage_6.destroy
destroy(this.dw_prestamo)
end on

type dw_prestamo from u_dw_cns within tabpage_6
integer x = 14
integer y = 36
integer width = 2985
integer height = 692
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_articulo_prestamo_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

type dw_master from u_dw_abc within w_cm506_articulos
integer x = 23
integer y = 52
integer width = 3003
integer height = 380
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_art_especializado_ff"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master				// dw_master
//idw_det  =  				// dw_detail
end event

event itemchanged;call super::itemchanged;Accepttext()
CHOOSE CASE dwo.name
		 CASE 'cod_art'			 
			 of_get_codigo( data )
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 
str_parametros sl_param


	OpenWithParm (w_pop_articulos, parent)
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' then
		this.object.cod_art[this.getrow()] = sl_param.field_ret[1]
		of_Get_codigo( sl_param.field_ret[1] )
 	END IF

end event

