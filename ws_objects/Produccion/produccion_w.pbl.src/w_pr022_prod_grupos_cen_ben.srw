$PBExportHeader$w_pr022_prod_grupos_cen_ben.srw
forward
global type w_pr022_prod_grupos_cen_ben from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_pr022_prod_grupos_cen_ben
end type
type st_2 from statictext within w_pr022_prod_grupos_cen_ben
end type
end forward

global type w_pr022_prod_grupos_cen_ben from w_abc_mastdet_smpl
integer width = 3931
integer height = 1732
string title = "Grupos de Centro Beneficio(PR022)"
string menuname = "m_mantto_consulta"
st_1 st_1
st_2 st_2
end type
global w_pr022_prod_grupos_cen_ben w_pr022_prod_grupos_cen_ben

on w_pr022_prod_grupos_cen_ben.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_pr022_prod_grupos_cen_ben.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if
if f_row_Processing( dw_detail, "tabular") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
end event

event resize;//Override

dw_master.height = newheight - dw_detail.y - 10
st_1.x = dw_master.X
st_1.width = dw_master.width

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

st_2.x = dw_detail.X
st_2.width = dw_detail.width
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pr022_prod_grupos_cen_ben
integer x = 0
integer y = 168
integer width = 1984
integer height = 1296
string dataobject = "d_abc_prod_grupo_centro_ben_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_det  =  				dw_detail
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve( aa_id[1])
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;long al_row

al_row = this.GetRow()

THIS.EVENT ue_output(al_row)
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pr022_prod_grupos_cen_ben
event ue_display ( string as_columna,  long al_row )
integer x = 2002
integer y = 176
integer width = 1984
integer height = 1296
string dataobject = "d_abc_prod_grupo_centro_ben_det_tbl"
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
			
Long		ll_row_find

//sg_parametros sl_param

choose case upper(as_columna)
		
		case "CENTRO_BENEF"

		ls_sql = "SELECT centro_benef AS CODIGO, " &
				  + "DESC_centro AS DESCRIPCION " &
				  + "FROM centro_beneficio " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef		[al_row] = ls_codigo
			this.object.desc_centro 		[al_row] = ls_data
			this.ii_update = 1
		end if					
end choose
end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_detail::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_nro_parte
Long		ll_count, ll_cuenta, ll_detail
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	
	case "centro_benef"
		
		SetNull(ls_data)
		select desc_centro
			into :ls_data
		from centro_beneficio
		where centro_benef = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Centro Beneficio no existe o no esta activo", StopSign!)
			SetNull(data)
			this.object.centro_benef	  	[row] = data
			this.object.desc_centro    	[row] = data
			return 1
		end if

		this.object.desc_centro 			[row] = ls_data

end choose
end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;integer 	li_item
long 		ll_rows, ll_master, ll_detail
string 	ls_nro_parte, ls_grupo

ll_master = dw_master.getrow( )

if ll_master < 1 then
	messagebox('Modulo de Produccion','Primero debe de definri un  Grupo de Centro Feneficio')
	return
end if

ls_nro_parte = dw_master.object.grp_centro_benef[ll_master]

this.object.grp_centro_benef			[ll_master] = ls_nro_parte

end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 3 	      // columnas que recibimos del master

end event

type st_1 from statictext within w_pr022_prod_grupos_cen_ben
integer x = 233
integer y = 48
integer width = 1152
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Grupos de Centro Beneficio"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pr022_prod_grupos_cen_ben
integer x = 2153
integer y = 48
integer width = 1129
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Centros de Beneficio Por Grupo"
alignment alignment = center!
boolean focusrectangle = false
end type

