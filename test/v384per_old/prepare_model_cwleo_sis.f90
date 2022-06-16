program prepare_model_cwleo_sis

  use const, only : dp, ch, cc, cpi, cmsun, cmh, cyear

  implicit none
  integer (kind=4) :: n, k
  real (kind=dp) :: rin, rcore, rout2, rout1, rout, dlogr, tcore, mloss
  real (kind=dp), allocatable, dimension(:) :: r, nh2, abund, tgas, vtb, dust, tdust, vel

  n=200

  allocate(r(n), nh2(n), abund(n), tgas(n), vtb(n), dust(n), tdust(n), vel(n))

  rcore= 3.7e13_dp
  rin=      5.0_dp*rcore
  rout1=   20.0_dp*rcore
  rout2=   50.0_dp*rcore
  rout=  2000.0_dp*rcore
  tcore= 2330.0_dp
  mloss= 1.6e-5_dp ! 2.1e-5_dp
  
  
  dlogr= (log10(rout)- log10(rcore))/ dble(n-1)
  
  write(*,'(a)') "CW Leo SiS Model of the envelope based on Fonfria et al."
  write(*,'(a)') "Species = SiS"
  write(*,'("Ncell   = ", i3)') n
  write(*,*)
  write(*,'("      r/cm         n(h2)/cc     [mol]/[H2]     T_gas/K        radial      microturb   dust-to-gas     T_dust/K")')
  write(*,'("                                                            velocity      / km/s")')
  write(*,'("                                                            / km/s       ")')


  do k= n, 1, -1
  
  r(k)= rcore*10.0_dp**(dlogr*(k-1))

  ! * Fonfria
  if (r(k).lt.rin) vel(k)= 1.0_dp+ 2.5_dp*(r(k)/ rcore- 1.0_dp)
  if (r(k).ge.rin .and.r(k).lt.rout1) vel(k)= 11.0_dp
  ! * msc
  if (r(k).lt.2.0_dp*rcore) vel(k)= 1.0_dp
  if (r(k).ge.2.0_dp*rcore .and. r(k).lt.rin) vel(k)= 1.0_dp+ 10.0_dp/ 3.0_dp* (r(k)/ rcore- 2.0_dp)
  if (r(k).ge.rin .and.r(k).lt.rout1) vel(k)= 11.0_dp  
  ! ** variant Fonfria (?)
  ! if (r(k).ge.rout1 .and.r(k).lt.(rout1+0.5*rcore)) vel(k)= 11.0_dp+(3.5_dp)/0.5_dp*(r(k)-rout1)/rcore
  ! ** variant msc
  if (r(k).ge.rout1 .and.r(k).lt.(rout1+10.0*rcore)) vel(k)= 11.0_dp+(3.5_dp)/10.0_dp*(r(k)-rout1)/rcore
  if (r(k).ge.(rout1+10.0*rcore)) vel(k)=14.5_dp

  ! * deBeck
  if (r(k).lt.9.0*rcore) tgas(k)= tcore* (rcore/r(k))**0.58
  if (r(k).ge.9.0*rcore .and. r(k).lt.65.0*rcore) tgas(k)= tcore*(1.0_dp/9.0_dp)**0.58*(9.0_dp*rcore/r(k))**0.40
  if (r(k).ge.65.0*rcore) tgas(k)= tcore*(1.0_dp/9.0_dp)**0.58*(9.0_dp/65.0_dp)**0.40*(65.0_dp*rcore/r(k))**1.2
  tgas(k)= max( tgas(K), 5.0_dp)

  if (r(k).lt.rin) abund(k)= 4.9e-6_dp
  ! * Fonfria
  if (r(k).ge.rin   .and. r(k).lt.rout1) abund(k)= 4.9e-6_dp- 3.3e-6_dp/(rout1- rin)*(r(k)- rin)
  if (r(k).ge.rout1 .and. r(k).lt.rout2) abund(k)= 1.6e-6_dp- 0.3e-6_dp/(rout2- rout1)*(r(k)- rout1)
  if (r(k).ge.rout2) abund(k)= 1.3e-6_dp
  ! * msc
  if (r(k).ge.rin   .and. r(k).lt.rout1) abund(k)= 4.9e-6_dp- 4.6e-6_dp/(rout1- rin)*(r(k)- rin)
  if (r(k).ge.rout1 .and. r(k).lt.rout2) abund(k)= 0.3e-6_dp- 0.25e-6_dp/(rout2- rout1)*(r(k)- rout1)
  if (r(k).ge.rout2) abund(k)= 0.25e-6_dp

  ! mu is 1.40 starting from May 25, 18.46
  nh2(k)= mloss*cmsun/cyear/ (4.0*cpi*1.40_dp*2.0_dp*cmh*vel(k)*1.0e5_dp*r(k)*r(k))

  vtb(k)= 1.0
  if (r(k).lt.5.0*rcore) vtb(k)= 5.0_dp*(rcore/r(k))
  !vtb(k)= 2.0
  !if (r(k).lt.2.5*rcore) vtb(k)= 5.0_dp*(rcore/r(k))
  !vtb(k)= 1.5
  !if (r(k).lt.(5./1.5*rcore)) vtb(k)= 5.0_dp*(rcore/r(k))

  dust(k)= 0.0
  if (r(k).gt.rin) dust(k)=1.0

  tdust(k)= 825.0* (rin/r(k))**0.39

  write(*,'(1p,8(e13.6,1x))') r(k), nh2(k), abund(k), tgas(k), vel(k), vtb(k), dust(k), tdust(k)

  enddo


  deallocate(r, nh2, abund, tgas, vtb, dust, tdust, vel)

end program prepare_model_cwleo_sis
