$PBExportHeader$w_cn021_sub_categ_cnta_ctbl.srw
forward
global type w_cn021_sub_categ_cnta_ctbl from w_abc_master_smpl
end type
end forward

global type w_cn021_sub_categ_cnta_ctbl from w_abc_master_smpl
integer width = 2734
integer height = 1760
string title = "[CN021] Cuentas Contables por Sub Categoría de Artículos"
string menuname = "m_abc_master_smpl"
end type
global w_cn021_sub_categ_cnta_ctbl w_cn021_sub_categ_cnta_ctbl

on w_cn021_sub_categ_cnta_ctbl.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
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

event resize;// Override
dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;// Centra pantalla
//long ll_x,ll_y
//ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
//ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
//This.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn021_sub_categ_cnta_ctbl
integer width = 2464
integer height = 1404
string dataobject = "d_sub_categ_cnta_tbl"
end type

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::itemchanged;call super::itemchanged;Integer 	li_registros
String 	ls_desc

This.AcceptText()

CHOOSE CASE dwo.name
	CASE 'cnta_cntbl'
		SELECT desc_cnta
      	INTO :ls_desc
      FROM cntbl_cnta
      WHERE cnta_ctbl = :data
		  and flag_estado = '1';
		
      IF SQLCA.SQLCode = 100 Then
			MessageBox("Error","Cuenta contable " + data + " no existe o no esta activo, por favor verifique!", StopSign!)
			this.object.cnta_cntbl	[row] = gnvo_app.is_null
			this.object.desc_cnta	[row] = gnvo_app.is_null
			return 1
		END IF
		
		this.object.desc_cnta	[row] = ls_desc
		
	CASE 'cnta_ctbl_haber'
		SELECT desc_cnta
      	INTO :ls_desc
      FROM cntbl_cnta
      WHERE cnta_ctbl = :data
		  and flag_estado = '1';
		
      IF SQLCA.SQLCode = 100 Then
			MessageBox("Error","Cuenta contable " + data + " no existe o no esta activo, por favor verifique!", StopSign!)
			this.object.cnta_ctbl_haber [row] = gnvo_app.is_null
			this.object.desc_cnta_haber [row] = gnvo_app.is_null
			return 1
		END IF
		
		this.object.desc_cnta_haber	[row] = ls_desc
END CHOOSE		
end event

event dw_master::ue_display;call super::ue_display;String ls_name,ls_prot
str_cnta_cntbl 	lstr_cnta

CHOOSE CASE lower(as_columna)
	CASE 'cnta_cntbl'
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.cnta_cntbl	[al_row] = lstr_cnta.cnta_cntbl
			this.object.desc_cnta 	[al_row] = lstr_cnta.desc_cnta
			this.ii_update = 1
		end if		
		
	CASE 'cnta_ctbl_haber'
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.cnta_ctbl_haber [al_row] = lstr_cnta.cnta_cntbl
			this.object.desc_cnta_haber [al_row] = lstr_cnta.desc_cnta
			this.ii_update = 1
		end if
		
END CHOOSE

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

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

