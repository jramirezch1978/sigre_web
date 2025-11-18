$PBExportHeader$w_ap309_variac_proy.srw
forward
global type w_ap309_variac_proy from w_abc_master
end type
type dw_crosstab from datawindow within w_ap309_variac_proy
end type
type dw_graph from datawindow within w_ap309_variac_proy
end type
end forward

global type w_ap309_variac_proy from w_abc_master
integer width = 2729
integer height = 1972
string title = "Variación de proyeccion de aprovisionamiento de materia prima (AP309)"
string menuname = "m_mantto_smpl"
windowstate windowstate = maximized!
dw_crosstab dw_crosstab
dw_graph dw_graph
end type
global w_ap309_variac_proy w_ap309_variac_proy

on w_ap309_variac_proy.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.dw_crosstab=create dw_crosstab
this.dw_graph=create dw_graph
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_crosstab
this.Control[iCurrent+2]=this.dw_graph
end on

on w_ap309_variac_proy.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_crosstab)
destroy(this.dw_graph)
end on

event ue_update;call super::ue_update;messagebox(this.title, "Se han guardado las variaciones")
This.event ue_dw_share( )
dw_master.event ue_insert( )

end event

event ue_dw_share;call super::ue_dw_share;string ls_origen, ls_especie
integer li_ano
long ll_master, ll_cuenta

ll_master = dw_master.getrow( )

if ll_master <= 0 then return

ls_origen = dw_master.object.origen[ll_master]
ls_especie = dw_master.object.especie[ll_master]
li_ano = dw_master.object.ano[ll_master]

declare proy_varia procedure for
	usp_ap_proy_varia(:ls_origen, :ls_especie, :li_ano);

dw_crosstab.visible = false
dw_crosstab.reset( )

execute proy_varia;
fetch proy_varia into :ll_cuenta;
close proy_varia;
if ll_cuenta <= 0 then 
	messagebox(this.title, "No se han podido cargar los datos, pobablemente ~r las tablas de proyecciones de aprovisionamiento ~r se encuentren vacías.")
	return
end if

dw_crosstab.retrieve()
dw_crosstab.visible = true

dw_graph.retrieve()
dw_graph.visible = true

end event

event ue_query_retrieve;//idw_query.AcceptText()
//idw_query.Object.datawindow.querymode = 'no'
//idw_query.Retrieve()
this.event ue_dw_share( )
end event

event ue_open_pre;call super::ue_open_pre;dw_crosstab.settransobject(sqlca)
dw_crosstab.visible = false

dw_graph.settransobject(sqlca)
dw_graph.visible = false

dw_master.event ue_insert( )
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_crosstab.width  = newwidth  - dw_crosstab.x - 10
dw_graph.width  = newwidth  - dw_graph.x - 10
dw_graph.height = newheight - dw_graph.y - 10
end event

type dw_master from w_abc_master`dw_master within w_ap309_variac_proy
integer x = 0
integer y = 0
integer width = 2665
integer height = 440
string dataobject = "d_ap_proy_variacion_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::doubleclicked;call super::doubleclicked;integer li_null
date ld_hoy
string ls_sql, ls_column, ls_return1, ls_return2, ls_return3, ls_return4, ls_especie, ls_mes, ls_ano
ls_column = trim(lower(string(dwo.name)))


if ls_column = 'especie' then
	ls_sql = "select especie as Id, descr_especie as Descripcion from tg_especies where flag_estado <> '0'"
	f_lista(ls_sql, ls_return1, ls_return2, '2')
	if isnull(ls_return1) or trim(ls_return1) = '' then return 2
	this.object.especie[row] = ls_return1
	this.object.descr_especie[row] = ls_return2
	setnull(li_null)
	this.object.ano[row] = li_null
	this.object.mes[row] = li_null
elseif ls_column = 'ano' or ls_column = 'mes' or ls_column = 'flag_proveedor' or ls_column = 'flag_zona_descarga' then
	ls_especie = this.object.especie[row]
	if isnull(ls_especie) or trim(ls_especie) = '' then
		messagebox(this.title, "No se pueden mostrar periodos de proyección ~r Ingrese o seleccione una especie...", StopSign!)
		return
	end if

	ls_sql = "select c1 as ano, c2 as mes, proveedor as tipo_proveedor, zona_descarga as tipo_zona_descarga from vw_ap_variac_proy_periodo"
	
	f_lista_4ret_text(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, '1')
	if isnull(ls_return1) or trim(ls_return1) = '' then return 2
		
	choose case ls_return3
		case 'Recursos Propios'
			ls_return3 = 'F'
		case 'Otros Proveedores (Terceros)'
			ls_return3 = 'T'
		case 'No Aplica'
			ls_return3 = ''
	end choose

	choose case ls_return4
		case 'Playa'
			ls_return4 = 'Y'
		case 'Chata'
			ls_return4 = 'C'
		case 'Planta'
			ls_return4 = 'P'
		case 'Otros'
			ls_return4 = 'O'
	end choose
	
	this.object.ano[row] = integer(ls_return1)
	this.object.mes[row] = integer(mid(ls_return2,2,2))
	this.object.flag_proveedor[row] = ls_return3
	this.object.flag_zona_descarga[row] = ls_return4

end if
	

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_nombre

select nombre
	into :ls_nombre
	from origen
	where cod_origen = :gs_origen;

this.object.origen[al_row] = gs_origen
this.object.nombre[al_row] = ls_nombre
this.object.cod_usuario[al_row] = gs_user

end event

event dw_master::ue_insert;IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row
dw_master.reset( )
ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
//	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

type dw_crosstab from datawindow within w_ap309_variac_proy
integer x = 18
integer y = 476
integer width = 2665
integer height = 564
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_ap_proyec_varia_ctb"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_graph from datawindow within w_ap309_variac_proy
integer x = 23
integer y = 1076
integer width = 2656
integer height = 292
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_ap_proyec_varia_grf"
boolean border = false
boolean livescroll = true
end type

