PROGRAM summer
use ifport
implicit none
integer :: NumArgs,NArg,op,iHisto,nrebin,NumEvents,NumPseudoExp,Lumi,iBin
character :: filename_in*(80),filename_in2*(80),filename_out*(50),operation*(10),factor_str*(20),iBin_str*(10),iVal_str*(20)
character :: iHisto_str*(5),nrebin_str*(5),NumEvents_str*(6),Lumi_str*(6),NumPseudoExp_str*(9),DeltaN_str*(5)
character :: dVcoupl_str*(10),dAcoupl_str*(10)
real(8) :: DeltaN,iVal
real(8):: factor =1d10,dVcoupl(1:6)=1d10,dAcoupl(1:6)=1d10,VcouplSM,AcouplSM
logical :: silent=.false.


! get number of arguments
  NumArgs = NArgs()-1

! get mode of operation
  call GetArg(1,operation)
  if( trim(operation).eq.'add' ) then
      op=1
  elseif( trim(operation).eq.'addsilent' ) then
      op=1
      silent=.true.
  elseif( trim(operation).eq.'avg' ) then
      op=2
  elseif( trim(operation).eq.'sumbins' ) then
      op=3
  elseif( trim(operation).eq.'mul' ) then
      op=4
  elseif( trim(operation).eq.'quo' ) then
      op=5
  elseif( trim(operation).eq.'rebin' ) then
      op=6
  elseif( trim(operation).eq.'readlhe' ) then
      op=7
  elseif( trim(operation).eq.'likelihood' ) then
     op=8
  elseif( trim(operation).eq.'ttbzcoupl' ) then
     op=9
  elseif( trim(operation) .eq. 'sum2dbins') then
     op=10
  elseif( trim(operation) .eq. 'sumslice') then
     op=11
  else

      write(*,*) "operation not available (add,avg,sumbins,mul,quo,rebin,readlhe,likelihood)",trim(operation)
      stop
  endif

! check for invalid arguments
  if( (op.lt.3 .and. NumArgs.le.3) .or. (op.eq.3 .and. NumArgs.ne.3) .or. (op.eq.4 .and. NumArgs.ne.4) .or. (op.eq.5 .and. NumArgs.le.3)  & 
                                   .or. (op.eq.6 .and. NumArgs.ne.5) .or. (op.eq.7 .and. NumArgs.ne.3) .or. (op.eq.8 .and. NumArgs.ne.8)  &
                                   .or. (op.eq.9 .and. NumArgs.ne.21).or. (op .eq. 10 .and. NumArgs .ne. 3) .or. NumArgs.gt.49 ) then
    print *, "invalid number of arguments",op,NumArgs
    stop
  endif


  if( op.eq.1 ) then
      call GetArg(NumArgs,filename_out)
      open(unit=10,file=trim(filename_out),form='formatted',access='sequential',status='replace') ! open output file (last one in arguments list)
      print *, "adding histograms"
      do NArg=2,NumArgs-1  ! open input files
        call GetArg(NArg,filename_in)
        open(unit=10+NArg,file=trim(filename_in),form='formatted',access='sequential')
      enddo
      call add_avg(NumArgs,op,silent)
      print *, "output written to "//trim(filename_out)

  elseif( op.eq.2 ) then
      call GetArg(NumArgs,filename_out)
      open(unit=10,file=trim(filename_out),form='formatted',access='sequential',status='replace') ! open output file (last one in arguments list)
      print *, "calculating mean value of histograms"
      do NArg=2,NumArgs-1  ! open input files
        call GetArg(NArg,filename_in)
        open(unit=10+NArg,file=trim(filename_in),form='formatted',access='sequential')
      enddo
      call add_avg(NumArgs,op,silent)
      print *, "output written to "//trim(filename_out)

  elseif( op.eq.3 ) then
      print *, "summing up histogram bins"
      call GetArg(2,filename_in)
      open(unit=12,file=trim(filename_in),form='formatted',access='sequential')  ! open input file
      call GetArg(3,iHisto_str)
      read(iHisto_str,"(I2)") iHisto
      call sum_histobins(NumArgs,iHisto)

  elseif( op.eq.4 ) then
      call GetArg(NumArgs,filename_out)
      open(unit=10,file=trim(filename_out),form='formatted',access='sequential',status='replace') ! open output file (last one in arguments list)
      call GetArg(3,filename_in)
      open(unit=12,file=trim(filename_in),form='formatted',access='sequential')  ! open input file
      call GetArg(2,factor_str)
      read(factor_str,"(F8.6)") factor
      print *, "multiply histogram with ",factor
      call multiply_histo(NumArgs,factor)
      print *, "output written to "//trim(filename_out)

  elseif( op.eq.5 ) then
      call GetArg(NumArgs,filename_out)
      open(unit=10,file=trim(filename_out),form='formatted',access='sequential',status='replace') ! open output file (last one in arguments list)
      print *, "dividing histograms"
      do NArg=2,NumArgs-1  ! open input files
        call GetArg(NArg,filename_in)
        open(unit=10+NArg,file=trim(filename_in),form='formatted',access='sequential')
      enddo
      call divide(NumArgs,op)
      print *, "output written to "//trim(filename_out)

  elseif( op.eq.6 ) then! SYNTAX: summer rebin infile outfile NHi nrebin
      print *, "rebinning"
      call GetArg(2,filename_in)
      open(unit=12,file=trim(filename_in),form='formatted',access='sequential')  ! open input file
      call GetArg(3,filename_out)
      open(unit=13,file=trim(filename_out),form='formatted',access='sequential')  ! open output file
      call GetArg(4,iHisto_str)
      read(iHisto_str,"(I2)") iHisto
      call GetArg(5,nrebin_str)
      read(nrebin_str,"(I2)") nrebin
!     chose one of the two subroutines, see description below      
      call rebinning1(iHisto,nrebin)   
!       call rebinning2(iHisto)

  elseif( op.eq.7 ) then
      print *, "reading lhe event file"
      call GetArg(2,filename_in)
      open(unit=12,file=trim(filename_in),form='formatted',access='sequential')  ! open input file
      call GetArg(3,filename_out)
      open(unit=13,file=trim(filename_out),form='formatted',access='sequential')  ! open output file
      call readlhe()

  elseif( op.eq.8 ) then! SYNTAX: summer likelihood infile1 infile2 Histo Events PseudoEvents DeltaN outfile
      call GetArg(2,filename_in)
      open(unit=12,file=trim(filename_in),form='formatted',access='sequential')  ! open input file1
      call GetArg(3,filename_in2)
      open(unit=13,file=trim(filename_in2),form='formatted',access='sequential')  ! open input file2
      print *, 'Using input files:', filename_in, filename_in2
      call GetArg(4,iHisto_str)
      read(iHisto_str,"(I2)") iHisto   

!       call GetArg(5,NumEvents_str)
!       read(NumEvents_str,"(I6)") NumEvents
      call GetArg(5,Lumi_str)
      read(Lumi_str,"(I6)") Lumi

      call GetArg(6,NumPseudoExp_str)
      call GetArg(7,DeltaN_str)
      read(DeltaN_str,"(F9.6)") DeltaN
!      DeltaN=1.3d0
      read(NumPseudoExp_str,"(I9)") NumPseudoExp
      call GetArg(8,filename_out)
      open(unit=14,file=trim(filename_out),form='formatted',access='sequential')  ! open output file
      write(*,*) ""
!       write(*,"(A,I2,A,I6,A,I9,A)") "reading histogram ",iHisto," for likelihood analysis with ",NumEvents," events using ",NumPseudoExp," pseudo-experiments"
!      write(*,"(A,I2,A,I6,A,I9,A)") "reading histogram ",iHisto," for likelihood analysis with Lumi=",Lumi,"fb^-1 using ",NumPseudoExp," pseudo-experiments"
      write(*,"(A,I2,A,I6,A,I9,A,F9.6)") "reading histogram ",iHisto," for likelihood analysis with Lumi=",Lumi,"fb^-1 using ",NumPseudoExp," pseudo-experiments, and scale uncertainty", DeltaN
      write(14,"(A,I2,A,I6,A,I9,A,F9.6)") "# reading histogram ",iHisto," for likelihood analysis with Lumi=",Lumi,"fb^-1 using ",NumPseudoExp," pseudo-experiments, and scale uncertainty", DeltaN
      write(*,*) "Writing output to file : ", filename_out
      write(*,*) ""
