$PBExportHeader$w_n_dwr_service_progress.srw
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type w_n_dwr_service_progress from window
end type
type cb_cancel from commandbutton within w_n_dwr_service_progress
end type
type st_remain from statictext within w_n_dwr_service_progress
end type
type st_title from statictext within w_n_dwr_service_progress
end type
type uo_prog from uo_dwr_progressbar within w_n_dwr_service_progress
end type
end forward

global type w_n_dwr_service_progress from window
integer x = 1056
integer y = 484
integer width = 1883
integer height = 440
boolean titlebar = true
string title = "Ñîõðàíåíèå â Excel"
windowtype windowtype = response!
long backcolor = 79741120
event type integer ue_show_progress (integer ai_progress)
cb_cancel cb_cancel
st_remain st_remain
st_title st_title
uo_prog uo_prog
end type
global w_n_dwr_service_progress w_n_dwr_service_progress

type variables
public nonvisualobject parm
public datetime idt_start
public datetime idt_last
public n_dwr_datetime invo_dt_srv
end variables

event ue_show_progress;long ll_cur_s
long ll_total_rem_s
long ll_rem_s
long ll_rem_m
long ll_rem_h
string ls_str
datetime ldt_now

ldt_now = datetime(today(),now())

if invo_dt_srv.of_secondsafter(idt_last,ldt_now) > 5 then
	idt_last = ldt_now
	ll_cur_s = invo_dt_srv.of_secondsafter(idt_start,ldt_now)

	if ll_cur_s > 3 and ai_progress > 0 then
		ll_total_rem_s = truncate(round((ll_cur_s * 100) / ai_progress - ll_cur_s,0),0)
		ll_total_rem_s = round(ll_total_rem_s / 5,0) * 5
		ll_rem_s = mod(ll_total_rem_s,60)
		ll_total_rem_s = truncate(ll_total_rem_s / 60,0)
		ll_rem_m = mod(ll_total_rem_s,60)
		ll_rem_h = truncate(ll_total_rem_s / 60,0)
		ls_str = ""

		if ll_rem_h = 1 then
			ls_str = ls_str + string(ll_rem_h) + " Hour "
		end if

		if ll_rem_h > 1 then
			ls_str = ls_str + string(ll_rem_h) + " Hours "
		end if

		if ll_rem_m = 1 then
			ls_str = ls_str + string(ll_rem_m) + " Minute "
		else

			if ((ll_rem_m > 1) or (ll_rem_h > 0)) then
				ls_str = ls_str + string(ll_rem_m) + " Minutes "
			end if

		end if

		if ll_rem_s = 1 then
			ls_str = ls_str + string(ll_rem_s) + " Second "
		else

			if (((ll_rem_s > 1) or (ll_rem_h > 0)) or (ll_rem_m > 0)) then
				ls_str = ls_str + string(ll_rem_s) + " Seconds "
			end if

		end if

		if ls_str <> "" then
			ls_str = ls_str + "Remaining"
		end if

		st_remain.text = ls_str
	end if

end if

uo_prog.setvalue(ai_progress)
return 1
end event

on w_n_dwr_service_progress.create
st_title = create st_title
st_remain = create st_remain
cb_cancel = create cb_cancel
uo_prog = create uo_prog
control[] = {st_title,st_remain,cb_cancel,uo_prog}
end on

on w_n_dwr_service_progress.destroy
destroy(st_title)
destroy(st_remain)
destroy(cb_cancel)
destroy(uo_prog)
end on

event open;environment l_env

parm = message.powerobjectparm
title = "Save as Excel"

if getenvironment(l_env) <> 1 then
	return
end if

x = (pixelstounits(l_env.screenwidth,xpixelstounits!) - width) / 2
y = (pixelstounits(l_env.screenheight,ypixelstounits!) - height) / 2
uo_prog.setrange(1,100)
idt_start = datetime(today(),now())
idt_last = idt_start
parm.postevent("ue_process_work")
return
end event

type cb_cancel from commandbutton within w_n_dwr_service_progress
integer x = 1399
integer y = 184
integer width = 393
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Îòìåíà"
boolean default = true
end type

event clicked;enabled = false
parent.parm.triggerevent("ue_cancel")
return
end event

event constructor;text = "Cancel"
return
end event

type st_remain from statictext within w_n_dwr_service_progress
integer x = 82
integer y = 160
integer width = 1303
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type st_title from statictext within w_n_dwr_service_progress
integer x = 82
integer y = 4
integer width = 1701
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type uo_prog from uo_dwr_progressbar within w_n_dwr_service_progress
integer x = 82
integer y = 84
integer width = 1710
integer height = 76
integer taborder = 10
boolean bringtotop = true
end type

on uo_prog.destroy
call super::destroy;
end on

