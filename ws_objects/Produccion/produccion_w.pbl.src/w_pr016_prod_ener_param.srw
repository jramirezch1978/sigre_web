$PBExportHeader$w_pr016_prod_ener_param.srw
forward
global type w_pr016_prod_ener_param from w_abc_master_smpl
end type
type st_1 from statictext within w_pr016_prod_ener_param
end type
end forward

global type w_pr016_prod_ener_param from w_abc_master_smpl
integer width = 2738
integer height = 1072
string title = "Parametros Generales de Energía(PR016)"
string menuname = "m_mantto_consulta"
st_1 st_1
end type
global w_pr016_prod_ener_param w_pr016_prod_ener_param

on w_pr016_prod_ener_param.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_pr016_prod_ener_param.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
//is_tabla = 'PROD_ENER_PARAM'

ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr016_prod_ener_param
event ue_display ( string as_columna,  long al_row )
integer x = 14
integer y = 220
integer width = 2651
integer height = 652
string dataobject = "d_abc_prod_ener_param_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

//sg_parametros sl_param

choose case upper(as_columna)
		
		case "COD_PLANTA"

		ls_sql = "SELECT COD_PLANTA AS CODIGO_PLANTA, " &
				  + "DESC_PLANTA AS DESCRIPCION " &
				  + "FROM TG_PLANTAS " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_planta		[al_row] = ls_codigo
			this.object.desc_planta		[al_row] = ls_data
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
		
	case "cod_planta"
		
		ls_codigo = this.object.cod_planta[row]

		SetNull(ls_data)
		select desc_planta
			into :ls_data
		from tg_plantas
		where cod_planta = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Planta no existe o no esta activa", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_planta	  	[row] = ls_codigo
			this.object.desc_planta		[row] = ls_codigo
			return 1
		end if

		this.object.desc_planta			[row] = ls_data
		
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;//Cargamos Datos iniciales de configuración

dw_master.Setitem(al_row,"ano",YEAR(date(f_fecha_actual())))
dw_master.Setitem(al_row,"mes",MONTH(date(f_fecha_actual())))


end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 3				// columnas de lectrua de este dw
ii_ck[3] = 4				// columnas de lectrua de este dw
end event

type st_1 from statictext within w_pr016_prod_ener_param
integer x = 795
integer y = 64
integer width = 1147
integer height = 108
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Parametros de Energía"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