!       call likelihood(iHisto,NumEvents,NumPseudoExp)
      call likelihood(iHisto,Lumi,NumPseudoExp,DeltaN)

  elseif( op.eq.9 ) then! SYNTAX: NHi dV1 dA1 file1 ... dV6 dA6 file6 outfilenametag
      VcouplSM = 0.24364d0
      AcouplSM = 0.60069d0
      write(*,"(2X,A,F8.5,A,F8.5)") "Fixed SM t-tb-Z couplings V=",VcouplSM," A=",AcouplSM
      call GetArg(2,iHisto_str)
      read(iHisto_str,"(I2)") iHisto   
      do NArg=3,NumArgs-1,3
            call GetArg(NArg,dVcoupl_str)
            read(dVcoupl_str,"(F5.2)") dVcoupl(NArg/3)
            call GetArg(NArg+1,dAcoupl_str)
            read(dAcoupl_str,"(F5.2)") dAcoupl(NArg/3)
            call GetArg(NArg+2,filename_in)
            open(unit=10+(NArg/3),file=trim(filename_in),form='formatted',access='sequential')! units=11,...,16
            write(*,"(2X,A,I1,X,A,A,F6.3,A,F6.3)") "Reading file ",(NArg/3),trim(filename_in), " with dV=",dVcoupl(NArg/3)," dA=",dAcoupl(NArg/3)
      enddo
      call GetArg(NumArgs,filename_out)
!       open(unit=10,file=trim(filename_out),form='formatted',access='sequential',status='replace') ! open output file (last one in arguments list)
      call ttbzcoupl(iHisto,VcouplSM,AcouplSM,dVcoupl,dAcoupl,filename_out)
      close(11);close(12);close(13);close(14);close(15);close(16)
  elseif( op.eq.10 ) then
      print *, "summing up two-dim histogram bins"
      call GetArg(2,filename_in)
      open(unit=12,file=trim(filename_in),form='formatted',access='sequential')  ! open input file
      call GetArg(3,iHisto_str)
      read(iHisto_str,"(I2)") iHisto
      call sum_2Dhistobins(NumArgs,iHisto)
   elseif( op .eq. 11 ) then
! syntax: FILENAME NHisto NBin BinVal
      print *,"summing up a slice of a 2-d histogram"
      call GetArg(2,filename_in)
      open(unit=12,file=trim(filename_in),form='formatted',access='sequential')  ! open input file
      call GetArg(3,iHisto_str)
      read(iHisto_str,"(I2)") iHisto
      call GetArg(4,iBin_str)
      read(iBin_str,"(I2)") iBin
      call GetArg(5,iVal_str) 
      read(iVal_str,"(F5.2)") iVal
      call sumslice(NumArgs,iHisto,iBin,iVal)

  endif


! close all files
  close(10)


CONTAINS 




SUBROUTINE add_avg(NumArgs,op,silent)
implicit none
integer :: NArg,row,NumArgs,op
character(len=*),parameter :: fmt1 = "(I2,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"
integer,parameter :: MaxFiles=50
integer :: NHisto(1:MaxFiles)=-999999,Hits(1:MaxFiles)=-999999
real(8) :: BinVal(1:MaxFiles)=-1d-99,Value(1:MaxFiles)=-1d-99,Error(1:MaxFiles)=-1d-99
real(8) :: SumValue,SumError,n
integer :: SumHits
character :: dummy*(1)
logical :: silent

  do while(.not.eof(12))  ! loop over all rows
    SumValue = 0d0
    SumError = 0d0
    Sumhits  = 0

    do NArg=1,NumArgs-2  ! loop over all input files
      read(unit=11+NArg,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=11+NArg) ! go to the beginning of the line
      read(unit=11+NArg,fmt=fmt1) NHisto(NArg),dummy,BinVal(NArg),dummy,Value(NArg),dummy,Error(NArg),dummy,Hits(NArg),dummy
      n = dble(NumArgs-2)
      if( op.eq.1 ) then
          SumValue = SumValue + Value(NArg)
          SumError = SumError + Error(NArg)**2
          Sumhits  = Sumhits + Hits(NArg)
      elseif( op.eq.2 ) then
          SumValue = SumValue + Value(NArg) / n
          Sumhits  = Sumhits + Hits(NArg)
      endif
    enddo

    if( op.eq.2 ) then
        do NArg=1,NumArgs-2
            SumError = SumError + (SumValue-Value(NArg))**2/(n-1d0)
        enddo
    endif
    SumError = dsqrt(SumError)

    if(dummy(1:1).eq."#") cycle
    if(.not. all(NHisto(1:NumArgs-2).eq.NHisto(1))) print *, "Error: unequal values for NHisto in row ",row
    if(.not. all(BinVal(1:NumArgs-2).eq.BinVal(1))) print *, "Error: unequal values for BinVal in row ",row


    if(abs(SumHits).gt.99999999) SumHits=99999999
    if( .not.silent ) write(* ,fmt1) NHisto(1),"|",BinVal(1),"|",SumValue,"|",SumError,"|",SumHits,"|"
    write(10,fmt1) NHisto(1),"|",BinVal(1),"|",SumValue,"|",SumError,"|",SumHits,"|"
  enddo

END SUBROUTINE




SUBROUTINE divide(NumArgs,op)
implicit none
integer :: NArg,row,NumArgs,op
character(len=*),parameter :: fmt1 = "(I2,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"
integer,parameter :: MaxFiles=50
integer :: NHisto(1:MaxFiles)=-999999,Hits(1:MaxFiles)=-999999
real(8) :: BinVal(1:MaxFiles)=-1d-99,Value(1:MaxFiles)=-1d-99,Error(1:MaxFiles)=-1d-99
real(8) :: SumValue,SumError,n
integer :: SumHits
character :: dummy*(1)


  do while(.not.eof(12))  ! loop over all rows
    SumValue = 0d0
    SumError = 0d0
    Sumhits  = 0

    do NArg=1,NumArgs-2  ! loop over all input files
      read(unit=11+NArg,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=11+NArg) ! go to the beginning of the line
      read(unit=11+NArg,fmt=fmt1) NHisto(NArg),dummy,BinVal(NArg),dummy,Value(NArg),dummy,Error(NArg),dummy,Hits(NArg),dummy
      n = dble(NumArgs-2)
    enddo


    if(dummy(1:1).eq."#") cycle
    if(.not. all(NHisto(1:NumArgs-2).eq.NHisto(1))) print *, "Error: unequal values for NHisto in row ",row
    if(.not. all(BinVal(1:NumArgs-2).eq.BinVal(1))) print *, "Error: unequal values for BinVal in row ",row

    SumError = dsqrt((Error(1)/Value(2))**2+(Error(2)*Value(1))**2)
    if(SumHits.gt.999999999) SumHits=999999999
    write(* ,fmt1) NHisto(1),"|",BinVal(1),"|",Value(1)/Value(2),"|",SumError,"|",SumHits,"|"
    write(10,fmt1) NHisto(1),"|",BinVal(1),"|",Value(1)/Value(2),"|",SumError,"|",SumHits,"|"
  enddo

END SUBROUTINE




SUBROUTINE sum_histobins(NumArgs,iHisto)
implicit none
character(len=*),parameter :: fmt1 = "(I2,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"
integer :: NumArgs,NArg,iHisto
integer,parameter :: MaxFiles=50
integer :: NHisto(1:MaxFiles)=-999999,Hits(1:MaxFiles)=-999999
real(8) :: BinVal(1:MaxFiles)=-1d-99,Value(1:MaxFiles)=-1d-99,Error(1:MaxFiles)=-1d-99
real(8) :: SumValue,BinSize_Tmp,BinSize
character :: dummy*(1)


  BinSize_Tmp = 1d-100
  BinSize = 1d-100

  SumValue = 0d0
  do while(.not.eof(12))  ! loop over all rows

      NArg=1
      read(unit=11+NArg,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=11+NArg) ! go to the beginning of the line
      read(unit=11+NArg,fmt=fmt1) NHisto(1),dummy,BinVal(1),dummy,Value(1),dummy,Error(1),dummy,Hits(1),dummy

      if(NHisto(1).ne.iHisto) cycle

      ! detect bin size (assume same size for all bins)
      if(BinSize_Tmp.ne.1d-100 .and. BinSize.eq.1d-100) then
          BinSize=dabs(BinVal(1)-BinSize_Tmp)
