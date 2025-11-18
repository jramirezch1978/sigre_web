$PBExportHeader$w_ba301_ingreso_vehicular.srw
forward
global type w_ba301_ingreso_vehicular from w_abc
end type
type tab_1 from tab within w_ba301_ingreso_vehicular
end type
type tp_1 from userobject within tab_1
end type
type cb_2 from commandbutton within tp_1
end type
type sle_1 from singlelineedit within tp_1
end type
type st_1 from statictext within tp_1
end type
type dw_1 from u_dw_abc within tp_1
end type
type uo_1 from n_cst_search within tp_1
end type
type dp_2 from datepicker within tp_1
end type
type st_2 from statictext within tp_1
end type
type cb_1 from commandbutton within tp_1
end type
type dp_1 from datepicker within tp_1
end type
type gb_1 from groupbox within tp_1
end type
type tp_1 from userobject within tab_1
cb_2 cb_2
sle_1 sle_1
st_1 st_1
dw_1 dw_1
uo_1 uo_1
dp_2 dp_2
st_2 st_2
cb_1 cb_1
dp_1 dp_1
gb_1 gb_1
end type
type tp_2 from userobject within tab_1
end type
type dw_2 from u_dw_abc within tp_2
end type
type tp_2 from userobject within tab_1
dw_2 dw_2
end type
type tab_1 from tab within w_ba301_ingreso_vehicular
tp_1 tp_1
tp_2 tp_2
end type
end forward

global type w_ba301_ingreso_vehicular from w_abc
integer width = 2399
integer height = 1270
string title = "(BA301) Ingreso Vehicular"
string menuname = "m_abc_master_smpl"
integer ii_pregunta_delete = 1
event ue_retrieve ( )
tab_1 tab_1
end type
global w_ba301_ingreso_vehicular w_ba301_ingreso_vehicular

type variables
datetime idt_fecsys
n_cst_seguridad_maestro inv_segmae
string is_puerta
end variables

forward prototypes
public function integer of_nro_registro (long al_row)
end prototypes

event ue_retrieve();//retrieve

tab_1.tp_1.cb_1.event clicked()
end event

public function integer of_nro_registro (long al_row);//Numera documento
Long                      ll_ult_nro, ll_i
string    ls_mensaje, ls_nro, ls_tabla

 ls_tabla = tab_1.tp_2.dw_2.Object.Datawindow.Table.UpdateTable
                
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
					 
					 tab_1.tp_2.dw_2.object.nro_registro[al_row] = ll_ult_nro
  
return 1
end function

on w_ba301_ingreso_vehicular.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_ba301_ingreso_vehicular.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 32
tab_1.height = newheight - tab_1.y - 32

tab_1.tp_1.dw_1.width = tab_1.tp_1.width - (tab_1.tp_1.dw_1.x + 32)
tab_1.tp_1.dw_1.height = tab_1.tp_1.height - (tab_1.tp_1.dw_1.y + 32)

tab_1.tp_2.dw_2.width = tab_1.tp_2.width - (tab_1.tp_2.dw_2.x + 32)
tab_1.tp_2.dw_2.height = tab_1.tp_2.height - (tab_1.tp_2.dw_2.y + 32)
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = tab_1.tp_2.dw_2
tab_1.tp_1.uo_1.of_set_dw( tab_1.tp_1.dw_1 )

tab_1.tp_2.dw_2.settransobject(sqlca)
tab_1.tp_1.dw_1.settransobject(sqlca)

m_abc_master_smpl.m_file.m_printer.m_print1.enabled = true
m_abc_master_smpl.m_file.m_printer.m_print1.toolbaritemvisible = true
m_abc_master_smpl.m_file.m_printer.m_print1.toolbaritemorder = 980
end event

event ue_insert;call super::ue_insert;tab_1.selecttab(2)

Long  ll_row

ll_row = tab_1.tp_2.dw_2.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_update_pre;long ll_reckey, ll_row

ib_update_check = False

