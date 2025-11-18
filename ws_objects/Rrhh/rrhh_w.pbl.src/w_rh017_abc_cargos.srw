$PBExportHeader$w_rh017_abc_cargos.srw
forward
global type w_rh017_abc_cargos from w_abc_master_smpl
end type
end forward

global type w_rh017_abc_cargos from w_abc_master_smpl
integer width = 3657
integer height = 1592
string title = "(RH017) Cargos u Ocupaciones"
string menuname = "m_master_simple"
end type
global w_rh017_abc_cargos w_rh017_abc_cargos

forward prototypes
public function boolean of_load_mof (long al_row)
end prototypes

public function boolean of_load_mof (long al_row);//blob 		lbl_imagen
//string	ls_mensaje
//
//selectblob foto_blob
//	into :lbl_imagen
//	from maestro m
//where cod_trabajador = :as_codtra;
//
//if SQLCA.SQLCode = 100 then
//	SetNull(lbl_imagen)
//end if
//
//if SQLCA.SQlcode = -1 then
//	ls_Mensaje = SQLCA.SQlErrText
//	ROLLBACK;
//	MessageBox('Error al recuperar foto de trabajador', ls_mensaje)
//	return
//end if
//
//if not Isnull(lbl_imagen) then
//	p_foto.SetPicture(lbl_imagen)
//else
//	setNull(lbl_imagen)
//	p_foto.setPicture(lbl_Imagen)
//	p_foto.picturename = is_not_imagen
//end if
return true
end function

on w_rh017_abc_cargos.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh017_abc_cargos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;//Verificacion de la Validacion al Grabar
string ls_cod_cargo, ls_desc_cargo 
integer li_row 
li_row = dw_master.Getrow()

If li_row > 0 Then  

	ls_cod_cargo = dw_master.GetItemString(li_row,"cod_cargo") 
	ls_desc_cargo = dw_master.GetItemString(li_row,"desc_cargo")

	If len(trim(ls_cod_cargo)) <> 8 Then 
			dw_master.ii_update = 0
			Messagebox("Sistema de Seguridad","El Codigo de cargo debe "+&
		           "tener 8 Digitos")
	End if 				  

	If len(trim(ls_desc_cargo)) = 0 Then
		  dw_master.ii_update = 0
		  Messagebox("Sistema de Seguridad","Ingrese la Descripcion "+&
		             "del CARGO")
					 
	End if 	
Else 
	return 
end if 	
dw_master.of_set_flag_replicacion( )
end event

event ue_insert;call super::ue_insert;
dw_master.SetItem(dw_master.getrow(),'flag_estado','1')
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh017_abc_cargos
event ue_display ( string as_columna,  long al_row )
integer width = 3557
integer height = 1336
string dataobject = "d_cargos_tbl"
boolean hscrollbar = false
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_null

this.AcceptText()
SetNull(ls_null)

choose case lower(as_columna)
		
	case "cod_ocupacion_rtps"
		ls_sql = "select t.cod_ocupacion_rtps as codigo, "&
				 + "t.desc_ocupacion as descripcion "&
				 + "from rrhh_ocupacion_rtps t "&
				 + "where t.flag_estado = '1'" 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_ocupacion_rtps	[al_row] = ls_codigo
			this.object.desc_ocupacion_rtps	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
	
	
end choose

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_null, ls_mensaje, ls_desc

This.AcceptText()
if row = 0 then return
if dw_master.GetRow() = 0 then return

Setnull( ls_null)

CHOOSE CASE lower(dwo.name)
	
	CASE 'cod_ocupacion_rtps'

		SELECT desc_ocupacion
			INTO :ls_desc
		FROM rrhh_ocupacion_rtps
   	WHERE cod_ocupacion_rtps = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso','Codigo de ocupación RTPS no existe ' &
					+ 'no esta activo, por favor verifique')
			else
				MessageBox('Error', SQLCA.SQLErrText)
			end if
			
			this.Object.cod_ocupacion_rtps	[row] = ls_null
			this.object.desc_ocupacion_rtps	[row] = ls_null
			this.setcolumn( "cod_ocupacion_rtps" )
		 	this.setfocus()
			RETURN 1
		END IF
		this.object.desc_ocupacion_rtps [row] = ls_desc
		
END CHOOSE

end event

event dw_master::clicked;call super::clicked;//string docpath, docname[]
//integer i, li_cnt, li_rtn, li_filenum
//string ls_col
//
//ls_col = lower(trim(string(dwo.name)))
//messagebox("JD",ls_col)
//choose case ls_col
//		
//	case 'b_1'
//    li_rtn = GetFileOpenName("Select File", &
//    docpath, docname[], "DOC", &
//    + "Text Files (*.TXT),*.TXT," &
//    + "Doc Files (*.DOC),*.DOC," &
//    + "All Files (*.*), *.*", &
//    "G:\")
//	 
//	IF li_rtn < 1 THEN 
//		messagebox(this.title,"Debe de seleccionar un archivo")
//		return 
//	end if
//	
//	if li_cnt = 1 then
//
//	    this.object.perfil_ruta[row] = string(docpath)
//
//   else
//		
//		messagebox(this.title,"Debe de seleccionar solo un archivo")
//		return
//		
//	end if
//	
//end choose
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

event dw_master::buttonclicked;call super::buttonclicked;String	ls_docname, ls_named, ls_cod_cargo
integer	li_Result
n_cst_maestro	lnvo_Master
str_parametros	lstr_param

if row = 0 then return

choose case lower(dwo.name)
	case 'b_mof'
		if dw_master.ii_update = 1 then
			MessageBox('Error', 'Tiene cambios pendientes por grabar, por favor actualice antes de subir el archivo MOF', StopSign!)
			return 
		end if

		li_result = GetFileOpenName("Seleccione Archivo para Subir", &
						ls_docname, ls_named, "PDF", &
						"Archivos PDF (*.pdf), *.PDF, Archivos DOC (*.DOC*),*.DOC, Archivos EXCEL (*.XLS*),*.XLS*")
	
		if li_result = 1 then
				
				ls_cod_cargo = dw_master.object.cod_cargo[dw_master.getRow()]
				
				if ls_cod_cargo = "" or IsNull(ls_cod_cargo) then
					MessageBox('Error', 'El codigo de cargo esta en blanco, '&
											+ 'asegurese de grabar los datos antes de asignar la foto')
					return 
				end if

				lnvo_Master = create n_cst_maestro
				lnvo_Master.of_grabar_mof( ls_docname, ls_cod_cargo)
				destroy lnvo_Master
				
				dw_master.object.flag_manual_mof [row] = '1'
				
				//of_load_foto(row)
		end if
		

END CHOOSE

end event