!           print *, "Bin size=",BinSize
      endif
      if(BinSize_Tmp.eq.1d-100) BinSize_Tmp=BinVal(1)

      SumValue = SumValue  + Value(1)
!       write(* ,fmt1) NHisto(1),"|",BinVal(1),"|",Value(1),"|",Error(1),"|",Hits(1),"|"

  enddo

  SumValue = SumValue * BinSize
  write(*,"(1PE23.16)") SumValue
!   write(10,"(1PE23.16)") SumValue

END SUBROUTINE

SUBROUTINE sum_2Dhistobins(NumArgs,iHisto)
implicit none
character(len=*),parameter :: fmt1 = "(I2,A,2X,1PE10.3,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"
integer :: NumArgs,NArg,iHisto
integer,parameter :: MaxFiles=50
integer :: NHisto(1:MaxFiles)=-999999,Hits(1:MaxFiles)=-999999
real(8) :: BinVal1(1:MaxFiles)=-1d-99,BinVal2(1:MaxFiles)=-1d-99,Value(1:MaxFiles)=-1d-99,Error(1:MaxFiles)=-1d-99
real(8) :: SumValue,BinSize1_Tmp,BinSize1,BinSize2_Tmp,BinSize2
character :: dummy*(1)


  BinSize1_Tmp = 1d-100
  BinSize1 = 1d-100

  BinSize2_Tmp = 1d-100
  BinSize2 = 1d-100

  SumValue = 0d0
  do while(.not.eof(12))  ! loop over all rows

      NArg=1
      read(unit=11+NArg,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=11+NArg) ! go to the beginning of the line
      read(unit=11+NArg,fmt=fmt1) NHisto(1),dummy,BinVal1(1),dummy,BinVal2(1),dummy,Value(1),dummy,Error(1),dummy,Hits(1),dummy

      if(NHisto(1).ne.iHisto) cycle

      ! detect bin size (assume same size for all bins)
      if(BinSize1_Tmp.ne.1d-100 .and. BinSize1.eq.1d-100) then
          BinSize1=dabs(BinVal1(1)-BinSize1_Tmp)
!           print *, "Bin size=",BinSize
      endif
      if(BinSize1_Tmp.eq.1d-100) BinSize1_Tmp=BinVal1(1)

      if (BinSize2_Tmp .eq. 1d-100) then
         BinSize2_Tmp=BinVal2(1)
      endif
      if (BinVal2(1) .ne. BinSize2_Tmp) then
         BinSize2=BinVal2(1)-BinSize2_Tmp
         BinSize2_Tmp=BinVal2(1)
      endif

      SumValue = SumValue  + Value(1)
!       write(* ,fmt1) NHisto(1),"|",BinVal1(1),"|",BinVal2(1),"|",Value(1),"|",Error(1),"|",Hits(1),"|"
  enddo

  SumValue = SumValue * BinSize1 * BinSize2
  write(*,"(1PE23.16)") SumValue
!   write(10,"(1PE23.16)") SumValue

END SUBROUTINE



SUBROUTINE sumslice(NumArgs,iHisto,iBin,iVal)
implicit none
character(len=*),parameter :: fmt1 = "(I2,A,2X,1PE10.3,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"
integer :: NumArgs,NArg,iHisto,iBin
real(8) :: iVal
integer,parameter :: MaxFiles=50
integer :: NHisto(1:MaxFiles)=-999999,Hits(1:MaxFiles)=-999999
real(8) :: BinVal(1:MaxFiles)=-1d-99,BinVal1(1:MaxFiles)=-1d-99,BinVal2(1:MaxFiles)=-1d-99,Value(1:MaxFiles)=-1d-99,Error(1:MaxFiles)=-1d-99
real(8) :: SumValue,BinSize_Tmp,BinSize
character :: dummy*(1)


  BinSize_Tmp = 1d-100
  BinSize = 1d-100

  SumValue = 0d0
  if (iBin .ne. 1 .and. iBin .ne. 2) then
     print *, "ERROR: This is a two-dimensional histogram, so iBin = 1 or 2"
     stop
  endif

  do while(.not.eof(12))  ! loop over all rows

      NArg=1
      read(unit=11+NArg,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=11+NArg) ! go to the beginning of the line
      read(unit=11+NArg,fmt=fmt1) NHisto(1),dummy,BinVal1(1),dummy,BinVal2(1),dummy,Value(1),dummy,Error(1),dummy,Hits(1),dummy

      if(NHisto(1).ne.iHisto) cycle

! pick up only the selected value for the selected bin
      if (iBin .eq. 1) then
         if (dabs(BinVal1(1)-iVal) .gt. 1d-10) then
            cycle
         else
            BinVal(1)=BinVal2(1)
         endif
      elseif (iBin .eq. 2) then
         if (dabs(BinVal2(1)-iVal) .gt. 1d-10) then
            cycle
         else
            BinVal(1)=BinVal1(1)
         endif
      endif
      

      ! detect bin size (assume same size for all bins)
      if(BinSize_Tmp.ne.1d-100 .and. BinSize.eq.1d-100) then
          BinSize=dabs(BinVal(1)-BinSize_Tmp)
!           print *, "Bin size=",BinSize
      endif
      if(BinSize_Tmp.eq.1d-100) BinSize_Tmp=BinVal(1)

      SumValue = SumValue  + Value(1)
!       write(* ,fmt1) NHisto(1),"|",BinVal(1),"|",Value(1),"|",Error(1),"|",Hits(1),"|"

  enddo

  SumValue = SumValue * BinSize
  write(*,"(1PE23.16)") SumValue
!   write(10,"(1PE23.16)") SumValue

END SUBROUTINE

SUBROUTINE multiply_histo(NumArgs,factor)
implicit none
character(len=*),parameter :: fmt1 = "(I2,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"
integer :: NumArgs,NArg
integer,parameter :: MaxFiles=50
integer :: NHisto(1:MaxFiles)=-999999,Hits(1:MaxFiles)=-999999
real(8) :: BinVal(1:MaxFiles)=-1d-99,Value(1:MaxFiles)=-1d-99,Error(1:MaxFiles)=-1d-99
real(8) :: SumValue,factor
character :: dummy*(1)

  do while(.not.eof(12))  ! loop over all rows
      NArg=1
      read(unit=11+NArg,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=11+NArg) ! go to the beginning of the line
      read(unit=11+NArg,fmt=fmt1) NHisto(NArg),dummy,BinVal(NArg),dummy,Value(NArg),dummy,Error(NArg),dummy,Hits(NArg),dummy

      if(dummy(1:1).eq."#") cycle
      if(Hits(1).gt.999999999) Hits=999999999
      write(* ,fmt1) NHisto(1),"|",BinVal(1),"|",factor*Value(1),"|",factor*Error(1),"|",Hits(1),"|"
      write(10,fmt1) NHisto(1),"|",BinVal(1),"|",factor*Value(1),"|",factor*Error(1),"|",Hits(1),"|"
  enddo


END SUBROUTINE



SUBROUTINE rebinning1(iHisto,nrebin)! this subroutine is just averaging nrebin consecutive bins
implicit none
character(len=*),parameter :: fmt1 = "(I2,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"
integer :: NumArgs,NArg,iHisto,nrebin, ibin
integer,parameter :: MaxBins=100
integer :: NHisto(0:MaxBins)=-999999,Hits(0:MaxBins)=-999999
real(8) :: BinVal(0:MaxBins)=-1d-99,Value(0:MaxBins)=-1d-99,Error(0:MaxBins)=-1d-99
real(8) :: newvalue, newerror
integer :: newhits
real(8) :: SumValue,BinSize_Tmp,BinSize
character :: dummy*(1)


  BinSize_Tmp = 1d-100
  BinSize = 1d-100

  SumValue = 0d0
  do while(.not.eof(12))  ! loop over all rows

      read(unit=12,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=12) ! go to the beginning of the line
      read(unit=12,fmt=fmt1) NHisto(1),dummy,BinVal(1),dummy,Value(1),dummy,Error(1),dummy,Hits(1),dummy

      if(NHisto(1).eq.iHisto) then