//Verificación de Data en Detalle de Documento
IF gnvo_app.of_row_Processing( tab_1.tp_2.dw_2 ) <> true then	
	tab_1.tp_2.dw_2.setFocus( )
	return
END IF

ll_row = tab_1.tp_2.dw_2.getrow()

ll_reckey = tab_1.tp_2.dw_2.object.nro_registro[ ll_row  ]

string ls_fecha, ls_puerta

ls_fecha = string(tab_1.tp_2.dw_2.object.fec_salida[ll_row],'dd/mm/yyyy')
ls_puerta = tab_1.tp_2.dw_2.object.cod_puerta_out[ll_row]

if ll_reckey <> 0 then
	
	if ls_fecha <> '00/00/0000' and ls_fecha <> '' and not isnull(ls_fecha) and ( ls_puerta = '' or isnull(ls_puerta) ) then
		MessageBox('Aviso','Debe Ingresar un codigo de puerta de salida para poder guardar')
		return
	end if
	
end if

if inv_segmae.of_setpersona( tab_1.tp_2.dw_2.object.tipo_doc_ident[ll_row], tab_1.tp_2.dw_2.object.nro_doc_ident[ll_row], &
									  tab_1.tp_2.dw_2.object.apepat[ll_row],tab_1.tp_2.dw_2.object.apemat[ll_row],tab_1.tp_2.dw_2.object.nombre[ll_row], &
									  tab_1.tp_2.dw_2.object.nro_brevete[ll_row]) = -1 then
	return
end if

if inv_segmae.of_setproveedor( tab_1.tp_2.dw_2.object.ruc[ll_row], tab_1.tp_2.dw_2.object.razon_social[ll_row]) = -1 then
	return
end if

if inv_segmae.of_setvehiculo( tab_1.tp_2.dw_2.object.placa[ll_row], tab_1.tp_2.dw_2.object.placa_carreta[ll_row], &
									  tab_1.tp_2.dw_2.object.tipo_remolque[ll_row],tab_1.tp_2.dw_2.object.ruc[ll_row]) = -1 then
	return
end if

//valor por defecto cuando se inserta un registro
if ll_reckey = 0 then
	
	if of_nro_registro( ll_row ) = 0 then
		return
	end if
	
end if

ib_update_check = true
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

tab_1.tp_2.dw_2.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	tab_1.tp_2.dw_2.ii_update = 1 AND lbo_ok = TRUE THEN
	IF tab_1.tp_2.dw_2.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    		Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		
		dwItemStatus l_status
		l_status = tab_1.tp_2.dw_2.GetItemStatus( tab_1.tp_2.dw_2.GetRow(), "nro_registro", Primary!)
		
		if l_status = New! or l_status = NewModified! then
			tab_1.tp_2.dw_2.object.nro_registro[ tab_1.tp_2.dw_2.GetRow() ] = 0
		end if
		
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	tab_1.tp_2.dw_2.ii_update = 0
END IF
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (tab_1.tp_2.dw_2.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		tab_1.tp_2.dw_2.ii_update = 0
	END IF
END IF
end event

event ue_print;call super::ue_print;long ll_nroreg
long ll_row

ll_row = tab_1.tp_2.dw_2.getrow()

if ll_row <= 0 then return

ll_nroreg = tab_1.tp_2.dw_2.object.nro_registro[ll_row]

str_parametros lstr_parametros

lstr_parametros.long1 = ll_nroreg

OpenSheetWithParm( w_ba301_ingreso_vehicular_ficha, lstr_parametros, this, 2, Layered!)
end event

type tab_1 from tab within w_ba301_ingreso_vehicular
integer x = 29
integer y = 26
integer width = 2315
integer height = 1078
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tp_1 tp_1
tp_2 tp_2
end type

on tab_1.create
this.tp_1=create tp_1
this.tp_2=create tp_2
this.Control[]={this.tp_1,&
this.tp_2}
end on

on tab_1.destroy
destroy(this.tp_1)
destroy(this.tp_2)
end on

type tp_1 from userobject within tab_1
integer x = 15
integer y = 106
integer width = 2286
integer height = 960
long backcolor = 79741120
string text = "Lista"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_2 cb_2
sle_1 sle_1
st_1 st_1
dw_1 dw_1
uo_1 uo_1
dp_2 dp_2
st_2 st_2
cb_1 cb_1
dp_1 dp_1
gb_1 gb_1
end type

on tp_1.create
this.cb_2=create cb_2
this.sle_1=create sle_1
this.st_1=create st_1
this.dw_1=create dw_1
this.uo_1=create uo_1
this.dp_2=create dp_2
this.st_2=create st_2
this.cb_1=create cb_1
this.dp_1=create dp_1
this.gb_1=create gb_1
this.Control[]={this.cb_2,&
this.sle_1,&
this.st_1,&
this.dw_1,&
this.uo_1,&
this.dp_2,&
this.st_2,&
this.cb_1,&
this.dp_1,&
this.gb_1}
end on

on tp_1.destroy
destroy(this.cb_2)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.uo_1)
destroy(this.dp_2)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.dp_1)
destroy(this.gb_1)
end on

