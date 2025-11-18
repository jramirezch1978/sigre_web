$PBExportHeader$w_cn056_cntbl_cnta_sunat.srw
forward
global type w_cn056_cntbl_cnta_sunat from w_abc_master
end type
type st_1 from statictext within w_cn056_cntbl_cnta_sunat
end type
type cb_1 from commandbutton within w_cn056_cntbl_cnta_sunat
end type
type em_ano from editmask within w_cn056_cntbl_cnta_sunat
end type
end forward

global type w_cn056_cntbl_cnta_sunat from w_abc_master
integer width = 2053
integer height = 1800
string title = "[CN056] Plan de Cuentas vs Cuentas SUNAT"
string menuname = "m_abc_master_smpl"
st_1 st_1
cb_1 cb_1
em_ano em_ano
end type
global w_cn056_cntbl_cnta_sunat w_cn056_cntbl_cnta_sunat

on w_cn056_cntbl_cnta_sunat.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
this.cb_1=create cb_1
this.em_ano=create em_ano
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.em_ano
end on

on w_cn056_cntbl_cnta_sunat.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.em_ano)
end on

event ue_open_pre;call super::ue_open_pre;em_ano.text = string(gnvo_app.of_fecha_actual(), 'yyyy')

this.event ue_retrieve()

end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("tipo_nota.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("tipo_nota")
END IF

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event ue_insert;//Override
end event

event ue_delete;//Override
end event

event ue_retrieve;call super::ue_retrieve;Long ll_year

ll_year = Long(em_ano.text)

dw_master.retrieve(ll_year)
end event

type dw_master from w_abc_master`dw_master within w_cn056_cntbl_cnta_sunat
integer y = 104
integer height = 1484
string title = "Tipo de Notas (CN001)"
string dataobject = "d_abc_cnta_cntbl_sunat_tbl"
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 9				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cnta_cntbl_sunat"
		ls_sql = "SELECT T.cnta_sunat as cuenta_sunat, " &
				 + "t.desc_cnta as descripcion_cuenta_sunat " &
				 + "FROM CNTA_CNTBL_SUNAT T"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cnta_cntbl_sunat	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose
end event

event dw_master::itemchanged;call super::itemchanged;Integer ls_desc
this.accepttext()
CHOOSE CASE dwo.name
	CASE 'cnta_cntbl_sunat'
		select desc_cnta
			into :ls_desc
		from CNTA_CNTBL_SUNAT
		where cnta_sunat = :data;
		
		// Verifica que articulo solo sea de reposicion		
		if sqlca.sqlcode= 100 then
			Messagebox( "Error", "Cuenta Contable de Sunat no existe, por favor verifique")
			this.object.cnta_cntbl_sunat			[row] = gnvo_app.is_null
			return 1
		end if
END CHOOSE		
end event

type st_1 from statictext within w_cn056_cntbl_cnta_sunat
integer y = 16
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cn056_cntbl_cnta_sunat
integer x = 485
integer width = 279
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event ue_retrieve()
end event

type em_ano from editmask within w_cn056_cntbl_cnta_sunat
integer x = 192
integer y = 8
integer width = 283
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "0~~9999"
end type

