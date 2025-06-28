; Initialise workspace
(sde:clear)

; Create substrate doped regions
(sdegeo:create-rectangle (position 0 0 0) (position -4 -12 0) "Silicon" "Substrate_1")
(sdegeo:create-polygon (list
	(position -7 -6.6 0)
	(position -7 -8.4 0)
	(position -10 -8.4 0)
	(position -10 -7.2 0)
	(position -8.5 -7.2 0)
	(position -8.5 -6.6 0)
	(position -7 -6.6 0)
	)
	"Silicon"
	"Substrate_2"
)

; Create process doped regions
(sdegeo:create-rectangle (position -4 0 0) (position -7 -12 0) "Silicon" "DNW")
(sdegeo:create-rectangle (position -7 0 0) (position -8.5 -6.6 0) "Silicon" "NW_1")
(sdegeo:create-rectangle (position -7 -8.4 0) (position -8.5 -12 0) "Silicon" "NW_2.1")
(sdegeo:create-rectangle (position -8.5 -8.4 0) (position -10 -9 0) "Silicon" "NW_2.2")
(sdegeo:create-rectangle (position -8.5 -11.4 0) (position -10 -12 0) "Silicon" "NW_2.3")
(sdegeo:create-rectangle (position -8.5 -9 0) (position -10 -11.4 0) "PolySi" "NP")
(sdegeo:create-rectangle (position -8.5 0 0) (position -10 -7.2 0) "PolySi" "PP")

; Set oxide regions for insulation
(sdegeo:create-rectangle (position -10 -12 0) (position -11 -10.8 0) "Oxide" "Ox")
(sdegeo:create-rectangle (position -10 -9.6 0) (position -11 -6 0) "Oxide" "Ox")

; Define contacts for simulation
(sdegeo:set-contact (find-edge-id (position -10 -2 0)) "anode")
(sdegeo:set-contact (find-edge-id (position -10 -10.2 0)) "cathode")
(sdegeo:set-contact (find-face-id (position 0 2 0)) "bulk")

