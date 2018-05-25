! compile: ifort -o ReadCSV ReadCSV.f90
PROGRAM ReadGnuplotCSV
use ifport
implicit none
character :: LOfile*(100),infile*(100),outfile*(100),Cphiq_str*(20),Cphiu_str*(20) 
real(8) :: BinVal(1:200),c_grest(1:200),c_gwsq(1:200),c_gasq(1:200),c_gvsq(1:200),c_ga(1:200),c_gv(1:200),LO(1:200)
real(8) :: grest,ga,gv,gw,gasq,gvsq,gwsq,Cphiq,Cphiu,NewBinVal,NewSigma=0d0,LOSigma=0d0,NLOSigma=0d0
integer :: NumBins0=1,i
character(len=*),parameter :: fmtIn  = "(E10.4,1X,E15.8,2X,E15.8,2X,E15.8,2X,E15.8,2X,E15.8,2X,E15.8)"
character(len=*),parameter :: fmtOut = "(I2,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"
real(8),parameter :: sw2 = 0.2228972d0
real(8),parameter :: cw2 = 1d0-sw2
real(8),parameter :: gv_SM = (0.5d0-4d0*sw2/3d0)/2d0/sqrt(sw2*cw2)
real(8),parameter :: ga_SM = 0.5d0/2d0/sqrt(sw2*cw2)
real(8),parameter :: gw_SM = 0.5d0/sqrt(2d0*sw2)
real(8),parameter :: vev=246d0,Lambda=1000d0
real(8),parameter :: BinSize = 50d0

  call GetArg(1,LOfile)
  call GetArg(2,infile)
  call GetArg(3,Cphiq_str)
  call GetArg(4,Cphiu_str)
  call GetArg(5,outfile)


  open(unit=112,file=trim(LOfile),form='formatted',access='sequential')  ! open LO file
  do while(.not.eof(112))
     read(unit=112,fmt="(E9.4,2X,E15.8)") BinVal(NumBins0),LO(NumBins0)     
     LOSigma = LOSigma + LO(NumBins0)
     NumBins0=NumBins0 + 1         
  enddo
  close(112)
  LOSigma = LOSigma*BinSize
  NumBins0 = 1
  
  
  open(unit=112,file=trim(infile),form='formatted',access='sequential')  ! open coupling input file
  do while(.not.eof(112))
     read(unit=112,fmt=fmtIn) BinVal(NumBins0),c_grest(NumBins0),c_gwsq(NumBins0),c_gasq(NumBins0),c_gvsq(NumBins0),c_ga(NumBins0),c_gv(NumBins0)
!      write(*,fmt="(E10.4,2X,E15.8,2X,E15.8,2X,E15.8,2X,E15.8,2X,E15.8,2X,E15.8)") BinVal(NumBins0),grest(NumBins0),gwsq(NumBins0),gasq(NumBins0),gvsq(NumBins0),ga(NumBins0),gv(NumBins0)
     NumBins0=NumBins0 + 1
  enddo
  close(112)
  
  
  read(Cphiq_str,"(F6.2)") Cphiq
  read(Cphiu_str,"(F6.2)") Cphiu
  
  gv = gv_SM + vev**2/Lambda**2 * ( Cphiq - 0.5d0*Cphiu )
  ga = ga_SM + vev**2/Lambda**2 * ( Cphiq + 0.5d0*Cphiu )
  gw = gw_SM + vev**2/Lambda**2 * ( 0.5d0*Cphiq )
   
  print *, ""
  print *, "---- input parameters ---"
  print *,"sw2=",sw2
  print *,"gv_SM=",gv_SM
  print *,"ga_SM=",ga_SM
  print *,"gw_SM=",gw_SM
  print *,""
  print *, "vev=",vev
  print *, "Lambda=",Lambda
  print *, "C_phiq^(3,33)=",Cphiq
  print *, "C_phiu^(33)  =",Cphiu  
  print *, ""
  print *, "(v/L)^2*C_phiq^(3,33)=",Cphiq*(vev/Lambda)**2
  print *, "(v/L)^2*C_phiu^(33)  =",Cphiu*(vev/Lambda)**2  
  print *, ""
  print *, "gv=",gv,"   (",(gv/gv_SM-1d0)*100d0,"%)"
  print *, "ga=",ga,"   (",(ga/ga_SM-1d0)*100d0,"%)"
  print *, "gw=",gw,"   (",(gw/gw_SM-1d0)*100d0,"%)"
  print *, "-------------------------"
  
  
! normalizing to SM
  gv = gv/gv_SM
  ga = ga/ga_SM
  gw = gw/gw_SM  
  grest = 1d0
  gasq = ga**2
  gvsq = gv**2
  gwsq = gw**2  
  
  open(unit=112,file=trim(outfile),form='formatted',access='sequential')  ! open output file
  do i=1,NumBins0-1
  
     NewBinVal = grest * c_grest(i)   & 
               + gwsq  * c_gwsq(i)    &
               + gasq  * c_gasq(i)    &
               + gvsq  * c_gvsq(i)    &
               + ga    * c_ga(i)      &
               + gv    * c_gv(i)      &
               + LO(i)                ! adding LO here
     write(unit=112,fmt=fmtOut) 1," ", BinVal(i)," ", NewBinVal," ", 0d0," ", 1," "
     NewSigma = NewSigma + NewBinVal     
  enddo
  close(112)
  NLOSigma = NewSigma*BinSize
 
  print *, ""
  print *, "---- results ---"  
  print *, "Total  LO cross section    ", LOSigma,"fb"
  print *, "Total NLO cross section    ", NLOSigma,"fb"
  print *, "Electroweak correction     ", NLOSigma-LOSigma,"fb <-->",(NLOSigma/LOSigma-1d0)*100d0," %"


  if( NLOSigma.lt.0d0 .or. dabs((NLOSigma/LOSigma-1d0)*100d0).gt.100d0 ) then
     print *, "WARNING"
     pause
  endif
  

END PROGRAM 

