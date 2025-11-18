$PBExportHeader$w_ds2xls.srw
forward
global type w_ds2xls from Window
end type
type dw_1 from datawindow within w_ds2xls
end type
end forward

global type w_ds2xls from Window
int X=0
int Y=0
int Width=3419
int Height=2076
boolean Visible=false
boolean TitleBar=true
string Title="Untitled"
long BackColor=80269524
boolean ControlMenu=true
string Icon="AppIcon!"
dw_1 dw_1
end type
global w_ds2xls w_ds2xls

forward prototypes
public function integer of_register_ds (ref datastore ads_ds)
public function integer of_unregister_ds (ref datastore ads_ds)
end prototypes

public function integer of_register_ds (ref datastore ads_ds);integer li_ret = 1
string ls_syntax, ls_err

ls_syntax = ads_ds.Describe("DataWindow.Syntax")
if len(ls_syntax) > 1 then
	li_ret = dw_1.Create(ls_syntax, ls_err)
	if li_ret <> 1 then messagebox('DW2XLS-Error', 'Invalid syntax DS!~n' + ls_err)
else
	li_ret = -1
end if

if li_ret = 1 then ads_ds.ShareData(dw_1)

return li_ret
end function

public function integer of_unregister_ds (ref datastore ads_ds);ads_ds.ShareDataOff()
return 1
end function

on w_ds2xls.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_ds2xls.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within w_ds2xls
int X=41
int Y=28
int Width=3328
int Height=1936
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

