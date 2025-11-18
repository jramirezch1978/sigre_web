$PBExportHeader$w_com901_generar_ot_com.srw
forward
global type w_com901_generar_ot_com from w_abc
end type
type pb_1 from picturebutton within w_com901_generar_ot_com
end type
type pb_salir from picturebutton within w_com901_generar_ot_com
end type
type st_total from statictext within w_com901_generar_ot_com
end type
type st_1 from statictext within w_com901_generar_ot_com
end type
type dw_1 from u_dw_abc within w_com901_generar_ot_com
end type
type dw_master from u_dw_abc within w_com901_generar_ot_com
end type
end forward

global type w_com901_generar_ot_com from w_abc
integer width = 1911
integer height = 1500
string title = "Generar Orden Trabajo (AP900)"
string menuname = "m_smpl"
boolean maxbox = false
boolean resizable = false
boolean center = true
event ue_generar ( )
event ue_cancelar ( )
pb_1 pb_1
pb_salir pb_salir
st_total st_total
st_1 st_1
dw_1 dw_1
dw_master dw_master
end type
global w_com901_generar_ot_com w_com901_generar_ot_com

event ue_generar();string  	ls_ot_adm, ls_ot_tipo, ls_mensaje,      &
  			ls_cencos_slc, ls_cencos_rsp, ls_descr, &
  			ls_win, ls_desc_proc, ls_cod_proc,      &
			ls_nro_orden
date    	ld_desde, ld_hasta
integer 	li_ok
long    	ll_nro_proc, ll_count, ll_row
u_dw_abc	ldw_1

ls_ot_adm 		= idw_1.object.ot_adm[1]
ls_ot_tipo 		= idw_1.object.ot_tipo[1]
ls_cencos_slc 	= idw_1.object.cencos_slc[1]
ls_cencos_rsp 	= idw_1.object.cencos_rsp[1]
ls_descr			= idw_1.object.descripcion[1]
ld_desde			= date(idw_1.object.fec_desde[1])
ld_hasta			= date(idw_1.object.fec_hasta[1])

if ls_ot_adm = '' or IsNull(ls_ot_adm) then
	MessageBox('COMEDORES', 'FALTA OT_ADM, POR FAVOR VERIFIQUE', stopSign!)
	return
end if

if ls_ot_tipo = '' or IsNull(ls_ot_tipo) then
	MessageBox('COMEDORES', 'FALTA OT_TIPO, POR FAVOR VERIFIQUE', stopSign!)
	return
end if

if ls_cencos_slc = '' or IsNull(ls_cencos_slc) then
	MessageBox('COMEDORES', 'FALTA CENTRO DE COSTO SOLICITANTE, POR FAVOR VERIFIQUE', stopSign!)
	return
end if

if ls_cencos_rsp = '' or IsNull(ls_cencos_rsp) then
	MessageBox('COMEDORES', 'FALTA CENTRO DE COSTO RESPONSABLE, POR FAVOR VERIFIQUE', stopSign!)
	return
end if

if ls_descr = '' or IsNull(ls_descr) then
	MessageBox('COMEDORES', 'FALTA UNA BREVE DESCRIPCION, POR FAVOR VERIFIQUE', stopSign!)
	return
end if

if IsNull(ld_desde) or IsNull(ld_hasta) then
	MessageBox('COMEDORES', 'FALTAN LAS FECHAS DEL RANGO, POR FAVOR VERIFIQUE', stopSign!)
	return
end if

if ld_hasta < ld_desde then
	MessageBox('COMEDORES', 'EL RANGO DE FECHAS ESTA ERRONEO, POR FAVOR VERIFIQUE', stopSign!)
	return
end if

ls_win       = this.ClassName( )
ls_desc_proc = "GENERACION AUTOMATICA DE ORDENES " &
		+ "DE TRABAJO -> TIPO OT: " + ls_ot_tipo
ls_cod_proc  = gs_origen + "C1"

//create or replace procedure USP_COM_GENERAR_OT(
//     asi_origen    in origen.cod_origen%TYPE        , -- Origen de la OT   
//     asi_ot_adm    in ot_administracion.ot_adm%TYPE , 
//     asi_ot_tipo   in ot_tipo.ot_tipo%TYPE          , -- Tipo de OT
//     asi_censlc    in centros_costo.cencos%TYPE     , -- Centro de Costo Solicitante
//     asi_cenrsp    in centros_costo.cencos%TYPE     , -- Centro de Costo Responsable
//     asi_descrip   in varchar2                      , -- Descripcion de la OT
//     adi_desde     in date                          , -- Inicio del Rango de Tiempo
//     adi_hasta     in date                          , -- Fin del Periodo de Tiempo
//     asi_user      in usuario.cod_usr%TYPE          , -- Usuario que genera las OT
//     asi_win       in varchar2                      , -- nombre de la Ventana
//     asi_cod_proc  in varchar2                      , -- Codigo del Proceso
//     asi_desc_proc in varchar2                      , -- Breve descripcion del Proceso
//     aso_mensaje   out varchar2                     , -- Mensaje de Error
//     aio_ok        out number                       ,
//     lio_nro_proc  out oper_procesos.nro_proceso%TYPE -- ID de Proceso realizado
//  ) is

