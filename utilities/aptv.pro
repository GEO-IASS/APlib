;==============================================================================
;    APTV
;+=============================================================================
; :Description:
;    Outputs a byte array directly in a terminal window.
;    Uses imgcat script for iTerm2:
;    https://raw.githubusercontent.com/gnachman/iTerm2/master/tests/imgcat
;
; :Params:
;   data : required
;     The byte array to display in the terminal. Will get passed on
;     directly to WRITE_PNG, so format accoringly. Can be flat or color.
;-=============================================================================
pro aptv, data, binary_color=binaryColor 
   if n_elements(data) eq 0 then message, 'No byte array passed in to display.'
   temp_code = strtrim(strjoin(strsplit(string(systime(/seconds), $
               /implied_print), '.',/extract)),2)
   temp_file = filepath('aptv_'+temp_code+'.png',/tmp)
   write_png, temp_file, data
   spawn, 'imgcat ' + temp_file
   file_delete, temp_file, /quiet
end
