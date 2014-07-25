PRO ISOHIST, testing=testing

args = command_line_args()
for i=0, n_elements(args)-1 do begin
	tmp=strsplit(args[i],'=',/extract)
	if strpos(strupcase(tmp[0]),'DATA') ge 0 then datafile = tmp[1]
endfor
basename = (strsplit(datafile,'.',/extract))[0]
outname = basename + ".smcont.dat"
openw, out, outname, /get_lun

; Z from 0.007 to 0.031
Z = 0.007 + 0.24 * dindgen(10000) / 10000
ZV = dblarr(10000)
; (m-M) from 7.5 to 12.5
D = 7.5 + 5.0 * dindgen(10000) / 10000
DV = dblarr(10000)
; Age from 6.5 to 11.5
A = 6.5 + 5.0 * dindgen(10000) / 10000
AV = dblarr(10000)
; Reddening from 0.0 to 1.4
R = 1.4 * dindgen(10000) / 10000
RV = dblarr(10000)

; Open up data file and look through
spawn, "cat "+datafile, datalines
for i=0, n_elements(datalines)-1 do begin
	datasplit = strsplit(datalines[i],/extract)
	DZ = double(datasplit[2])
	if double(datasplit[3]) gt 0.002 then DZE = double(datasplit[3]) else DZE = 0.002
	DA = double(datasplit[4])
	if double(datasplit[5]) gt 0.02 then DAE = double(datasplit[5]) else DAE = 0.1
	DD = double(datasplit[6])
	if double(datasplit[7]) gt 0.02 then DDE = double(datasplit[7]) else DDE = 0.1
	DR = double(datasplit[8])
	if double(datasplit[9]) gt 0.002 then DRE = double(datasplit[7]) else DRE = 0.002
	
	ZV += 1.0 / DZE * exp(-1.0 * (Z - DZ)^2.0 / (2.0 * DZE^2.0))
	AV += 1.0 / DAE * exp(-1.0 * (A - DA)^2.0 / (2.0 * DAE^2.0))
	DV += 1.0 / DDE * exp(-1.0 * (D - DD)^2.0 / (2.0 * DDE^2.0))
	RV += 1.0 / DRE * exp(-1.0 * (R - DR)^2.0 / (2.0 * DRE^2.0))
endfor

for i=0, 9999 do printf, out, Z[i], ZV[i], A[i], AV[i], D[i], DV[i], R[i], RV[i], format='(8F15.4)'

END