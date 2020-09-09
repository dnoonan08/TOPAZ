#! /bin/bash
#
#
#

if [ "$Collider" == "11" ] ; then
  CollTag="LHC7"
fi
if [ "$Collider" == "12" ] ; then
  CollTag="LHC8"
fi
if [ "$Collider" == "13" ] ; then
  CollTag="LHC13"
fi
if [ "$Collider" == "15" ] ; then
  CollTag="LHC100"
fi
if [ "$Collider" == "6" ] ; then
  CollTag="ee500"
fi


export myExec=TOPAZ

#
#
# general setup
. /cvmfs/sft.cern.ch/lcg/external/gcc/4.7.2/x86_64-slc6-gcc47-opt/setup.sh

export myAFSpath=/afs/cern.ch/user/d/dnoonan/work/TTGamma_TOPAZ_Sep2020/TOPAZ

export LD_LIBRARY_PATH=/afs/cern.ch/user/m/maschulz/lib/yaml/lib/:/cvmfs/cms.cern.ch/slc6_amd64_gcc481/external/lhapdf/6.1.5/lib/:${LD_LIBRARY_PATH}

export LHAPATH=/cvmfs/cms.cern.ch/slc6_amd64_gcc481/external/lhapdf/6.1.5/share/LHAPDF/:${LHAPATH}
export LHAPDF_DATA_PATH=/cvmfs/cms.cern.ch/slc6_amd64_gcc481/external/lhapdf/6.1.5/share/LHAPDF/:${LHAPDF_DATA_PATH}


echo "runTOPAZ: Copying executable, grids and pdfs to cluster"
cp ${myAFSpath}/${myExec} .
mkdir ./PDFS/
cp ${myAFSpath}/PDFS/* ./PDFS/
cp ${myAFSpath}/grids/*.grid ./

echo "runTOPAZ: Running TOPAZ. DATE = `date`"
if [ "$NLOParam" == "1" ]
then
    ./${myExec} MTop=$MTop TTBZdebug=$TTBZdebug ObsSet=$ObsSet Collider=$Collider Process=$Process Correction=$Correction NLOParam=$NLOParam PDFSet=$PDFSet ZDK=$ZDK TopDK=$TopDK VegasIt0=$VegasIt0 VegasNc0=$VegasNc0 VegasIt1=$VegasIt1 VegasNc1=$VegasNc1 MuRen=$Mu MuFac=$Mu DynMuMult=$DynMuMult FileTag=$FileTag VegasSeed=$VegasSeed DipAlpha=$DipAlpha DipAlpha2=$DipAlpha2 DKAlpha=$DKAlpha GridIO=$GridIO GridFile=$GridFile RelDelF1A=$RelDelF1A RelDelF1V=$RelDelF1V RelDelF2A=$RelDelF2A RelDelF2V=$RelDelF2V DataDir=$OutputDir
else
    ./${myExec} MTop=$MTop TTBZdebug=$TTBZdebug ObsSet=$ObsSet Collider=$Collider Process=$Process Correction=$Correction NLOParam=$NLOParam PDFSet=$PDFSet ZDK=$ZDK TopDK=$TopDK VegasIt0=$VegasIt0 VegasNc0=$VegasNc0 VegasIt1=$VegasIt1 VegasNc1=$VegasNc1 MuRen=$Mu MuFac=$Mu FileTag=$FileTag VegasSeed=$VegasSeed DipAlpha=$DipAlpha DipAlpha2=$DipAlpha2 DKAlpha=$DKAlpha GridIO=$GridIO GridFile=$GridFile RelDelF1A=$RelDelF1A RelDelF1V=$RelDelF1V RelDelF2A=$RelDelF2A RelDelF2V=$RelDelF2V DataDir=$OutputDir
fi


echo "runTOPAZ: Done. DATE = `date`"


# ACTIVATE THIS ONLY WHEN GRIDS ARE GENERATED
# cp ./${GridFile} ${myAFSpath}/

