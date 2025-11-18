$PBExportHeader$w_rh035_abc_conceptos_cuentas.srw
forward
global type w_rh035_abc_conceptos_cuentas from w_abc_master_smpl
end type
type uo_cabecera from u_cst_quick_search within w_rh035_abc_conceptos_cuentas
end type
end forward

global type w_rh035_abc_conceptos_cuentas from w_abc_master_smpl
integer width = 2976
integer height = 2108
string title = "(RH035) Cuentas Contables y Presupuestales por Conceptos"
string menuname = "m_master_simple"
uo_cabecera uo_cabecera
end type
global w_rh035_abc_conceptos_cuentas w_rh035_abc_conceptos_cuentas

type variables
string is_codigo

end variables

on w_rh035_abc_conceptos_cuentas.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.uo_cabecera=create uo_cabecera
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_cabecera
end on

on w_rh035_abc_conceptos_cuentas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_cabecera)
end on

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.concep.Protect)
IF li_protect = 0 THEN
   dw_master.Object.concep.Protect = 1
END IF
li_protect = integer(dw_master.Object.tipo_trabajador.Protect)
IF li_protect = 0 THEN
   dw_master.Object.tipo_trabajador.Protect = 1
END IF

end event

event ue_open_pre;// Override
im_1 = CREATE m_rButton      				// crear menu de boton derecho del mouse
idw_1 = dw_master             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master
ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

// Posicionando ventana
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

// Seteando objeto quick_search (uo_1).
uo_cabecera.of_set_dw('d_concepto_lista_tbl')
uo_cabecera.of_set_field('concep')

// Capturando información
uo_cabecera.of_retrieve_lista()
uo_cabecera.of_sort_lista()
uo_cabecera.of_protect()

THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()
end event

event resize;// Override
uo_cabecera.width  = newwidth  - uo_cabecera.x - 10

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update_pre;call super::ue_update_pre;string ls_cuenta_deb, ls_cuenta_hab, ls_cuenta_prsp
integer li_row

ib_update_check = false


if dw_master.RowCount() = 0 then 
	ib_update_check = true
	return
end if

if not gnvo_app.of_row_processing( dw_master ) then return


dw_master.of_set_flag_replicacion( )

ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh035_abc_conceptos_cuentas
event ue_display ( string as_columna,  long al_row )
integer y = 1004
integer width = 2528
integer height = 732
string dataobject = "d_cuentas_conceptos_tbl"
end type

event dw_master::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_cnta_cntbl 	lstr_cnta

choose case lower(as_columna)
		
	case "origen"
		
		ls_sql = "select cod_origen as codigo_origen, " &
				 + "nombre as nombre_origen " &
				 + "from origen " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.origen	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cnta_cntbl_debe"

		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.cnta_cntbl_debe [al_row] = lstr_cnta.cnta_cntbl
			this.ii_update = 1
		end if

		/*
		ls_sql = "SELECT CNTA_CTBL AS Cuenta_contable, " &
				  + "DESC_CNTA AS DESCRIPCION_cuenta " &
				  + "FROM cntbl_cnta " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "  and flag_permite_mov = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_cntbl_debe	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		*/
	case "cnta_cntbl_haber"

		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.cnta_cntbl_haber [al_row] = lstr_cnta.cnta_cntbl
			this.ii_update = 1
		end if
		
		/*
		ls_sql = "SELECT CNTA_CTBL AS Cuenta_contable, " &
				  + "DESC_CNTA AS DESCRIPCION_cuenta " &
				  + "FROM cntbl_cnta " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "  and flag_permite_mov = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_cntbl_haber	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		*/
		
	case "cnta_cntbl_debe_veda"
		
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.cnta_cntbl_debe_veda [al_row] = lstr_cnta.cnta_cntbl
			this.ii_update = 1
		end if
		
		/*
		ls_sql = "SELECT CNTA_CTBL AS Cuenta_contable, " &
				  + "DESC_CNTA AS DESCRIPCION_cuenta " &
				  + "FROM cntbl_cnta " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "  and flag_permite_mov = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_cntbl_debe_veda	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		*/
		
	case "devengado"
		
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.devengado [al_row] = lstr_cnta.cnta_cntbl
			this.ii_update = 1
		end if
		
		/*
		ls_sql = "SELECT CNTA_CTBL AS Cuenta_contable, " &
				  + "DESC_CNTA AS DESCRIPCION_cuenta " &
				  + "FROM cntbl_cnta " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "  and flag_permite_mov = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.devengado	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		*/
		
	case "cnta_prsp"

		ls_sql = "SELECT CNTA_PRSP AS CODIGO, " &
				  + "DESCRIPCION AS DESC_CUENTA " &
				  + "FROM PRESUPUESTO_CUENTA " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "tipo_trabajador"
		
		ls_sql = "select tt.tipo_trabajador as tipo_trabajador, " &
				 + "tt.desc_tipo_tra as descripcion_tipo_trabajador " &
				 + "from tipo_trabajador tt, " &
				 + "     tipo_trabajador_user ttu " &
				 + "where tt.tipo_trabajador = ttu.tipo_trabajador " &
				 + "  and ttu.cod_usr        = '" + gs_user + "'" &
				 + "  and tt.flag_estado 	  = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_trabajador	[al_row] = ls_codigo
			this.object.desc_tipo_tra		[al_row] = ls_data
			this.ii_update = 1
		end if			
end choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("concep.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("tipo_trabajador.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cnta_cntbl_debe.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cnta_cntbl_debe_veda.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cnta_cntbl_haber.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cnta_prsp.Protect='1~tIf(IsRowNew(),0,1)'")

// Datos que se asignan en automático
this.setitem(al_row,"concep",is_codigo)

int li_protect

li_protect = integer(dw_master.Object.concep.Protect)
IF li_protect = 0 THEN
   dw_master.Object.concep.Protect = 1
END IF
end event

event dw_master::constructor;is_dwform = 'tabular'  // tabular, grid, form (default)
ii_ck[1] = 1
ii_ck[2] = 2
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0

	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc

dw_master.Accepttext()
Accepttext()

CHOOSE CASE dwo.name
	CASE 'tipo_trabajador'
		
		// Verifica que codigo ingresado exista			
		select tt.desc_tipo_tra
			into :ls_desc
		from 	tipo_trabajador tt,
     			tipo_trabajador_user ttu
		where tt.tipo_trabajador = ttu.tipo_trabajador
 	 	  and ttu.cod_usr        = :gs_user
		  and tt.flag_estado		 = '1'
		  and tt.tipo_trabajador = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Tipo de trabajador " + data + " no existe, no se encuentra activo o usted no tiene acceso, por favor verifique")
			this.object.tipo_trabajador	[row] = gnvo_app.is_null
			this.object.desc_tipo_tra		[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_tipo_trab		[row] = ls_desc

END CHOOSE
end event

type uo_cabecera from u_cst_quick_search within w_rh035_abc_conceptos_cuentas
integer width = 2487
integer height = 980
integer taborder = 10
boolean bringtotop = true
end type

on uo_cabecera.destroy
call u_cst_quick_search::destroy
end on

event ue_retorno;call super::ue_retorno;dw_master.Retrieve(aa_id)
is_codigo=aa_id
end event

