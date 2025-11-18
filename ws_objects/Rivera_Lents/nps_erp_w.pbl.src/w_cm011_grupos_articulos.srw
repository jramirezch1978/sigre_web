$PBExportHeader$w_cm011_grupos_articulos.srw
forward
global type w_cm011_grupos_articulos from w_abc_mastdet_smpl_v
end type
type st_1 from statictext within w_cm011_grupos_articulos
end type
type st_2 from statictext within w_cm011_grupos_articulos
end type
end forward

global type w_cm011_grupos_articulos from w_abc_mastdet_smpl_v
integer width = 4334
integer height = 2460
string title = "Grupos [CM011]"
st_1 st_1
st_2 st_2
end type
global w_cm011_grupos_articulos w_cm011_grupos_articulos

on w_cm011_grupos_articulos.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_cm011_grupos_articulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_modify;call super::ue_modify;int li_protect_grupo, li_protect_art

li_protect_grupo = integer(dw_master.Object.Grupo_art.Protect)
IF li_protect_grupo= 0 THEN
   dw_master.Object.grupo_art.Protect = 1
END IF

li_protect_art = integer(dw_detail.Object.Cod_art.Protect)
IF li_protect_art = 0 THEN
   dw_detail.Object.cod_art.Protect = 1
END IF
end event

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

type ole_skin from w_abc_mastdet_smpl_v`ole_skin within w_cm011_grupos_articulos
end type

type st_filter from w_abc_mastdet_smpl_v`st_filter within w_cm011_grupos_articulos
end type

type uo_filter from w_abc_mastdet_smpl_v`uo_filter within w_cm011_grupos_articulos
end type

type uo_h from w_abc_mastdet_smpl_v`uo_h within w_cm011_grupos_articulos
end type

type st_box from w_abc_mastdet_smpl_v`st_box within w_cm011_grupos_articulos
end type

type dw_master from w_abc_mastdet_smpl_v`dw_master within w_cm011_grupos_articulos
event ue_display ( string as_columna,  long al_row )
integer x = 507
integer y = 416
integer width = 1952
integer height = 1320
string dataobject = "d_abc_grupos_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo

this.AcceptText()

choose case lower(as_columna)
		
	case "und"
		ls_sql = "SELECT und AS CODIGO_unidad, " &
				  + "desc_unidad AS DESCRIPCION_unidad " &
				  + "FROM unidad " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.und			[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
		return
end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//ib_delete_cascada = true
is_dwform = 'tabular'
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve( aa_id[1])
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "und"
		
		select desc_unidad
			into :ls_data
		from unidad
		where und = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de unidad no existe o no está activo", StopSign!)
			this.object.und	[row] = ls_null
			return 1
		end if

end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

type dw_detail from w_abc_mastdet_smpl_v`dw_detail within w_cm011_grupos_articulos
integer x = 2482
integer y = 416
integer width = 1742
integer height = 1320
string dataobject = "d_abc_articulo_grupo_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 2	      // columnas que recibimos del master

end event

event dw_detail::doubleclicked;// Abre ventana de ayuda 
str_parametros sl_param
String ls_name, ls_prot

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

IF ls_name = 'cod_art' and ls_prot = '0' then
	OpenWithParm (w_pop_articulos, parent)
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' then
		this.object.cod_art[this.getrow()] = sl_param.field_ret[1]
//		this.object.desc_art[this.getrow()] = sl_param.field_ret[2]		
 	END IF
END IF
end event

type st_vertical from w_abc_mastdet_smpl_v`st_vertical within w_cm011_grupos_articulos
integer x = 2459
integer y = 416
end type

type st_1 from statictext within w_cm011_grupos_articulos
integer x = 507
integer y = 328
integer width = 1952
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
string text = "Grupos"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm011_grupos_articulos
integer x = 2482
integer y = 332
integer width = 1742
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
string text = "Articulos"
alignment alignment = center!
boolean focusrectangle = false
end type

