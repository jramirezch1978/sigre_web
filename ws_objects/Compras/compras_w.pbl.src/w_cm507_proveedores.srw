$PBExportHeader$w_cm507_proveedores.srw
forward
global type w_cm507_proveedores from w_abc
end type
type dw_master from u_dw_abc within w_cm507_proveedores
end type
type tab_1 from tab within w_cm507_proveedores
end type
type tabpage_1 from userobject within tab_1
end type
type dw_compras from u_dw_cns within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_compras dw_compras
end type
type tabpage_2 from userobject within tab_1
end type
type dw_pendientes from u_dw_cns within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_pendientes dw_pendientes
end type
type tabpage_3 from userobject within tab_1
end type
type dw_tiempo from u_dw_cns within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_tiempo dw_tiempo
end type
type tabpage_4 from userobject within tab_1
end type
type dw_atencion from u_dw_cns within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_atencion dw_atencion
end type
type tabpage_5 from userobject within tab_1
end type
type dw_precios from u_dw_cns within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_precios dw_precios
end type
type tabpage_6 from userobject within tab_1
end type
type dw_devoluciones from u_dw_cns within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_devoluciones dw_devoluciones
end type
type tabpage_7 from userobject within tab_1
end type
type dw_ctacte from u_dw_cns within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_ctacte dw_ctacte
end type
type tab_1 from tab within w_cm507_proveedores
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type
end forward

global type w_cm507_proveedores from w_abc
integer x = 5
integer y = 4
integer width = 3634
integer height = 2016
string title = "Consulta Especializada por Proveedor (CM507)"
string menuname = "m_consulta_impresion"
dw_master dw_master
tab_1 tab_1
end type
global w_cm507_proveedores w_cm507_proveedores

type variables
Integer ii_tabpos
end variables

forward prototypes
public subroutine wf_reset ()
public subroutine wf_precios_prod (string as_data)
public subroutine of_get_codigo (string as_codigo)
end prototypes

public subroutine wf_reset ();dw_master.Reset()
tab_1.tabpage_1.dw_compras.Reset()
tab_1.tabpage_2.dw_pendientes.Reset()
tab_1.tabpage_3.dw_tiempo.Reset()
tab_1.tabpage_4.dw_atencion.Reset()
tab_1.tabpage_5.dw_precios.Reset()
tab_1.tabpage_6.dw_devoluciones.Reset()
ROLLBACK;
dw_master.TriggerEvent('ue_insert')
end subroutine

public subroutine wf_precios_prod (string as_data);string	ls_msg
DECLARE USP_CMP_PRECIO_PROM_ART_X_PROV PROCEDURE FOR 
		USP_CMP_PRECIO_PROM_ART_X_PROV(:as_data);
EXECUTE USP_CMP_PRECIO_PROM_ART_X_PROV;

IF SQLCA.SQLCODE = -1 THEN
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_CMP_PRECIO_PROM_ART_X_PROV", ls_msg)
	Return
END IF

CLOSE USP_CMP_PRECIO_PROM_ART_X_PROV;
end subroutine

public subroutine of_get_codigo (string as_codigo);dw_master.Retrieve(as_codigo)
IF dw_master.Rowcount() = 0 THEN
	wf_reset()
	Messagebox('Aviso','Codigo de Proveedor no existe!')
		
	dw_master.SetFocus()
	dw_master.Setrow(dw_master.getrow())
	dw_master.SetColumn('proveedor')
	Return 
ELSE
	wf_precios_prod(as_codigo)
	tab_1.tabpage_1.dw_compras.retrieve(as_codigo)
	tab_1.tabpage_2.dw_pendientes.retrieve('3',as_codigo)
	tab_1.tabpage_3.dw_tiempo.retrieve(as_codigo)
	tab_1.tabpage_4.dw_atencion.retrieve('1',as_codigo)
	tab_1.tabpage_5.dw_precios.retrieve()
	tab_1.tabpage_6.dw_devoluciones.retrieve(as_codigo)					
END IF				
end subroutine

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width  = newwidth  - tab_1.x - 20
tab_1.height = newheight - tab_1.y - 40

