$PBExportHeader$w_cam301_proy_horas_jornal.srw
forward
global type w_cam301_proy_horas_jornal from w_abc_mastdet_smpl
end type
type uo_fechas from u_ingreso_rango_fechas within w_cam301_proy_horas_jornal
end type
type cb_procesar from commandbutton within w_cam301_proy_horas_jornal
end type
end forward

global type w_cam301_proy_horas_jornal from w_abc_mastdet_smpl
integer width = 2437
integer height = 2288
string title = "[CAM301] Proyección de Horas Jornaleros"
string menuname = "m_abc_master_smpl"
uo_fechas uo_fechas
cb_procesar cb_procesar
end type
global w_cam301_proy_horas_jornal w_cam301_proy_horas_jornal

on w_cam301_proy_horas_jornal.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.uo_fechas=create uo_fechas
this.cb_procesar=create cb_procesar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_procesar
end on

on w_cam301_proy_horas_jornal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_procesar)
end on

event ue_insert;//Override
Long  ll_row

if idw_1 = dw_detail then
	ll_row = idw_1.Event ue_insert()
	
	IF ll_row <> -1 THEN
		THIS.EVENT ue_insert_pos(ll_row)
	end if
end if

end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0   //hace que no se haga el retrieve del dw_master


end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cam301_proy_horas_jornal
integer x = 0
integer y = 136
integer width = 2162
integer height = 932
string dataobject = "d_list_lote_campo_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle


end event

event dw_master::ue_output;call super::ue_output;date 		ld_fecha1, ld_fecha2
string 	ls_nro_lote

ls_nro_lote = this.object.nro_lote [al_row]
ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )

dw_detail.retrieve( ls_nro_lote, ld_fecha1, ld_fecha2)
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;this.event ue_output(currentrow)
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cam301_proy_horas_jornal
integer x = 0
integer y = 1092
integer width = 1865
integer height = 944
string dataobject = "d_abc_proy_hrs_jornal_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 3				// columnas de lectrua de este dw
ii_ck[3] = 4				// columnas de lectrua de este dw
ii_ck[4] = 6				// columnas de lectrua de este dw

ii_rk[1] = 3 	      // columnas que recibimos del master


end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro	[al_row] = f_fecha_Actual()
this.object.fec_programada	[al_row] = uo_fechas.of_get_fecha1( )

// Inicializo las horas
this.object.hrs_programadas 	[al_row] = 0.00
this.object.hrs_ejec_normal	[al_row] = 0.00
this.object.hrs_ejec_extras 	[al_row] = 0.00

end event

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "campana"
		ls_sql = "SELECT campana AS campaña, " &
				  + "DESCRIPCION AS descripcion_campaña " &
				  + "FROM campanas " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.campana			[al_row] = ls_codigo
			this.object.desc_campana	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_labor"
		ls_sql = "SELECT cod_labor AS CODIGO_labor, " &
				  + "desc_labor AS descripcion_labor " &
				  + "FROM labor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_labor	[al_row] = ls_codigo
			this.object.desc_labor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'campana'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc1
		  from campanas
		 Where campana = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Campaña o no se encuentra activo, por favor verifique")
			this.object.campana			[row] = ls_null
			this.object.desc_campana	[row] = ls_null
			return 1
			
		end if

		this.object.desc_campana		[row] = ls_desc1

CASE 'cod_labor' 

		// Verifica que codigo ingresado exista			
		Select desc_labor
	     into :ls_desc1
		  from labor
		 Where cod_labor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Labor o no se encuentra activo, por favor verifique")
			this.object.cod_labor	[row] = ls_null
			this.object.desc_labor	[row] = ls_null
			return 1
			
		end if

		this.object.desc_labor		[row] = ls_desc1


END CHOOSE
end event

type uo_fechas from u_ingreso_rango_fechas within w_cam301_proy_horas_jornal
integer y = 12
integer taborder = 40
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date ld_fecha
of_set_label('Desde:','Hasta:') // para seatear el titulo del boton


ld_fecha = date(f_fecha_actual())
of_set_rango_inicio(date('01/01/1000')) // rango inicial

of_set_rango_fin(date('31/12/9999')) // rango final

of_set_fecha(date('01' + string(ld_fecha, '/mm/yyyy')), ld_fecha) //para setear la fecha inicial


end event

type cb_procesar from commandbutton within w_cam301_proy_horas_jornal
integer x = 1289
integer y = 4
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;dw_master.Retrieve()

if dw_master.RowCount() > 0 then
	dw_master.SelectRow( 0, false)
	dw_master.SelectRow( 1, true)
	dw_master.SetRow( 1 )
	dw_master.il_row = dw_master.GetRow( )
	//dw_detail.event ue_output( dw_master.GetRow())
end if
end event