DECLARE USP_COM_GENERAR_OT PROCEDURE FOR
	USP_COM_GENERAR_OT( :gs_origen     , 
	                    :ls_ot_adm     ,
							  :ls_ot_tipo    ,
							  :ls_cencos_slc ,
							  :ls_cencos_rsp ,
							  :ls_descr      ,
							  :ld_desde      ,
							  :ld_hasta      ,
							  :gs_user       ,
							  :ls_win        ,
							  :ls_cod_proc   ,
							  :ls_desc_proc  );

EXECUTE USP_COM_GENERAR_OT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_COM_GENERAR_OT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_COM_GENERAR_OT INTO :ls_mensaje, :li_ok, :ll_nro_proc;
CLOSE USP_COM_GENERAR_OT;

if li_ok <> 1 then
	MessageBox('Error USP_COM_GENERAR_OT', ls_mensaje, StopSign!)	
	return
end if

if li_ok = 1 then
	MessageBox('COMEDORES', 'PROCESO EJECUTADO DE MANERA SATISFACTORIA', Exclamation!)	
	dw_1.Retrieve()
	st_total.text = string( dw_1.RowCount() )
	if IsValid(w_com300_parte_raciones) and &
		Not IsNull(w_com300_parte_raciones) then
		
		ldw_1  = w_com300_parte_raciones.dw_master
		ll_row = ldw_1.GetRow()
		if ll_row <= 0 then return
		if dw_1.RowCount() = 0 then return
		
		ls_nro_orden = dw_1.object.nro_orden[1]
		
		ldw_1.object.nro_orden[ll_row] = ls_nro_orden
		ldw_1.SetColumn("nro_orden")
		ldw_1.SetFocus()
		Close(this)
		
	else
		return
	end if

end if

end event

event ue_cancelar;close(this)
end event

on w_com901_generar_ot_com.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.pb_1=create pb_1
this.pb_salir=create pb_salir
this.st_total=create st_total
this.st_1=create st_1
this.dw_1=create dw_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_salir
this.Control[iCurrent+3]=this.st_total
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.dw_master
end on

on w_com901_generar_ot_com.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_salir)
destroy(this.st_total)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;date ld_fecha

ld_fecha = Today()

idw_1 = dw_master
idw_1.event dynamic ue_insert()

idw_1.object.fec_desde[1] = ld_fecha
idw_1.object.fec_hasta[1] = ld_fecha

dw_1.SetTransObject(sqlca)
end event

type pb_1 from picturebutton within w_com901_generar_ot_com
integer x = 1353
integer y = 888
integer width = 457
integer height = 164
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
end type

event clicked;Parent.event dynamic ue_generar()
end event

type pb_salir from picturebutton within w_com901_generar_ot_com
integer x = 1426
integer y = 1084
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = right!
end type

event clicked;Parent.event dynamic ue_cancelar()
end event

type st_total from statictext within w_com901_generar_ot_com
integer x = 923
integer y = 748
integer width = 357
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_com901_generar_ot_com
integer x = 27
integer y = 748
integer width = 901
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15780518
string text = "Ordenes Trab. Generadas:"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_1 from u_dw_abc within w_com901_generar_ot_com
integer x = 32
integer y = 816
integer width = 891
integer height = 440
integer taborder = 20
string dataobject = "d_tt_ot_generadas"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

type dw_master from u_dw_abc within w_com901_generar_ot_com
event ue_display ( string as_columna,  long al_row )
integer x = 32
integer y = 32
integer width = 1815
integer height = 692
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
		ls_otadm = this.object.ot_adm[al_row]
		
		if ls_otadm = '' or IsNull(ls_otadm) then
			MessageBox('APROVISIONAMIENTO', 'NO SE INDICADO UN OT_ADM, POR FAVOR VERIFIQUE', stopSign!)
			return
		end if
		
		ls_sql = "SELECT OT_TIPO AS CODIGO, " &
				  + "DESCRIPCION AS DESC_OT_TIPO " &
				  + "FROM ot_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.ot_tipo[al_row] 		= ls_codigo
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
			this.object.cencos_slc[al_row] 		= ls_codigo
			this.object.desc_cencos_slc[al_row] = ls_data
			this.ii_update = 1
		end if

	case "CENCOS_RSP"

		ls_sql = "SELECT CENCOS AS CODIGO, " &
			    + "DESC_CENCOS AS DESC_OT_TIPO " &
				 + "FROM CENTROS_COSTO " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos_rsp[al_row] 		= ls_codigo
			this.object.desc_cencos_rsp[al_row] = ls_data
			this.ii_update = 1
		end if

	case "COD_PLANTILLA"

		ls_sql = "SELECT COD_PLANTILLA AS CODIGO, " &
			    + "DESC_PLANTILLA AS DESCRIPCION " &
				 + "FROM vw_plant_ot_adm " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_plantilla[al_row]  = ls_codigo
			this.object.desc_plantilla[al_row] = ls_data
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

