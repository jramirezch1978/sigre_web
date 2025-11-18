$PBExportHeader$w_rh123_abc_mov_inasistencia.srw
forward
global type w_rh123_abc_mov_inasistencia from w_abc_master
end type
type uo_cabecera from u_cst_quick_search within w_rh123_abc_mov_inasistencia
end type
end forward

global type w_rh123_abc_mov_inasistencia from w_abc_master
integer width = 3154
integer height = 1912
string title = "(RH123) Control de Inasistencia "
string menuname = "m_master_simple"
uo_cabecera uo_cabecera
end type
global w_rh123_abc_mov_inasistencia w_rh123_abc_mov_inasistencia

type variables
STRING is_codigo
end variables

on w_rh123_abc_mov_inasistencia.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.uo_cabecera=create uo_cabecera
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_cabecera
end on

on w_rh123_abc_mov_inasistencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_cabecera)
end on

event ue_open_pre;call super::ue_open_pre;
// Asignando datos para constuir el quick-search
uo_cabecera.of_set_dw('d_maestro_lista_tbl')
uo_cabecera.of_set_field('nombres')

uo_cabecera.of_retrieve_lista(gs_origen)
uo_cabecera.of_sort_lista()
uo_cabecera.of_protect()

end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

ib_update_check = true

dw_master.of_set_flag_replicacion( )
end event

event resize;call super::resize;uo_cabecera.width  = newwidth  - uo_cabecera.x - 10

end event

type dw_master from w_abc_master`dw_master within w_rh123_abc_mov_inasistencia
event ue_display ( string as_columna,  long al_row )
integer y = 1068
integer width = 3077
integer height = 576
string dataobject = "d_mov_inasistencia_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_display;boolean 	lb_ret
string 	ls_sql, ls_concep, ls_desc_concep

this.AcceptText()

choose case lower(as_columna)
		

	CASE "concep"
		
		ls_sql = "SELECT CONCEP as codigo_concepto, " &
			    + "		  DESC_concep as descripcion_concepto " &
				 + "FROM CONCEPTO c, " &
				 + "		grupo_calculo_det gcd, " &
				 + "		RRHHPARAM_CCONCEP r " &
				 + "WHERE gcd.concepto_calc = c.concep " &
				 + "  and gcd.grupo_calculo = r.grp_calc_inasistencia " &
				 + "  and c.flag_estado = '1' " &
				 + "ORDER BY 1 ASC "   
				 
		lb_ret = f_lista(ls_sql, ls_concep, ls_desc_concep, '1')
		
		if ls_concep <> '' then
			this.object.concep				[al_row] = ls_concep
			this.object.desc_concepto		[al_row] = ls_desc_concep
			
			this.ii_update = 1
		end if

	
end choose

end event

event dw_master::constructor;is_dwform = 'tabular'  // tabular, grid, form (default)
ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;integer 	li_periodo 
String 	ls_mensaje

//Validacion para ingresar un registro
dw_master.Modify("concep.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("fec_desde.Protect='1~tIf(IsRowNew(),0,1)'")

// Datos que se ingresan automáticamente
this.object.cod_trabajador [al_row] = is_codigo
this.object.cod_usr			[al_row] = gs_user


this.setColumn('fec_movim')


end event

event dw_master::itemchanged;call super::itemchanged;date 		ld_fec_desde, ld_fec_hasta, ldt_fecha
string 	ls_fec_hasta, ls_desc, ls_null
Integer 	li_dias, li_count

SetNull(ls_null)

dw_master.Accepttext()

choose case dwo.name
	case 'concep'
		SELECT DESC_concep 
			into :ls_desc
		FROM 	CONCEPTO		c, 
				grupo_calculo_det gcd, 
				RRHHPARAM_CCONCEP r 
		WHERE gcd.concepto_calc = c.concep 
		  and gcd.grupo_calculo = r.grp_calc_inasistencia 
		  and c.flag_estado = '1' 
		  and c.concep = :data;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Error', 'Código de Concepto no existe, no está activo ' &
							+ 'o no es un concepto válido para el grupo ')
			this.object.concep 			[row] = ls_null
			this.object.desc_concepto 	[row] = ls_null
			return 1
		end if
		
		this.object.desc_concepto [row] = ls_desc
				 
	CASE 'fec_desde'
		
		setNull(ld_fec_hasta)
		this.object.fec_hasta 		[row] = ld_fec_hasta
		this.object.dias_inasist 	[row] = 0.00
		this.SetColumn("fec_hasta")
		this.Setfocus()
		return 1

	CASE 'fec_hasta'
		
		//Fecha Inicial es NULA
		ld_fec_desde= date(dw_master.object.fec_desde [row])   
		
		If isnull(ld_fec_desde) then
		  messagebox("Error","Ingrese una Fecha Inicial, por favor verifique")
		  this.object.dias_inasist [row] = 0.00
		  this.SetColumn("fec_desde")
		  this.Setfocus()
		  return 1
		End if 	  
		
		//Verificar que la Fecha FINAL sea mayor que la Fecha INICIAL
		ld_fec_hasta=date(mid(data,1,10))   		  
		
		IF ld_fec_hasta < ld_fec_desde THEN 
			messagebox("Error","La fecha Final debe ser "+&
						"mayor que la Fecha Inicial")
			setNull(ld_fec_hasta)
			this.object.fec_hasta [row] = ld_fec_hasta
		  	Return 1
		end if
		
		//Numero de Dias a Calcular 
		li_dias=DaysAfter(ld_fec_desde,ld_fec_hasta) + 1
		this.object.dias_inasist [row] = li_dias
	
	case "periodo_inicio"
		
		select count(*)
			into :li_count
		from rrhh_vacaciones_trabaj t
		where t.cod_trabajador = :is_codigo
		  and t.periodo_inicio = :data
		  and t.dias_totales > t.dias_gozados
		  and t.flag_estado = '1';
	 	
		if li_count  = 0 then
			MessageBox('Error', "Error en el ingreso del periodo de inicio, esto se puede deber a:" &
								+ "~r~n1.- No existe el periodo de inicio vacacional para el trabaajdor "&
								+ "~r~n2.- El periodo de inicio no se encuentra activo " &
								+ "~r~n3.- Ya completo los días de vacaciones en el periodo indicado ")
			setNull(li_dias)
			this.object.periodo_inicio [row] = li_dias
			return 1
		end if
		
end choose 


end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

type uo_cabecera from u_cst_quick_search within w_rh123_abc_mov_inasistencia
integer y = 12
integer width = 1641
integer height = 1044
integer taborder = 10
boolean bringtotop = true
end type

on uo_cabecera.destroy
call u_cst_quick_search::destroy
end on

event ue_retorno;call super::ue_retorno;dw_master.Retrieve(aa_id)
is_codigo=aa_id
end event

