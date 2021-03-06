module ModIntDipoles_QGTTBQP
use ModParameters
use ModProcess
use ModMisc
implicit none
private

public:: EvalIntDipoles_QGTTBQP
integer, parameter  :: dp = selected_real_kind(15)


!       double precision, private, parameter :: NCol=3d0
!       double precision, private, parameter :: TR=0.5d0
!       double precision, private, parameter :: CA=2d0*TR*NCol
!       double precision, private, parameter :: CF=TR*(NCol**2-1d0)/NCol

contains


!-------------------------------------------------------------
!    ordering of the momenta in the p-array:
!     outgoing convention:
!     bar t = 1, photon =2, t=3 ,  incoming quark=4,
!     5=incoming gluon
!-----------------------------------------------------------

      subroutine EvalIntDipoles_QGTTBQP(p,MomDK,z,res)
      use ModIntDipoles
      use ModAmplitudes
      implicit none
      real(dp), intent(in) :: p(4,5),MomDK(1:4,1:6),z
      real(dp), intent(out) :: res(1:2,1:3)
      real(dp) :: dipsoft,dipfini,dipplus,AP(1:3),CF,TR
      type(Particle),save :: ExtParticles1(1:5)
      type(TreeProcess),save :: TreeAmpsDip1(1:2)
      type(Particle),save :: ExtParticles2(1:5)
      type(TreeProcess),save :: TreeAmpsDip2(1:2)
      complex(dp) :: Bm(1:2),mtrsq(2)
      complex(dp) :: AM(1:2,1:2)
      integer :: iTree,i1,i2,i3,i4,i5,i,j,i6,n
      integer :: hel(1:5),emi , Nmax(5)
      character(2) :: diptype
      real(dp) :: Cup(1:2,1:2),Cdn(1:2,1:2),C(1:2,1:2),epcorr
      logical, save :: first_time1 = .true.
      logical, save :: first_time2 = .true.
      real,parameter :: PhotonCouplCorr=2d0

      real(dp) :: MG_MOM(0:3,1:5),MadGraph_tree

      res(1:2,1:3) = zero
      CF=4d0/3d0
      TR = 0.5d0

         Nmax = 1

        if (TopDecays.ge.1) then
            Nmax(1) = -1
            Nmax(3) = -1
        endif

       if( first_time1 ) then   ! q-> g splitting, with gg->ttgam process
              call InitTrees(2,3,2,TreeAmpsDip1)
              call InitProcess_TbTGGG(ExtParticles1(1:5))
             TreeAmpsDip1(1)%PartRef(1:5) = (/1,5,2,3,4/)
             TreeAmpsDip1(2)%PartRef(1:5) = (/1,5,2,4,3/)
             do iTree=1,2
             call LinkTreeParticles(TreeAmpsDip1(iTree),ExtParticles1(1:5))
             enddo
             first_time1=.false.
      endif

      call cc_gg_ttgam(C)


!--- after momentum mapping -- sum over colors and polarizations


        mtrsq = 0d0

       do i1=-1,Nmax(1),2
         do i2 = -1,Nmax(2),2
           do i3 = -1,Nmax(3),2
             do i4 = -1,Nmax(4),2
               do i5 = -1,Nmax(5),2

          hel(1) = i1
          hel(2) = i2
          hel(3) = i3
          hel(4) = i4
          hel(5) = i5

  call GenerateEvent52((/p(1:4,1),p(1:4,3),p(1:4,4),p(1:4,5),p(1:4,2)/), &
  momDK(1:4,1:6),(/hel(1),hel(3),hel(4),hel(5),hel(2)/),ExtParticles1(1:5))


          do i6 = 1,2
              call EvalTree2(TreeAmpsDip1(i6),Bm(i6))
          enddo

          do i=1,2
          do j=1,2
              mtrsq(1) =  mtrsq(1) + C(i,j)*Bm(i)*dconjg(Bm(j))
          enddo
          enddo

      enddo
      enddo
      enddo
      enddo
      enddo

! spin & color avg., color convention adjustment
      mtrsq(1) = mtrsq(1) * alpha_s4Pi**2 * alpha4Pi * Q_top**2 /4d0/64d0 * PhotonCouplCorr
      mtrsq(2) = mtrsq(1) ! here was a bug: this line was missing, q-> g splitting for down quarks


