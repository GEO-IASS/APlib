; USER IDL STARTUP FILE'
; Set path to be able to use the apPath routine
ssw_path, '/Users/aram/git/APlib/path', /prepend, /quiet
; Save the original SSW path
ssw_path, /save, /quiet
; Use the apPath routine
apPath, /all, /old_core