; Create a sweeping path and sweep along it
(define rectangular_path (sdegeo:create-polyline-wire (list
	(position 0 -6 0)
	(position 0 -6 2.5)
	(position 0 -2.5 6)
	(position 0 2.5 6)
	(position 0 6 2.5)
	(position 0 6 -2.5)
	(position 0 2.5 -6)
	(position 0 -2.5 -6)
	(position 0 -6 -2.5)
	(position 0 -6 0)
)))
(sdegeo:sweep (entity:faces (find-material-id "PolySi")) rectangular_path 
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"  ))
(sdegeo:sweep (entity:faces (find-material-id "Silicon")) rectangular_path 
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"  ))
(sdegeo:sweep (entity:faces (find-material-id "Oxide")) rectangular_path 
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"  ))

; Define contacts for simulation
(sdegeo:set-contact (find-face-id (position -10 -2 0)) "anode")
(sdegeo:set-contact (find-face-id (position -10 2 0)) "anode")
(sdegeo:set-contact (find-face-id (position -10 0 -2)) "anode")
(sdegeo:set-contact (find-face-id (position -10 0 2)) "anode")
(sdegeo:set-contact (find-face-id (position 0 -2 0)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 -2 2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 -2 -2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 0 -2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 2 -2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 -2 -2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 2 0)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 2 2)) "bulk")
(sdegeo:set-contact (find-face-id (position 0 0 2)) "bulk")

; Define and set doping profiles
(sdedr:define-constant-profile "Substrate_doping" "BoronActiveConcentration" 1e+15)

(sdedr:define-constant-profile-region "Substrate_1_doping" "Substrate_doping" "Substrate_1")
(sdedr:define-constant-profile-region "Substrate_2_doping" "Substrate_doping" "Substrate_2")
(sdedr:define-constant-profile-region "DNW_base" "Substrate_doping" "DNW")
(sdedr:define-constant-profile-region "NW_1_base" "Substrate_doping" "NW_1")
(sdedr:define-constant-profile-region "NW_2.1_base" "Substrate_doping" "NW_2.1")
(sdedr:define-constant-profile-region "NW_2.2_base" "Substrate_doping" "NW_2.2")
(sdedr:define-constant-profile-region "NW_2.3_base" "Substrate_doping" "NW_2.3")
(sdedr:define-constant-profile-region "NP_base" "Substrate_doping" "NP")
(sdedr:define-constant-profile-region "PP_base" "Substrate_doping" "PP")

; Set BaseLine definitions for analytical profiles
(sdedr:define-refeval-window "BaseLine.DNW" "Polygon"  (list  
	(position -7 -11.8 -4.8)
	(position -7 -4.8 -11.8)
	(position -7 4.8 -11.8)
	(position -7 11.8 -4.8)
	(position -7 11.8 4.8)
	(position -7 4.8 11.8)
	(position -7 -4.8 11.8)
	(position -7 -11.8 4.8)
))
(sdedr:define-refeval-window "BaseLine.NW_1" "Polygon"  (list  
	(position -10 -6.2 -2.7)
	(position -10 -2.7 -6.2)
	(position -10 2.7 -6.2)
	(position -10 6.2 -2.7)
	(position -10 6.2 2.7)
	(position -10 2.7 6.2)
	(position -10 -2.7 6.2)
	(position -10 -6.2 2.7)
))
(sdedr:define-refeval-window "BaseLine.NW_2" "Polygon"  (list  
	(position -10 -11.8 -4.8)
	(position -10 -4.8 -11.8)
	(position -10 4.8 -11.8)
	(position -10 11.8 -4.8)
	(position -10 11.8 4.8)
	(position -10 4.8 11.8)
	(position -10 -4.8 11.8)
	(position -10 -11.8 4.8)
	(position -10 -11.8 -4.79)
	(position -10 -8.6 -3.71)
	(position -10 -8.6 3.7)
	(position -10 -3.7 8.6)
	(position -10 3.7 8.6)
	(position -10 8.6 3.7)
	(position -10 8.6 -3.7)
	(position -10 3.7 -8.6)
	(position -10 -3.7 -8.6)
	(position -10 -8.6 -3.7)
))
(sdedr:define-refeval-window "BaseLine.NP" "Polygon"  (list  
	(position -10 -11.2 -4.5)
	(position -10 -4.5 -11.2)
	(position -10 4.5 -11.2)
	(position -10 11.2 -4.5)
	(position -10 11.2 4.5)
	(position -10 4.5 11.2)
	(position -10 -4.5 11.2)
	(position -10 -11.2 4.5)
	(position -10 -11.2 -4.79)
	(position -10 -9.2 -3.91)
	(position -10 -9.2 3.9)
	(position -10 -3.9 9.2)
	(position -10 3.9 9.2)
	(position -10 9.2 3.9)
	(position -10 9.2 -3.9)
	(position -10 3.9 -9.2)
	(position -10 -3.9 -9.2)
	(position -10 -9.2 -3.9)
))
(sdedr:define-refeval-window "BaseLine.PP" "Polygon"  (list  
	(position -10 -7 -2.8)
	(position -10 -2.8 -7)
	(position -10 2.8 -7)
	(position -10 7 -2.8)
	(position -10 7 2.8)
	(position -10 2.8 7)
	(position -10 -2.8 7)
	(position -10 -7 2.8)
))

; Define analytical doping profiles
(sdedr:define-gaussian-profile "Gauss.DNW"
	"PhosphorusActiveConcentration" "PeakPos" 1.5 "PeakVal" 7.5e19
	"ValueAtDepth" 3e10 "Depth" 2.5 "Gauss" "Factor" 0.5)
(sdedr:define-gaussian-profile "Gauss.NW_1"
	"PhosphorusActiveConcentration" "PeakPos" 1.5 "PeakVal" 1e16
	"ValueAtDepth" 3e14 "Depth" 0.4 "Gauss" "Factor" 0.5)
(sdedr:define-gaussian-profile "Gauss.NW_2"
	"PhosphorusActiveConcentration" "PeakPos" 1.5 "PeakVal" 1e16
	"ValueAtDepth" 3e14 "Depth" 0.4 "Gauss" "Factor" 0.5)
(sdedr:define-gaussian-profile "Gauss.NP"
	"PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 5e21
	"ValueAtDepth" 3e19 "Depth" 0.7 "Gauss" "Factor" 0.2)
(sdedr:define-gaussian-profile "Gauss.PP"
	"BoronActiveConcentration" "PeakPos" 0 "PeakVal" 5e21
	"ValueAtDepth" 3e19 "Depth" 0.7 "Gauss" "Factor" 0.3)

; Set analytical doping profiles
(sdedr:define-analytical-profile-placement "PlaceAP.DNW"
	"Gauss.DNW" "BaseLine.DNW" "Positive" "Replace" "Eval")
(sdedr:define-analytical-profile-placement "PlaceAP.NW_1"
	"Gauss.NW_1" "BaseLine.NW_1" "Positive" "NoReplace" "Eval")
(sdedr:define-analytical-profile-placement "PlaceAP.NW_2"
	"Gauss.NW_2" "BaseLine.NW_2" "Positive" "NoReplace" "Eval")
(sdedr:define-analytical-profile-placement "PlaceAP.NP"
	"Gauss.NP" "BaseLine.NP" "Positive" "NoReplace" "Eval")
(sdedr:define-analytical-profile-placement "PlaceAP.PP"
	"Gauss.PP" "BaseLine.PP" "Positive" "NoReplace" "Eval")

; Define meshing strategy
(sdedr:define-refinement-size "RefDef.Mat.All" 10 10 10 0.5 0.5 0.5)
(sdedr:define-refinement-placement "Ref.Mat.All" "RefDef.Mat.All" (list "material" "Silicon" "material" "PolySi"))
(sdedr:define-refinement-function "RefDef.Mat.All" "DopingConcentration" "MaxTransDiff" 0.05)
(sdedr:define-refinement-function "RefDef.Mat.All" "MaxLenInt" "Silicon" "PolySi" 1 1.4)
(sdedr:define-refinement-function "RefDef.Mat.All" "MaxLenInt" "Silicon" "Silicon" 1 1.4)

; Mesh the device
(sde:build-mesh "n1")

(system:command "svisual n1_msh.tdr &")