event itemchanged;call super::itemchanged;string ls_data, ls_codigo, ls_otadm
this.AcceptText()

if row = 0 then
	return
end if

choose case upper(dwo.name)

	case "OT_ADM"
		
		ls_codigo = this.object.ot_adm[row]
		
		SetNull(ls_data)
		SELECT DESCRIPCION 
			into :ls_data
		FROM vw_ot_adm_user
		WHERE COD_USR = :gs_user
		  and ot_adm = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = '' then
			MessageBox('APROVISIONAMIENTO', 'CODIGO DE OT_ADM NO EXISTE O NO ESTA AUTORIZADO', stopSign!)
			SetNull(ls_codigo)
			this.object.ot_adm[row]       = ls_codigo
			this.object.desc_ot_adm[row]  = ls_codigo
 			this.object.ot_tipo[row] 		= ls_codigo
			this.object.desc_ot_tipo[row] = ls_codigo
			return 1
		end if
		
		this.object.desc_ot_adm[row] = ls_data
		
		SetNull(ls_codigo)
		this.object.ot_tipo[row] 		= ls_codigo
		this.object.desc_ot_tipo[row] = ls_codigo
		
	case "OT_TIPO"
		ls_otadm = this.object.ot_adm[row]
		
		if ls_otadm = '' or IsNull(ls_otadm) then
			MessageBox('APROVISIONAMIENTO', 'NO SE INDICADO UN OT_ADM, POR FAVOR VERIFIQUE', stopSign!)
			return
		end if
		
		ls_codigo = this.object.ot_tipo[row]
		
		SetNull(ls_data)
		SELECT DESCRIPCION 
			into :ls_data
		from vw_ot_tipo_ot_adm 
	 	WHERE OT_ADM = :ls_otadm
		  and ot_tipo = :ls_codigo;
		 
		if IsNull(ls_data) or ls_data = '' then
			MessageBox('APROVISIONAMIENTO', 'CODIGO DE OT_TIPO NO EXISTE O NO ESTA AUTORIZADO', stopSign!)
			SetNull(ls_codigo)
 			this.object.ot_tipo[row] 		= ls_codigo
			this.object.desc_ot_tipo[row] = ls_codigo
			return 1
		end if
		
		this.object.desc_ot_tipo[row] = ls_data

	case "CENCOS_SLC"
		ls_codigo = this.object.cencos_slc[row]

		SetNull(ls_data)
		SELECT DESC_CENCOS
			into :ls_data
		FROM CENTROS_COSTO
		WHERE FLAG_ESTADO = '1'
		  and cencos = :ls_codigo;

		if IsNull(ls_data) or ls_data = '' then
			MessageBox('APROVISIONAMIENTO', 'CODIGO DE CENTRO DE COSTO SOLICITANTE NO EXISTE O NO ESTA ACTIVO', stopSign!)
			SetNull(ls_codigo)
 			this.object.cencos_slc[row] 		= ls_codigo
			this.object.desc_cencos_slc[row] = ls_codigo
			return 1
		end if

		this.object.desc_cencos_slc[row] = ls_data

	case "CENCOS_SLC"
		ls_codigo = this.object.cencos_rsp[row]

		SetNull(ls_data)
		SELECT DESC_CENCOS
			into :ls_data
		FROM CENTROS_COSTO
		WHERE FLAG_ESTADO = '1'
		  and cencos = :ls_codigo;

		if IsNull(ls_data) or ls_data = '' then
			MessageBox('APROVISIONAMIENTO', 'CODIGO DE CENTRO DE COSTO REPONSABLE NO EXISTE O NO ESTA ACTIVO', stopSign!)
			SetNull(ls_codigo)
 			this.object.cencos_rsp[row] 		= ls_codigo
			this.object.desc_cencos_rsp[row] = ls_codigo
			return 1
		end if

		this.object.desc_cencos_rsp[row] = ls_data

	case "COD_PLANTILLA"
		ls_codigo = this.object.cod_plantilla[row] 
		
		SetNull(ls_data)
		SELECT DESC_PLANTILLA
			into :ls_data
		from vw_plant_ot_adm
	  	WHERE FLAG_ESTADO = '1'
		  and cod_plantilla = :ls_codigo;
		  
		if IsNull(ls_data) or ls_data = '' then
			MessageBox('APROVISIONAMIENTO', 'CODIGO DE PLANTILLA NO EXISTE, NO ESTA ACTIVO O TIENE AUTORIZACION', stopSign!)
			SetNull(ls_codigo)
 			this.object.cod_plantilla[row]  = ls_codigo
			this.object.desc_plantilla[row] = ls_codigo
			return 1
		end if

		this.object.desc_plantilla[row] = ls_data
end choose

end event

