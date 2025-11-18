$PBExportHeader$w_ve020_comisiones_det.srw
forward
global type w_ve020_comisiones_det from w_abc_master
end type
type st_1 from statictext within w_ve020_comisiones_det
end type
end forward

global type w_ve020_comisiones_det from w_abc_master
integer width = 741
integer height = 1320
string title = "[VE020] Copiar Periodo Existente"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_1 st_1
end type
global w_ve020_comisiones_det w_ve020_comisiones_det

type variables
date id_fecha
string is_comision
end variables

on w_ve020_comisiones_det.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_ve020_comisiones_det.destroy
call super::destroy
destroy(this.st_1)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event resize;//Override

end event

event open;//Override
str_parametros lstr_parametros

if isvalid(message.powerobjectparm) then
	
	lstr_parametros = message.powerobjectparm
	
	id_fecha    = lstr_parametros.fecha1
	is_comision = lstr_parametros.string1
	
	if is_comision = 'CF' then
		dw_master.dataobject = 'd_abc_lista_comision_fija'
	elseif is_comision = 'CC' then
		dw_master.dataobject = 'd_abc_lista_comision_cobertura'
	elseif is_comision = 'CP' then
		dw_master.dataobject = 'd_abc_lista_comision_producto'
	end if
	
	dw_master.settransobject( sqlca )
	dw_master.retrieve()

	of_center_window(this)
	
else
	
	messagebox('Aviso','Error al pasar argumentos')
	
end if
end event

type dw_master from w_abc_master`dw_master within w_ve020_comisiones_det
integer x = 37
integer y = 256
integer width = 626
integer height = 900
string dataobject = "d_abc_lista_comision_fija"
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = 	dw_master

settransobject(sqlca)
end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::doubleclicked;call super::doubleclicked;if row = 0 then return

date ld_Fecha_ini, ld_fecha_fin

ld_fecha_ini = date(this.object.fecha_ini[row])
ld_fecha_fin = date(this.object.fecha_fin[row])
	
if is_comision = 'CF' then

	delete 
	  from comision_fija
	 where fecha_ini = :id_fecha;
	
	if sqlca.sqlnrows > 0 or sqlca.sqlcode = 0 then
		commit;
	end if
	
	insert into comision_fija (canal, porc_cuota, fecha_ini,
					fecha_fin, importe, cod_usr)
		  select canal, porc_cuota, :id_fecha, :ld_fecha_fin, importe, 
					:gs_user
			 from comision_fija
			where fecha_ini = trunc(:ld_fecha_ini);
			
elseif is_comision = 'CC' then
	
	delete 
	  from comision_cobertura
	 where fecha_ini = :id_fecha;
	
	if sqlca.sqlnrows > 0 or sqlca.sqlcode = 0 then
		commit;
	end if
	
	insert into comision_cobertura (canal, cod_art, fecha_ini,
					fecha_fin, porc_vnt_clt, cant_vnt, importe, cod_usr)
		  select canal, cod_art, :id_fecha, :ld_fecha_fin, porc_vnt_clt, cant_vnt,
					importe, :gs_user
			 from comision_cobertura
			where fecha_ini = trunc(:ld_fecha_ini);
			
elseif is_comision = 'CP' then
	
	delete 
	  from comision_producto
	 where fecha_ini = :id_fecha;
	
	if sqlca.sqlnrows > 0 or sqlca.sqlcode = 0 then
		commit;
	end if
	
	insert into comision_producto (canal, cod_art, vendedor, fecha_ini,
					fecha_fin, cantidad, importe, cod_usr)
		  select canal, cod_art, vendedor, :id_fecha, :ld_fecha_fin, cantidad, importe, 
					:gs_user
			 from comision_producto
			where fecha_ini = trunc(:ld_fecha_ini);

end if

if sqlca.sqlcode <> 0 then
	rollback;
	messagebox('Error',string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext))
	closewithreturn(parent,'1')
else
	commit;
	closewithreturn(parent,'0')
end if
end event

type st_1 from statictext within w_ve020_comisiones_det
integer x = 37
integer y = 32
integer width = 631
integer height = 196
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Seleccion con Doble Clic el Periodo que se desea copiar."
boolean focusrectangle = false
end type

