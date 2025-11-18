$PBExportHeader$w_ope027_labor_trabajador.srw
forward
global type w_ope027_labor_trabajador from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_ope027_labor_trabajador
end type
type st_2 from statictext within w_ope027_labor_trabajador
end type
type cb_2 from commandbutton within w_ope027_labor_trabajador
end type
end forward

global type w_ope027_labor_trabajador from w_abc_mastdet_smpl
integer width = 2811
integer height = 2076
string title = "(OPE027) Trabajadores por labor ejecutor"
string menuname = "m_master_sin_lista"
event type integer ue_listar_data ( string as_file )
st_1 st_1
st_2 st_2
cb_2 cb_2
end type
global w_ope027_labor_trabajador w_ope027_labor_trabajador

event type integer ue_listar_data(string as_file);oleobject excel
Long		ll_item, ll_return, ll_max_rows, ll_fila1, ll_fila, ll_count
double 	dbl_precio
boolean 	lb_cek
String 	ls_cellValue , ls_nomcol, ls_codigo, ls_mensaje, ls_trabajador, ls_labor, ls_ejecutor

oleobject  lole_workbook, lole_worksheet

try 
	excel = create oleobject;
	
	if not(FileExists( as_file )) then
		messagebox('Excel','Archivo Excel ' + as_file + ' no existe, por favor verifique!', Information!) 
		return -1
	end if 
	
	//connect to office application
	ll_return = excel.connecttonewobject("excel.application")
	if ll_return <> 0 then
		messagebox('Error','No tiene instalado o configurado el MS.Excel, por favor verifique!',exclamation!)
		return -1
	end if
	
	//open file excel (you can make this string as variable)
	excel.workbooks.open( as_file )
	excel.application.visible = false
	excel.windowstate = 2
	
	//cek rows in excel sheet with return value copy
	lole_workbook 	= excel.workbooks(1)
	lb_cek 			= lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   	= lole_worksheet.UsedRange.Rows.Count
	
	if MessageBox('Information', "Va importar " + string(ll_max_rows) &
		+ " desea continuar?. De continuar con el proceso se añadiran los datos a las labores", &
		Information!, YesNo!, 2) = 2 then return -1
		
	//Borro todos los datos de las cuadrillas
	//delete from labor_trabajador ;
	
	ll_item = 1
	
	FOR ll_fila1 = 2 TO ll_max_rows
		yield()
		ls_trabajador	= string(lole_worksheet.cells(ll_fila1,1).value)
		ls_labor			= string(lole_worksheet.cells(ll_fila1,2).value)
		
		if IsNull(ls_labor) or trim(ls_labor) = '' then
			gnvo_app.of_mensaje_error("El código del trabajador " + ls_trabajador + ", no tiene labor asignada, por favor verifique en la hoja de excel!")
			return -1
		end if
		
		//Valido los datos
		select count(*)
		  into :ll_count
		from maestro m
		where m.cod_trabajador = :ls_trabajador;
		
		if ll_count = 0 then
			gnvo_app.of_mensaje_error("Codigo de Trabajador " + ls_trabajador + ", de la línea " + string(ll_fila1) &
											+ ", no existe en el maestro de trabajador, por favor verifique!")
			return -1
		end if
		
		select count(*)
		  into :ll_count
		from labor t
		where t.cod_labor = :ls_labor;
		
		if ll_count = 0 then
			gnvo_app.of_mensaje_error("Labor " + ls_labor + ", de la línea " + string(ll_fila1) &
											+ ", no existe en el maestro de Labores, por favor verifique!")
			return -1
		end if
		
		//Obtengo el elecutor
		select cod_ejecutor
			into :ls_ejecutor
		from labor_ejecutor
		where cod_labor = :ls_labor;
		
		//Verifico que no exista el trabajador en la labor
		select count(*)
			into :ll_count
		from labor_trabajador
		where cod_labor 		= :ls_labor
		  and cod_trabajador = :ls_trabajador
		  and cod_ejecutor	= :ls_ejecutor;
		
		if ll_count = 0 then
			insert into labor_trabajador(
				cod_labor, cod_trabajador, flag_estado, cod_ejecutor)
			values(
				:ls_labor, :ls_trabajador, '1', :ls_ejecutor);
				
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				gnvo_app.of_mensaje_error("Error al insertar en labor_trabajador: " + ls_mensaje)
				return -1
			end if
		end if
		
	next
	
	commit;
	
	f_mensaje("Archivo de Excel " + as_file + " importado correctamente. Por favor verifique!", "")
	
	RETURN 1
	
