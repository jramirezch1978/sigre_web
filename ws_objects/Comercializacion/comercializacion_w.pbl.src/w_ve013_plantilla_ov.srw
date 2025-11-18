$PBExportHeader$w_ve013_plantilla_ov.srw
forward
global type w_ve013_plantilla_ov from w_abc_mastdet
end type
end forward

global type w_ve013_plantilla_ov from w_abc_mastdet
integer width = 2519
integer height = 1364
string title = "[VE013] Plantilla de Orden de Venta"
string menuname = "m_mantenimiento_sl"
boolean maxbox = false
boolean resizable = false
end type
global w_ve013_plantilla_ov w_ve013_plantilla_ov

on w_ve013_plantilla_ov.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_ve013_plantilla_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.retrieve()

of_position_window(50,50)
end event

event resize;//Override
end event

type dw_master from w_abc_mastdet`dw_master within w_ve013_plantilla_ov
integer x = 165
integer y = 32
integer width = 2126
integer height = 516
string dataobject = "d_abc_plantilla_ov"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

is_dwform = 'tabular' // tabular form
ii_ss = 1
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet`dw_detail within w_ve013_plantilla_ov
integer x = 37
integer y = 576
integer width = 2400
integer height = 580
string dataobject = "d_abc_plantilla_ov_det"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

ii_ss = 1
end event

event dw_detail::doubleclicked;call super::doubleclicked;if row = 0 then return 

str_seleccionar lstr_seleccionar

if dwo.name = 'servicio' then
	
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT SERVICIO AS CODIGO, DESCRIPCION AS DESCRIPCION '&
									 +'FROM SERVICIOS '&
									 +"WHERE FLAG_ESTADO = '1'"
	
	OpenWithParm(w_seleccionar,lstr_seleccionar)
					
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
					
	IF lstr_seleccionar.s_action = "aceptar" THEN
		Setitem(row,'servicio',lstr_seleccionar.param1[1])
		Setitem(row,'descripcion',lstr_seleccionar.param2[1])
		ii_update = 1
	END IF
	
end if
end event

event dw_detail::itemchanged;call super::itemchanged;if row = 0 then return

if dwo.name = 'servicio' then
	
	string ls_desc
	
	select descripcion
	  into :ls_desc
	  from servicios
	 where servicio = :data;
	
	if sqlca.sqlcode = -1 then
		
		messagebox('Aviso','Servicio no Existe')
		this.object.servicio[row] = setnull(ls_desc)
		return 1
		
		
	else
		
		this.object.descripcion[row] = ls_desc
		
	end if
	
end if
end event

