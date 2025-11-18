$PBExportHeader$w_hd001_contacto_empresa.srw
forward
global type w_hd001_contacto_empresa from window
end type
type pb_cancelar from picturebutton within w_hd001_contacto_empresa
end type
type pb_guardar from picturebutton within w_hd001_contacto_empresa
end type
type st_cerrar from statictext within w_hd001_contacto_empresa
end type
type st_contacto from statictext within w_hd001_contacto_empresa
end type
type dw_master from u_dw_abc within w_hd001_contacto_empresa
end type
type r_1 from rectangle within w_hd001_contacto_empresa
end type
type ln_1 from line within w_hd001_contacto_empresa
end type
end forward

global type w_hd001_contacto_empresa from window
integer width = 1929
integer height = 1136
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_cancelar pb_cancelar
pb_guardar pb_guardar
st_cerrar st_cerrar
st_contacto st_contacto
dw_master dw_master
r_1 r_1
ln_1 ln_1
end type
global w_hd001_contacto_empresa w_hd001_contacto_empresa

type variables
//Integer ii_empresa_id, ii_email_empresa_id
str_parametros ist_datos
end variables

on w_hd001_contacto_empresa.create
this.pb_cancelar=create pb_cancelar
this.pb_guardar=create pb_guardar
this.st_cerrar=create st_cerrar
this.st_contacto=create st_contacto
this.dw_master=create dw_master
this.r_1=create r_1
this.ln_1=create ln_1
this.Control[]={this.pb_cancelar,&
this.pb_guardar,&
this.st_cerrar,&
this.st_contacto,&
this.dw_master,&
this.r_1,&
this.ln_1}
end on

on w_hd001_contacto_empresa.destroy
destroy(this.pb_cancelar)
destroy(this.pb_guardar)
destroy(this.st_cerrar)
destroy(this.st_contacto)
destroy(this.dw_master)
destroy(this.r_1)
destroy(this.ln_1)
end on

event open;//ii_empresa_id = w_cw501_contactos.ii_empresa_id
if gs_action='new' then
	dw_master.Reset()
	dw_master.event ue_Insert()
	
	dw_master.ii_protect = 1
	dw_master.of_protect()
	
	dw_master.SetFocus()
	dw_master.setColumn("cod_usr")
elseif gs_action = 'open' then
	// Asigna parametro
	if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
		ist_datos = MESSAGE.POWEROBJECTPARM	
	end if
	//ii_email_empresa_id = w_cw501_contactos.ii_email_empresa_id
	dw_master.Retrieve(ist_datos.int1)
end if

end event

type pb_cancelar from picturebutton within w_hd001_contacto_empresa
integer x = 1143
integer y = 956
integer width = 357
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
long backcolor = 16777215
end type

event clicked;str_parametros lstr_param

lstr_param.b_return = false
CloseWithReturn(parent, lstr_param)
end event

type pb_guardar from picturebutton within w_hd001_contacto_empresa
integer x = 1536
integer y = 956
integer width = 357
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Guardar"
long textcolor = 16777215
long backcolor = 134217734
end type

event clicked;String ls_mensaje
str_parametros	lstr_param

dw_master.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al insertar contacto', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.b_return = true
CloseWithReturn(parent, lstr_param)
end event

type st_cerrar from statictext within w_hd001_contacto_empresa
integer x = 1787
integer y = 44
integer width = 133
integer height = 84
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217738
long backcolor = 16777215
string text = "X"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;str_parametros lstr_param

lstr_param.b_return = false
CloseWithReturn(parent, lstr_param)
end event

type st_contacto from statictext within w_hd001_contacto_empresa
integer x = 23
integer y = 44
integer width = 517
integer height = 80
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217734
long backcolor = 16777215
string text = "Contacto"
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_hd001_contacto_empresa
integer x = 37
integer y = 176
integer width = 1870
integer height = 700
string dataobject = "d_abc_contacto_empresa_ff"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_rec_error		[al_row] = '0'
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event ue_display;call super::ue_display;boolean	lb_ret
string 	ls_codigo, ls_data, ls_sql

this.AcceptText()
choose case lower(as_columna)
	case "empresa_id"
		ls_sql = "select empresa_id as id_empresa, " &
				 + "cod_empresa as codigo_empresa, " &
				 + "nombre as nombre_empresa " &
				 + "from empresa  " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.empresa_id		[al_row] = Integer(ls_codigo)
			this.object.cod_empresa		[al_row] = ls_data
			this.ii_update = 1
		end if
end choose

end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'empresa_id'
		
		// Verifica que codigo ingresado exista			
		Select cod_empresa
		into :ls_desc
		from empresa
		Where empresa_id = :data  
			and flag_estado = '1';
			
		// Verifica que el registro exista o no
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe empresa ingresada o no se encuentra activa, por favor verifique")
			this.object.empresa_id	[row] = ls_null
			this.object.cod_empresa	[row] = ls_null
			return 1
		end if

		this.object.cod_empresa		[row] = ls_desc

END CHOOSE
end event

type r_1 from rectangle within w_hd001_contacto_empresa
long linecolor = 134217734
integer linethickness = 4
long fillcolor = 67108864
integer x = -9
integer y = 888
integer width = 1952
integer height = 256
end type

type ln_1 from line within w_hd001_contacto_empresa
long linecolor = 134217734
integer linethickness = 4
integer beginx = 5
integer beginy = 164
integer endx = 1952
integer endy = 164
end type