catch ( Exception ex )
	ROLLBACK;
	gnvo_app.of_catch_exception( ex, "")
	return -1
	
finally
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
		destroy excel;
	end if
	
end try

end event

on w_ope027_labor_trabajador.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.st_1=create st_1
this.st_2=create st_2
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_2
end on

on w_ope027_labor_trabajador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_2)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_labor.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cod_labor")
	dw_master.of_column_protect("cod_ejecutor")
END IF
ls_protect=dw_detail.Describe("cod_trabajador.protect")
IF ls_protect='0' THEN
   dw_detail.of_column_protect("cod_trabajador")
END IF

end event

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)

//Help
ii_help = 1
ii_lec_mst = 0
//dw_master.retrieve(gs_user)
dw_master.retrieve()
end event

event ue_print();call super::ue_print;String      ls_cadena
Str_cns_pop lstr_cns_pop

IF idw_1.getrow() = 0 THEN RETURN

ls_cadena = idw_1.Object.cod_fase[idw_1.getrow()]

IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN RETURN

lstr_cns_pop.arg[1] = ls_cadena
lstr_cns_pop.arg[2] = gs_empresa
lstr_cns_pop.arg[3] = gs_user
lstr_cns_pop.arg[4] = ''


lstr_cns_pop.dataobject = 'd_rpt_labor_fase_etapa_ff'
lstr_cns_pop.title = 'Reporte de Etapas Por Fase'
lstr_cns_pop.width  = 3650
lstr_cns_pop.height = 1950

OpenSheetWithParm(w_rpt_pop, lstr_cns_pop, This, 2, Layered!)
end event

event ue_update_pre;call super::ue_update_pre;dw_master.accepttext()
dw_detail.accepttext()


ib_update_check = False	
//--VERIFICACION Y ASIGNACION DE FASE Y ETAPA

IF gnvo_app.of_row_Processing( dw_detail ) <> true then	return
	

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

ib_update_check = True
end event

event ue_update;//Overwriting
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_detail.of_create_log()
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_detail.ii_update = 0
	dw_detail.il_totdel = 0
	
	dw_detail.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ope027_labor_trabajador
integer x = 0
integer y = 104
integer width = 2720
integer height = 812
string dataobject = "d_labor_ejecutor_conf_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1					// columnas de lectrua de este dw
ii_ck[2] = 2					// columnas de lectrua de este dw
ii_dk[1] = 1 	      		// columnas que se pasan al detalle
ii_dk[2] = 2 	      		// columnas que se pasan al detalle

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;//idw_det.retrieve(aa_id[1],gs_user)
idw_det.retrieve(aa_id[1], aa_id[2])
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;//String ls_codigo,ls_descripcion
//Long 	 ll_count
//
//Accepttext()
//
//choose case dwo.name
//	 	 case 'ot_adm'
//				
//				select count(*) 
//				  into :ll_count
//				  from vw_ope_ot_adm_usr
//				 where (ot_adm  = :data    ) and
//				 		 (cod_usr = :gs_user ) ;
//				
//				if ll_count = 0 then
//					SetNull(ls_codigo)
//					Messagebox('Aviso','OT Administracion No Existe Verifique')
//					This.object.ot_adm      [row] = ls_codigo
//					This.object.descripcion [row] = ls_codigo
//					Return 1	
//				else
//					select descripcion into :ls_descripcion from ot_administracion where ot_adm =:data ;
//					
//					This.object.descripcion [row] = ls_descripcion
//					
//				end if		
//				 		 
//
//end choose
//
end event

