;==============================================================================
;    APTV
;+=============================================================================
; :Description:
;    Outputs a byte array directly in a terminal window.
;
; :Params:
;   data : required, type=byte
;     The byte array to display in the terminal
;-=============================================================================
pro aptv, data
   if n_elements(data) eq 0 then message, 'no byte array passed in to display'
   temp_code = strtrim(strjoin(strsplit(string(systime(/seconds), $
               /implied_print), '.',/extract)),2)
   temp_file = filepath('aptv_'+temp_code+'.png',/tmp)
   print, temp_file
   write_png, temp_file, data
   spawn, 'imgcat ' + temp_file
end