type cb_2 from commandbutton within tp_1
integer x = 1485
integer y = 118
integer width = 176
integer height = 102
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_sql, ls_return1, ls_return2
ls_sql = "SELECT cod_puerta as codigo, descripcion as descripcion FROM seg_puerta_ingreso_salida where flag_estado = '1' and flag_in_out in ('1','3') and cod_origen = '"+gs_origen+"'" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				sle_1.text = ls_return1
				
if dw_1.rowcount() = 0 then
	is_puerta = ls_return1
end if
end event

type sle_1 from singlelineedit within tp_1
integer x = 1276
integer y = 118
integer width = 176
integer height = 102
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

event modified;integer li_count
select count(1)
into :li_count
from seg_puerta_ingreso_salida 
where cod_puerta = :this.text and flag_estado = '1' and flag_in_out in ('1','3') and cod_origen = :gs_origen;

if li_count = 0 then
	this.text = ''
end if		 	
			 
if DW_1.rowcount() = 0 then
	is_puerta = this.text
end if
end event

type st_1 from statictext within tp_1
integer x = 1097
integer y = 141
integer width = 201
integer height = 67
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Puerta:"
boolean focusrectangle = false
end type

type dw_1 from u_dw_abc within tp_1
integer x = 33
integer y = 448
integer width = 2209
integer height = 464
integer taborder = 60
string dataobject = "d_list_control_ingreso_vehicular_carga"
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'grid'	// tabular, form (default)
end event

event rowfocuschanged;call super::rowfocuschanged;tab_1.tp_2.dw_2.retrieve( this.object.nro_registro[currentrow])
end event

event clicked;call super::clicked;if row > 0 then
	tab_1.tp_2.dw_2.retrieve( this.object.nro_registro[row])
end if
end event

event doubleclicked;call super::doubleclicked;if row > 0 then
	tab_1.tp_2.dw_2.retrieve( this.object.nro_registro[row])
	tab_1.selecttab(2)
end if
end event

event ue_delete;//override
return 0
end event

type uo_1 from n_cst_search within tp_1
integer y = 307
integer width = 2940
integer height = 83
integer taborder = 50
end type

on uo_1.destroy
call n_cst_search::destroy
end on

type dp_2 from datepicker within tp_1
integer x = 607
integer y = 122
integer width = 446
integer height = 99
integer taborder = 40
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-18"), Time("10:24:32.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type st_2 from statictext within tp_1
integer x = 523
integer y = 141
integer width = 80
integer height = 51
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

type cb_1 from commandbutton within tp_1
integer x = 1759
integer y = 173
integer width = 315
integer height = 99
integer taborder = 40
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

datetime ldt_ini, ldt_fin

ldt_ini = datetime( date(dp_1.value), time('00:00:00') )