!         write(* ,fmt1) NHisto(1),"|",BinVal(1),"|",Value(1),"|",Error(1),"|",Hits(1),"|"

         read(unit=12,fmt="(A)") dummy
         if(dummy(1:1).eq."#") cycle
         backspace(unit=12) ! go to the beginning of the line

         newvalue = Value(1) 
         newerror = Error(1)**2
         newhits = Hits(1)
         
         do ibin = 1, nrebin
            read(unit=12,fmt=fmt1) NHisto(1+ibin),dummy,BinVal(1+ibin),dummy,Value(1+ibin),dummy,Error(1+ibin),dummy,Hits(1+ibin),dummy
            !         write(* ,fmt1) NHisto(2),"|",BinVal(2),"|",Value(2),"|",Error(2),"|",Hits(2),"|"
            newvalue = newvalue + Value(1+ibin)
            newerror = newerror + Error(1+ibin)**2
            newhits = newhits + Hits(1+ibin)
         enddo

         newerror = dsqrt(newerror)/real(nrebin+1)
         newvalue = newvalue/real(nrebin+1)

         write(13 ,fmt1) NHisto(1),"|",BinVal(1),"|",newvalue,"|",newerror,"|",newhits,"|"
         write(*  ,fmt1) NHisto(1),"|",BinVal(1),"|",newvalue,"|",newerror,"|",newhits,"|"

!          do ibin = 1, nrebin
!             write(13 ,fmt1) NHisto(1),"|",BinVal(1+ibin),"|",newvalue,"|",newerror,"|",newhits,"|"
!          enddo

      else
         write(13 ,fmt1) NHisto(1),"|",BinVal(1),"|",Value(1),"|",Error(1),"|",Hits(1),"|"
         write(*  ,fmt1) NHisto(1),"|",BinVal(1),"|",Value(1),"|",Error(1),"|",Hits(1),"|"
      endif

  enddo


END SUBROUTINE






SUBROUTINE rebinning2(iHisto)! this subroutine is averaging two bins and including half of the neighboring bins
implicit none
character(len=*),parameter :: fmt1 = "(I2,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"
integer :: NumArgs,NArg,iHisto, ibin
integer,parameter :: MaxBins=100
integer :: NHisto(0:MaxBins)=-999999,Hits(0:MaxBins)=-999999
real(8) :: BinVal(0:MaxBins)=-1d-99,Value(0:MaxBins)=-1d-99,Error(0:MaxBins)=-1d-99,NewValue(0:MaxBins)=-1d-99
integer :: i
real(8) :: SumValue,BinSize_Tmp,BinSize
character :: dummy*(1)


  BinSize_Tmp = 1d-100
  BinSize = 1d-100

  SumValue = 0d0
  ibin=0
  do while(.not.eof(12))  ! loop over all rows
      read(unit=12,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=12) ! go to the beginning of the line
      read(unit=12,fmt=fmt1) NHisto(0),dummy,BinVal(0),dummy,Value(0),dummy,Error(0),dummy,Hits(0),dummy

      if(NHisto(0).eq.iHisto) then! find the right histogram
          backspace(unit=12) ! go to the beginning of the line
          ibin=ibin+1      
          if( ibin.eq.1 ) then 
         endif
         read(unit=12,fmt=fmt1) NHisto(ibin),dummy,BinVal(ibin),dummy,Value(ibin),dummy,Error(ibin),dummy,Hits(ibin),dummy
      endif

  enddo


! rebinning
  Value(0) = 0d0
  Value(ibin+1) = 0d0
  do i = 1,ibin,2
     if( i.eq.1 ) NewValue(i)   =   Value(i)+Value(i+1)/2d0 + Value(i+2)/2d0  ! first bin 
     if( i.eq.ibin ) NewValue(i)   =   Value(i-1)/2d0 + Value(i)/2d0+Value(i+1)! last bin 
     if( i.gt.1 .and. i.ne.ibin) NewValue(i)   =   Value(i-1)/2d0 + Value(i)/2d0+Value(i+1)/2d0 + Value(i+2)/2d0 ! else
     NewValue(i)=NewValue(i)/2d0
     NewValue(i+1) = 0d0
  enddo



! write new histo file
  rewind(12)
  ibin=0
  do while(.not.eof(12))  ! loop over all rows
      read(unit=12,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=12) ! go to the beginning of the line
      read(unit=12,fmt=fmt1) NHisto(0),dummy,BinVal(0),dummy,Value(0),dummy,Error(0),dummy,Hits(0),dummy

      if(NHisto(0).eq.iHisto) then! find the right histogram
          ibin=ibin+1
          if( mod(ibin+1,2).eq.0 ) write(13,fmt=fmt1) iHisto,dummy,BinVal(ibin),dummy,NewValue(ibin),dummy,Error(ibin),dummy,Hits(ibin),dummy
      else
          write(13,fmt=fmt1) NHisto(0),dummy,BinVal(0),dummy,Value(0),dummy,Error(0),dummy,Hits(0),dummy
      endif
  enddo


END SUBROUTINE








SUBROUTINE readlhe()
implicit none
character(len=*),parameter :: fmt1 = "(I2,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"
integer :: NumArgs,NArg
integer,parameter :: MaxFiles=50
integer :: NHisto(1:MaxFiles)=-999999,Hits(1:MaxFiles)=-999999
real(8) :: BinVal(1:MaxFiles)=-1d-99,Value(1:MaxFiles)=-1d-99,Error(1:MaxFiles)=-1d-99
real(8) :: SumValue,factor
character :: dummy*(1)


  do while(.not.eof(12))  ! loop over all events

      read(unit=12,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=12) ! go to the beginning of the line
      read(unit=12,fmt=fmt1) NHisto(NArg),dummy,BinVal(NArg),dummy,Value(NArg),dummy,Error(NArg),dummy,Hits(NArg),dummy

  enddo

END SUBROUTINE





SUBROUTINE likelihood(iHisto,LumiORNumEvents,NumPseudoExp,DeltaN)
implicit none
integer :: iHisto,LumiORNumEvents,NumPseudoExp
real(8) :: DeltaN
integer,parameter :: MaxBins=1000, MaxEvents=200000
integer,parameter :: NumLLbins=1000! the LLratio should only vary between - and + this number
character(len=*),parameter :: fmt1 = "(I2,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"
character :: dummy*(1)
integer :: iBin,iPseudoExp,NumBins1=0,NumBins2=0,ranBin,BinAccept(1:MaxEvents),NumAccepted,NEvent,TryEvents
integer :: NumEvents,NumExpectedEvents(1:2),iHypothesis
integer :: NHisto(1:2)=-999999,Hits(1:2,1:MaxBins)=-999999,WhichBin
real(8) :: Lumi,BinVal(1:2,1:MaxBins)=-1d-99,Value(1:2,1:MaxBins)=-1d-99,Error(1:2,1:MaxBins)=-1d-99
real(8) :: ymax,zran(1:2),nran(1:2),ValAccepted(1:MaxEvents),LLRatio,BinSize,MaxPoisson(1:2)
real(8) :: sigmatot(1:2),check(1:2),alpha(1:2,1:MaxBins),IntLLRatio(1:2),checkalpha(1:MaxBins)
integer :: SelectedEvent,LLbin,PlotObsEvts(1:2,1:10000),i,s,offset,SUA
real(8) :: alphamin,alphamax,betamin,betamax,rescale(1:2),sran
real(8) :: LLRatio_array(1:2,1:NumPseudoExp),LLRatio_min,LLRatio_max
logical ::  GotNumEvents,PoissonEvents,PoissonBins,useshape
type :: Histogram
    integer :: NBins
    real(8) :: BinSize
    real(8) :: LowVal
    integer :: Hits(1:1000)
end type
type(Histogram) :: LLHisto(1:2)
logical, parameter :: normalize=.true.



! NumEvents=LumiORNumEvents
Lumi = dble(LumiORNumEvents)


!--------------------------------------------------
!          0. init
!--------------------------------------------------
LLHisto(1)%NBins   = 1000
LLHisto(1)%BinSize = 0.5d0
LLHisto(1)%LowVal  = -200d0
LLHisto(1)%Hits(:) = 0

