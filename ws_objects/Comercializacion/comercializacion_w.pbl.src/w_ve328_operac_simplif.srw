$PBExportHeader$w_ve328_operac_simplif.srw
forward
global type w_ve328_operac_simplif from w_abc
end type
type cb_3 from commandbutton within w_ve328_operac_simplif
end type
type cb_2 from commandbutton within w_ve328_operac_simplif
end type
type cb_1 from commandbutton within w_ve328_operac_simplif
end type
type uo_fechas from u_ingreso_rango_fechas within w_ve328_operac_simplif
end type
type cb_imprimir from commandbutton within w_ve328_operac_simplif
end type
type dw_master from u_dw_abc within w_ve328_operac_simplif
end type
end forward

global type w_ve328_operac_simplif from w_abc
integer width = 4581
integer height = 2552
string title = "[VE328] Procesos Simplificados de la OV"
string menuname = "m_only_filtro"
event ue_facturar ( long al_row )
event ue_anular_row ( long al_row )
event ue_cerrar_ov ( )
event ue_generar_transformacion ( )
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
uo_fechas uo_fechas
cb_imprimir cb_imprimir
dw_master dw_master
end type
global w_ve328_operac_simplif w_ve328_operac_simplif

type prototypes

end prototypes

type variables
n_cst_ventas 	invo_ventas
end variables

forward prototypes
public function integer of_get_param ()
public function long of_count_select ()
public function boolean of_valida_select ()
public function boolean of_cerrar_ov (string as_tipo_doc, string as_nro_doc)
end prototypes

event ue_cerrar_ov();Long 		ll_row, ll_count
String 	ls_tipo_doc, ls_nro_doc

if not of_Valida_select() then return

ll_count = this.of_count_select()

if MessageBox('Aviso', 'Se va a proceder a cerrar las OV seleccionadas, ' &
							+ 'una vez cerradas no será posible aperturarlo ni continuar usandolo. ' &
							+ '¿Desea Cerrar los ' + string(ll_count) + ' OV Seleccionada?', Information!, &
							YEsno!, 2) = 2 then return

for ll_row = 1 to dw_master.RowCount()
	if dw_master.object.checked [ll_row] = '1' then
		ls_tipo_doc = dw_master.object.tipo_doc 	[ll_row]
		ls_nro_doc	= dw_master.object.nro_doc		[ll_row]
		
		invo_ventas.of_cerrar_ov(ls_tipo_doc, ls_nro_doc)
		
	end if
next

this.event ue_refresh()


end event

event ue_generar_transformacion();Long 				ll_row, ll_count
String 			ls_tipo_doc, ls_nro_doc[]
str_parametros	lstr_param

if not of_Valida_select() then return

ll_count = this.of_count_select()

if MessageBox('Aviso', 'Se va a proceder a generar el movimiento de Transformación. ' &
							+ '¿Desea procesar los ' + string(ll_count) + ' OV Seleccionados?', Information!, &
							YEsno!, 2) = 2 then return

for ll_row = 1 to dw_master.RowCount()
	if dw_master.object.checked [ll_row] = '1' then
		ls_tipo_doc 									= dw_master.object.tipo_doc 	[ll_row]
		ls_nro_doc[upperBound(ls_nro_doc) + 1]	= dw_master.object.nro_doc		[ll_row]
		
		lstr_param.string1 	= ls_tipo_doc
		lstr_param.str_array = ls_nro_doc
		
		invo_ventas.of_gen_transformacion(lstr_param)
		
	end if
next

this.event ue_refresh()

end event

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