! !      MADGRAPH CHECK: gg->ttbp
!        MG_MOM(0:3,1) =-p(1:4,4)*100d0
!        MG_MOM(0:3,2) =-p(1:4,5)*100d0
!        MG_MOM(0:3,3) = p(1:4,3)*100d0
!        MG_MOM(0:3,4) = p(1:4,1)*100d0
!        MG_MOM(0:3,5) = p(1:4,2)*100d0
!        call coupsm(0)
!        call SGG_TTBA(MG_MOM,MadGraph_tree)
!        print *,MadGraph_tree*(100d0)**2
!        print *,mtrsq(1)
!        print *, mtrsq(1)/MadGraph_tree/(100d0)**2
!        pause



      res = 0d0

      dipsoft =ii_qg(zero,zero,p,4,5,z,1)*2d0*CF
      dipfini =ii_qg(zero,zero,p,4,5,z,2)*2d0*CF
      dipplus =ii_qg(zero,zero,p,4,5,z,3)*2d0*CF
      emi = 1 ! mom #3 is emitting

!       if(emi.eq.1) then
        res(:,1) = res(:,1) + (dipsoft-dipplus)*mtrsq(:)*alpha_sOver2Pi*0.5d0! overall normalization: alpha_s/4pi
        res(:,2) = res(:,2) + (dipfini+dipplus)*mtrsq(:)*alpha_sOver2Pi*0.5d0
!       endif
!       if(emi.eq.2) then
!         res(:,1) = res(:,1) + (dipsoft-dipplus)*mtrsq(:)
!         res(:,3) = res(:,3) + (dipfini+dipplus)*mtrsq(:)
!       endif
!       if(emi.eq.3) then
!         res(:,1) = res(:,1) + (dipsoft-dipplus)*mtrsq(:)
!         res(:,2) = res(:,2) + (dipfini+dipplus)*0.5_dp*mtrsq(:)
!         res(:,3) = res(:,3) + (dipfini+dipplus)*0.5_dp*mtrsq(:)
!       endif


! print *, "1u",res(1,1:3)
! print *, "1d",res(2,1:3)


     epcorr = epinv
     AP(1)= 0d0
     AP(2)= CF*(1d0+(1d0-z)**2)/z*mtrsq(1)*alpha_sOver2Pi*epinv
     AP(3)= 0d0

     res(1:2,1) = res(1:2,1) + (AP(1)-AP(3)) ! here was a bug:  q-> g splitting for down quarks was missing
     res(1:2,2) = res(1:2,2) + (AP(2)+AP(3))
     res(1:2,3) = 0d0


! print *, "2u",res(1,1:3)
! print *, "2d",res(2,1:3)






!-- ---- NEXT DIPOLE

       if( first_time2 ) then   ! g -> qb splitting, with q qb->ttgam process
              call InitTrees(4,1,2,TreeAmpsDip2)
              call InitProcess_TbTQbQG(ExtParticles2(1:5))
             TreeAmpsDip2(1)%PartRef(1:5) = (/1,5,2,3,4/)
             TreeAmpsDip2(2)%PartRef(1:5) = (/1,2,3,5,4/)
             do iTree=1,2
             call LinkTreeParticles(TreeAmpsDip2(iTree),ExtParticles2(1:5))
             enddo
             first_time2=.false.
      endif

      call cc_qq_ttgam('up',Cup)
      call cc_qq_ttgam('dn',Cdn)


        mtrsq = 0d0

       do i1=-1,Nmax(1),2
         do i2 = -1,Nmax(2),2
           do i3 = -1,Nmax(3),2
             do i4 = -1,Nmax(4),2
               do i5 = -1,Nmax(5),2

          hel(1) = i1
          hel(2) = i2
          hel(3) = i3
          hel(4) = i4
          hel(5) = i5

  call GenerateEventttqqg2((/p(1:4,1),p(1:4,3),p(1:4,4),p(1:4,5),p(1:4,2)/), &
  momDK(1:4,1:6),(/hel(1),hel(3),hel(4),hel(5),hel(2)/),ExtParticles2(1:5))

          do i6 = 1,2
              call EvalTree2(TreeAmpsDip2(i6),Bm(i6))
          enddo

          do i=1,2
          do j=1,2
              mtrsq(1) =  mtrsq(1) + Cup(i,j)*real(Bm(i)*dconjg(Bm(j)),dp)
              mtrsq(2) =  mtrsq(2) + Cdn(i,j)*real(Bm(i)*dconjg(Bm(j)),dp)
          enddo
          enddo


      enddo
      enddo
      enddo
      enddo
      enddo