LLHisto(2)%NBins   = LLHisto(1)%NBins
LLHisto(2)%BinSize = LLHisto(1)%BinSize
LLHisto(2)%LowVal  = LLHisto(1)%LowVal
LLHisto(2)%Hits(:) = LLHisto(1)%Hits(:)
PlotObsEvts=0

PoissonEvents=.true.
!  Scale Uncertainty Approach: 
! 1=rescale PREDICTED cross-secs and distr (conservative)
! 2=change OBSERVED events in each pseudoexp
SUA=1                   

if (SUA .ne. 1 .and. SUA .ne. 2 .and. DeltaN .ne. 1d0) then
   print *, "WARNING : SCALE UNCERTAINTY NOT USED!"
   stop
endif



!--------------------------------------------------
!          1. reading input files
!--------------------------------------------------
  do while(.not.eof(12))!   reading input file 1
      read(unit=12,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=12) ! go to the beginning of the line

      read(unit=12,fmt=fmt1) NHisto(1),dummy,BinVal(1,NumBins1+1),dummy,Value(1,NumBins1+1),dummy,Error(1,NumBins1+1),dummy,Hits(1,NumBins1+1),dummy
      if( NHisto(1).ne.iHisto ) cycle
      NumBins1=NumBins1 + 1
  enddo

  do while(.not.eof(13))!   reading input file 2
      read(unit=13,fmt="(A)") dummy
      if(dummy(1:1).eq."#") cycle
      backspace(unit=13) ! go to the beginning of the line

      read(unit=13,fmt=fmt1) NHisto(2),dummy,BinVal(2,NumBins2+1),dummy,Value(2,NumBins2+1),dummy,Error(2,NumBins2+1),dummy,Hits(2,NumBins2+1),dummy
      if( NHisto(2).ne.iHisto ) cycle
      NumBins2=NumBins2 + 1
  enddo

  if( NumBins1.ne.NumBins2 ) then
     print *, "Error: Number of bins in input file 1 and 2 are different: ",NumBins1,NumBins2
     stop
  endif

  sigmatot(1:2) = 0d0
  BinSize = BinVal(1,2)-BinVal(1,1)
  do iBin=1,NumBins1! calculate total cross section
       sigmatot(1) = sigmatot(1) + Value(1,iBin) * BinSize
       sigmatot(2) = sigmatot(2) + Value(2,iBin) * BinSize
  enddo

  NumExpectedEvents(1) = int(Lumi * sigmatot(1) *8 ) ! factor of 8 from lepton species
  NumExpectedEvents(2) = int(Lumi * sigmatot(2) *8 ) 
  write(*,"(A,1PE16.8,A,I6)") "Total cross section of input file 1: ",sigmatot(1),"   <-->   Number of events: ",NumExpectedEvents(1)
  write(*,"(A,1PE16.8,A,I6)") "Total cross section of input file 2: ",sigmatot(2),"   <-->   Number of events: ",NumExpectedEvents(2)
  check(1:2) = 0d0

  rescale=1d0
  if (SUA .eq. 1) then
     ! Added -- scale uncertainty -- this should also change 
     if (sigmatot(1) .gt. sigmatot(2)) then
        if (sigmatot(1)/DeltaN .gt. sigmatot(2)*DeltaN) then
           sigmatot(1)=sigmatot(1)/DeltaN
           sigmatot(2)=sigmatot(2)*DeltaN
           rescale(1)=1d0/DeltaN
           rescale(2)=DeltaN
        else
           rescale(1)=1d0
           rescale(2)=sigmatot(1)/sigmatot(2)
           sigmatot(2)=sigmatot(1)
        endif
     else
        if (sigmatot(1)*DeltaN .lt. sigmatot(2)/DeltaN) then
           sigmatot(1)=sigmatot(1)*DeltaN
           sigmatot(2)=sigmatot(2)/DeltaN
           rescale(1)=DeltaN
           rescale(2)=1d0/DeltaN
        else
           rescale(1)=1d0
           rescale(2)=sigmatot(1)/sigmatot(2)
           sigmatot(2)=sigmatot(1)
        endif
     endif
  endif

  NumExpectedEvents(1) = int(Lumi * sigmatot(1) *8 ) ! factor of 8 from lepton species
  NumExpectedEvents(2) = int(Lumi * sigmatot(2) *8 ) 


  write(*,"(A,I6,A)") "Scale uncertainty for null hypothesis-> ", NumExpectedEvents(1) , " events"
  write(*,"(A,I6,A)") "Scale uncertainty for alt hypothesis-> ", NumExpectedEvents(2) , " events"
  
  MaxPoisson(1) = Poisson(NumExpectedEvents(1),NumExpectedEvents(1))
  MaxPoisson(2) = Poisson(NumExpectedEvents(2),NumExpectedEvents(2))

  print *, 'Max of Poisson:', MaxPoisson(1:2)
! normalize distributions
  if( normalize ) then
   print *, "Normalizing input files" 
   do iBin=1,NumBins1! normalize histogram
       Value(1,iBin) = Value(1,iBin)*BinSize/sigmatot(1)*rescale(1)
       Value(2,iBin) = Value(2,iBin)*BinSize/sigmatot(2)*rescale(2)
   enddo
  endif
! print the input histograms 
  write(*,"(2X,A,16X,A,11X,A,16X,A)") "NBin|","Input file 1","|","Input file 2"
  do iBin=1,NumBins1
    write(*,fmt="(2X,1I3,A,2X,1PE10.3,2X,1PE23.16,A,2X,1PE10.3,2X,1PE23.16)") iBin," | ",BinVal(1,iBin),Value(1,iBin)," | ",BinVal(2,iBin),Value(2,iBin)
    if( dabs(BinVal(1,iBin)-BinVal(2,iBin)).gt.1d-6 ) then
        print *, "Error: Different bin sizes in input files 1 and 2"
        stop
    endif
  enddo
  check(1:2) = 0d0
  do iBin=1,NumBins1! check
      check(1) = check(1) + Value(1,iBin)
      check(2) = check(2) + Value(2,iBin)
  enddo
  write(*,"(A,1PE16.8)") "Sum of bins in input file 1: ",check(1)
  write(*,"(A,1PE16.8)") "Sum of bins in input file 2: ",check(2)
  write(*,*) ""








!----------------------------------------------------------------------------------------
!          2. generate pseudo experiments for null hypothesis and alternative hypothesis
!----------------------------------------------------------------------------------------
  call random_seed()     
do iHypothesis=1,2

   if (.not. PoissonEvents) then       ! dont incl cross-section info, so same number of events for every pseudoexperiment
      !   NumEvents = NumExpectedEvents(1)              ! choose number of events fixed for each hypothesis
      NumEvents = NumExpectedEvents(iHypothesis)    ! choose number of events differently for each hypothesis

      write(*,"(A,I6,A)") "Generating ",NumEvents," events"
      if( NumEvents.gt.MaxEvents ) then
         print *, "Error: NumEvents is too large. Increase MaxEvents in SUBROUTINE likelihood."
         stop
      endif
   else
      write(*,*)  "Generating Poisson distributed events for each pseudoexperiment"
   endif

   do iPseudoExp=1,NumPseudoExp

      if( mod(iPseudoExp,10000).eq.0 ) print *, "Pseudo experiment ",iPseudoExp,"/",NumPseudoExp

      
      if (PoissonEvents) then
               
!*************************************************************
!  2.0 generate number of events for null hypothesis
!*************************************************************
         GotNumEvents=.false.
               
         do while (.not. GotNumEvents) 
            call random_number(nran(1:2))
            nran(1)=nran(1)*MaxPoisson(iHypothesis)
            TryEvents=int(2d0*NumExpectedEvents(iHypothesis)*nran(2)) 
            if ( Poisson(NumExpectedEvents(iHypothesis),TryEvents) .gt. nran(1) ) then
               NumEvents = TryEvents
               GotNumEvents=.true.
