$PBExportHeader$w_ba300_ingreso_personal_externo.srw
forward
global type w_ba300_ingreso_personal_externo from w_abc_master_smpl
end type
type dp_1 from datepicker within w_ba300_ingreso_personal_externo
end type
type st_1 from statictext within w_ba300_ingreso_personal_externo
end type
type dp_2 from datepicker within w_ba300_ingreso_personal_externo
end type
type cb_1 from commandbutton within w_ba300_ingreso_personal_externo
end type
type uo_1 from n_cst_search within w_ba300_ingreso_personal_externo
end type
type st_2 from statictext within w_ba300_ingreso_personal_externo
end type
type sle_1 from singlelineedit within w_ba300_ingreso_personal_externo
end type
type cb_2 from commandbutton within w_ba300_ingreso_personal_externo
end type
type gb_1 from groupbox within w_ba300_ingreso_personal_externo
end type
end forward

global type w_ba300_ingreso_personal_externo from w_abc_master_smpl
integer width = 4506
integer height = 1424
string title = "(BA300) Control de Ingreso de Visitantes"
string menuname = "m_abc_master_smpl"
dp_1 dp_1
st_1 st_1
dp_2 dp_2
cb_1 cb_1
uo_1 uo_1
st_2 st_2
sle_1 sle_1
cb_2 cb_2
gb_1 gb_1
end type
global w_ba300_ingreso_personal_externo w_ba300_ingreso_personal_externo

type variables
datetime idt_fecsys
n_cst_seguridad_maestro inv_segmae
string is_puerta
end variables

forward prototypes
public function integer of_nro_reckey (long al_row)
end prototypes

public function integer of_nro_reckey (long al_row);//Numera documento
Long                      ll_ult_nro, ll_i
string    ls_mensaje, ls_nro, ls_tabla

 ls_tabla = dw_master.Object.Datawindow.Table.UpdateTable
                
                if ls_tabla = '' or Isnull(ls_tabla) then
                               MessageBox('Error', 'No ha especificado una tabla a actualizar para el datawindows maestro, por favor verifique!')
                               return 0
                end if
                
                Select ult_nro 
                               into :ll_ult_nro 
                from num_tablas 
                where origen = :gs_origen
                  and tabla           = :ls_tabla for update;
                
                IF SQLCA.SQLCode = 100 then
                               ll_ult_nro = 1
                               
                               Insert into num_tablas (origen, tabla, ult_nro)
                                               values( :gs_origen, :ls_tabla, 1);
                               
                               IF SQLCA.SQLCode < 0 then
                                               ls_mensaje = SQLCA.SQLErrText
                                               ROLLBACK;
                                               MessageBox('Error al insertar registro en num_tablas', ls_mensaje)
                                               return 0
                               end if
                end if
                
                dw_master.object.reckey[al_row] = ll_ult_nro
                
                //Incrementa contador
                Update num_tablas 
                               set ult_nro = :ll_ult_nro + 1 
                 where origen = :gs_origen
                  and tabla           = :ls_tabla;
                
                IF SQLCA.SQLCode < 0 then
                               ls_mensaje = SQLCA.SQLErrText
                               ROLLBACK;
                               MessageBox('Error al actualizar num_tablas', ls_mensaje)
                               return 0
                end if
  
return 1
end function

on w_ba300_ingreso_personal_externo.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.dp_1=create dp_1
this.st_1=create st_1
this.dp_2=create dp_2
this.cb_1=create cb_1
this.uo_1=create uo_1
this.st_2=create st_2
this.sle_1=create sle_1
this.cb_2=create cb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dp_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dp_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_1
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.gb_1
end on

on w_ba300_ingreso_personal_externo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dp_1)
destroy(this.st_1)
destroy(this.dp_2)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.cb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;datetime ldt_ini, ldt_fin
ldt_ini = datetime(date(dp_1.value),time('00:00:00'))
ldt_fin = datetime(date(dp_2.value),time('23:59:59'))

idt_fecsys = gnvo_app.of_fecha_actual()

is_puerta = sle_1.text

dw_master.retrieve(ldt_ini,ldt_fin, gs_origen, is_puerta)

end event

event ue_update_pre;call super::ue_update_pre;long i
long ll_reckey
string ls_null

setnull(ls_null)

ib_update_check = False

//Verificación de Data en Detalle de Documento
IF gnvo_app.of_row_Processing( dw_master ) <> true then	
	dw_master.setFocus( )
	return
END IF