tab_1.tabpage_1.dw_compras.width  = newwidth  - tab_1.tabpage_1.dw_compras.x - 200
tab_1.tabpage_1.dw_compras.height = newheight - tab_1.tabpage_1.dw_compras.y - 600

tab_1.tabpage_2.dw_pendientes.width  = newwidth  - tab_1.tabpage_2.dw_pendientes.x - 200
tab_1.tabpage_2.dw_pendientes.height = newheight - tab_1.tabpage_2.dw_pendientes.y - 600


tab_1.tabpage_3.dw_tiempo.width  = newwidth  - tab_1.tabpage_3.dw_tiempo.x - 200
tab_1.tabpage_3.dw_tiempo.height = newheight - tab_1.tabpage_3.dw_tiempo.y - 600

tab_1.tabpage_4.dw_atencion.width  = newwidth  - tab_1.tabpage_4.dw_atencion.x - 200
tab_1.tabpage_4.dw_atencion.height = newheight - tab_1.tabpage_4.dw_atencion.y - 600

tab_1.tabpage_5.dw_precios.width  = newwidth  - tab_1.tabpage_5.dw_precios.x - 200
tab_1.tabpage_5.dw_precios.height = newheight - tab_1.tabpage_5.dw_precios.y - 600

tab_1.tabpage_6.dw_devoluciones.width  = newwidth  - tab_1.tabpage_6.dw_devoluciones.x - 200
tab_1.tabpage_6.dw_devoluciones.height = newheight - tab_1.tabpage_6.dw_devoluciones.y - 600

tab_1.tabpage_7.dw_ctacte.width  = newwidth  - tab_1.tabpage_7.dw_ctacte.x - 200
tab_1.tabpage_7.dw_ctacte.height = newheight - tab_1.tabpage_7.dw_ctacte.y - 600


end event

on w_cm507_proveedores.create
int iCurrent
call super::create
if this.MenuName = "m_consulta_impresion" then this.MenuID = create m_consulta_impresion
this.dw_master=create dw_master
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.tab_1
end on

on w_cm507_proveedores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.tab_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
tab_1.tabpage_1.dw_compras.SettransObject(sqlca)
tab_1.tabpage_2.dw_pendientes.SettransObject(sqlca)
tab_1.tabpage_3.dw_tiempo.SettransObject(sqlca)
tab_1.tabpage_4.dw_atencion.SettransObject(sqlca)
tab_1.tabpage_5.dw_precios.SettransObject(sqlca)
tab_1.tabpage_6.dw_devoluciones.SettransObject(sqlca)
//dw_lista.SetTransObject(sqlca)

wf_reset()
idw_1 = dw_master              		// asignar dw corriente
of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event ue_print();call super::ue_print;String      ls_cadena
Str_seleccionar lstr_seleccionar

IF dw_master.getrow() = 0 THEN RETURN

ls_cadena = Trim(String(dw_master.Object.proveedor[1]))



IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN RETURN

lstr_seleccionar.s[1] = ls_cadena
lstr_seleccionar.s[2] = '3'
lstr_seleccionar.s[3] = '1'
lstr_seleccionar.s[4] = gs_empresa
lstr_seleccionar.s[5] = gs_user
lstr_seleccionar.s[6] = Trim(String(ii_tabpos)) 


lstr_seleccionar.title = 'Consulta Epecializada Por Proveedor'
lstr_seleccionar.width  = 3650
lstr_seleccionar.height = 1950

OpenSheetWithParm(w_cm507_proveedor_especif, lstr_seleccionar, This, 2, Layered!)

end event

type dw_master from u_dw_abc within w_cm507_proveedores
integer x = 14
integer y = 32
integer width = 3177
integer height = 368
boolean bringtotop = true
string dataobject = "d_cns_prov_especializado_ff"
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

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;Accepttext()

CHOOSE CASE dwo.name
		 CASE 'proveedor'
			 of_get_codigo(data)				
END CHOOSE

end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda
string ls_sql, ls_codigo, ls_data
boolean	lb_ret