!               PlotObsEvts(iHypothesis,TryEvents)=PlotObsEvts(iHypothesis,TryEvents)+1     ! this is to check the Poisson dist.
            endif
         enddo
         if( NumEvents.gt.MaxEvents ) then
            print *, "Error: NumEvents is too large. Increase MaxEvents in SUBROUTINE likelihood."
            stop
         endif
      endif

      if (SUA .eq. 2) then  
         !************************************************************
         !  2.0a change number of observed events for scale uncertainty
         !************************************************************    
         
         call random_number(sran)
         sran=sran*(DeltaN**2-1d0)/DeltaN + 1d0/DeltaN
         write(201,*) sran
         ! this should be uniformly distr in [1/DeltaN,DeltaN] -- check
         NumEvents=NumEvents*sran
         PlotObsEvts(iHypothesis,NumEvents)=PlotObsEvts(iHypothesis,NumEvents)+1     ! this is to check the Poisson dist.
      endif



!************************************************************
!  2.1 generate event sample according to hypothesis
!************************************************************
      ! find max. of y-axis
      ymax=-1d13;
      do iBin=1,NumBins1
         if(  Value(iHypothesis,iBin).gt.ymax ) ymax = Value(iHypothesis,iBin)
      enddo

      NumAccepted=0
!      call random_seed()     
      do while( NumAccepted .lt. NumEvents )!  loop until required number of events is reached
           call random_number(zran(1:2))         
           ranBin = 1 + int( zran(1)*NumBins1 ) ! randomly select a bin (=event)
           if( ymax*zran(2) .lt.  Value(iHypothesis,ranBin) ) then! accept/reject this event
               NumAccepted=NumAccepted+1
               BinAccept(NumAccepted) = ranBin
               ValAccepted(NumAccepted) = Value(iHypothesis,ranBin)
           endif
      enddo


!************************************************************
!  2.2 calculate log likelihood ratio 
!************************************************************
!      LLRatio = 0d0
       if (PoissonEvents) then
         LLRatio=NumEvents*dlog(1d0*NumExpectedEvents(1)/NumExpectedEvents(2))
      else
         LLRatio = 0d0
      endif
      do NEvent=1,NumEvents
         SelectedEvent = BinAccept(NEvent)
         if( ValAccepted(NEvent).ne.Value(iHypothesis,SelectedEvent) ) then! can be removed/simplified later 
             print *, "error in ll"
             stop
         endif
         LLRatio = LLRatio + 2d0*dlog( (Value(1,SelectedEvent))/(Value(2,SelectedEvent)) )
      enddo
      if (iHypothesis .eq. 1 .and. iPseudoExp .eq. 1) then
         offset=-100d0*(int(LLRatio)/100)

      endif
      LLRatio=LLRatio+offset
      if (iPseudoExp .eq. 1) then
         print *, 'LLRatio=',LLRatio,offset
      endif


      LLRatio_array(iHypothesis,iPseudoExp)=LLRatio
  enddo! iPseudoExp
  do i=1,2000
     s=101+iHypothesis
     write(s,*) i,PlotObsEvts(iHypothesis,i)
  enddo

enddo! iHypothesis

LLRatio_max=-1d-6
LLRatio_min=1d6

do iHypothesis=1,2
   do iPseudoExp=1,NumPseudoExp
      if (LLRatio_array(iHypothesis,iPseudoExp) .gt. LLRatio_max) then
         LLRatio_max=LLRatio_array(iHypothesis,iPseudoExp) 
      endif
      if (LLRatio_array(iHypothesis,iPseudoExp) .lt. LLRatio_min) then
         LLRatio_min=LLRatio_array(iHypothesis,iPseudoExp) 
      endif
   enddo
enddo
print *, LLRatio_min,LLRatio_max
!LLRatio_max=100d0*(int(LLRatio_max/100)+1)
!LLRatio_min=100d0*(int(LLRatio_max/100)-1)
LLRatio_max=ceiling(LLRatio_max)
LLRatio_min=floor(LLRatio_min)

if (LLRatio_max .lt. LLRatio_min) then
   print *, 'ERROR: MAX OF LL RATIO IS SMALLER THAN MIN!'
   print *, LLRatio_max,LLRatio_min
   stop
endif


LLHisto(1)%NBins   = 1000
LLHisto(1)%BinSize = (LLRatio_max-LLRatio_min)/LLHisto(1)%NBins
LLHisto(1)%LowVal  = LLRatio_min
LLHisto(1)%Hits(:) = 0
print *, LLHisto(1)%BinSize
print *, LLRatio_min, LLRatio_max
pause
LLHisto(2)%NBins   = LLHisto(1)%NBins
LLHisto(2)%BinSize = LLHisto(1)%BinSize
LLHisto(2)%LowVal  = LLHisto(1)%LowVal
LLHisto(2)%Hits(:) = LLHisto(1)%Hits(:)

!************************************************************
!  2.3 bin the likelihood value 
!************************************************************
do iHypothesis=1,2
   do iPseudoExp=1,NumPseudoExp
      LLRatio=LLRatio_array(iHypothesis,iPseudoExp)
      WhichBin = (LLRatio-LLHisto(iHypothesis)%LowVal)/LLHisto(iHypothesis)%BinSize + 1
      WhichBin=int(WhichBin)
      if( WhichBin.lt.0 ) WhichBin = 1
      if( WhichBin.gt.LLHisto(iHypothesis)%NBins ) WhichBin = LLHisto(iHypothesis)%NBins
      LLHisto(iHypothesis)%Hits(WhichBin) = LLHisto(iHypothesis)%Hits(WhichBin) + 1
   enddo

         
!************************************************************
! 2.4 Find the integral under the LL distribution
!************************************************************

      do LLbin=1,LLHisto(iHypothesis)%NBins
         IntLLRatio(iHypothesis)=IntLLRatio(iHypothesis)+&
              LLHisto(iHypothesis)%BinSize * LLHisto(iHypothesis)%Hits(LLbin)
         alpha(iHypothesis,LLBin)=IntLLRatio(iHypothesis)/(NumPseudoExp*LLHisto(iHypothesis)%BinSize)
      enddo
enddo
!************************************************************
!  3. write out the LL distribution, and find integral under each distribution
!************************************************************
      print *, ""
      print *, "Writing log-likelihood distribution to outful file"
      print *, ""
      do LLbin=1,LLHisto(1)%NBins
!         print *, LLBin
           write(14,"(2X,I4,2X,1PE16.8,2X,I10,2X,1PE16.8,2X,I10,2X,1PE16.8,2X,1PE16.8)") LLbin, LLHisto(1)%LowVal+LLbin*LLHisto(1)%BinSize, LLHisto(1)%Hits(LLbin),LLHisto(2)%LowVal+LLbin*LLHisto(2)%BinSize, LLHisto(2)%Hits(LLbin),alpha(1,LLBin),alpha(2,LLBin)
      enddo


!************************************************************
!  4. Now find the point at which alpha=1-beta
!************************************************************

! for the time being, I'm going to assume that both distributions have the same range and binning - can change this later
   do LLbin=1,LLHisto(1)%NBins
      checkalpha(LLBin)=alpha(1,LLBin)+alpha(2,LLBin)-1d0
      print *, LLBIn,alpha(1,LLBin),alpha(2,LLBin),checkalpha(LLBin)
      if (checkalpha(LLBin)*checkalpha(LLBin-1) .lt. 0d0) then
         alphamin=alpha(1,LLBin-1)
         alphamax=alpha(1,LLBin)
         betamin =alpha(2,LLBin-1)
         betamax =alpha(2,LLBin)
         
         if (checkalpha(LLBin) .eq. 1d0 .and. checkalpha(LLBin-1) .eq.-1d0) then
            ! this is comparing two identical hypotheses!
            alphamin=1d0
            alphamax=1d0
            betamin=0d0
            betamax=0d0
         endif
      endif
   enddo

   print *, 'alpha value in range:', alphamin,alphamax
   print *, 'betaa value in range:', betamin,betamax 

   write(14,"(A,2X,1PE16.8,2X,1PE16.8)") "# alpha value in range:",alphamin,alphamax
   write(14,"(A,2X,1PE16.8,2X,1PE16.8)") "# beta value in range:",betamin,betamax


END SUBROUTINE






