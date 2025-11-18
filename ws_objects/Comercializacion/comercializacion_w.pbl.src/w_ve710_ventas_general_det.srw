$PBExportHeader$w_ve710_ventas_general_det.srw
forward
global type w_ve710_ventas_general_det from w_report_smpl
end type
type st_etiqueta from statictext within w_ve710_ventas_general_det
end type
end forward

global type w_ve710_ventas_general_det from w_report_smpl
integer width = 1134
integer height = 1228
string title = "[VE710] Detalle de Ventas Generales"
string menuname = "m_reporte"
long backcolor = 67108864
st_etiqueta st_etiqueta
end type
global w_ve710_ventas_general_det w_ve710_ventas_general_det

type variables
string is_categ, is_serie, is_tipo
end variables

on w_ve710_ventas_general_det.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_etiqueta=create st_etiqueta
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_etiqueta
end on

on w_ve710_ventas_general_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_etiqueta)
end on

event open;//Override
THIS.EVENT ue_open_pre()

date ld_fec_ini, ld_fec_fin
string ls_canal, ls_sub_canal, ls_zona, ls_flag_opc, ls_desc_opc, ls_distrito, ls_desc_distr, ls_parametros[7], ls_datawindow
str_parametros lstr_parametros

if isvalid(message.powerobjectparm ) then
	
	lstr_parametros = message.powerobjectparm
	
	ld_fec_ini = lstr_parametros.fecha1
	ld_fec_fin = lstr_parametros.fecha2
	
	ls_parametros[] = lstr_parametros.str_array[]
	
	ls_canal	     = ls_parametros[1]
	ls_sub_canal  = ls_parametros[2]
	ls_zona 		  = ls_parametros[3]
	ls_flag_opc   = ls_parametros[4]
	ls_desc_opc   = ls_parametros[5]
	ls_distrito   = ls_parametros[6]
	ls_desc_distr = ls_parametros[7]
	
	ls_datawindow = lstr_parametros.dw_master
	is_tipo		  = lstr_parametros.tipo // CA = Canal ; SC = Sub Canal ; ZO = Zonas ; DI = Distrito ; CL = cliente
	
	idw_1.dataobject = ls_datawindow
	idw_1.settransobject( sqlca )
	
	if is_tipo = 'CA' then
		idw_1.retrieve( ls_flag_opc )
		idw_1.object.gr_1.values.Label = ls_desc_opc
		
	elseif is_tipo = 'SC' then
		idw_1.retrieve( ls_canal , ls_flag_opc )
		idw_1.object.gr_1.values.Label = ls_desc_opc
		
	elseif is_tipo = 'ZO' then
		idw_1.retrieve( ls_canal , ls_sub_canal , ls_flag_opc )
		idw_1.object.gr_1.values.Label = ls_desc_opc
				
	elseif is_tipo = 'DI' then

		idw_1.retrieve( ls_canal, ls_sub_canal, ls_zona, ls_flag_opc)
		idw_1.object.gr_1.values.Label = ls_desc_opc
		
	elseif is_tipo = 'CL' then

		idw_1.retrieve( ls_canal, ls_sub_canal, ls_zona, ls_distrito, ls_desc_distr, ls_flag_opc)
		idw_1.object.gr_1.values.Label = ls_desc_opc
		
	end if
	
	idw_1.visible = true
	
else
	messagebox('Error','ERror al momento de pasar Parametros')
end if
end event

event ue_open_pre;call super::ue_open_pre;idw_1.visible = true
end event

type dw_report from w_report_smpl`dw_report within w_ve710_ventas_general_det
event ue_mousemove pbm_mousemove
integer x = 37
integer y = 32
integer width = 1029
integer height = 964
end type

event dw_report::ue_mousemove;//codigo
Int     li_Series, li_Category 
String  ls_serie, ls_categ, ls_mensaje, ls_cantidad, ls_nombre

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	
	ls_categ = this.CategoryName('gr_1', li_Category)
	ls_serie = this.SeriesName('gr_1', li_Series)
	
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
	
	if is_tipo = 'CL' then
		
		select nom_proveedor
		  into :ls_serie
		  from proveedor
		 where trim(proveedor) = :ls_categ;
		 
	end if
	
	ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_categ)+' - '+trim(ls_serie)+' )'
	
	st_etiqueta.BringToTop = TRUE 
	st_etiqueta.text = ls_mensaje 
	
	st_etiqueta.width = len(trim(st_etiqueta.text)) * 35
	
	if is_tipo = 'CL' then
	
		if ls_categ <> is_categ or ls_serie <> is_serie then
		
			is_categ = ls_categ
			is_serie = ls_serie
			
			if ( st_etiqueta.width + st_etiqueta.x ) < parent.width then
				
				st_etiqueta.move( ( xpos + this.x + 60), ( ypos + this.y + 80) )
				
			end if
	
			if ( ( st_etiqueta.width + st_etiqueta.x ) > parent.width ) then
				
				st_etiqueta.move( ( ( xpos + this.x ) - st_etiqueta.width ) , ( ypos + this.y + 80) )
				
			end if
		
		end if
		
	else
		
		st_etiqueta.move( ( xpos + this.x + 60), ( ypos + this.y + 80) )
		
	end if
	
	st_etiqueta.visible = true 
	
ELSE 
	
 	st_etiqueta.visible = false 
	 
END IF
end event

type st_etiqueta from statictext within w_ve710_ventas_general_det
integer x = 608
integer y = 12
integer width = 402
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

