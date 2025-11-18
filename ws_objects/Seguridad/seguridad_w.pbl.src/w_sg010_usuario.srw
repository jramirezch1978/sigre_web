$PBExportHeader$w_sg010_usuario.srw
forward
global type w_sg010_usuario from w_abc_mastdet_smpl
end type
type st_roles from statictext within w_sg010_usuario
end type
type st_2 from statictext within w_sg010_usuario
end type
type st_label from statictext within w_sg010_usuario
end type
type dw_aplicaciones from u_dw_cns within w_sg010_usuario
end type
type cb_copiar from commandbutton within w_sg010_usuario
end type
type st_4 from statictext within w_sg010_usuario
end type
type ddlb_usuario from u_ddlb within w_sg010_usuario
end type
type uo_search from n_cst_search within w_sg010_usuario
end type
end forward

global type w_sg010_usuario from w_abc_mastdet_smpl
integer width = 3392
integer height = 2300
string title = "Mantenimiento de Usuarios  (SG010)"
string menuname = "m_abc_mastdet_smpl"
long backcolor = 67108864
st_roles st_roles
st_2 st_2
st_label st_label
dw_aplicaciones dw_aplicaciones
cb_copiar cb_copiar
st_4 st_4
ddlb_usuario ddlb_usuario
uo_search uo_search
end type
global w_sg010_usuario w_sg010_usuario

type variables
String	is_usr_org, is_usr_dst
end variables

event resize;// Override

dw_detail.height = newheight * 0.25 //La altura del DW de roles será la cuarta parte de la ventana
dw_detail.width  = newwidth / 2 - dw_detail.x - 10
dw_detail.y = newheight - dw_detail.height - 5

dw_aplicaciones.height 	= dw_detail.height
dw_aplicaciones.y			= dw_detail.y
dw_aplicaciones.x			= dw_detail.x + dw_detail.width + 10 
dw_aplicaciones.width  	= newwidth - dw_aplicaciones.x - 10

//Texto ROLES
st_roles.x = dw_detail.x
st_roles.y = dw_detail.y - 10 - st_roles.height

st_4.y 			= st_roles.y
ddlb_usuario.y = st_roles.y
cb_copiar.y		= st_roles.y

//dw_detail.width  = newwidth  - dw_detail.x - 10
dw_master.width 	= newwidth  - dw_master.x - 10
dw_master.height 	= st_roles.y - dw_master.y - 10
st_label.x 			= dw_master.width - st_label.width  - 10

uo_search.width 	= st_label.x - uo_Search.x - 10
uo_search.event ue_resize(sizetype, uo_search.width, newheight)
uo_search.of_set_filter_or_find( '1' )

end event

on w_sg010_usuario.create
int iCurrent
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
this.st_roles=create st_roles
this.st_2=create st_2
this.st_label=create st_label
this.dw_aplicaciones=create dw_aplicaciones
this.cb_copiar=create cb_copiar
this.st_4=create st_4
this.ddlb_usuario=create ddlb_usuario
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_roles
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_label
this.Control[iCurrent+4]=this.dw_aplicaciones
this.Control[iCurrent+5]=this.cb_copiar
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.ddlb_usuario
this.Control[iCurrent+8]=this.uo_search
end on

on w_sg010_usuario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_roles)
destroy(this.st_2)
destroy(this.st_label)
destroy(this.dw_aplicaciones)
destroy(this.cb_copiar)
destroy(this.st_4)
destroy(this.ddlb_usuario)
destroy(this.uo_search)
end on

event ue_open_pre;call super::ue_open_pre;dw_aplicaciones.SetTransObject(SQLCA)

if trim(gs_empresa) = "CROMOPLASTIC" then
	dw_master.Dataobject = "d_usuario_cromoplastic_tbl"
else
	dw_master.Dataobject = "d_usuario_tbl"
end if

dw_master.SetTransObject(SQLCA)

uo_search.of_set_dw(dw_master)
end event

event ue_insert;call super::ue_insert;IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF
end event

event ue_set_access;call super::ue_set_access;IF is_flag_duplicar = '1' THEN cb_copiar.enabled = True
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_sg010_usuario
integer y = 104
integer width = 3305
integer height = 840
string dataobject = "d_usuario_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
ii_dk[1] = 1 	
end event

event dw_master::clicked;call super::clicked;// Actualiza detalle

IF row = 0 THEN RETURN