SUBROUTINE ttbzcoupl(iHisto,VcouplSM,AcouplSM,dVcoupl,dAcoupl,filename_out)
IMPLICIT NONE
integer :: iHisto
real(8) :: VcouplSM,AcouplSM,dVcoupl(1:6),dAcoupl(1:6),Vcoupl,Acoupl
character :: filename_out*(50),NewFileName*(100)
character(len=*),parameter :: fmt1 = "(I2,A,2X,1PE10.3,A,2X,1PE23.16,A,2X,1PE23.16,A,2X,I9,A)"!  standard TOPAZ output
character(len=*),parameter :: fmt2 = "(I2,4X,1F9.6,4X,F22.20)"                                !  new mathematica output
character :: dummy*(1)
integer,parameter :: MaxBins=100
integer :: NHisto=-999999,Hits=-999999,TheUnit,ibin,NumBins,Vgrid,Agrid,Ai,Vi
real(8) :: BinVal(1:6,0:MaxBins)=-1d-99,Value(1:6,0:MaxBins)=-1d-99,Error=-1d-99
real(8) :: res,CoefFits(1:6),couplMatrix_new(1:6),dV_new,dA_new,NewValue,dVrange,dArange,dVstep,dAstep
complex(8) :: couplMatrix(1:6,1:7)

  ! reading all input files
  do TheUnit=11,16! looping over all 6 input files
      ibin=0
      do while(.not.eof(TheUnit))! looping over all lines in the input file
          read(unit=TheUnit,fmt="(A)") dummy; if(dummy(1:1).eq."#") cycle; backspace(unit=TheUnit) ! skip # lines
          read(unit=TheUnit,fmt="(I2)") NHisto
          if(NHisto.eq.iHisto) then
              backspace(unit=TheUnit)
              ibin=ibin+1
               read(unit=TheUnit,fmt=fmt1) NHisto,dummy,BinVal(TheUnit-10,ibin),dummy,Value(TheUnit-10,ibin),dummy,Error,dummy,Hits,dummy !   TOPAZ
!              read(unit=TheUnit,fmt=fmt2) NHisto,BinVal(TheUnit-10,ibin),Value(TheUnit-10,ibin)                                !   MATHEMATICA
          endif
      enddo 
  enddo
  NumBins=ibin


dummy=" "
write(*,*) ""
do ibin=1,NumBins! looping over all histogram bins
! Solving the system of 6 linear equations for coefficients of A^2, V^2, 1, A*V, A, V
  do TheUnit=1,6
     if( BinVal(TheUnit,ibin).ne.BinVal( mod(TheUnit,6)+1,ibin)  ) print *, "ERROR: Different bin values in file", TheUnit
     Vcoupl = VcouplSM * ( 1d0 + dVcoupl(TheUnit) )
     Acoupl = AcouplSM * ( 1d0 + dAcoupl(TheUnit) )
     res = Value(TheUnit,ibin)
     couplMatrix(TheUnit,1:7) = (/ dcmplx(Acoupl**2), dcmplx(Vcoupl**2), dcmplx(1d0), dcmplx(Acoupl*Vcoupl), dcmplx(Acoupl), dcmplx(Vcoupl), dcmplx(res) /)
!      write(*,"(2X,A,6F8.5,F10.6)") "Matrix ",dble(couplMatrix(TheUnit,1:7))
   enddo
!    CoefFits(1:6) = dble( go_Gauss_64(6,couplMatrix(1:6,1:7)) )
   CoefFits(1:6) = dble( go_GaussLU(6,couplMatrix(1:6,1:7)) )
   if( ibin.eq.1 ) write(*,"(2X,A)") "                             A^2       V^2       1        A*V         A         V   "
   write(*,"(2X,A,I2,A,6F10.6)") "HistoBin=",ibin," Fit coeffs.:",CoefFits(1:6)
!    pause

!--- GRID SETUP -----------
     dVrange=0.2d0   ! this means variation by +/- dVrange
     dArange=0.2d0   ! this means variation by +/- dArange
     Vgrid=10        ! how many sub-divisions for *each* +/- +/- sector
     Agrid=10        ! how many sub-divisions for *each* +/- +/- sector
!--------------------------

     dVstep=dVrange/dble(Vgrid)
     dAstep=dArange/dble(Agrid)
     dV_new=0d0; dA_new=0d0
     do Vi=0,Vgrid
        dV_new = Vi * dVstep
        do Ai=0,Agrid
           dA_new = Ai * dAstep

!           generating the +V +A results        
            Vcoupl = VcouplSM * ( 1d0 + dV_new )
            Acoupl = AcouplSM * ( 1d0 + dA_new )
            couplMatrix_new(1:6) = (/ dcmplx(Acoupl**2), dcmplx(Vcoupl**2), dcmplx(1d0), dcmplx(Acoupl*Vcoupl), dcmplx(Acoupl), dcmplx(Vcoupl) /)
            NewValue = couplMatrix_new(1)*CoefFits(1) + couplMatrix_new(2)*CoefFits(2) + couplMatrix_new(3)*CoefFits(3)  &
                     + couplMatrix_new(4)*CoefFits(4) + couplMatrix_new(5)*CoefFits(5) + couplMatrix_new(6)*CoefFits(6)
            write(NewFileName,"(A,A,I2,A,1F4.2,A,1F4.2,A)") trim(filename_out),"_Hi",iHisto,"_V+",dV_new,"_A+",dA_new,".dat"
            if( ibin.eq.1 ) then
                open(unit=10,file=trim(NewFileName),form='formatted',access='sequential')
            else
                open(unit=10,file=trim(NewFileName),form='formatted',access='sequential',position='append')
            endif
            write(unit=10,fmt=fmt1) iHisto,dummy,BinVal(1,ibin),dummy,NewValue,dummy,0d0,dummy,0,dummy
!             write(*,"(2X,A,2F10.6,A,A)") "Fitting for (V,A)= (",Vcoupl,Acoupl,"). Filename=",trim(NewFileName)
            close(10)
            if( dV_new.eq.0d0 .and. dA_new.eq.0d0 )  cycle


!           generating the +V -A results     
            if( dA_new.ne.0d0 ) then
              Vcoupl = VcouplSM * ( 1d0 + dV_new )
              Acoupl = AcouplSM * ( 1d0 - dA_new )
              couplMatrix_new(1:6) = (/ dcmplx(Acoupl**2), dcmplx(Vcoupl**2), dcmplx(1d0), dcmplx(Acoupl*Vcoupl), dcmplx(Acoupl), dcmplx(Vcoupl) /)
              NewValue = couplMatrix_new(1)*CoefFits(1) + couplMatrix_new(2)*CoefFits(2) + couplMatrix_new(3)*CoefFits(3)  &
                      + couplMatrix_new(4)*CoefFits(4) + couplMatrix_new(5)*CoefFits(5) + couplMatrix_new(6)*CoefFits(6)
              write(NewFileName,"(A,A,I2,A,1F4.2,A,1F4.2,A)") trim(filename_out),"_Hi",iHisto,"_V+",dV_new,"_A-",dA_new,".dat"
              if( ibin.eq.1 ) then
                  open(unit=10,file=trim(NewFileName),form='formatted',access='sequential')
              else
                  open(unit=10,file=trim(NewFileName),form='formatted',access='sequential',position='append')
              endif
              write(unit=10,fmt=fmt1) iHisto,dummy,BinVal(1,ibin),dummy,NewValue,dummy,0d0,dummy,0,dummy
!               write(*,"(2X,A,2F10.6,A,A)") "Fitting for (V,A)= (",Vcoupl,Acoupl,"). Filename=",trim(NewFileName)
              close(10)
            endif


!           generating the -V +A results 
            if( dV_new.ne.0d0 ) then
              Vcoupl = VcouplSM * ( 1d0 - dV_new )
              Acoupl = AcouplSM * ( 1d0 + dA_new )
              couplMatrix_new(1:6) = (/ dcmplx(Acoupl**2), dcmplx(Vcoupl**2), dcmplx(1d0), dcmplx(Acoupl*Vcoupl), dcmplx(Acoupl), dcmplx(Vcoupl) /)
              NewValue = couplMatrix_new(1)*CoefFits(1) + couplMatrix_new(2)*CoefFits(2) + couplMatrix_new(3)*CoefFits(3)  &
                      + couplMatrix_new(4)*CoefFits(4) + couplMatrix_new(5)*CoefFits(5) + couplMatrix_new(6)*CoefFits(6)
              write(NewFileName,"(A,A,I2,A,1F4.2,A,1F4.2,A)") trim(filename_out),"_Hi",iHisto,"_V-",dV_new,"_A+",dA_new,".dat"
              if( ibin.eq.1 ) then
                  open(unit=10,file=trim(NewFileName),form='formatted',access='sequential')
              else
                  open(unit=10,file=trim(NewFileName),form='formatted',access='sequential',position='append')
              endif
              write(unit=10,fmt=fmt1) iHisto,dummy,BinVal(1,ibin),dummy,NewValue,dummy,0d0,dummy,0,dummy
