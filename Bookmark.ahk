#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
^!b::

KeyWait Control
KeyWait Alt

WinGetTitle title, A
if InStr(title, "YouTube") {
	title := StrReplace(title, " - YouTube")
}

if InStr(title, "(Private Browsing)") {
	title := StrReplace(title, " (Private Browsing)")
}

if InStr(title, "Mozilla Firefox") {
	title := StrReplace(title, " - Mozilla Firefox")
	title := StrReplace(title, " — Mozilla Firefox")
} else if InStr(title, "Microsoft Edge") {
	title := StrReplace(title, " ‎- Microsoft Edge")

	extrapos := RegExMatch(title, " and \d\d* more")
	if extrapos {
		title := SubStr(title, 1, extrapos - 1)
	}
} else if WinActive("ahk_class Chrome_WidgetWin_1") {
	title := StrReplace(title, " - Google Chrome")
} else {
	return
}

clipboard :=

Send {F6}
Sleep, 500

Send ^c
ClipWait 0.1

if ErrorLevel {
	MsgBox Failed to copy to clipboard.
	return
}

url := StrReplace(clipboard, "`r`n")

clipboard := title ", " url
ClipWait 0.1

if ErrorLevel {
	MsgBox Failed to copy to clipboard.
	return
}

return
