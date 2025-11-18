$PBExportHeader$w_ds2xls.srw
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type w_ds2xls from window
end type
type dw_1 from datawindow within w_ds2xls
end type
end forward

global type w_ds2xls from window
integer x
integer y
integer width = 3419
integer height = 2076
boolean visible = false
boolean titlebar = true
string title = "Untitled"
long backcolor = 80269524
boolean controlmenu = true
string icon = "AppIcon!"
dw_1 dw_1
end type
global w_ds2xls w_ds2xls

forward prototypes
public function integer of_register_ds (ref datastore ads_ds)
public function integer of_unregister_ds (ref datastore ads_ds)
end prototypes

public function integer of_register_ds (ref datastore ads_ds);integer li_ret = 1
string ls_syntax
string ls_err

ls_syntax = ads_ds.describe("DataWindow.Syntax")

if len(ls_syntax) > 1 then
	li_ret = dw_1.create(ls_syntax,ls_err)

	if li_ret <> 1 then
		messagebox("DW2XLS-Error","Invalid syntax DS!~n" + ls_err)
	end if

else
	li_ret = -1
end if

if li_ret = 1 then
	ads_ds.sharedata(dw_1)
end if

return li_ret
end function

public function integer of_unregister_ds (ref datastore ads_ds);ads_ds.sharedataoff()
return 1
end function

on w_ds2xls.create
dw_1 = create dw_1
control[] = {dw_1}
end on

on w_ds2xls.destroy
destroy(dw_1)
end on

type dw_1 from datawindow within w_ds2xls
integer x = 41
integer y = 28
integer width = 3328
integer height = 1936
integer taborder = 10
borderstyle borderstyle = stylelowered!
boolean livescroll = true
end type

