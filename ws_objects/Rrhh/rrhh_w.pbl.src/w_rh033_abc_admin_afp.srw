$PBExportHeader$w_rh033_abc_admin_afp.srw
forward
global type w_rh033_abc_admin_afp from w_abc_master_lstmst
end type
end forward

global type w_rh033_abc_admin_afp from w_abc_master_lstmst
integer width = 1728
integer height = 1816
string title = "(RH033) Administradoras de A.F.P."
string menuname = "m_master_simple"
end type
global w_rh033_abc_admin_afp w_rh033_abc_admin_afp

on w_rh033_abc_admin_afp.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh033_abc_admin_afp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.cod_afp.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_afp.Protect = 1
END IF

end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)



end event

event resize;dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_lstmst`dw_master within w_rh033_abc_admin_afp
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 544
integer width = 1659
integer height = 1084
string dataobject = "d_admin_afp_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_null

this.AcceptText()
SetNull(ls_null)

choose case lower(as_columna)
		
	case "cod_pension_rtps"
		ls_sql = "select t.cod_pension_rtps as cod_pension_rtps, " &
				 + "t.desc_pension_rtps as desc_pension_rtps, " &
				 + "t.flag_estado as flag_estado " &
				 + "from rrhh_pensiones_rtps t " &
				 + "where t.flag_estado = '1' " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_pension_rtps		[al_row] = ls_codigo
			this.object.desc_pension_rtps		[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
	
	
end choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;//Long ll_row
//Any  la_id
//
//la_id = dw_master.object.data.primary.current[dw_master.il_row, dw_master.ii_colnum]
//
THIS.SetItem(al_row, "flag_estado", '1')

//of_SetItem(dw_master,dw_master.il_row, dw_master.ii_cn, al_row, ii_cn)
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_master::itemchanged;call super::itemchanged;String ls_null, ls_desc
Long   ll_count

Accepttext()


SetNull(ls_null)

choose case lower(dwo.name)
	case 'cod_relacion'
		select count(*) into :ll_count 
		 from proveedor
		where (proveedor   = :data ) and
				(flag_estado = '1'	) ;
				
		if ll_count = 0 then
			this.object.cod_relacion [row] = ls_null
			Messagebox('Aviso','Codigo de Relacion No Existe ,Verifique!')
			Return 1
		end if
	
	case "cod_pension_rtps"
			
		SELECT desc_pension_rtps
			INTO :ls_desc
		FROM rrhh_pensiones_rtps
   	WHERE  cod_pension_rtps = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso','Codigo de pension RTPS no existe ' &
					+ 'no esta activo, por favor verifique')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.cod_pension_rtps		[row] = ls_null
			this.object.desc_pension_rtps 	[row] = ls_null
			this.setcolumn( "cod_pension_rtps" )
		 	this.setfocus()
			RETURN 1
		END IF
		this.object.desc_pension_rtps [row] = ls_desc
		
END CHOOSE

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::buttonclicked;call super::buttonclicked;IF Getrow() = 0 THEN Return

String ls_name ,ls_prot
Str_seleccionar lstr_seleccionar


ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'b_1'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO , '&
								   					 +'PROVEEDOR.NOM_PROVEEDOR AS DESCRIPCION,'&
                                           +'RUC AS NRO_RUC '				   &
									   				 +'FROM PROVEEDOR '&
														 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
				
END CHOOSE


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

type dw_lista from w_abc_master_lstmst`dw_lista within w_rh033_abc_admin_afp
integer x = 0
integer y = 0
integer width = 1673
integer height = 528
string dataobject = "d_admin_afp_lista_tbl"
end type

event dw_lista::constructor;call super::constructor;ii_ck[1] = 1 

end event

