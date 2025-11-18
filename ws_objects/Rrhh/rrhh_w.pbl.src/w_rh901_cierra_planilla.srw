$PBExportHeader$w_rh901_cierra_planilla.srw
forward
global type w_rh901_cierra_planilla from w_prc
end type
type rb_1 from radiobutton within w_rh901_cierra_planilla
end type
type rb_2 from radiobutton within w_rh901_cierra_planilla
end type
type cb_cerrar from commandbutton within w_rh901_cierra_planilla
end type
type st_2 from statictext within w_rh901_cierra_planilla
end type
type st_1 from statictext within w_rh901_cierra_planilla
end type
type dw_master from u_dw_abc within w_rh901_cierra_planilla
end type
end forward

global type w_rh901_cierra_planilla from w_prc
integer width = 3922
integer height = 2036
string title = "(RH901) Cierre de Planilla calculada"
string menuname = "m_only_exit"
boolean minbox = false
boolean resizable = false
boolean center = true
event ue_tipo_planilla ( )
event ue_fecha_proceso ( )
event ue_retrieve ( )
event ue_filter ( )
event ue_filter_avanzado ( )
event ue_sort ( )
rb_1 rb_1
rb_2 rb_2
cb_cerrar cb_cerrar
st_2 st_2
st_1 st_1
dw_master dw_master
end type
global w_rh901_cierra_planilla w_rh901_cierra_planilla

event ue_tipo_planilla();//String	ls_origen, ls_tipo_trabajador, ls_tipo_planilla, ls_desc_tipo_planilla
//
//ls_origen 				= em_origen.text
//ls_tipo_trabajador 	= em_ttrab.text
//
//if IsNull(ls_origen) or trim(ls_origen) = '' then return
//if IsNull(ls_tipo_trabajador) or trim(ls_tipo_trabajador) = '' then return
//
//select distinct c.tipo_planilla, 
//		 USP_SIGRE_RRHH.of_tipo_planilla(c.tipo_planilla)
//	into :ls_tipo_planilla, :ls_desc_tipo_planilla		 
//from calculo 	c,
//	  maestro	m
//where c.cod_trabajador = m.cod_trabajador
//  and m.tipo_trabajador = :ls_tipo_trabajador
//  and m.cod_origen		= :ls_origen;
//
//em_tipo_planilla.text 		= ls_tipo_planilla
//em_desc_tipo_planilla.text = ls_desc_tipo_planilla
end event

event ue_fecha_proceso();//string 	ls_origen, ls_tipo_trabajador, ls_tipo_planilla
//Date		ld_fecha
//
//ls_origen 				= em_origen.text
//ls_tipo_trabajador 	= em_ttrab.text
//ls_tipo_planilla		= em_tipo_planilla.text
//
//if IsNull(ls_origen) or trim(ls_origen) = '' then return
//if IsNull(ls_tipo_trabajador) or trim(ls_tipo_trabajador) = '' then return
//if isNull(ls_tipo_planilla) or trim(ls_tipo_planilla) = '' then return
//
////ld_fecha = gnvo_app.rrhhparam.of_get_ult_fec_proceso(ls_origen, ls_tipo_trabajador, ls_tipo_planilla)
//select distinct fec_proceso
//  into :ld_fecha
// from calculo c,
// 		maestro m
// where c.cod_trabajador 	= m.cod_trabajador
//   and m.cod_origen			= :ls_origen
//	and m.tipo_trabajador 	= :ls_tipo_trabajador
//	and c.tipo_planilla		= :ls_tipo_planilla;
//
//em_fec_proceso.text = string(ld_fecha, 'dd/mm/yyyy')
end event

event ue_retrieve();
if rb_1.checked then
	dw_master.DataObject = 'd_lista_cierre_planilla_tbl'
end if

if rb_2.checked then
	dw_master.DataObject = 'd_lista_cierre_planilla_hist_tbl'
end if

dw_master.setTransObject(SQLCA)

dw_master.retrieve(gs_user)
end event

event ue_filter();dw_master.EVENT ue_filter()
end event

event ue_filter_avanzado();dw_master.EVENT ue_filter_avanzado()
end event

event ue_sort();dw_master.EVENT ue_sort()
end event

on w_rh901_cierra_planilla.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cb_cerrar=create cb_cerrar
this.st_2=create st_2
this.st_1=create st_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.cb_cerrar
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dw_master
end on

on w_rh901_cierra_planilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cb_cerrar)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;//inicializa datos
try 
	
	event ue_retrieve()
	

catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "")
end try

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

st_1.width  = newwidth  - st_1.x - 10

end event

type rb_1 from radiobutton within w_rh901_cierra_planilla
integer x = 2482
integer y = 112
integer width = 434
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "En proceso"
boolean checked = true
end type

event clicked;cb_cerrar.enabled = false
parent.event ue_retrieve()
end event

type rb_2 from radiobutton within w_rh901_cierra_planilla
integer x = 2482
integer y = 192
integer width = 434
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Histórico"
end type

event clicked;cb_cerrar.enabled = false
parent.event ue_retrieve()
end event

type cb_cerrar from commandbutton within w_rh901_cierra_planilla
integer x = 2921
integer y = 116
integer width = 352
integer height = 168
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Cerrar"
end type

event clicked;Integer li_opcion
Long    ll_count, ll_i
String  ls_origen,ls_ttrab ,ls_mensaje, ls_tipo_planilla
Date	  ld_fec_proceso