// busca tipos de movimiento definidos
//SELECT 	FS_PARAM.COD_MONEDA, moneda.DESCRIPCION, 
//			FS_PARAM.FORMA_PAGO, FORMA_PAGO.DESC_FORMA_PAGO,  
//			FS_PARAM.TIPO_IMPUESTO, IMPUESTOS_TIPO.DESC_IMPUESTO,   
//			FS_PARAM.MOTIVO_TRASLADO, MOTIVO_TRASLADO.DESCRIPCION,   
//			FS_PARAM.ALMACEN, ALMACEN.DESC_ALMACEN,   
//         FS_PARAM.PUNTO_VENTA, PUNTOS_VENTA.DESC_PTO_VTA,
//			FS_PARAM.FORMA_EMBARQUE, FORMA_EMBARQUE.DESCRIPCION
//   into 	:is_cod_moneda, :is_desc_moneda,
// 			:is_forma_pago, :is_desc_forma_pago,
//			:is_tipo_impuesto, :is_desc_impuesto,
//			:is_motivo_traslado, :is_desc_motivo,
//			:is_almacen, :is_desc_almacen,
//			:is_punto_venta, :is_desc_pto_vta,
//			:is_forma_embarque, :is_desc_forma_embarque         
//    FROM FS_PARAM,   
//         MONEDA,   
//         FORMA_PAGO,   
//         IMPUESTOS_TIPO,   
//         MOTIVO_TRASLADO,   
//         ALMACEN,   
//         PUNTOS_VENTA,   
//         FORMA_EMBARQUE  
//   WHERE moneda.cod_moneda (+) = fs_param.cod_moneda
//	  and forma_pago.forma_pago (+) = fs_param.forma_pago
//	  and impuestos_tipo.tipo_impuesto (+) = fs_param.tipo_impuesto
//	  and motivo_traslado.motivo_traslado (+) = fs_param.motivo_traslado
//	  and almacen.almacen (+) = fs_param.almacen
//	  and puntos_venta.punto_venta (+) = fs_param.punto_venta
//	  and forma_embarque.forma_embarque (+) = fs_param.forma_embarque
//	  and fs_param.cod_origen = :gs_origen;    
//
//
//if sqlca.sqlcode = 100 then
//	Messagebox( "Error", "no ha definido parametros en fs_param")
//	return 0
//end if
//
//if sqlca.sqlcode < 0 then
//	ls_mensaje = SQLCA.SQLErrText
//	ROLLBACK;
//	Messagebox( "Error", ls_mensaje)
//	return 0
//end if



return 1
end function

public function long of_count_select ();Long ll_row, ll_count

dw_master.AcceptText()

ll_count = 0
for ll_row = 1 to dw_master.RowCount()
	if dw_master.object.checked [ll_row] = '1' then
		ll_count ++
	end if
next

return ll_count
end function

public function boolean of_valida_select ();if this.of_count_select() = 0 then 
	Rollback;
	MessageBox('Error', 'No ha seleccionado ningun registro, por favor verifique!', StopSign!)
	return false
end if


return true

end function

public function boolean of_cerrar_ov (string as_tipo_doc, string as_nro_doc);return true
end function

on w_ve328_operac_simplif.create
int iCurrent
call super::create
if this.MenuName = "m_only_filtro" then this.MenuID = create m_only_filtro
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.uo_fechas=create uo_fechas
this.cb_imprimir=create cb_imprimir
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.uo_fechas
this.Control[iCurrent+5]=this.cb_imprimir
this.Control[iCurrent+6]=this.dw_master
end on

on w_ve328_operac_simplif.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.uo_fechas)
destroy(this.cb_imprimir)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;
invo_ventas = create n_cst_ventas

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

end event

event ue_refresh;call super::ue_refresh;Date ld_fecha1, ld_fecha2

ld_Fecha1 = uo_fechas.of_get_fecha1()
ld_Fecha2 = uo_fechas.of_get_fecha2()

dw_master.Retrieve(ld_fecha1, ld_fecha2)
end event

event close;call super::close;destroy invo_ventas
end event

type cb_3 from commandbutton within w_ve328_operac_simplif
integer x = 1467
integer width = 443
integer height = 104
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_refresh()
SetPointer(Arrow!)
end event

type cb_2 from commandbutton within w_ve328_operac_simplif
integer x = 3104
integer width = 626
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar VS y G. Remision"
end type

event clicked;Opensheet(w_ve319_imprimir_tickets, w_main, 0, Layered!)





end event

type cb_1 from commandbutton within w_ve328_operac_simplif
integer x = 1952
integer width = 443
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar la OV"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_cerrar_ov()
SetPointer(Arrow!)
end event

