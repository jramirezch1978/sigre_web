$PBExportHeader$w_pr025_ususarios_por_centro_ben.srw
forward
global type w_pr025_ususarios_por_centro_ben from w_abc_master
end type
type st_c from statictext within w_pr025_ususarios_por_centro_ben
end type
type st_u from statictext within w_pr025_ususarios_por_centro_ben
end type
type dw_centros from u_dw_abc within w_pr025_ususarios_por_centro_ben
end type
end forward

global type w_pr025_ususarios_por_centro_ben from w_abc_master
integer width = 3305
integer height = 2188
string title = "Usuarios por Centro de Beneficio(PR025)"
string menuname = "m_mantto_consulta"
st_c st_c
st_u st_u
dw_centros dw_centros
end type
global w_pr025_ususarios_por_centro_ben w_pr025_ususarios_por_centro_ben

on w_pr025_ususarios_por_centro_ben.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.st_c=create st_c
this.st_u=create st_u
this.dw_centros=create dw_centros
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_c
this.Control[iCurrent+2]=this.st_u
this.Control[iCurrent+3]=this.dw_centros
end on

on w_pr025_ususarios_por_centro_ben.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_c)
destroy(this.st_u)
destroy(this.dw_centros)
end on

event resize;//Override

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

st_c.x = dw_master.X
st_c.width = dw_master.width

dw_centros.width  = newwidth  - dw_centros.x - 10
st_u.x = dw_master.X
st_u.width = dw_master.width
end event

event ue_open_pre;call super::ue_open_pre;long 		ll_row
ib_log = TRUE

dw_centros.SetTransObject(sqlca)
dw_centros.Retrieve()




end event

type dw_master from w_abc_master`dw_master within w_pr025_ususarios_por_centro_ben
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 1064
integer width = 3141
integer height = 812
string dataobject = "d_abc_prod_centro_benef_usuario_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

//sg_parametros sl_param

choose case upper(as_columna)
		
		case "COD_USR"

		ls_sql = "SELECT COD_USR AS CODIGO_USUARIO, " &
				  + "NOMBRE AS NOMBRE_USUARIO " &
				  + "FROM USUARIO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_usr			[al_row] = ls_codigo
			this.object.nombre			[al_row] = ls_data
			this.ii_update = 1
		end if					
end choose
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master


end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
Long		ll_count

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
		
	case "cod_usr"
		
		ls_codigo = this.object.cod_usr[row]

		SetNull(ls_data)
		select nombre
			into :ls_data
		from usuario
		where cod_usr = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Usuario no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_usr	  	[row] = ls_codigo
			this.object.nombre		[row] = ls_codigo
			return 1
		end if

		this.object.nombre			[row] = ls_data
  end choose
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;integer 	li_item
long 		ll_rows, ll_master, ll_detail
string 	ls_nro_parte, ls_grupo

ll_master = dw_centros.getrow( )

if ll_master < 0 then
	messagebox('Modulo de Produccion','Primero debe Seleccionar un Centro Feneficio')
	return

else
	
	ls_nro_parte = dw_centros.object.centro_benef [ll_master]
	this.object.centro_benef [al_row] = ls_nro_parte
	
end if
end event

event dw_master::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type st_c from statictext within w_pr025_ususarios_por_centro_ben
integer width = 3141
integer height = 92
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centros de Beneficio"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_u from statictext within w_pr025_ususarios_por_centro_ben
integer y = 968
integer width = 3141
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Usuarios por Centro de Beneficio"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_centros from u_dw_abc within w_pr025_ususarios_por_centro_ben
integer y = 100
integer width = 3141
integer height = 860
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_prod_centro_ben_usuarios_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;is_mastdet = 'm'			// 'm' = master sin detalle (default), 'd' =  detalle,
                     	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 					// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle

end event

event rowfocuschanged;call super::rowfocuschanged;//dw_detail.reset()
//dw_master.reset()
//
//if currentrow >= 1 then
//	if dw_master.retrieve(this.object.nro_parte[currentrow]) >= 1 then
//		dw_master.scrolltorow(1)
//		dw_master.setrow(1)
//		dw_master.selectrow( 1, true)
//	end if
//end if
end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

dw_master.ScrollToRow(al_row)

end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;dw_master.retrieve(aa_id[1])
end event

event ue_delete;//Override

Return 1
end event

event ue_insert;//Override

Return 1
end event

event ue_insert_pre;//Override

Return
end event

event itemerror;call super::itemerror;return 1
end event

