
File{
	Grid		= "n1_msh.tdr"
	Plot		= "n2_des.tdr"
	Current		= "n2_des.plt"
	Output		= "n2_des.log"
}

Electrode{
	{ Name="anode"		Voltage=0.0 }
	{ Name="cathode"	Voltage=0.0 }
	{ Name="bulk"	  	Voltage=0.0 }
}

Physics{
	Fermi
	EffectiveIntrinsicDensity( BandGapNarrowing(OldSlotboom) )
	Mobility(
		DopingDep
		eHighFieldsaturation( GradQuasiFermi )
		hHighFieldsaturation( GradQuasiFermi )
		Enormal
	)
	Recombination(
		SRH( DopingDependence )
		Avalanche( ElectricField )
	)
}

Plot{
	*--Density and Currents, etc
	eDensity hDensity
	TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
	eMobility/Element hMobility/Element
	eVelocity hVelocity
	eQuasiFermi hQuasiFermi

	*--Temperature 
	eTemperature hTemperature Temperature

	*--Fields and charges
	ElectricField/Vector Potential SpaceCharge

	*--Doping Profiles
	Doping DonorConcentration AcceptorConcentration

	*--Generation/Recombination
	SRH Band2Band Auger
	ImpactIonization eImpactIonization hImpactIonization

	*--Driving forces
	eGradQuasiFermi/Vector hGradQuasiFermi/Vector
	eEparallel hEparallel eENormal hENormal

	*--Band structure/Composition
	BandGap 
	BandGapNarrowing
	Affinity
	ConductionBand ValenceBand
	eQuantumPotential hQuantumPotential
}

Math{
	RefDens_eGradQuasiFermi_ElectricField_HFS = 1e12
	RefDens_hGradQuasiFermi_ElectricField_HFS = 1e12
	
	Extrapolate
	ExtendedPrecision
	NumberOfThreads=Maximum
	
	Derivatives
	Avalderivatives
	
	RelErrControl
	Digits=4
	
	Iterations=50
	NotDamped=100
	
	BreakCriteria{ Current(Contact="cathode" AbsVal=1e-6) }
}

Solve{
	NewCurrentPrefix="init_"
	Coupled(Iterations=100){ Poisson eQuantumPotential }
	Coupled { Poisson Electron Hole eQuantumPotential }
	
	Save ( FilePrefix = "n2_init" )
	
	NewCurrentPrefix="IV_"
	Quasistationary(
		InitialStep=0.1e-3 Increment=2 Decrement=1 MinStep=1e-15 MaxStep=0.5
		Goal { Name="cathode" Voltage=40 }
	) { Coupled { Poisson Electron Hole eQuantumPotential } 
		*Plot at a set of given values of the t variable
		Plot( -Loadable Fileprefix="n2_inter_" NoOverWrite Time= (0.1; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9; 1.0) )
		*I-V calculated at regular intervals
		CurrentPlot(Time=(Range=(0 1) Intervals=200))
	}
	

}