if MessageBox('Informacion', &
		"Ha seleccionado CERRAR una(s) planilla(s). " &
	 + "Si continua con el proceso, las planillas seleccionadas dejeran de estar disponibles para su modificacion." &
	 + "Desea continuar con el proceso de REVERSION?", &
		Information!, Yesno!, 2) = 2 then return
		
for ll_i = 1 to dw_master.RowCount()
	if dw_master.object.checked[ll_i] = '1' then
		ls_origen 			= String(dw_master.object.cod_origen 		[ll_i])
		ls_ttrab	 			= String(dw_master.object.tipo_trabajador	[ll_i])
		ls_tipo_planilla	= String(dw_master.object.tipo_planilla	[ll_i])
		ld_fec_proceso	 	= Date(dw_master.object.fec_proceso			[ll_i])
		
		
		select count(*) 
		  into :ll_count
		  from origen 
		 where cod_origen  = :ls_origen 
			and flag_estado = '1';
				  
		if ll_count = 0 then
			rollback;
			Messagebox('Aviso','Origen No Existe o no esta activo, por favor Verifique!')
			Return
		end if
		
		select count(*) 
		  into :ll_count 
		  from tipo_trabajador
		 where tipo_trabajador = :ls_ttrab 
			and flag_estado	   = '1'	;
		
		if ll_count = 0 then
			rollbacK;
			Messagebox('Aviso','Tipo de trabajador no existe o no esta activo, por favor Verifique!')
			Return
		end if
		
		//se grabo informacion satisfactoriamente
		select count(*) 
			into :ll_count 
		from 	historico_calculo hc
		where trunc(hc.fec_calc_plan) = trunc(:ld_fec_proceso)
		  and hc.cod_origen       	   = :ls_origen    		
		  and hc.tipo_trabajador  	   = :ls_ttrab
		  and hc.tipo_planilla			= :ls_tipo_planilla;
		
		if ll_count > 0 then
			rollbacK;
			Messagebox('Aviso','Planilla ya fue Enviada a los historicos , por favor Verifique!')
			Return
		end if
		
		//create or replace procedure usp_rh_cierre_planilla(
		//       asi_origen         in origen.cod_origen%Type               ,
		//       asi_tipo_trab      in tipo_trabajador.tipo_trabajador%Type ,
		//       adi_fec_proceso    in date,
		//       asi_tipo_planilla  in calculo.tipo_planilla%TYPE
		//) is
		
		
		//ejecuto procesos de CIERRE DE PLANILLA
		DECLARE usp_rh_cierre_planilla PROCEDURE FOR 
			usp_rh_cierre_planilla(	:ls_origen ,
											:ls_ttrab ,
											:ld_fec_proceso,
											:ls_tipo_planilla);
		
		EXECUTE usp_rh_cierre_planilla ;
		  
		//busco errores
		if sqlca.sqlcode = -1 then
			ls_mensaje = sqlca.sqlerrtext
			Rollback ;
			Messagebox('SQL Error usp_rh_cierre_planilla', 'Error al procesar el cierre de planilla. ' + ls_mensaje)
			Return
		end if	   	  
		  
		CLOSE usp_rh_cierre_planilla ;
		  
		
		//se grabo informacion satisfactoriamente
		select count(*) 
			into :ll_count 
		from 	historico_calculo hc
		where trunc(hc.fec_calc_plan) = :ld_Fec_proceso 
		  and hc.cod_origen       	   = :ls_origen    		
		  and hc.tipo_trabajador  	   = :ls_ttrab
		  and hc.tipo_planilla			= :ls_tipo_planilla;
				 
		if ll_count = 0 then		 
			Rollback ;
			gnvo_app.of_mensaje_error("No se ha procesado correctamente el cierre de una planilla procesada" &
										  + "~r~nOrigen: " + ls_origen &
										  + "~r~nTipo Trabaj: " + ls_ttrab &
										  + "~r~nTipo Planilla: " + ls_tipo_planilla &
										  + "~r~Fec Proceso: " + string(ld_fec_proceso, 'dd/mm/yyyy'))
										  
			return
		end if	
		
	end if
next


Commit ;	 

dw_master.Retrieve(gs_user)
cb_cerrar.enabled = false

Messagebox('Aviso','Proceso ha concluído Satisfactoriamente')



end event

type st_2 from statictext within w_rh901_cierra_planilla
integer x = 27
integer y = 124
integer width = 2418
integer height = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "En esta opción verás todas las planillas (a las que tienes acceso) que se encuentran procesadas y que aun no han sido cerradas. Marque la planilla que desee cerrar y haga click en el boton"
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh901_cierra_planilla
integer width = 3922
integer height = 108
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "PLANILLAS PENDIENTES DE CERRAR"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_rh901_cierra_planilla
integer y = 292
integer width = 3259
integer height = 1080
string dataobject = "d_lista_cierre_planilla_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_lbuttonup;call super::ue_lbuttonup;Integer li_count, ll_i

if row = 0 then return

if rb_2.checked then return

this.AcceptText()

li_count = 0
for ll_i = 1 to this.RowCount()
	if this.object.checked[ll_i] = '1' then
		li_count++
	end if
next

if li_count > 0 then
	cb_Cerrar.Enabled = true
else
	cb_Cerrar.Enabled = false
end if
end event

