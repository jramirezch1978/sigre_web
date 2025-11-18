$PBExportHeader$w_ma902_generar_ot.srw
forward
global type w_ma902_generar_ot from w_abc
end type
type pb_2 from picturebutton within w_ma902_generar_ot
end type
type pb_1 from picturebutton within w_ma902_generar_ot
end type
type dw_master from u_dw_abc within w_ma902_generar_ot
end type
end forward

global type w_ma902_generar_ot from w_abc
integer width = 1911
integer height = 824
string title = "Generar Orden Trabajo (AP900)"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
event ue_aceptar ( )
event ue_cancelar ( )
pb_2 pb_2
pb_1 pb_1
dw_master dw_master
end type
global w_ma902_generar_ot w_ma902_generar_ot

type variables
sg_parametros		ist_datos
end variables

event ue_aceptar();string 	ls_ot_adm, ls_ot_tipo, ls_cencos_slc, &
			ls_Cencos_rsp, ls_centro_benef

if f_row_processing( dw_master, 'form') = false then return

ls_ot_adm 		 = dw_master.object.ot_adm			[1]
ls_ot_tipo 		 = dw_master.object.ot_tipo		[1]
ls_cencos_slc	 = dw_master.object.cencos_slc	[1]
ls_cencos_rsp	 = dw_master.object.cencos_rsp	[1]
ls_centro_benef = dw_master.object.centro_benef	[1]

ist_datos.string1 = ls_ot_adm
ist_datos.string2 = ls_ot_tipo
ist_datos.string3 = ls_cencos_slc
ist_datos.string4 = ls_cencos_rsp
ist_datos.string5 = ls_centro_benef
ist_datos.titulo = "s"	

CloseWithReturn(this, ist_datos)

end event

event ue_cancelar();ist_datos.titulo = "n"	
CloseWithReturn(this, ist_datos)
end event

on w_ma902_generar_ot.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_ma902_generar_ot.destroy
call super::destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_master)
end on

event ue_set_access;// Ancestor Script has been Override"
end event

event ue_open_pre;call super::ue_open_pre;dw_master.InsertRow(0)
end event

type pb_2 from picturebutton within w_ma902_generar_ot
integer x = 955
integer y = 492
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_cancelar()
end event

type pb_1 from picturebutton within w_ma902_generar_ot
integer x = 581
integer y = 492
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type dw_master from u_dw_abc within w_ma902_generar_ot
event ue_display ( string as_columna,  long al_row )
integer x = 32
integer y = 32
integer width = 1815
integer height = 444
string dataobject = "d_generar_ot_ff"
boolean border = false
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_otadm
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "OT_ADM"
		
		ls_sql = "SELECT OT_ADM AS CODIGO, " &
				  + "DESCRIPCION AS DESC_OT_ADM " &
				  + "FROM vw_ot_adm_user " &
				  + "WHERE COD_USR = '" + gs_user +"'"

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.ot_adm[al_row] 		= ls_codigo
			this.object.desc_ot_adm[al_row] 	= ls_data
			SetNull(ls_data)
 			this.object.ot_tipo[al_row] 		= ls_data
			this.object.desc_ot_tipo[al_row] = ls_data
			this.ii_update = 1
		end if

	case "OT_TIPO"
		
		ls_sql = "SELECT OT_TIPO AS CODIGO, " &
				  + "DESCRIPCION AS DESC_OT_TIPO " &
				  + "FROM ot_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.ot_tipo		[al_row]	= ls_codigo
			this.object.desc_ot_tipo[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "CENCOS_SLC"

		ls_sql = "SELECT CENCOS AS CODIGO, " &
			    + "DESC_CENCOS AS DESC_OT_TIPO " &
				 + "FROM CENTROS_COSTO " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos_slc		[al_row] = ls_codigo
			this.object.desc_cencos_slc[al_row] = ls_data
			this.ii_update = 1
		end if

	case "CENTRO_BENEF"

		ls_sql = "SELECT CENTRO_BENEF AS CODIGO, " &
			    + "DESC_CENTRO AS DESC_OT_TIPO " &
				 + "FROM centro_beneficio " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.object.desc_centro		[al_row] = ls_data
			this.ii_update = 1
		end if

	case "CENCOS_RSP"

		ls_sql = "SELECT CENCOS AS CODIGO, " &
			    + "DESC_CENCOS AS DESC_OT_TIPO " &
				 + "FROM CENTROS_COSTO " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos_rsp		[al_row] = ls_codigo
			this.object.desc_cencos_rsp[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event doubleclicked;call super::doubleclicked;string ls_columna
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

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;string ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

if row = 0 then return 

choose case upper(dwo.name)

	case "OT_ADM"
		
		SELECT DESCRIPCION 
			into :ls_data
		FROM vw_ot_adm_user
		WHERE COD_USR 	= :gs_user
		  and ot_adm 	= :data;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Error', 'CODIGO DE OT_ADM NO EXISTE O NO ESTA AUTORIZADO', stopSign!)
			this.object.ot_adm[row]       = ls_null
			this.object.desc_ot_adm[row]  = ls_null
			return 1
		end if
		
		this.object.desc_ot_adm[row] = ls_data
		
	case "OT_TIPO"
		
		SELECT DESCRIPCION 
			into :ls_data
		from ot_tipo 
	 	WHERE ot_tipo = :data;
		 
		if SQLCA.sqlcode = 100 then
			MessageBox('Error', 'CODIGO DE OT_TIPO NO EXISTE', stopSign!)
 			this.object.ot_tipo[row] 		= ls_null
			this.object.desc_ot_tipo[row] = ls_null
			return 1
		end if
		
		this.object.desc_ot_tipo[row] = ls_data

	case "CENCOS_SLC"
		
		SELECT DESC_CENCOS
			into :ls_data
		FROM CENTROS_COSTO
		WHERE FLAG_ESTADO = '1'
		  and cencos = :data;

		if SQLCA.SQlCode = 100 then
			MessageBox('Aviso', 'CODIGO DE CENTRO DE COSTO NO EXISTE O NO ESTA ACTIVO', stopSign!)
 			this.object.cencos_slc		[row] = ls_null
			this.object.desc_cencos_slc[row] = ls_null
			return 1
		end if

		this.object.desc_cencos_slc[row] = ls_data

	case "CENCOS_RSP"
		
		SELECT DESC_CENCOS
			into :ls_data
		FROM CENTROS_COSTO
		WHERE FLAG_ESTADO = '1'
		  and cencos = :data;

		if SQLCA.SQlCode = 100 then
			MessageBox('Aviso', 'CODIGO DE CENTRO DE COSTO NO EXISTE O NO ESTA ACTIVO', stopSign!)
 			this.object.cencos_rsp		[row] = ls_null
			this.object.desc_cencos_rsp[row] = ls_null
			return 1
		end if

		this.object.desc_cencos_rsp[row] = ls_data

	case "CENTRO_BENEF"
		
		SELECT desc_centro
			into :ls_data
		FROM centro_beneficio
		WHERE FLAG_ESTADO = '1'
		  and centro_benef = :data;

		if SQLCA.SQlCode = 100 then
			MessageBox('Aviso', 'CODIGO DE CENTRO DE COSTO NO EXISTE O NO ESTA ACTIVO', stopSign!)
 			this.object.centro_benef	[row] = ls_null
			this.object.desc_centro		[row] = ls_null
			return 1
		end if

		this.object.desc_centro[row] = ls_data

end choose

end event

