$PBExportHeader$w_cn021_sub_categ_cnta_ctbl.srw
forward
global type w_cn021_sub_categ_cnta_ctbl from w_abc_master_smpl
end type
end forward

global type w_cn021_sub_categ_cnta_ctbl from w_abc_master_smpl
integer width = 2734
integer height = 1760
string title = "Cuentas Contables por Sub Categoría de Artículos (CN021)"
string menuname = "m_mtto_smpl"
boolean center = true
end type
global w_cn021_sub_categ_cnta_ctbl w_cn021_sub_categ_cnta_ctbl

on w_cn021_sub_categ_cnta_ctbl.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_cn021_sub_categ_cnta_ctbl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_sub_cat.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cod_sub_cat")
END IF


end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type ole_skin from w_abc_master_smpl`ole_skin within w_cn021_sub_categ_cnta_ctbl
end type

type uo_h from w_abc_master_smpl`uo_h within w_cn021_sub_categ_cnta_ctbl
end type

type st_box from w_abc_master_smpl`st_box within w_cn021_sub_categ_cnta_ctbl
end type

type st_filter from w_abc_master_smpl`st_filter within w_cn021_sub_categ_cnta_ctbl
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_cn021_sub_categ_cnta_ctbl
end type

type dw_master from w_abc_master_smpl`dw_master within w_cn021_sub_categ_cnta_ctbl
integer x = 498
integer width = 2464
integer height = 1404
string dataobject = "d_sub_categ_cnta_tbl"
end type

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cnta_cntbl'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_cntbl',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		 CASE 'cnta_ctbl_haber'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_ctbl_haber',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
END CHOOSE

end event

event dw_master::itemchanged;call super::itemchanged;Integer li_registros
String ls_cuenta, ls_null

Setnull(ls_null)
This.AcceptText()

CHOOSE CASE dwo.name
	CASE 'cnta_cntbl'
		ls_cuenta = data

		SELECT count(*)
      	INTO :li_registros
      FROM cntbl_cnta
      WHERE cnta_ctbl = :data
		  and flag_estado = '1';
		
      IF li_registros = 0 Then
			MessageBox("Mensaje al Usuario","Cuenta contable no existe o no esta activo")
			this.object.cnta_cntbl[row] = ls_null
		END IF;
		
	CASE 'cnta_cntbl_haber'
		ls_cuenta = data

		SELECT count(*)
      	INTO :li_registros
      FROM cntbl_cnta
      WHERE cnta_ctbl = :data
		  and flag_estado = '1';
		
      IF li_registros = 0 Then
			MessageBox("Mensaje al Usuario","Cuenta contable no existe o no esta activo")
			this.object.cnta_ctbl_haber [row] = ls_null
		END IF;
END CHOOSE		
end event

