;==============================================================================
;    APINITIDL
;+=============================================================================
; :Description:
;    Initializes IDL to properly work with the AP library
;
;-=============================================================================
pro apInitIDL
	
	;Set the proper visual class
	device, GET_VISUAL_DEPTH=depth
	if (depth eq 8) then begin
		device, pseudo_color=depth
	endif else begin
		device, true_color=depth
	endelse
	
	;Set up windows repair and color decomoposition
	device, retain=2, decomposed=1
	
end