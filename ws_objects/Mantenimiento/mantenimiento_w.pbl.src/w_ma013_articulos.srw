$PBExportHeader$w_ma013_articulos.srw
forward
global type w_ma013_articulos from w_abc
end type
type dw_master from u_dw_abc within w_ma013_articulos
end type
end forward

global type w_ma013_articulos from w_abc
integer width = 2853
integer height = 1032
string title = "Articulos (MA013)"
string menuname = "m_cns_list"
dw_master dw_master
end type
global w_ma013_articulos w_ma013_articulos

on w_ma013_articulos.create
int iCurrent
call super::create
if this.MenuName = "m_cns_list" then this.MenuID = create m_cns_list
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_ma013_articulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_retrieve_list();call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
sg_parametros sl_param



sl_param.dw1    = 'd_dddw_articulo'
sl_param.titulo = 'Vista de Articulos'
sl_param.field_ret_i[1] = 1


OpenWithParm( w_search, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	idw_1.retrieve(sl_param.field_ret[1])
END IF

end event

event ue_open_pre();call super::ue_open_pre;String ls_cod_art

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente

dw_master.of_protect()         		// bloquear modificaciones 


of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic


//Recupera Primer Articulo 
SELECT COD_ART
INTO   :ls_cod_art
FROM   ARTICULO
WHERE  rownum = 1 ;

IF Isnull(ls_cod_art) OR Trim(ls_cod_art) = '' THEN
	Messagebox('Aviso','No Existen Articulos')
ELSE
	idw_1.Retrieve(ls_cod_art)
END IF
end event

type dw_master from u_dw_abc within w_ma013_articulos
integer x = 18
integer y = 24
integer width = 2761
integer height = 784
string dataobject = "d_abc_articulo_ff"
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master				// dw_master

end event

