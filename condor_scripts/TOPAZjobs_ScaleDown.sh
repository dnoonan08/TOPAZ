#!/bin/bash

pwd
ls

obsNumber=$1

RunWhat=$2

jobNumber=$(( $3 ))

echo $jobNumber

export RunDir=$PWD

export ObsSet=$obsNumber

if [ "$ObsSet" == "23" ] ; then
   export TopDK=1
fi
if [ "$ObsSet" == "24" ] ; then
   export TopDK=4
fi
if [ "$ObsSet" == "25" ] ; then
   export TopDK=2
fi
export ZDK=0

#
# adjust CollTag in runTOPAZ.sh
export Collider=13
export PDFSet=2
#
export Mu=0.8625

export DynMuMult=0.5

export MTop=1.725

export OutputDir="/afs/cern.ch/work/d/dnoonan/TTGamma_TOPAZ_Sep2020/TOPAZ/TTGammaScaleDown/"

#
#
#
export VegasSeed=19
export DipAlpha=00000 DipAlpha2=1 DKAlpha=111
export FileTag="."
export GridFile="."
export HelSamp=F GridIO=0
export TTBZdebug=0
export RelDelF1A=+0.00 
export RelDelF1V=+0.00
export RelDelF2A=+0.00
export RelDelF2V=+0.00
#
#
#
# ---------------------------------------------
  echo Ready to run the job: $RunWhat ?
# ---------------------------------------------



if [ "$RunWhat" == "LOLO" ] ; then
    export WALLTIME=03:00
    export Correction=0 NLOParam=1

    case "$jobNumber" in
	0)
	    export Process=20 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000
	    ./runTOPAZ.sh
	    ;;
	1)
  	    export Process=21 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000
	    ./runTOPAZ.sh
	    ;;
	2)
	    export Process=22 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000
	    ./runTOPAZ.sh
	    ;;
	3)
	    export Process=23 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000
	    ./runTOPAZ.sh
	    ;;
    esac
fi


if [ "$RunWhat" == "LO" ] ; then
    export WALLTIME=03:00
    export Correction=0 NLOParam=2


    case "$jobNumber" in
	0)
	    export Process=20 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000
	    ./runTOPAZ.sh
	    ;;
	1)
	    export Process=21 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000
	    ./runTOPAZ.sh
	    ;;
        2)
	    export Process=22 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000
	    ./runTOPAZ.sh
	    ;;
	3)
	    export Process=23 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000
	    ./runTOPAZ.sh
	    ;;
	esac
fi

if [ "$RunWhat" == "VI" ] ; then
    export WALLTIME1=106:00
    export WALLTIME2=106:00
    export Correction=1 NLOParam=2 GridIO=2


    case "$jobNumber" in
	0)
    	    export VegasSeed=20
	    export Process=20 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	1)
    	    export VegasSeed=20
	    export Process=21 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=100000
	    ./runTOPAZ.sh
	    ;;
        2)
    	    export VegasSeed=20
	    export Process=22 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	3)
    	    export VegasSeed=20
	    export Process=23 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=100000
	    ./runTOPAZ.sh
	    ;;
	4)
	    export VegasSeed=40
	    export Process=20 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	5)
	    export VegasSeed=40
	    export Process=21 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=100000
	    ./runTOPAZ.sh
	    ;;
	6)
	    export VegasSeed=40
	    export Process=22 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	7)
	    export VegasSeed=40
	    export Process=23 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=100000
	    ./runTOPAZ.sh
	    ;;
	8)
	    export VegasSeed=60
	    export Process=20 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	9)
	    export VegasSeed=60
	    export Process=21 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=100000
	    ./runTOPAZ.sh
	    ;;
	10)
	    export VegasSeed=60
	    export Process=22 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	11)
	    export VegasSeed=60
	    export Process=23 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=100000
	    ./runTOPAZ.sh
	    ;;
	12)
	    export VegasSeed=80
	    export Process=20 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	13)
	    export VegasSeed=80
	    export Process=21 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=100000
	    ./runTOPAZ.sh
	    ;;
	14)
	    export VegasSeed=80
	    export Process=22 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	15)
	    export VegasSeed=80
	    export Process=23 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=100000
	    ./runTOPAZ.sh
	    ;;
	16)
	    export VegasSeed=25
	    export Process=20 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	17)
	    export VegasSeed=25
	    export Process=22 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	18)
	    export VegasSeed=45
	    export Process=20 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	19)
	    export VegasSeed=45
	    export Process=22 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	20)
	    export VegasSeed=65
	    export Process=20 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	21)
	    export VegasSeed=65
	    export Process=22 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	22)
	    export VegasSeed=85
	    export Process=20 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
	23)
	    export VegasSeed=85
	    export Process=22 VegasIt0=3 VegasIt1=1 VegasNc0=5000000 VegasNc1=50000
	    ./runTOPAZ.sh
	    ;;
    esac


    export VegasSeed=19
    export GridIO=0
    
fi




# ---------------------------------------------




