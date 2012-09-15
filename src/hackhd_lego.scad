// HackHD LEGO-compatible carrier

include <hackhd_dimensions.scad>
$fn=16;
use <hackhd_parts.scad>

render_part="hhd_frame";

lego_peg_d=4.9;
lego_unit_xy=8.0;
lego_unit_3rd_h=3.2;
lego_unit_h=10.0;
lego_unit_peg_h=1.8;
lego_unit_socket_h=2.0;

module hhd_frame(show_hhd=false) {
  // Frame relative to camera PCB base at [0,0,0]
  lu2side=(hhd_cam_rel_rhs+lego_unit_xy-(hhd_cam_rel_rhs+lego_unit_xy)%lego_unit_xy)/lego_unit_xy; // lego units to side
  lu2top= (hhd_cam_rel_top+lego_unit_xy-(hhd_cam_rel_top+lego_unit_xy)%lego_unit_xy)/lego_unit_xy; // lego units to top
  hhd_cam2bot=hhd_h-hhd_cam_rel_top;
  lu2bot=(hhd_cam2bot+lego_unit_xy-(hhd_cam2bot+lego_unit_xy)%lego_unit_xy)/lego_unit_xy; // lego units to bottom
  echo("lu2side: ",lu2side);
  echo(" lu2top: ",lu2top);
  echo(" lu2bot: ",lu2bot);
  difference() {
    translate([-(lu2side+1)*lego_unit_xy,-(lu2bot+1)*lego_unit_xy,-lego_unit_3rd_h])
      cube([2*(lu2side+1)*lego_unit_xy,(lu2top+lu2bot+2)*lego_unit_xy,lego_unit_3rd_h],center=false);
    translate([-hhd_cam_rel_rhs,-hhd_h+hhd_cam_rel_top,-2*lego_unit_3rd_h]) linear_extrude(height=3*lego_unit_3rd_h)
	hackhd_pcb_2d();
  }
  for(iy=[-lu2bot:lu2top]) {
    translate([-(lu2side+0.5)*lego_unit_xy,(iy-0.5)*lego_unit_xy,0]) cylinder(r=lego_peg_d/2,h=lego_unit_peg_h,center=false);
    translate([(lu2side+0.5)*lego_unit_xy,(iy-0.5)*lego_unit_xy,0]) cylinder(r=lego_peg_d/2,h=lego_unit_peg_h,center=false);
  }
  for(ix=[0:2*lu2side+1]) {
    translate([-(lu2side+0.5)*lego_unit_xy+ix*lego_unit_xy,(lu2top+0.5)*lego_unit_xy,0]) cylinder(r=lego_peg_d/2,h=lego_unit_peg_h,center=false);
  }
  if(show_hhd==true) {
    translate([-hhd_cam_rel_rhs,-hhd_h+hhd_cam_rel_top,0]) % hackhd_body_blank();
  }
}

if(render_part=="hhd_frame") {
  echo("Rendering hhd_frame()...");
  hhd_frame(show_hhd=true);
}