type uo_fechas from u_ingreso_rango_fechas within w_ve328_operac_simplif
event destroy ( )
integer y = 4
integer width = 1426
integer taborder = 70
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:')// para seatear el titulo del boton 
of_set_fecha(Date('01/'+string(today(),'mm/yyyy')), date(gd_fecha)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/2002')) // rango inicial
of_set_rango_fin(date(gd_fecha)) // rango final

end event

type cb_imprimir from commandbutton within w_ve328_operac_simplif
integer x = 2437
integer width = 626
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Transformación"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_generar_transformacion()
SetPointer(Arrow!)




end event

type dw_master from u_dw_abc within w_ve328_operac_simplif
integer y = 124
integer width = 4475
integer height = 1848
string dataobject = "d_abc_listado_ov_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
//idw_det  =  				// dw_detail
is_dwform = 'tabular'	// tabular, form (default)
end event

event doubleclicked;call super::doubleclicked;String 			ls_nro_doc, ls_tipo_doc
str_parametros	lstr_param

if row = 0 then return

ls_tipo_doc = this.object.tipo_doc 	[row]
ls_nro_doc	= this.object.nro_doc	[row]

lstr_param.dw1 		= 'd_cns_detalle_ov_tbl'
lstr_param.titulo 	= 'Detalle de la Orden de Venta ' + ls_nro_doc
lstr_param.string1 	= ls_tipo_doc
lstr_param.string2 	= ls_nro_doc
lstr_param.tipo		= '1S2S'
lstr_param.b_preview	= false
		
OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end event

event itemchanged;call super::itemchanged;//Long    ll_count,ll_nro_serie_doc,ll_null
//String  ls_desc_data     ,ls_null         ,ls_cod_relacion ,ls_dir_dep_estado , &
//        ls_dir_distrito	,ls_dir_direccion ,ls_tipo_doc	  , ls_nom_vendedor
//Integer li_num_dir
//
//Accepttext()
//
//SetNull(ls_null)
//SetNull(ll_null)
//
//choose case dwo.name
//		 case 'nro_serie_doc'
//				ll_nro_serie_doc = Long(data) 
//				
//				if rb_1.checked then
//					ls_tipo_doc = is_doc_fac
//				elseif rb_2.checked then
//					ls_tipo_doc = is_doc_bvc
//				end if	
//				
//				
//				select count(*) into :ll_count 
//				  from doc_tipo_usuario 
//				 where (cod_usr   = :gs_user          ) and
//					    (tipo_doc  = :ls_tipo_doc      ) and
//						 (nro_serie	= :ll_nro_serie_doc ) ;
//						 
//			  if ll_count = 0 then
//				  Messagebox('Aviso','Nro de Serie de Guia No Existe ,Verifique!')
//				  this.object.nro_serie_doc [row] = ll_null
//				  Return 1
//			  end if 
//				
//		 case 'nro_serie_guia'
//				ll_nro_serie_doc = Long(data) 
//				
//				select count(*) into :ll_count 
//				  from doc_tipo_usuario 
//				 where (cod_usr   = :gs_user          ) and
//					    (tipo_doc  = :is_doc_gr        ) and
//						 (nro_serie	= :ll_nro_serie_doc ) ;
//						 
//			   if ll_count = 0 then
//				   Messagebox('Aviso','Nro de Serie de Guia No Existe ,Verifique!')
//				   this.object.nro_serie_guia [row] = ll_null
//				   Return 1
//			   end if 
//			  
//		
//		 case 'cod_relacion'
//
//				select p.nom_proveedor into :ls_desc_data
//				  from proveedor p
//				 where (p.proveedor   = :data ) and
//				       (p.flag_estado = '1'   ) ;
//				
//				
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
//				     Messagebox('Aviso','Codigo de Relacion no Existe')
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//					This.object.cod_relacion   [row] = ls_null
//					This.Object.desc_crelacion [row] = ls_null
//			      RETURN 1
//			  end if
//			
//
//  			  This.Object.desc_crelacion  [row] = ls_desc_data
//		     This.Object.comp_final 		[row] = data
//			  This.Object.desc_comp_final [row] = ls_desc_data
//		 
//		 case 'comp_final'
//
//				select p.nom_proveedor into :ls_desc_data
//				  from proveedor p
//				 where (p.proveedor   = :data ) and
//				       (p.flag_estado = '1'   ) ;
//				
//				
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
//				     Messagebox('Aviso','Codigo de Relacion no Existe')
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//					This.object.comp_final      [row] = ls_null
//					This.Object.desc_comp_final [row] = ls_null
//			      RETURN 1
//			  end if
//			
//
//  			  This.Object.desc_comp_final [row] = ls_desc_data
//						  
//		 case 'item_direccion'
//			
//				ls_cod_relacion = dw_master.object.cod_relacion [row]		
//				
//				IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion)  = '' THEN
//					Messagebox('Aviso','Debe Ingresar Codigo de Proveedor , Verifique!')
//					Return 1
//				END IF
//
//				/**/
//				li_num_dir = Integer(data)
//				/**/
//				
//
//				SELECT Nvl(dir_dep_estado,' ') ,Nvl(dir_distrito,' ')   ,
//					 	 Nvl(dir_direccion,' ')  
//				  INTO :ls_dir_dep_estado ,:ls_dir_distrito	  ,	
//						 :ls_dir_direccion 		
//				  FROM direcciones
//				 WHERE (codigo = :ls_cod_relacion) AND
//				 		 (item	= :li_num_dir     ) AND
//						 (flag_uso = '1'           ) ;
//						  
//
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
// 					  Messagebox('Aviso','Direccion No Existe , Verifique!')				
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//					Setnull(li_num_dir)
//					This.Object.item_direccion [row] = li_num_dir
//					This.Object.desc_direccion [row] = ls_null
//			      RETURN 1
//			  end if
//
//			  This.Object.desc_direccion [row] = Trim(ls_dir_dep_estado)+' '+Trim(ls_dir_distrito)+' '+Trim(ls_dir_direccion)	 
//				
//		 case 'cod_moneda'
//			
//				select descripcion
//			     into :ls_desc_data
//			     from moneda
//				 where (cod_moneda = :data) ;	
//					
//		      if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			      if SQLCA.SQLCode = 100 then
//						Messagebox('Aviso','Moneda No Existe , Verifique!')				
//			      else
//				      MessageBox('Aviso', SQLCA.SQLErrText)
//			      end if
//				  
//					This.Object.cod_moneda  [row] = ls_null
//					This.Object.desc_moneda [row] = ls_null
//			      RETURN 1
//			   end if
//
//			   This.Object.desc_moneda [row] = ls_desc_data
//				
//				
//		 case 'motivo_traslado'   				
//				
//				select descripcion 
//				  into :ls_desc_data
//				  from motivo_traslado mt
//				 where (mt.motivo_traslado = :data) ;
//					 
//		      if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			      if SQLCA.SQLCode = 100 then
//						Messagebox('Aviso','Motivo de Traslado No Existe , Verifique!')				
//			      else
//				      MessageBox('Aviso', SQLCA.SQLErrText)
//			      end if
//				  
//					This.Object.motivo_traslado [row] = ls_null
//					This.Object.desc_motivo     [row] = ls_null
//			      RETURN 1
//			   end if
//
//				This.Object.desc_motivo     [row] = ls_desc_data 
//				
//				
//				
//				
//		 case	'almacen'	
//				
//				select desc_almacen 
//			     into :ls_desc_data
//		        from almacen
//   	       where (almacen     = :data      ) and
//				       (flag_estado = '1'        ) and
//						 (cod_origen  = :gs_origen ) ; 
//		  
//		     if SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 then
//			     if SQLCA.SQLCode = 100 then
//				     Messagebox('Aviso','Codigo de almacen no existe, ' &
//					             + 'no esta activo o no le corresponde a su origen ')
//			     else
//				     MessageBox('Aviso', SQLCA.SQLErrText)
//			     end if
//				  
//			     this.Object.almacen	 	[row] = ls_null
//			     this.object.desc_almacen [row] = ls_null
//			     RETURN 1
//			  end if
//			
//		     this.object.desc_almacen [row] = ls_desc_data
//				
//
//		CASE 'vendedor'
//			
//				select nvl(u.nombre,'')
//				  into :ls_nom_vendedor
//				  from vendedor v, usuario u
//				 where v.vendedor = u.cod_usr
//				   and v.vendedor = :data;
//				
//				if ls_nom_vendedor = '' then
//					messagebox('Aviso','Codigo de Vendedor no existe, Verifique!')
//					setnull(ls_nom_vendedor)
//					this.object.vendedor[row] = ls_nom_Vendedor
//					this.object.nom_vendedor[row] = ls_nom_vendedor
//					return 1
//				end if
//				
//				this.object.nom_vendedor[row] = ls_nom_vendedor
//
//end choose
//
end event

event itemerror;call super::itemerror;Return 1
end event