for i = 1 to dw_master.rowcount()

	ll_reckey = dw_master.object.reckey[i]
	
	//valor por defecto cuando se inserta un registro
	if ll_reckey = 0 then
		
		if of_nro_reckey(i) = 0 then
			return
		end if
		
		if inv_segmae.of_setpersona( dw_master.object.tipo_doc_ident[i], dw_master.object.nro_doc_ident[i], &
											  dw_master.object.apell_paterno[i], dw_master.object.apell_materno[i], dw_master.object.nombre[i], &
											  ls_null) = -1 then
			return
		end if
		
	end if
	
next



ib_update_check = true
end event

event ue_open_pre;//override
THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()

idw_1 = dw_master             // asignar dw corriente
idw_1.SetTransObject(SQLCA)

im_1 = CREATE m_rButton      


ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master



uo_1.of_set_dw(dw_master)

end event

event ue_update;//override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	
	dw_master.il_totdel = 0
	
	dw_master.ResetUpdate()
	
//	dw_master.ii_protect = 0
//	dw_master.of_protect( )
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
//	this.event ue_retrieve()
	
END IF
end event

type dw_master from w_abc_master_smpl`dw_master within w_ba300_ingreso_personal_externo
integer x = 29
integer y = 410
integer width = 4421
integer height = 848
string dataobject = "d_ope_ingreso_personal_externo"
end type

event dw_master::constructor;call super::constructor;is_dwform =  'grid'
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr				[al_row] = gs_user
this.object.fec_registro [al_row] = datetime(today(),now())
this.object.fec_ingreso [al_row] = datetime(today(),now())
this.object.cod_origen [al_row] = gs_origen
this.object.cod_puerta[al_row] = is_puerta
setcolumn('fec_ingreso')
end event

event dw_master::doubleclicked;call super::doubleclicked;if row > 0 then
	string ls_sql, ls_return1, ls_return2, ls_rest
	
	ls_rest = 'if ( isnull(Fec_salida), 0,1)'
	
	if this.Describe("Evaluate('"+ls_rest+"', "+string(row)+")") = '1' then
		return
	end if
	
	if dwo.name = 'tipo_doc_ident' then
		ls_sql = "SELECT cod_doc_identidad as codigo, descripcion as descripcion FROM RRHH_DOCUMENTO_IDENTIDAD_RTPS where flag_estado = '1'" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				this.object.tipo_doc_ident [row] = ls_return1
				this.ii_update = 1
	elseif dwo.name = 'ruc' then
		ls_sql = "SELECT ruc as ruc, nom_proveedor as razon_social FROM proveedor where ruc is not null order by 2" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				this.object.ruc [row] = ls_return1
				this.object.razon_social [row] = ls_return2
				this.ii_update = 1
	end if
end if
end event

event dw_master::itemchanged;call super::itemchanged;if row > 0 then
	
	string ls_desc, ls_apepat, ls_apemat, ls_nombre, ls_brevete
	
	choose case dwo.name
			
		case 'tipo_doc_ident'
			
			SELECT descripcion into :ls_desc FROM RRHH_DOCUMENTO_IDENTIDAD_RTPS where flag_estado = '1' and cod_doc_identidad = :data;
			
			if sqlca.sqlcode = 100 then
				this.object.tipo_doc_ident[row] = ''
				return 1
			end if
			
			if inv_segmae.of_getpersona(data,this.object.nro_doc_ident[row],ls_apepat,ls_apemat,ls_nombre,ls_brevete) = 1 then
				this.object.apell_paterno[row] = ls_apepat
				this.object.apell_materno[row] = ls_apemat
				this.object.nombre[row] = ls_nombre
				setcolumn('visita_dst')
			end if
		
		case 'nro_doc_ident'
			
			if inv_segmae.of_getpersona(this.object.tipo_doc_ident[row],data,ls_apepat,ls_apemat,ls_nombre,ls_brevete) = 1 then
				this.object.apell_paterno[row] = ls_apepat
				this.object.apell_materno[row] = ls_apemat
				this.object.nombre[row] = ls_nombre
				setcolumn('visita_dst')
			end if
			
		case 'ruc'
			
			if inv_segmae.of_getproveedor(data,ls_desc) = 1 then
				this.object.razon_social[row] = ls_desc
				setcolumn('obs')
			end if
			
			select nom_proveedor into :ls_desc from proveedor where ruc = :data;
			
			if sqlca.sqlcode = 0 then
				this.object.razon_social[row] = ls_desc
				return 2
			end if			
			
		case 'fec_ingreso' 
			
			if date(data) < date(idt_fecsys) then
				MessageBox('Aviso','La fecha de Ingreso no puede ser menor a la del dia de hoy')
				this.object.fec_ingreso[row] = datetime(date(idt_fecsys),now())
				return 1
			end if
			
			if datetime(data) > datetime( this.object.fec_salida[row] ) then
				MessageBox('Aviso','La fecha de Ingreso no puede ser mayor a la de salida')
				this.object.fec_ingreso[row] = datetime(date(idt_fecsys),time('00:00:00'))
				return 1
			end if
			
		case 'fec_salida' 
			
			if datetime(data) > datetime(idt_fecsys) then
				MessageBox('Aviso','La fecha de salida no puede ser mayor a la del sistema')
				this.object.fec_salida[row] = idt_fecsys
				return 1
			end if
			
			if datetime(data) < datetime(  this.object.fec_ingreso[row] ) then
				MessageBox('Aviso','La fecha de salida no puede ser menor a la de ingreso')
				this.object.fec_salida[row] = idt_fecsys
				return 1
			end if
			
	end choose
	
end if
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert;//override
long ll_row

if is_puerta = '' or isnull(is_puerta) then
	MessageBox('Aviso','Debe definir una puerta de Ingreso para poder continuar')
	return 0
end if

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
//	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF (is_mastdet = 'md' OR is_mastdet = 'dd') and (not ISNull(idw_det) and isValid(idw_det)) THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

event dw_master::ue_delete_pre;call super::ue_delete_pre;if this.getrow() <= 0 then return 0

if this.object.reckey[this.getrow()] <> 0 then
	return 0
else
	return 1
end if
end event

event dw_master::ue_delete;//override
long ll_row = 1

ib_insert_mode = False

ll_row = THIS.Event ue_delete_pre()  // solo si se tiene detalle

IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row


end event

type dp_1 from datepicker within w_ba300_ingreso_personal_externo
integer x = 73
integer y = 115
integer width = 457
integer height = 99
integer taborder = 20
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-13"), Time("16:06:45.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type st_1 from statictext within w_ba300_ingreso_personal_externo
integer x = 530
integer y = 131
integer width = 80
integer height = 51
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type dp_2 from datepicker within w_ba300_ingreso_personal_externo
integer x = 625
integer y = 115
integer width = 457
integer height = 99
integer taborder = 20
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-13"), Time("16:06:45.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type cb_1 from commandbutton within w_ba300_ingreso_personal_externo
integer x = 1814
integer y = 154
integer width = 355
integer height = 106
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Aceptar"
end type

event clicked;if sle_1.text = '' or isnull(sle_1.text) then
	MessageBox('Aviso','Debe Ingresar un Codigo de puerta para poder ver el listado')
	return
end if

parent.event ue_retrieve()
end event

type uo_1 from n_cst_search within w_ba300_ingreso_personal_externo
integer x = 29
integer y = 282
integer width = 2966
integer height = 106
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call n_cst_search::destroy
end on

type st_2 from statictext within w_ba300_ingreso_personal_externo
integer x = 1156
integer y = 131
integer width = 176
integer height = 51
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Puerta:"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_ba300_ingreso_personal_externo
integer x = 1342
integer y = 112
integer width = 194
integer height = 90
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

event modified;integer li_count
select count(1)
into :li_count
from seg_puerta_ingreso_salida 
where cod_puerta = :this.text and flag_estado = '1' and flag_in_out in ('1','2') and cod_origen = :gs_origen;

if li_count = 0 then
	this.text = ''
end if
		 	
			 
if dw_master.rowcount() = 0 then
	is_puerta = this.text
end if
end event

type cb_2 from commandbutton within w_ba300_ingreso_personal_externo
integer x = 1562
integer y = 112
integer width = 165
integer height = 90
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;string ls_sql, ls_return1, ls_return2
ls_sql = "SELECT cod_puerta as codigo, descripcion as descripcion FROM seg_puerta_ingreso_salida where flag_estado = '1' and flag_in_out in ('1','2') and cod_origen = '"+gs_origen+"'" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				sle_1.text = ls_return1
				
if dw_master.rowcount() = 0 then
	is_puerta = ls_return1
end if
end event

type gb_1 from groupbox within w_ba300_ingreso_personal_externo
integer x = 29
integer y = 26
integer width = 1759
integer height = 234
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

