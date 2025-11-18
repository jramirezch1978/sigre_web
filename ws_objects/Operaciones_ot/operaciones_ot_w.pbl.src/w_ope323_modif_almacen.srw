$PBExportHeader$w_ope323_modif_almacen.srw
forward
global type w_ope323_modif_almacen from w_abc
end type
type st_1 from statictext within w_ope323_modif_almacen
end type
type sle_1 from singlelineedit within w_ope323_modif_almacen
end type
type cb_1 from commandbutton within w_ope323_modif_almacen
end type
type dw_master from u_dw_abc within w_ope323_modif_almacen
end type
end forward

global type w_ope323_modif_almacen from w_abc
integer width = 4037
integer height = 1524
string title = "Modificacion Almacen (OPE323)"
string menuname = "m_modifica_graba"
st_1 st_1
sle_1 sle_1
cb_1 cb_1
dw_master dw_master
end type
global w_ope323_modif_almacen w_ope323_modif_almacen

forward prototypes
public function boolean of_set_saldo_total (string as_cod_art, string as_almacen)
end prototypes

public function boolean of_set_saldo_total (string as_cod_art, string as_almacen);Decimal	ldc_saldo_total, ldc_costo_unit,ldc_costo_unit_old
Boolean  lb_ret = TRUE


ldc_costo_unit_old = dw_master.object.precio_unit[dw_master.GetRow()]

SELECT usf_cmp_prec_ult_compra(:as_cod_art, :as_almacen ) 
  INTO :ldc_costo_unit 
  FROM dual ;

if ldc_costo_unit_old > ldc_costo_unit then
	LB_RET = false
	Messagebox('Aviso','Precio Anterior es Superior ,Porceda A Desaprobar Articulo !')
	GOTO SALIDA
end if	

dw_master.object.precio_unit[dw_master.GetRow()] = ldc_costo_unit




select sldo_total
	into :ldc_saldo_total
from articulo_almacen
where cod_art = :as_cod_art
  and almacen = :as_almacen;

if SQLCA.SQLCode = 100 then ldc_saldo_total = 0

dw_master.object.saldo_total [dw_master.GetRow()] = ldc_saldo_Total

SALIDA:


return lb_ret
end function

on w_ope323_modif_almacen.create
int iCurrent
call super::create
if this.MenuName = "m_modifica_graba" then this.MenuID = create m_modifica_graba
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_master
end on

on w_ope323_modif_almacen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente


of_position_window(0,0)       			// Posicionar la ventana en forma fija

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

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

type st_1 from statictext within w_ope323_modif_almacen
integer y = 136
integer width = 416
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "O.Trabajo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_ope323_modif_almacen
integer x = 439
integer y = 128
integer width = 549
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ope323_modif_almacen
integer x = 1024
integer y = 128
integer width = 402
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_tipo_doc,ls_nro_doc

select doc_ot into :ls_tipo_doc from logparam where reckey = '1' ;

ls_nro_doc = sle_1.text

dw_master.retrieve(ls_tipo_doc,ls_nro_doc)
end event

type dw_master from u_dw_abc within w_ope323_modif_almacen
integer y = 256
integer width = 3986
integer height = 1056
string dataobject = "d_abc_modif_alm_ot_tbl"
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


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2

idw_mst  = dw_master

end event

event itemchanged;call super::itemchanged;String ls_colname,ls_cod_art,ls_null,ls_desc

this.acceptText()


ls_colname = dwo.name
SetNull(ls_null)

if dwo.name = 'almacen' then
	
	if of_set_saldo_total(this.object.cod_art[this.GetRow()], data)  then
		ls_cod_art   = this.object.cod_art [row]
	
		select desc_almacen
			into :ls_desc
		from almacen
		where almacen = :data
		  and flag_estado = '1';
	
		IF SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'El codigo de almacen no existe o no esta activo')
			this.object.almacen [row] = ls_null
			return
		end if


		
	end if
END IF		


end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN Return

String ls_name,ls_prot


str_seleccionar lstr_seleccionar

ls_name = dwo.name
if this.Describe( lower(dwo.name) + ".Protect") = '1' then return



CHOOSE CASE dwo.name

 	CASE 'almacen'
	
		
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT almacen AS codigo_almacen, "&   
										 +"desc_almacen AS DESCripcion_almacen "&   
										 +"FROM  almacen " &
										 +"where flag_estado = '1'"

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			if of_set_saldo_total(this.object.cod_art[this.GetRow()], lstr_seleccionar.param1[1]) then
				this.object.almacen [row] = lstr_seleccionar.param1[1]
				this.ii_update = 1
			end if

			
		END IF
				

END CHOOSE
end event