!               write(*,"(2X,A,2F10.6,A,A)") "Fitting for (V,A)= (",Vcoupl,Acoupl,"). Filename=",trim(NewFileName)
              close(10)
            endif


!           generating the -V -A results  
            if( dV_new.ne.0d0 .and. dA_new.ne.0d0 ) then      
              Vcoupl = VcouplSM * ( 1d0 - dV_new )
              Acoupl = AcouplSM * ( 1d0 - dA_new )
              couplMatrix_new(1:6) = (/ dcmplx(Acoupl**2), dcmplx(Vcoupl**2), dcmplx(1d0), dcmplx(Acoupl*Vcoupl), dcmplx(Acoupl), dcmplx(Vcoupl) /)
              NewValue = couplMatrix_new(1)*CoefFits(1) + couplMatrix_new(2)*CoefFits(2) + couplMatrix_new(3)*CoefFits(3)  &
                      + couplMatrix_new(4)*CoefFits(4) + couplMatrix_new(5)*CoefFits(5) + couplMatrix_new(6)*CoefFits(6)
              write(NewFileName,"(A,A,I2,A,1F4.2,A,1F4.2,A)") trim(filename_out),"_Hi",iHisto,"_V-",dV_new,"_A-",dA_new,".dat"
              if( ibin.eq.1 ) then
                  open(unit=10,file=trim(NewFileName),form='formatted',access='sequential')
              else
                  open(unit=10,file=trim(NewFileName),form='formatted',access='sequential',position='append')
              endif
              write(unit=10,fmt=fmt1) iHisto,dummy,BinVal(1,ibin),dummy,NewValue,dummy,0d0,dummy,0,dummy
!               write(*,"(2X,A,2F10.6,A,A)") "Fitting for (V,A)= (",Vcoupl,Acoupl,"). Filename=",trim(NewFileName)
              close(10)
            endif

        enddo
     enddo

enddo! ibin


END SUBROUTINE




FUNCTION Poisson(nu,n)
! Poisson distribution = exp(-nu)*nu^n/n!
  implicit none
  integer :: nu,n
  real(8) :: Poisson
    
  Poisson=-nu+n*log(1d0*nu)-logfac(n)
  Poisson=exp(Poisson)
  
end FUNCTION POISSON


FUNCTION logfac(N)
  ! log(N!)=log[ (N)(N-1)(N-2)...(2)(1)]=log(N)+log(N-1)+...+log(2)
  implicit none
  integer :: N,i
  real(8) :: logfac
  
  logfac=0d0
  do i=2,N
     logfac=logfac+dlog(1d0*i)
  enddo
  
end FUNCTION logfac










FUNCTION go_Gauss_64(N,matrix)
implicit none
complex(8), intent(in) :: matrix(1:N,1:N+1)
integer, intent(in) :: N
complex(8) :: go_Gauss_64(1:N)
complex(8) :: work(1:N,1:N+1)
integer :: i,j
complex(8) :: mult, tsum

    work(1:N,1:N+1) = matrix(1:N,1:N+1)
    do i = 1,N
      if (cdabs(work(i,i)) <= 1.0e-6) then
         print *, i,N
         print *, "go_Gauss, Zero pivot element: ",cdabs(work(i,i))
      endif
      do j = i+1,N
        mult = work(j,i)/work(i,i)
        work(j,1:N+1) = work(j,1:N+1) - mult*work(i,1:N+1)
      end do
    end do
    do i=N,1,-1
      tsum = work(i,N+1)
      do j=i+1,N
        tsum = tsum - work(i,j)*work(j,N+1)
      end do
      work(i,N+1) = tsum/work(i,i)
    end do
    go_Gauss_64(1:N) = work(1:N,N+1)
    return
END FUNCTION








FUNCTION go_GaussLU(n,A)
implicit none
integer n, perm(1:n)
complex(8) A(1:n,1:n+1)
complex(8) go_GaussLU(n)

      call XLUDecomp(A(1:n,1:n), n, perm(1:n))
      call XLUBackSubst(A(1:n,1:n), n, perm(1:n), A(1:n,n+1))
      go_GaussLU(1:n) = A(1:n,n+1)

END FUNCTION


! * Solution of the linear equation A.x = B by Gaussian elimination
! * with partial pivoting
! * this file is part of LoopTools
! * last modified 24 Jan 06 th
! * Author: Michael Rauch, 7 Dec 2004
! * Reference: Folkmar Bornemann, course notes to
! * Numerische Mathematik 1, Technische Universitaet, Munich, Germany
!
! *#include "defs.h"
!
! *#define MAXDIM 8
!
! ************************************************************************
! * LUDecomp computes the LU decomposition of the n-by-n matrix A
! * by Gaussian Elimination with partial pivoting;
! * compact (in situ) storage scheme
! * Input:
! *   A: n-by-n matrix to LU-decompose
! *   n: dimension of A
! * Output:
! *   A: mangled LU decomposition of A in the form
! *     ( y11 y12 ... y1n )
! *     ( x21 y22 ... y2n )
! *     ( x31 x32 ... y3n )
! *     ( ............... )
! *     ( xn1 xn2 ... ynn )
! *   where
! *     (   1   0 ...   0 )  ( y11 y12 ... y1n )
! *     ( x21   1 ...   0 )  (   0 y22 ... y2n )
! *     ( x31 x32 ...   0 )  (   0   0 ... y3n )  =  Permutation(A)
! *     ( ............... )  ( ............... )
! *     ( xn1 xn2 ...   1 )  (   0   0 ... ynn )
! *   perm: permutation vector


   SUBROUTINE XLUDecomp(A, n, perm)
   implicit none
   integer n, perm(n)
   complex(8) A(n,n)

   integer i, j, k, imax
   complex(8) tmp,czip
   real(8) Amax
   parameter(czip=(0d0,0d0))
   do j = 1, n
! do U part (minus diagonal one)
     do i = 1, j - 1
       do k = 1, i - 1
         A(i,j) = A(i,j) - A(i,k)*A(k,j)
       enddo
     enddo

! do L part (plus diagonal from U case)
     Amax = 0
     do i = j, n
       tmp = czip
       do k = 1, j - 1
         tmp = tmp + A(i,k)*A(k,j)
       enddo
       A(i,j) = A(i,j) - tmp

! do partial pivoting
! find the pivot
       if( abs(A(i,j)) .gt. Amax ) then
         Amax = abs(A(i,j))
         imax = i
       endif
     enddo

! exchange rows
     perm(j) = imax
     do k = 1, n
       tmp = A(j,k)
       A(j,k) = A(imax,k)
       A(imax,k) = tmp
     enddo

! division by the pivot element
     if( A(j,j) .eq. czip ) then
       tmp = dcmplx(1D123)
     else
       tmp = 1/A(j,j)
     endif
     do i = j + 1, n
       A(i,j) = A(i,j)*tmp
     enddo
   enddo
   END SUBROUTINE

! ************************************************************************
! * LUBackSubst computes the x in A.x = b from the LU-decomposed A.
! * Input:
! *   A: LU-decomposed n-by-n matrix A
! *   b: input vector b in A.x = b
! *   n: dimension of A
! *   p: permutation vector from LU decomposition
! * Output:
! *   b: solution vector x in A.x = b

   SUBROUTINE XLUBackSubst(A, n, p, b)
   implicit none
   integer n, p(n)
   complex(8) A(n,n)
   complex(8) b(*)

   integer i, j
   complex(8) tmp

! permute b
   do i = 1, n
     tmp = b(i)
     b(i) = b(p(i))
     b(p(i)) = tmp
   enddo

! forward substitution L.Y = B
   do i = 1, n
     do j = 1, i - 1
       b(i) = b(i) - A(i,j)*b(j)
     enddo
   enddo

! backward substitution U.X = Y
   do i = n, 1, -1
     do j = i + 1, n
       b(i) = b(i) - A(i,j)*b(j)
     enddo
     b(i) = b(i)/A(i,i)
   enddo
   END SUBROUTINE



END PROGRAM












