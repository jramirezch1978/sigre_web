$PBExportHeader$w_ope321_prod_x_ot.srw
forward
global type w_ope321_prod_x_ot from w_abc
end type
type uo_2 from u_ingreso_fecha within w_ope321_prod_x_ot
end type
type cb_2 from commandbutton within w_ope321_prod_x_ot
end type
type dw_detail from u_dw_abc within w_ope321_prod_x_ot
end type
type cb_1 from commandbutton within w_ope321_prod_x_ot
end type
type st_2 from statictext within w_ope321_prod_x_ot
end type
type dw_master from u_dw_abc within w_ope321_prod_x_ot
end type
type st_1 from statictext within w_ope321_prod_x_ot
end type
end forward

global type w_ope321_prod_x_ot from w_abc
integer width = 3200
integer height = 2052
string title = "Producion Destajo (OPE321)"
string menuname = "m_salir"
uo_2 uo_2
cb_2 cb_2
dw_detail dw_detail
cb_1 cb_1
st_2 st_2
dw_master dw_master
st_1 st_1
end type
global w_ope321_prod_x_ot w_ope321_prod_x_ot

type variables
String is_tipo_mov
end variables

on w_ope321_prod_x_ot.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.uo_2=create uo_2
this.cb_2=create cb_2
this.dw_detail=create dw_detail
this.cb_1=create cb_1
this.st_2=create st_2
this.dw_master=create dw_master
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_2
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.dw_master
this.Control[iCurrent+7]=this.st_1
end on

on w_ope321_prod_x_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_2)
destroy(this.cb_2)
destroy(this.dw_detail)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.dw_master)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)

idw_1 = dw_master  

//parametros
select oper_ing_prod into :is_tipo_mov from logparam where reckey = '1' ;

if isnull(is_tipo_mov) or is_tipo_mov = '' then
	Messagebox('Aviso','Tipo de movimiento de Ingreso de Produción No esta Definido , Verifique!')

end if
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10


end event

type uo_2 from u_ingreso_fecha within w_ope321_prod_x_ot
event destroy ( )
integer x = 37
integer y = 160
integer taborder = 30
end type

on uo_2.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type cb_2 from commandbutton within w_ope321_prod_x_ot
integer x = 2715
integer y = 960
integer width = 343
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Long   ll_inicio,ll_row_master
String ls_nro_orden,ls_oper_sec    ,ls_supervisor,ls_administrador,ls_ot_adm,&
		 ls_cod_labor,ls_cod_ejecutor,ls_desc_labor,ls_und,ls_nro_parte_dstj,&
		 ls_cencos   ,ls_flag_cierre ,ls_cod_art
Decimal {2} ldc_porc,ldc_total_porc
Datetime		ld_fec_parte
Boolean     lb_ret = TRUE


SetPointer(hourglass!)

dw_master.Accepttext()
dw_detail.Accepttext()

//recupera informacion de cabecera..
ll_row_master = dw_master.Getrow()

if ll_row_master = 0 then 
	Messagebox('Aviso','Debe Selecionar un Parte de Produccion , Verifique!')
	SetPointer(hourglass!)	
	return
end if

//datos de cabecera
ls_supervisor		= dw_master.object.supervisor     [ll_row_master]
ls_administrador  = dw_master.object.administrador  [ll_row_master]
ls_ot_adm			= dw_master.object.ot_adm			 [ll_row_master]
ld_fec_parte		= dw_master.object.fec_parte		 [ll_row_master]
ls_cod_labor		= dw_master.object.cod_labor		 [ll_row_master]
ls_cod_ejecutor	= dw_master.object.cod_ejecutor	 [ll_row_master]
ls_desc_labor		= dw_master.object.desc_labor  	 [ll_row_master]
ls_und				= dw_master.object.und			  	 [ll_row_master]
ls_nro_parte_dstj = dw_master.object.nro_parte_dstj [ll_row_master]
ls_cod_art			= dw_master.object.cod_art			 [ll_row_master]



if dw_detail.Rowcount() > 0 then
	//VERIFICA TOTAL %
	ldc_total_porc = dw_detail.object.total_porc [1]
	
	if ldc_total_porc < 100 then
		Messagebox('Aviso','Porcentaje de Participacion tiene que Acumular en 100 %')
		lb_ret = FALSE
		GOTO SALIDA
	end if	
else
	Messagebox('Aviso','No existen Ordenes de trabajo Seleccionados')
	lb_ret = FALSE
	GOTO SALIDA
end if	