event dw_master::doubleclicked;call super::doubleclicked;//IF Getrow() = 0 THEN Return
//String ls_name,ls_prot
//str_seleccionar lstr_seleccionar
//
//ls_name = dwo.name
//ls_prot = this.Describe( ls_name + ".Protect")
//
//if ls_prot = '1' then    //protegido 
//	return
//end if
//
//CHOOSE CASE dwo.name
//		 CASE 'ot_adm'
//			
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT VW_OPE_OT_ADM_USR.OT_ADM AS OT_ADM, '&
//														 +'VW_OPE_OT_ADM_USR.DESCRIPCION AS DESCRIPCION '&
//														 +'FROM VW_OPE_OT_ADM_USR '&
//														 +'WHERE COD_USR = '+"'"+gs_user+"'"
//														 
//
//										  
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'ot_adm',lstr_seleccionar.param1[1])
//					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//END CHOOSE
//
//
//
//
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ope027_labor_trabajador
integer x = 18
integer y = 1024
integer width = 2706
integer height = 872
string dataobject = "d_abc_labor_ejec_trabaj_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_rk[1] = 1
ii_rk[2] = 2

end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

event dw_detail::itemchanged;call super::itemchanged;String ls_codigo, ls_descripcion
Long 	 ll_count

Accepttext()

choose case dwo.name
		
	CASE 'cod_trabajador'
		
		select count(*) 
		  into :ll_count
		  from maestro 
		 where (cod_trabajador = :data ) ;
		 
		IF ll_count = 0 then
			SetNull(ls_codigo)
			Messagebox('Aviso','Código trabajador no existe. Verifique')
			This.object.cod_trabajador  [row] = ls_codigo 
			This.object.nombre [row] = ls_codigo
			Return 1	
		ELSE
			SELECT nom_proveedor 
	  		  INTO :ls_descripcion 
	 		  FROM proveedor 
	 		 WHERE proveedor =:data ;
	
			 This.object.nombre [row] = ls_descripcion
		END IF 

END CHOOSE

end event

event dw_detail::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name, ls_prot, ls_nombre 
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
	 CASE 'cod_trabajador'
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT MAESTRO.COD_TRABAJADOR AS CODIGO, '&
      								 +'MAESTRO.APEL_PATERNO AS APEL_PATERNO, ' &
										 +'MAESTRO.APEL_MATERNO AS APEL_MATERNO, ' &
										 +'MAESTRO.NOMBRE1 AS NOMBRE ' &
										 +'FROM MAESTRO ' &
										 +'WHERE MAESTRO.FLAG_ESTADO <> 0' 
										  
			OpenWithParm(w_seleccionar,lstr_seleccionar)
				
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			IF lstr_seleccionar.s_action = "aceptar" THEN
				Setitem(row,'cod_trabajador',lstr_seleccionar.param1[1])
				ls_nombre = TRIM(lstr_seleccionar.param2[1]) + ' ' + &
								TRIM(lstr_seleccionar.param3[1]) + ', '+ &
								TRIM(lstr_seleccionar.param4[1]) 
				Setitem(row, 'nombre', ls_nombre)								
				ii_update = 1
			END IF
END CHOOSE

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;// Flag de estado activo
this.object.flag_estado[al_row]='1'

end event

type st_1 from statictext within w_ope027_labor_trabajador
integer y = 4
integer width = 2743
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Labores por ejecutores"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ope027_labor_trabajador
integer x = 512
integer y = 936
integer width = 1591
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Trabajadores por labor"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_ope027_labor_trabajador
integer width = 475
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Importar de XLS"
end type

event clicked;Integer	li_value
string 	ls_docname, ls_named, ls_codigo, ls_filtro, ls_mensaje

li_value =  GetFileOpenName("Abrir ..",  ls_docname, ls_named, "XLS",  "Archivos Excel (*.XLS),*.XLS" )

IF parent.event ue_listar_data(ls_docname) = -1 THEN 
	RETURN -1
END IF





end event