if [ "$RunWhat" == "RE" ] ; then
    export WALLTIME=300:00
    export Correction=2 NLOParam=2

    case "$jobNumber" in
	0)
	    export Process=24 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	1) 
	    export Process=25 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	2) 
	    export Process=26 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	3) 
	    export Process=27 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	4) 
	    export Process=28 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	5) 
	    export Process=29 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	6) 
	    export Process=30 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=10000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	7) 
	    export Process=31 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	8) 
	    export Process=24 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	9) 
	    export Process=25 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	10)
	    export Process=26 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	11)
	    export Process=27 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	12)
	    export Process=28 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	13)
	    export Process=29 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	14)
	    export Process=30 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=10000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	15)
	    export Process=31 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	16)   
	    export Process=24 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	17)   
	    export Process=25 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	18)
	    export Process=26 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	19)
	    export Process=27 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	20)
	    export Process=28 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	21)
	    export Process=29 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	22)
	    export Process=30 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=10000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	23)
	    export Process=31 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	24)
	    export Process=24 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	25)
	    export Process=25 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	26)
	    export Process=26 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	27)
	    export Process=27 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	28)
	    export Process=28 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	29)
	    export Process=29 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	30)
	    export Process=30 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=10000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;
	31)
	    export Process=31 VegasIt0=3 VegasIt1=5 VegasNc0=10000000 VegasNc1=20000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220" VegasSeed=65
	    ./runTOPAZ.sh
	    ;;

    esac

    export VegasSeed=19
    
fi



# ---------------------------------------------





if [ "$RunWhat" == "ID" ] ; then
    export WALLTIME=48:00
    export Correction=3 NLOParam=2

    case "$jobNumber" in
	0)
	    export Process=24 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	1)
	    export Process=25 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	2)
	    export Process=26 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	3)
	    export Process=27 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	4)
	    export Process=28 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	5)
	    export Process=29 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	6)
	    export Process=30 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	7)
	    export Process=31 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=11100 DipAlpha2=1 FileTag="1110"
	    ./runTOPAZ.sh
	    ;;
	8)
	    export Process=24 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	9)
	    export Process=25 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	10)
	    export Process=26 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	11)
	    export Process=27 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	12)
	    export Process=28 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	13)
	    export Process=29 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	14)
	    export Process=30 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
	15)
	    export Process=31 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=10000000 DipAlpha=22200 DipAlpha2=5 FileTag="2220"
	    ./runTOPAZ.sh
	    ;;
    esac

fi



# ---------------------------------------------




if [ "$RunWhat" == "DKVI" ] ; then
    export WALLTIME=48:00
    export Correction=4 NLOParam=2

    case "$jobNumber" in
	0)
	    export Process=20 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1"
	    ./runTOPAZ.sh
	    ;;
	1)
	    export Process=21 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1"
	    ./runTOPAZ.sh
	    ;;
	2)
	    export Process=22 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1"
	    ./runTOPAZ.sh
	    ;;
	3)
	    export Process=23 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1"
	    ./runTOPAZ.sh
	    ;;
	4)
	    export Process=20 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2"
	    ./runTOPAZ.sh
	    ;;
	5)
	    export Process=21 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2"
	    ./runTOPAZ.sh
	    ;;
	6)
	    export Process=22 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2"
	    ./runTOPAZ.sh
	    ;;
	7)
	    export Process=23 VegasIt0=3 VegasIt1=5 VegasNc0=5000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2"
	    ./runTOPAZ.sh
	    ;;
    esac
fi


# ---------------------------------------------


if [ "$RunWhat" == "DKRE" ] ; then
    export WALLTIME=48:00
    export Correction=5 NLOParam=2

    export

    case "$jobNumber" in
        0)
	    export Process=20 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1" VegasSeed=19
	    ./runTOPAZ.sh
	    ;;
	1)
	    export Process=21 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1" VegasSeed=19
	    ./runTOPAZ.sh
	    ;;
	2)
	    export Process=22 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1" VegasSeed=19
	    ./runTOPAZ.sh
	    ;;
	3)
	    export Process=23 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1" VegasSeed=19
	    ./runTOPAZ.sh
	    ;;
	4)
	    export Process=20 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2" VegasSeed=19
	    ./runTOPAZ.sh
	    ;;
	5)
	    export Process=21 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2" VegasSeed=19
	    ./runTOPAZ.sh
	    ;;
	6)
	    export Process=22 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2" VegasSeed=19
	    ./runTOPAZ.sh
	    ;;
	7)
	    export Process=23 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2" VegasSeed=19
	    ./runTOPAZ.sh
	    ;;
	8)
	    export Process=20 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1" VegasSeed=40
	    ./runTOPAZ.sh
	    ;;
	9)
	    export Process=21 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1" VegasSeed=40
	    ./runTOPAZ.sh
	    ;;
	10)
	    export Process=22 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1" VegasSeed=40
	    ./runTOPAZ.sh
	    ;;
	11)
	    export Process=23 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=555 FileTag="1" VegasSeed=40
	    ./runTOPAZ.sh
	    ;;
	12)
	    export Process=20 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2" VegasSeed=40
	    ./runTOPAZ.sh
	    ;;
	13)
	    export Process=21 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2" VegasSeed=40
	    ./runTOPAZ.sh
	    ;;
	14)
	    export Process=22 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2" VegasSeed=40
	    ./runTOPAZ.sh
	    ;;
	15)
	    export Process=23 VegasIt0=3 VegasIt1=5 VegasNc0=2000000 VegasNc1=5000000 DipAlpha=00001 DKAlpha=111 FileTag="2" VegasSeed=40
	    ./runTOPAZ.sh
	    ;;
    esac
    export VegasSeed=19
    
fi

echo $PWD
ls