is_usr_dst = THIS.object.cod_usr[row]

dw_detail.retrieve( dw_master.object.cod_usr[dw_master.getrow()])
if dw_detail.rowcount() > 0 then
	dw_aplicaciones.retrieve( dw_detail.object.grupo[1])
end if
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
dw_detail.retrieve( dw_master.object.cod_usr[dw_master.getrow()])
if dw_detail.rowcount() > 0 then
	dw_aplicaciones.retrieve( dw_detail.object.grupo[1])
end if
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_origen			[al_row] = 'S'
this.object.clave					[al_row] = 'x'
this.object.clave_soap			[al_row] = 'x'
this.object.flag_estado			[al_row] = '1'
this.object.nivel_log_objeto	[al_row] = '5'

end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc

dw_master.Accepttext()

CHOOSE CASE dwo.name
	CASE 'origen_alt'
		
		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_desc
		  from origen
		 Where cod_origen = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "CODIGO DE ORIGEN " + data + " no existe o no se encuentra activo, por favor verifique")
			this.object.origen_alt	[row] = gnvo_app.is_null
			this.object.nom_origen	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.nom_origen		[row] = ls_desc


END CHOOSE
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
		
	case "origen_alt"

		ls_sql = "select o.cod_origen as codigo_origen, " &
				 + "o.nombre as descripcion_origen " &
				 + "  from origen o" &
				 + " where o.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.origen_alt	[al_row] = ls_codigo
			this.object.nom_origen	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_sg010_usuario
integer y = 1044
integer width = 1829
integer height = 1044
string dataobject = "d_usr_grp_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1	
ii_rk[1] = 1 	
end event

event dw_detail::clicked;call super::clicked;if dw_detail.getrow() > 0 then
   dw_aplicaciones.retrieve( dw_detail.object.grupo[dw_detail.getrow()])
else
	dw_aplicaciones.reset()
end if 
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;if dw_detail.getrow() > 0 then
   dw_aplicaciones.retrieve( dw_detail.object.grupo[dw_detail.getrow()])
else
	dw_aplicaciones.reset()
end if 
end event

type st_roles from statictext within w_sg010_usuario
integer x = 9
integer y = 948
integer width = 421
integer height = 76
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Roles:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_sg010_usuario
integer x = 9
integer y = 12
integer width = 571
integer height = 88
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Usuarios:"
boolean focusrectangle = false
end type

type st_label from statictext within w_sg010_usuario
integer x = 2414
integer y = 8
integer width = 905
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "* Colocar ~'x~' como password generico"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_aplicaciones from u_dw_cns within w_sg010_usuario
integer x = 1861
integer y = 1044
integer width = 1454
integer height = 1044
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_grp_obj"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
ii_dk[1] = 1 	
end event

type cb_copiar from commandbutton within w_sg010_usuario
integer x = 3049
integer y = 948
integer width = 256
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Copiar"
end type

event clicked;Integer li_msg_result

IF dw_master.ii_update > 0 THEN 
	MessageBox('Eror', 'Primero debe grabar los nuevos Registros')
	RETURN
END IF

li_msg_result = MessageBox("Se procedara a Borrar los Accesos Actuales de: " + is_usr_org, "Esta Usted Seguro", Question!, YesNo!, 1)
IF li_msg_result <> 1 THEN RETURN

DECLARE PB_1 PROCEDURE FOR 
		  usp_copiar_acc_usr(:is_usr_org, :is_usr_dst);
		  
EXECUTE PB_1 ;

IF SQLCA.SQLCode = -1 THEN 
	Rollback ;
	Messagebox('Error','No se pudo Copiar los Atributos')
	Return
ELSE
	Commit ;
end if

CLOSE PB_1 ;


end event

type st_4 from statictext within w_sg010_usuario
integer x = 1390
integer y = 948
integer width = 498
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Copiar Accesos de:"
boolean focusrectangle = false
end type

type ddlb_usuario from u_ddlb within w_sg010_usuario
integer x = 1934
integer y = 948
integer width = 1070
integer height = 660
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_usuarios_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 12                     // Longitud del campo 1
ii_lc2 = 30							// Longitud del campo 2

end event

event ue_output;call super::ue_output;is_usr_org = aa_key
end event

type uo_search from n_cst_search within w_sg010_usuario
integer x = 613
integer y = 16
integer width = 1792
integer taborder = 30
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

