$PBExportHeader$w_cam012_formulas.srw
forward
global type w_cam012_formulas from w_abc_master_smpl
end type
end forward

global type w_cam012_formulas from w_abc_master_smpl
integer width = 2779
integer height = 2044
string title = "[CAM012] Formulas"
string menuname = "m_abc_anular_lista"
end type
global w_cam012_formulas w_cam012_formulas

type variables
end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve (integer ai_reckey)
end prototypes

public function integer of_set_numera ();integer li_id

if is_action = 'new' then
	select NVL(max(reckey),0) + 1
		into :li_id
	from campo_formulas;
	
	idw_1.object.reckey[idw_1.getRow()] = li_id
end if

return 1

end function

public subroutine of_retrieve (integer ai_reckey);Long ll_row

ll_row = dw_master.retrieve(ai_reckey)
is_action = 'open'

return 
end subroutine

on w_cam012_formulas.create
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
end on

on w_cam012_formulas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Modify("form_cant_bruta.Visible='1~tIf(flag_cant_bruta=~"C~",1,0)'")
idw_1.Modify("form_cant_neta.Visible='1~tIf(flag_cant_neta=~"C~",1,0)'")
idw_1.Modify("form_impureza.Visible='1~tIf(flag_impureza=~"C~",1,0)'")
idw_1.Modify("form_brix.Visible='1~tIf(flag_brix=~"C~",1,0)'")
idw_1.Modify("form_pol.Visible='1~tIf(flag_pol=~"C~",1,0)'")
idw_1.Modify("form_pureza.Visible='1~tIf(flag_pureza=~"C~",1,0)'")
idw_1.Modify("form_reductores.Visible='1~tIf(flag_reductores=~"C~",1,0)'")
idw_1.Modify("form_cana.Visible='1~tIf(flag_cana=~"C~",1,0)'")
idw_1.Modify("form_jaba.Visible='1~tIf(flag_jaba=~"C~",1,0)'")
idw_1.Modify("form_quintales.Visible='1~tIf(flag_quintales=~"C~",1,0)'")
idw_1.Modify("form_bolsas.Visible='1~tIf(flag_bolsas=~"C~",1,0)'")
idw_1.Modify("form_bls_neto.Visible='1~tIf(flag_bls_neto=~"C~",1,0)'")
idw_1.Modify("form_bls_total.Visible='1~tIf(flag_bls_total=~"C~",1,0)'")
idw_1.Modify("form_melaza.Visible='1~tIf(flag_melaza=~"C~",1,0)'")
idw_1.Modify("form_kgs_tmc.Visible='1~tIf(flag_kgs_tmc=~"C~",1,0)'")
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

ib_update_check = true

dw_master.of_set_flag_replicacion()

if of_set_numera	() = 0 then return
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_formulas_tbl'
sl_param.titulo = 'Formulas'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(integer(sl_param.field_ret[1]))
END IF
end event

type dw_master from w_abc_master_smpl`dw_master within w_cam012_formulas
integer width = 2702
integer height = 1832
string dataobject = "d_abc_formulas_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado		[al_row] = '1'
this.object.fec_vigencia	[al_row] = f_fecha_Actual()

this.object.flag_cant_bruta	[al_row] = 'I'
this.object.flag_cant_neta		[al_row] = 'I'
this.object.flag_impureza		[al_row] = 'I'
this.object.flag_brix			[al_row] = 'I'
this.object.flag_pol				[al_row] = 'I'
this.object.flag_pureza			[al_row] = 'I'
this.object.flag_reductores	[al_row] = 'I'
this.object.flag_cana			[al_row] = 'I'
this.object.flag_jaba			[al_row] = 'I'
this.object.flag_quintales		[al_row] = 'I'
this.object.flag_bolsas			[al_row] = 'I'
this.object.flag_bls_neto		[al_row] = 'I'
this.object.flag_bls_total		[al_row] = 'I'
this.object.flag_melaza			[al_row] = 'I'
this.object.flag_kgs_tmc		[al_row] = 'I'


is_action = "new"

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cod_ingenio"
		ls_sql = "SELECT cod_ingenio AS codigo_ingenio, " &
				  + "desc_ingenio AS descripcion_ingenio " &
				  + "FROM campo_ingenio " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_ingenio		[al_row] = ls_codigo
			this.object.desc_ingenio	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_mov"
		ls_sql = "SELECT tipo_mov AS tipo_movimiento, " &
				  + "desc_tipo_mov AS descripcion_tipo_movimiento " &
				  + "FROM articulo_mov_tipo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_mov			[al_row] = ls_codigo
			this.object.desc_tipo_mov	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count, ll_nro_lineas, ll_nro_plantas, ll_total_plantas

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cencos'
		
		// Verifica que codigo ingresado exista			
		Select desc_cencos
	     into :ls_desc1
		  from centros_costo
		 Where cencos = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Costo o no se encuentra activo, por favor verifique")
			this.object.cencos		[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			return 1
			
		end if

		this.object.desc_cencos		[row] = ls_desc1

	CASE 'cod_sector'
		
		// Verifica que codigo ingresado exista			
		Select desc_sector
	     into :ls_desc1
		  from sector_campo
		 Where cod_sector = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Costo o no se encuentra activo, por favor verifique")
			this.object.cod_sector	[row] = ls_null
			this.object.desc_sector	[row] = ls_null
			return 1
			
		end if

		this.object.desc_sector		[row] = ls_desc1

	CASE 'centro_benef'
		
		// Verifica que codigo ingresado exista			
		Select desc_centro
	     into :ls_desc1
		  from centro_beneficio
		 Where centro_benef = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Beneficio o no se encuentra activo, por favor verifique")
			this.object.centro_benef	[row] = ls_null
			this.object.desc_centro		[row] = ls_null
			return 1
			
		end if

		this.object.desc_centro		[row] = ls_desc1
	
	case 'nro_lineas', 'nro_plantas'
		
		ll_nro_lineas = integer(this.object.nro_lineas[row])
		ll_nro_plantas= integer(this.object.nro_plantas[row])
		
		this.object.total_plantas [row] = ll_nro_lineas * ll_nro_plantas
		
		
END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_dwform =  'form'   // tabular,grid,form
ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

