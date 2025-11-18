$PBExportHeader$w_cm324_oc_importacion.srw
forward
global type w_cm324_oc_importacion from w_abc
end type
type pb_aceptar from picturebutton within w_cm324_oc_importacion
end type
type pb_cancel from picturebutton within w_cm324_oc_importacion
end type
type dw_master from u_dw_abc within w_cm324_oc_importacion
end type
end forward

global type w_cm324_oc_importacion from w_abc
integer width = 2309
integer height = 1376
string title = "Datos en OC Importacion (CM324)"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
pb_aceptar pb_aceptar
pb_cancel pb_cancel
dw_master dw_master
end type
global w_cm324_oc_importacion w_cm324_oc_importacion

forward prototypes
public subroutine of_retrieve (string as_origen, string as_nro_oc)
end prototypes

public subroutine of_retrieve (string as_origen, string as_nro_oc);Long ll_row

dw_master.Retrieve(as_origen, as_nro_oc)

if dw_master.RowCount() = 0 then
	ll_row = dw_master.event ue_insert()
	if ll_row > 0 then
		dw_master.object.cod_origen [ll_row] = as_origen
		dw_master.object.nro_oc		 [ll_row] = as_nro_oc
	end if
end if
end subroutine

on w_cm324_oc_importacion.create
int iCurrent
call super::create
this.pb_aceptar=create pb_aceptar
this.pb_cancel=create pb_cancel
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_aceptar
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.dw_master
end on

on w_cm324_oc_importacion.destroy
call super::destroy
destroy(this.pb_aceptar)
destroy(this.pb_cancel)
destroy(this.dw_master)
end on

event open;// Ancestor Script has been Override

str_parametros lstr_data

if Not IsValid(Message.PowerObjectParm) &
	or IsNull(Message.PowerObjectParm) then
	
	Close(this)
	
end if

if Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Aviso', 'Parametros de Ingreso son diferentes a str_parametros')
	Close(this)
	return
end if
	
lstr_data = Message.PowerObjectParm
dw_master.SetTransObject(SQLCA)

of_retrieve(lstr_data.origen, lstr_data.nro_oc)



end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

ib_update_check = true
end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

type pb_aceptar from picturebutton within w_cm324_oc_importacion
integer x = 745
integer y = 1064
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

event clicked;parent.event dynamic ue_update()
close(parent)
end event

type pb_cancel from picturebutton within w_cm324_oc_importacion
integer x = 1120
integer y = 1064
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
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_update_request()
close(parent)
end event

type dw_master from u_dw_abc within w_cm324_oc_importacion
event ue_display ( string as_columna,  long al_row )
integer width = 2240
integer height = 1040
string dataobject = "d_abc_oc_importacion"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "agente_aduana"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS DESCRIPCION_proveedor, " &
				  + "ruc AS nro_ruc " &
				  + "FROM proveedor " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.agente_aduana		[al_row] = ls_codigo
			this.object.nom_agente_aduana	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "courrier"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS DESCRIPCION_proveedor, " &
				  + "ruc AS nro_ruc " &
				  + "FROM proveedor " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.courrier		[al_row] = ls_codigo
			this.object.nom_courrier[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose

end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event itemchanged;call super::itemchanged;string ls_desc, ls_null

SetNull(ls_null)

choose case lower(dwo.name)
		
	case "agente_aduana"
		
		select nom_proveedor
			into :ls_desc
		from proveedor
		where proveedor = :data
		  and flag_estado = '1';
		  
		if SQLCA.SQlCode = 100 then
			MessageBox('Aviso', 'Debe ingresar un codigo de relacion valido')
			this.object.agente_aduana 		[row] = ls_null
			this.object.nom_agente_aduana [row] = ls_null
			return
		end if
		
		this.object.nom_agente_aduana [row] = ls_desc

	case "courrier"
		
		select nom_proveedor
			into :ls_desc
		from proveedor
		where proveedor = :data
		  and flag_estado = '1';
		  
		if SQLCA.SQlCode = 100 then
			MessageBox('Aviso', 'Debe ingresar un codigo de relacion valido')
			this.object.courrier		[row] = ls_null
			this.object.nom_courrier[row] = ls_null
			return
		end if
		
		this.object.nom_courrier[row] = ls_desc
end choose

end event

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