ldt_fin = datetime( date(dp_2.value), time('23:59:59') )

idt_fecsys = gnvo_app.of_fecha_actual()

is_puerta = sle_1.text

dw_1.retrieve(ldt_ini, ldt_fin, gs_origen, is_puerta)

tab_1.tp_2.dw_2.reset()
end event

type dp_1 from datepicker within tp_1
integer x = 73
integer y = 122
integer width = 446
integer height = 99
integer taborder = 30
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-18"), Time("10:24:32.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type gb_1 from groupbox within tp_1
integer x = 33
integer y = 26
integer width = 1697
integer height = 250
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas de Ingreso"
end type

type tp_2 from userobject within tab_1
integer x = 15
integer y = 106
integer width = 2286
integer height = 960
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tp_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tp_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw_abc within tp_2
integer x = 37
integer y = 32
integer width = 2209
integer height = 877
integer taborder = 20
string dataobject = "d_ope_control_ingreso_vehicular_carga"
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr				[al_row] = gs_user
this.object.fec_registro [al_row] = datetime(today(),now())
this.object.fec_ingreso [al_row] = datetime(today(),now())
this.object.km_ingreso[al_row] = 0
this.object.km_salida[al_row] = 0
this.object.cant_diesel[al_row] = 0
idt_fecsys = gnvo_app.of_fecha_actual()
this.object.codigo_origen_in [al_row] = gs_origen
this.object.cod_puerta_in[al_row] = is_puerta
setcolumn('fec_ingreso')
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;if row > 0 then
	
	string ls_desc, ls_apepat, ls_apemat, ls_nombre, ls_brevete
	string ls_placaremolque, ls_tiporemolque, ls_descremolque, ls_ruc, ls_razonsocial
	string ls_fecha
	
	choose case dwo.name
			
		case 'placa'
			
			if inv_segmae.of_getvehiculo(data,ls_placaremolque, ls_tiporemolque, ls_descremolque, ls_ruc, ls_razonsocial) = 1 then
				this.object.placa_carreta[row] = ls_placaremolque
				this.object.tipo_remolque[row] = ls_tiporemolque
				this.object.desc_remolque[row] = ls_descremolque
				this.object.ruc[row] = ls_ruc
				this.object.razon_social[row] = ls_razonsocial
				setcolumn('km_ingreso')
			end if
						
		case 'ruc'
			
			if inv_segmae.of_getproveedor(data,ls_razonsocial) = 1 then
				this.object.razon_social[row] = ls_razonsocial
				setcolumn('km_ingreso')
			end if
			
			select nom_proveedor into :ls_razonsocial from proveedor where ruc = :data;
			
			if sqlca.sqlcode = 0 then
				this.object.razon_social[row] = ls_razonsocial
				return 2
			end if
			
		case 'tipo_doc_ident'
			
			SELECT descripcion into :ls_desc FROM RRHH_DOCUMENTO_IDENTIDAD_RTPS where flag_estado = '1' and cod_doc_identidad = :data;
			
			if sqlca.sqlcode = 100 then
				this.object.tipo_doc_ident[row] = ''
				return 1
			end if
			
			if inv_segmae.of_getpersona(data,this.object.nro_doc_ident[row],ls_apepat,ls_apemat,ls_nombre,ls_brevete) = 1 then
				this.object.apepat[row] = ls_apepat
				this.object.apemat[row] = ls_apemat
				this.object.nombre[row] = ls_nombre
				this.object.nro_brevete[row] = ls_brevete
				setcolumn('motivo_ingsal')
			end if
			
		case 'nro_doc_ident'
			
			if inv_segmae.of_getpersona(this.object.tipo_doc_ident[row],data,ls_apepat,ls_apemat,ls_nombre,ls_brevete) = 1 then
				this.object.apepat[row] = ls_apepat
				this.object.apemat[row] = ls_apemat
				this.object.nombre[row] = ls_nombre
				this.object.nro_brevete[row] = ls_brevete
				setcolumn('motivo_ingsal')
			end if
		
		case 'tipo_remolque'
			
			select desc_remolque into :ls_desc from seg_tipo_semiremolque where flag_estado = '1' and tipo_remolque = :data;
			
			if sqlca.sqlcode = 100 then
				this.object.tipo_remolque[row] = ''
				this.object.desc_remolque[row] = ''
				return 1
			end if			
			
			this.object.desc_remolque[row] = ls_desc
		
		case 'almacen'
			
			select desc_almacen into :ls_desc from almacen where flag_estado = '1' and almacen = :data;
			
			if sqlca.sqlcode = 100 then
				this.object.almacen[row] = ''
				this.object.desc_almacen[row] = ''
				return 1
			end if			
			
			this.object.desc_almacen[row] = ls_desc
			
		case 'motivo_ingsal'
			
			select desc_motivo into :ls_desc from seg_motivo_ingreso_salida where flag_estado = '1' and motivo_ingsal = :data;
			
			if sqlca.sqlcode = 100 then
				this.object.motivo_ingsal[row] = ''
				this.object.desc_motivo[row] = ''
				return 1
			end if			
			
			this.object.desc_motivo[row] = ls_desc
			
			
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
			
		case 'km_ingreso'
			
			if long(data) < 0 then
				this.object.km_ingreso[row] = 0
				return 1
			end if
			
			if long(this.object.km_salida[row]) <> 0 and long(data) > long(this.object.km_salida[row]) then
				messagebox('Aviso','El kilometraje de ingreso no puede ser mayor que el de salida')
				this.object.km_ingreso[row] = 0
				return 1
			end if
			
		case 'km_salida'
			
			if long(data) < 0 then
				this.object.km_salida[row] = this.object.km_ingreso[row] 
				return 1
			end if
			
			if long(data) < long(this.object.km_ingreso[row]) then
				messagebox('Aviso','El kilometraje de salida no puede ser menor que el de ingreso')
				this.object.km_salida[row] = 0
				return 1
			end if
			
		case 'marcar_desmarcar'
			
			ls_fecha = string(this.object.fec_salida[row],'dd/mm/yyyy')
			
			if ls_fecha <> '00/00/0000' and ls_fecha <> '' and not isnull(ls_fecha) then
				ls_fecha = 'S'
			else
				ls_fecha = 'N'
			end if
		
			if data = '1' then
				
				if ls_fecha = 'N' then
					this.object.checkinasidel[row] = '1'
					this.object.checkinasitra[row] = '1'
					this.object.checkingua[row] = '1'
					this.object.checkindie[row] = '1'
					this.object.checkinpar[row] = '1'
					this.object.checkincha[row] = '1'
					this.object.checkinlla[row] = '1'
					this.object.checkinpla[row] = '1'
					this.object.checkinmal[row] = '1'
				else
					this.object.checkoutasidel[row] = '1'
					this.object.checkoutasitra[row] = '1'
					this.object.checkoutgua[row] = '1'
					this.object.checkoutdie[row] = '1'
					this.object.checkoutpar[row] = '1'
					this.object.checkoutcha[row] = '1'
					this.object.checkoutlla[row] = '1'
					this.object.checkoutpla[row] = '1'
					this.object.checkoutmal[row] = '1'
				end if
			else
				if ls_fecha = 'N' then
					this.object.checkinasidel[row] = '0'
					this.object.checkinasitra[row] = '0'
					this.object.checkingua[row] = '0'
					this.object.checkindie[row] = '0'
					this.object.checkinpar[row] = '0'
					this.object.checkincha[row] = '0'
					this.object.checkinlla[row] = '0'
					this.object.checkinpla[row] = '0'
					this.object.checkinmal[row] = '0'
				else
					this.object.checkoutasidel[row] = '0'
					this.object.checkoutasitra[row] = '0'
					this.object.checkoutgua[row] = '0'
					this.object.checkoutdie[row] = '0'
					this.object.checkoutpar[row] = '0'
					this.object.checkoutcha[row] = '0'
					this.object.checkoutlla[row] = '0'
					this.object.checkoutpla[row] = '0'
					this.object.checkoutmal[row] = '0'
				end if
			end if
			
		case 'cod_puerta_out'
			
			ls_fecha = string(this.object.fec_salida[row],'dd/mm/yyyy') 
			
			if (ls_fecha = '00/00/0000' or ls_fecha = '' or isnull(ls_fecha) ) then
				MessageBox('Aviso','Debe Ingresar una fecha de salida valida para poder ingresar un codigo de puerta')
				this.object.cod_puerta_out[row] = ''
				return 1
			end if
			
			select descripcion into :ls_desc from seg_puerta_ingreso_salida where cod_puerta = :data and flag_estado = '1' and flag_in_out in ('1','3') and cod_origen = :gs_origen;
			
			if sqlca.sqlcode = 100 then
				this.object.cod_puerta_out[row] = ''
				this.object.codigo_origen_out[row] = ''
				return 1
			end if		
			
			this.object.codigo_origen_out[row] = gs_origen
			
	end choose
	