! spin & color avg., color convention adjustment
      mtrsq = mtrsq * alpha_s4Pi**2 * alpha4Pi *Q_top**2 /4d0/9d0 * PhotonCouplCorr


! !      MADGRAPH CHECK: qqb->ttbp
!        MG_MOM(0:3,1) =-p(1:4,4)*100d0
!        MG_MOM(0:3,2) =-p(1:4,5)*100d0
!        MG_MOM(0:3,3) = p(1:4,3)*100d0
!        MG_MOM(0:3,4) = p(1:4,1)*100d0
!        MG_MOM(0:3,5) = p(1:4,2)*100d0
!        call coupsm(0)
!        call SDDB_TTBA(MG_MOM,MadGraph_tree)
!        print *,MadGraph_tree*(100d0)**2
!        print *,mtrsq(2)
!        print *, mtrsq(2)/MadGraph_tree/(100d0)**2
!        pause


      dipsoft =ii_gq(zero,zero,p,5,4,z,1) *2d0  ! factor 2d0 fixes normalization for ii_gq dipole
      dipfini =ii_gq(zero,zero,p,5,4,z,2) *2d0
      dipplus =ii_gq(zero,zero,p,5,4,z,3) *2d0
      diptype ='ii'
      emi = 2 !

!       if(emi.eq.2) then
         res(:,1) = res(:,1) + (dipsoft-dipplus)*mtrsq(:) * alpha_sOver2Pi*0.5d0   ! overall normalization: alpha_s/4pi
         res(:,3) = res(:,3) + (dipfini+dipplus)*mtrsq(:) * alpha_sOver2Pi*0.5d0   ! overall normalization: alpha_s/4pi
!       endif

! print *, "3u",res(1,1:3)
! print *, "3d",res(2,1:3)

! !        epcorr=epinv+2d0*dlog(renscale/facscale)
          epcorr=epinv
          AP(1)= 0d0
          AP(2)= TR*(z**2+(1d0-z)**2)* alpha_sOver2Pi *epcorr
          AP(3)= 0d0

          res(1:2,1) = res(1:2,1) + (AP(1)-AP(3))*mtrsq(1:2)
          res(1:2,2) = res(1:2,2)
          res(1:2,3) = res(1:2,3) + (AP(2)+AP(3))*mtrsq(1:2)


! print *, "4u",res(1,1:3)
! print *, "4d",res(2,1:3)
! pause

  return
  end subroutine








      subroutine cc_gg_ttgam(C)
      real(dp), intent(out) :: C(2,2)


       C(1,1) = 64.0_dp/3.0_dp
       C(1,2) =  - 8.0_dp/3.0_dp
       C(2,1) =  - 8.0_dp/3.0_dp
       C(2,2) = 64.0_dp/3.0_dp

      end subroutine cc_gg_ttgam




      subroutine cc_qq_ttgam(ixq,C)
      character, intent(in) :: ixq*2
      real(dp), intent(out) :: C(2,2)

      C = 0.0_dp

      if (ixq.eq.'up') then
       C(1,1)  =  8.0_dp
       C(1,2)  =  8.0_dp*Q_up/Q_top
       C(2,1)  =  8.0_dp*Q_up/Q_top
       C(2,2)  =  8.0_dp*Q_up**2/Q_top**2

       elseif(ixq.eq.'dn') then
       C(1,1)  =  8.0_dp
       C(1,2)  =  8.0_dp*Q_dn/Q_top
       C(2,1)  =  8.0_dp*Q_dn/Q_top
       C(2,2)  =  8.0_dp*Q_dn**2/Q_top**2
       endif

      end subroutine


end  module
