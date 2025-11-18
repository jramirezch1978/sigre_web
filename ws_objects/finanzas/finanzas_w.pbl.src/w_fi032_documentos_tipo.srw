$PBExportHeader$w_fi032_documentos_tipo.srw
forward
global type w_fi032_documentos_tipo from w_abc_master_smpl
end type
end forward

global type w_fi032_documentos_tipo from w_abc_master_smpl
integer width = 3803
integer height = 1616
string title = "[FI032] Tipo de Documentos"
string menuname = "m_mantenimiento_sl"
end type
global w_fi032_documentos_tipo w_fi032_documentos_tipo

on w_fi032_documentos_tipo.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fi032_documentos_tipo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.tipo_doc.Protect)

IF li_protect = 0 THEN
   dw_master.Object.tipo_doc.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1 
idw_1.Retrieve()

end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if


dw_master.of_set_flag_replicacion ()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi032_documentos_tipo
event ue_display ( string as_columna,  long al_row )
integer width = 3630
integer height = 1224
string dataobject = "d_abc_doc_tipo_tbl"
end type

event dw_master::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_parametros sl_param

choose case lower(as_columna)
		
	case "tipo_cred_fiscal"
		
		ls_sql = "SELECT TIPO_CRED_FISCAL  AS CODIGO ," &
    			 + "DESCRIPCION AS DESCRIPCION " &
				 + "FROM CREDITO_FISCAL " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_cred_fiscal 		[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "nro_libro"
		
		ls_sql = "SELECT NRO_LIBRO AS LIBRO ," &
				 + "DESC_LIBRO AS DESCRIPCION " &
				 + "FROM CNTBL_LIBRO"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.setitem( al_row, lower(as_columna), ls_codigo)
			this.ii_update = 1
		end if

	case "cod_sunat"
		
		ls_sql = "SELECT codigo AS cod_sunat, " &
				 + "descripcion AS DESCRIPCION " &
				 + "FROM sunat_tabla10 " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_sunat	[al_row] = ls_codigo
			this.object.descripcion	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_sunat_tabla1"
		
		ls_sql = "select t.codigo as cod_sunat, " &
				 + "       t.descripcion as descripcion " &
				 + "from SUNAT_TABLA1 t " &
				 + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_sunat_tabla1	[al_row] = ls_codigo
			this.object.desc_medio_pago	[al_row] = ls_data
			this.ii_update = 1
		end if
	
end choose


//IF Getrow() = 0 THEN Return
//
//String ls_name, ls_prot 
//Str_seleccionar lstr_seleccionar
//Datawindow		 ldw	
//ls_name = dwo.name
//ls_prot = this.Describe( ls_name + ".Protect")
//
//if ls_prot = '1' then    //protegido 
//	return
//end if
//
//CHOOSE CASE dwo.name
//		
//		 CASE ''
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = ''
//				
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'tipo_cred_fiscal',lstr_seleccionar.param1[1])
//					ii_update = 1
//				END IF
//				
//		 CASE ''
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = ' '
//				
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'nro_libro',lstr_seleccionar.param1[1])
//					ii_update = 1
//				END IF
//		
//		
//							
//END CHOOSE


end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;//dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
//dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")

this.object.flag_afecta_prsp [al_row] = '1'
this.object.nivel_auto_req	  [al_row] = '0'	
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
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

event dw_master::itemchanged;call super::itemchanged;IF Getrow() = 0 THEN Return

String ls_name, ls_prot, ls_codigo, ls_desc
Long ll_count

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		
	 CASE 'tipo_cred_fiscal'
			SELECT count(*)
			INTO :ll_count
			FROM CREDITO_FISCAL
			WHERE tipo_cred_fiscal = :data ;

			IF ll_count=0 THEN
				Messagebox('Aviso','Tipo de crédito fiscal no existe')
				this.object.tipo_cred_fiscal[row] = gnvo_app.is_null
				return
			END IF
			ii_update = 1
			
	 CASE 'nro_libro'
			SELECT count(*)
			INTO :ll_count
			FROM CNTBL_LIBRO
			WHERE nro_libro = :data ;

			IF ll_count=0 THEN
				Messagebox('Aviso','Nro de libro contable no existe')
				this.object.nro_libro[row] = gnvo_app.is_null
				return 1
			END IF
			ii_update = 1

	CASE 'cod_sunat'
			SELECT descripcion
			INTO :ls_desc
			FROM sunat_tabla10
			WHERE codigo = :data 
			  and flag_estado = '1';

			IF SQLCA.SQLCode = 100 THEN
				Messagebox('Error','CODIGO de SUNAT no existe o no esta activo en SUNAT_TABLA10, por favor verifique!')
				this.object.cod_sunat	[row] = gnvo_app.is_null
				this.object.descripcion	[row] = gnvo_app.is_null
				return 1
			END IF
			
			this.object.descripcion	[row] = ls_desc
			
			this.ii_update = 1

	CASE 'cod_sunat_tabla1'
			SELECT descripcion
			INTO :ls_desc
			FROM SUNAT_TABLA1
			WHERE codigo = :data 
			  and flag_estado = '1';

			IF SQLCA.SQLCode = 100 THEN
				Messagebox('Error','CODIGO de SUNAT no existe o no esta activo en SUNAT_TABLA1, por favor verifique!')
				this.object.cod_sunat_tabla1	[row] = gnvo_app.is_null
				this.object.desc_medio_pago	[row] = gnvo_app.is_null
				return 1
			END IF
			
			this.object.desc_medio_pago	[row] = ls_desc
			
			this.ii_update = 1			
END CHOOSE

end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
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

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

