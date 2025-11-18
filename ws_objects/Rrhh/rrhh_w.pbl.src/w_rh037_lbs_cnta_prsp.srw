$PBExportHeader$w_rh037_lbs_cnta_prsp.srw
forward
global type w_rh037_lbs_cnta_prsp from w_abc_master_smpl
end type
end forward

global type w_rh037_lbs_cnta_prsp from w_abc_master_smpl
integer width = 3657
integer height = 1596
string title = "[RH037] Cuentas Presupuestal y Concepto PLAME por LBS"
string menuname = "m_master_simple"
end type
global w_rh037_lbs_cnta_prsp w_rh037_lbs_cnta_prsp

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

on w_rh037_lbs_cnta_prsp.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh037_lbs_cnta_prsp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return



ib_update_check = true

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh037_lbs_cnta_prsp
event ue_display ( string as_columna,  long al_row )
integer width = 3557
integer height = 1336
string dataobject = "d_abc_lbs_cnta_prsp_tipo_trabajador_tbl"
boolean hscrollbar = false
end type

event dw_master::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_flag_concepto_lbs, &
			ls_tipo_trabaj, ls_cencos

date 		ld_fec_cese
integer 	li_year
str_parametros	lstr_parametros

choose case lower(as_columna)
		
	case "concepto_rtps"
		ls_sql = "SELECT cod_concepto_rtps AS codigo_concepto, " &
				  + "DESC_CONCEPTO_RTPS AS descripcion_concepto " &
				  + "FROM rrhh_conceptos_rtps " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.concepto_rtps		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cnta_prsp"
		
		ld_fec_cese 			= Date(dw_master.Object.fec_salida[dw_master.GetRow()])
		li_year 					= year(ld_fec_cese)
		ls_cencos 				= this.object.cencos[al_row]
		ls_tipo_trabaj 		= dw_master.object.tipo_trabajador 	[dw_master.GetRow()]
		ls_flag_concepto_lbs = this.object.flag_titulo_lbs			[al_row]

		
		if ls_cencos = '' or IsNull(ls_cencos) then
			MessageBox('Error', 'Debe ingresar un centro de costos')
			this.SetColumn('cencos')
			return
		end if
		
		ls_sql = "select distinct pc.cnta_prsp as cnta_prsp, " &
				 + "pc.descripcion as descripcion_cnta_prsp " &
				 + "from presupuesto_cuenta pc, " &
				 + "     presupuesto_partida pp, " &
				 + "     lbs_cnta_prsp_tipo_trabaj l " & 
				 + "where pc.cnta_prsp = pp.cnta_prsp " &
				 + "  and l.cnta_prsp  = pc.cnta_prsp " &
				 + "  and l.tipo_trabajador = '" + ls_tipo_trabaj + "' " &
				 + "  and l.flag_concepto_lbs = '" + ls_flag_concepto_lbs + "' " &
				 + "  and pp.flag_estado <> '0' " &
				 + "  and pp.cencos = '" + ls_cencos + "' " &
				 + "  and pp.ano = " + string(li_year) & 
				  + " order by 2"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.ii_update = 1
		end if

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

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado	[al_row]= '1'
end event