end if
end event

event buttonclicked;call super::buttonclicked;if row > 0 then
	string ls_sql, ls_return1, ls_return2, ls_rest
	
	ls_rest = 'if ( isnull(Fec_salida), 0,1)'
	
	if this.Describe("Evaluate('"+ls_rest+"', "+string(row)+")") = '1' then
		return
	end if
	
	if dwo.name = 'b_tipo_remolque' then
		ls_sql = "select tipo_remolque as codigo, desc_remolque as descripcion from seg_tipo_semiremolque where flag_estado = '1' order by 2" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				this.object.tipo_remolque [row] = ls_return1
				this.object.desc_remolque [row] = ls_return2
				this.ii_update = 1
	elseif dwo.name = 'b_almacen'  then
		ls_sql = "select almacen as codigo, desc_almacen as descripcion from almacen where flag_estado = '1' order by 2" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				this.object.almacen [row] = ls_return1
				this.object.desc_almacen [row] = ls_return2
				this.ii_update = 1
	elseif dwo.name = 'b_motivo_ingsal'  then
		ls_sql = "select motivo_ingsal as codigo, desc_motivo as descripcion from seg_motivo_ingreso_salida where flag_estado = '1' order by 2" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				this.object.motivo_ingsal [row] = ls_return1
				this.object.desc_motivo [row] = ls_return2
				this.ii_update = 1
	elseif  dwo.name = 'b_tipo_doc_ident' then
		ls_sql = "SELECT cod_doc_identidad as codigo, descripcion as descripcion FROM RRHH_DOCUMENTO_IDENTIDAD_RTPS where flag_estado = '1'" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				this.object.tipo_doc_ident [row] = ls_return1
				this.ii_update = 1
	elseif  dwo.name = 'b_cod_puerta_out' then
		ls_sql = "SELECT cod_puerta as codigo, descripcion as descripcion FROM seg_puerta_ingreso_salida where flag_estado = '1' and flag_in_out in ('1','3') and cod_origen = '"+gs_origen+"'" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				this.object.cod_puerta_out [row] = ls_return1
				this.object.codigo_origen_out[row] = gs_origen
				this.ii_update = 1
	end if
end if
end event

event ue_delete;//override
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

event ue_delete_pre;call super::ue_delete_pre;if this.getrow() <= 0 then return 0

if this.object.reckey[this.getrow()] <> 0 then
	return 0
else
	return 1
end if
end event

event ue_insert;//override

if is_puerta = '' or isnull(is_puerta) then
	MessageBox('Aviso','Debe definir una puerta de Ingreso para poder continuar')
	return 0
end if

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF not Isnull(idw_mst) and IsValid(idw_mst) then
		if idw_mst.il_row = 0 THEN
			MessageBox("Error", "No ha seleccionado registro Maestro")
			RETURN - 1
		end if
	END IF
END IF

long ll_row

this.reset()
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