For ll_inicio = 1 to dw_detail.Rowcount()
	 ls_nro_orden   = dw_detail.object.nro_orden   [ll_inicio] 
	 ldc_porc	    = dw_detail.object.porc		  [ll_inicio]
	 ls_oper_sec    = dw_detail.object.oper_sec	  [ll_inicio]
	 ls_cencos	    = dw_detail.object.cencos	     [ll_inicio] 
	 ls_flag_cierre = dw_detail.object.flag_cierre [ll_inicio] 	 
	 
	 //genera parte diario
	 if ldc_porc > 0 then
		 DECLARE PB_USP_OPE_PROC_PDIARIO_DESTAJO PROCEDURE FOR USP_OPE_PROC_PDIARIO_DESTAJO
		 (:ls_nro_orden ,:ls_oper_sec ,:ldc_porc,:ls_ot_adm      ,:ls_administrador,:ls_supervisor    ,
		  :ld_fec_parte ,:ls_cod_labor,:ls_und  ,:ls_desc_labor  ,:ls_cod_ejecutor ,:ls_nro_parte_dstj,
        :ls_cencos	 ,:gs_origen   ,:gs_user ,:ls_flag_cierre ,:ls_cod_art );
		 EXECUTE PB_USP_OPE_PROC_PDIARIO_DESTAJO ; 
			
		 IF SQLCA.SQLCode = -1 THEN 
			 MessageBox("SQL error", SQLCA.SQLErrText)
			 lb_ret = FALSE
			 GOTO SALIDA
		 END IF
		 
		 
			
			
	 end if
	 
Next	



SALIDA:


IF lb_ret THEN
	
	Commit ;
	Messagebox('Aviso','Proceso Culmino Satisfactoriamente')
	//actualiza lista de parte de producion
	cb_1.TriggerEvent(Clicked!)
	
ELSE
	Rollback ;
	Messagebox('Aviso','Proceso Tuvo Problemas ,Verifique Informacion!')
	cb_1.TriggerEvent(Clicked!)
END IF	


SetPointer(Arrow!)
end event

type dw_detail from u_dw_abc within w_ope321_prod_x_ot
integer x = 27
integer y = 1072
integer width = 3045
integer height = 672
integer taborder = 20
string dataobject = "d_abc_oper_prod_destajo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
							
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_detail
end event

type cb_1 from commandbutton within w_ope321_prod_x_ot
integer x = 2715
integer y = 144
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;Date ld_fecha_inicio


SetPointer(hourglass!)
dw_master.reset()

ld_fecha_inicio = uo_2.of_get_fecha()  


DECLARE PB_usp_ope_pdestajo_x_pendiente PROCEDURE FOR usp_ope_pdestajo_x_pendiente 
(:ld_fecha_inicio);
EXECUTE PB_usp_ope_pdestajo_x_pendiente ;



IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF


dw_master.Retrieve()



SetPointer(Arrow!)
end event

type st_2 from statictext within w_ope321_prod_x_ot
integer x = 55
integer y = 976
integer width = 549
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Ordenes de Trabajo :"
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_ope321_prod_x_ot
integer x = 27
integer y = 264
integer width = 3045
integer height = 672
string dataobject = "d_abc_ope_tt_parte_prod_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,

is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = dw_master

end event

event rowfocuschanged;call super::rowfocuschanged;String ls_cod_labor,ls_cod_ejec,ls_cod_art,ls_ind_dist

This.SelectRow(0, False)
This.SelectRow(currentrow, True)

if currentrow > 0 then
	ls_cod_labor = this.object.cod_labor    [currentrow]
	ls_cod_ejec  = this.object.cod_ejecutor [currentrow]
	ls_cod_art   = this.object.cod_art		 [currentrow]
	ls_ind_dist	 = this.object.ind_distrib	 [currentrow]
	
	if trim(ls_cod_art) = '%' then
		ls_cod_art = '%'
	end if
	
	
	if ls_ind_dist = '2' then //distribucion buscar articulos producidos el dia de hoy
		
		dw_detail.dataobject = 'd_abc_oper_prod_destajo_x_art_prod_tbl'
		dw_detail.Settransobject(sqlca)
		dw_detail.retrieve(ls_cod_labor,ls_cod_ejec,is_tipo_mov)
	else
		dw_detail.dataobject = 'd_abc_oper_prod_destajo_tbl'
		dw_detail.Settransobject(sqlca)
		dw_detail.retrieve(ls_cod_labor,ls_cod_ejec,is_tipo_mov,ls_cod_art)
	end if
	
end if	







end event

type st_1 from statictext within w_ope321_prod_x_ot
integer x = 55
integer y = 48
integer width = 850
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Partes de Produccion Destajo :"
boolean focusrectangle = false
end type

