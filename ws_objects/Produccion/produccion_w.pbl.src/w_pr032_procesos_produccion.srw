$PBExportHeader$w_pr032_procesos_produccion.srw
forward
global type w_pr032_procesos_produccion from w_abc_master_smpl
end type
type st_1 from statictext within w_pr032_procesos_produccion
end type
end forward

global type w_pr032_procesos_produccion from w_abc_master_smpl
integer width = 3186
integer height = 1436
string title = "[PR032] Procesos de Producción"
string menuname = "m_mantto_consulta"
st_1 st_1
end type
global w_pr032_procesos_produccion w_pr032_procesos_produccion

on w_pr032_procesos_produccion.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_pr032_procesos_produccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
//is_tabla = 'PROD_ENER_PARAM'

ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr032_procesos_produccion
event ue_display ( string as_columna,  long al_row )
integer x = 14
integer y = 188
integer width = 3104
integer height = 1044
string dataobject = "d_abc_procesos_produccion_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedorx
			
Long		ll_row_find

//sg_parametros sl_param

choose case upper(as_columna)
		
		case "COD_PLANTILLA"

		ls_sql = "Select pc.cod_plantilla as codigo, pc.observaciones as descripcion, pc.ot_adm as ot_adm "&
					+ "from plantilla_costo pc Where Nvl(pc.flag_estado,'0')='1' Order by pc.cod_plantilla"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_plantilla		[al_row] = ls_codigo
			this.object.observaciones		[al_row] = ls_data
			this.ii_update = 1
		end if
					
end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
Long		ll_count

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
		
	case "cod_plantilla"
		
		ls_codigo = this.object.cod_plantilla[row]

		SetNull(ls_data)
		select pc.observaciones
			into :ls_data
		from plantilla_costo pc
		where pc.cod_plantilla = :ls_codigo
		  and Nvl(pc.flag_estado,'0') = '1';
		
		 
 
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Plantilla de Costo no existe o no esta activa", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_plantilla	  	[row] = ls_codigo
			this.object.observaciones		[row] = ls_codigo
			return 1
		end if

		this.object.observaciones			[row] = ls_data
		
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;DateTime ldt_fecha


ldt_fecha = f_fecha_actual();

this.object.fecha_registro		[al_row] = ldt_fecha
this.object.cod_usr				[al_row] = gs_user
this.object.estacion				[al_row] = gs_estacion
this.object.flag_estado		   [al_row] = '1'
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 3				// columnas de lectrua de este dw
ii_ck[3] = 4				// columnas de lectrua de este dw
end event

type st_1 from statictext within w_pr032_procesos_produccion
integer x = 914
integer y = 32
integer width = 1161
integer height = 108
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Procesos de Producción"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