if dwo.name = 'b_prov' then
	ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
			 + "nom_proveedor AS nombre_proveedor, " &
			 + "ruc AS ruc_proveedor " &
			 + "FROM proveedor " &
			 + "where flag_estado = '1'"
			 
	lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
	if ls_codigo <> '' then
		this.object.proveedor	[row] = ls_codigo
		of_Get_codigo( ls_codigo )
	end if
	
end if		
end event

type tab_1 from tab within w_cm507_proveedores
integer x = 14
integer y = 432
integer width = 3191
integer height = 864
integer taborder = 20
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
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
end on

event selectionchanging;ii_tabpos = newindex 
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3154
integer height = 736
long backcolor = 79741120
string text = "Compras"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Move!"
long picturemaskcolor = 553648127
dw_compras dw_compras
end type

on tabpage_1.create
this.dw_compras=create dw_compras
this.Control[]={this.dw_compras}
end on

on tabpage_1.destroy
destroy(this.dw_compras)
end on

type dw_compras from u_dw_cns within tabpage_1
integer width = 3141
integer height = 600
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_proveedor_orden_compra_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
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
integer width = 3154
integer height = 736
long backcolor = 79741120
string text = "Pendientes"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom024!"
long picturemaskcolor = 553648127
dw_pendientes dw_pendientes
end type

on tabpage_2.create
this.dw_pendientes=create dw_pendientes
this.Control[]={this.dw_pendientes}
end on

on tabpage_2.destroy
destroy(this.dw_pendientes)
end on

type dw_pendientes from u_dw_cns within tabpage_2
integer width = 2926
integer height = 608
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_proveedor_orden_compra_pend_tbl"
boolean hscrollbar = true
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
integer width = 3154
integer height = 736
long backcolor = 79741120
string text = "Tiempo Entrega"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ComputePage5!"
long picturemaskcolor = 553648127
dw_tiempo dw_tiempo
end type

on tabpage_3.create
this.dw_tiempo=create dw_tiempo
this.Control[]={this.dw_tiempo}
end on

on tabpage_3.destroy
destroy(this.dw_tiempo)
end on

type dw_tiempo from u_dw_cns within tabpage_3
integer width = 2926
integer height = 668
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_proveedor_art_x_tiempo_ent_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3154
integer height = 736
long backcolor = 79741120
string text = "Atención"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom038!"
long picturemaskcolor = 553648127
dw_atencion dw_atencion
end type

on tabpage_4.create
this.dw_atencion=create dw_atencion
this.Control[]={this.dw_atencion}
end on

on tabpage_4.destroy
destroy(this.dw_atencion)
end on

type dw_atencion from u_dw_cns within tabpage_4
integer width = 2926
integer height = 668
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_proveedor_orden_compra_atend_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3154
integer height = 736
long backcolor = 79741120
string text = "Precios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "FormatDollar!"
long picturemaskcolor = 553648127
dw_precios dw_precios
end type

on tabpage_5.create
this.dw_precios=create dw_precios
this.Control[]={this.dw_precios}
end on

on tabpage_5.destroy
destroy(this.dw_precios)
end on

type dw_precios from u_dw_cns within tabpage_5
integer width = 2926
integer height = 668
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_proveedor_articulo_precio_cross"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3154
integer height = 736
long backcolor = 79741120
string text = "Devoluciones"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom044!"
long picturemaskcolor = 553648127
dw_devoluciones dw_devoluciones
end type

on tabpage_6.create
this.dw_devoluciones=create dw_devoluciones
this.Control[]={this.dw_devoluciones}
end on

on tabpage_6.destroy
destroy(this.dw_devoluciones)
end on

type dw_devoluciones from u_dw_cns within tabpage_6
integer width = 2926
integer height = 668
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_proveedor_art_devueltos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3154
integer height = 736
long backcolor = 79741120
string text = "Cta. Cte."
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ArrangeTables!"
long picturemaskcolor = 553648127
dw_ctacte dw_ctacte
end type

on tabpage_7.create
this.dw_ctacte=create dw_ctacte
this.Control[]={this.dw_ctacte}
end on

on tabpage_7.destroy
destroy(this.dw_ctacte)
end on

type dw_ctacte from u_dw_cns within tabpage_7
integer width = 2926
integer height = 668
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
 

end event

