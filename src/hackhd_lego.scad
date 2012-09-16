// HackHD LEGO-compatible carrier

include <hackhd_dimensions.scad>
$fn=16;
use <hackhd_parts.scad>

render_part="lattice_holes";
render_part="hhd_frame";

lego_peg_d=4.9;
lego_unit_xy=8.0;
lego_unit_3rd_h=3.2;
lego_unit_h=10.0;
lego_unit_peg_h=1.8;
lego_unit_socket_h=2.0;
m1p8_bolt_d=1.75;

module lattice_holes(xn,yn,zn,hole_d=0.5) {
  echo(str("lattice_holes(xn=",xn,",yn=",yn,",zn=",zn));
  for(zk=[0:zn]) translate([0,0,zk*lego_unit_h/3]) {
    for(xi=[0:xn]) translate([xi*lego_unit_xy,-hole_d,0]) rotate([-90,0,0]) if(zk==0 || zk>=zn-1 || zk%2==0) {
      cylinder($fn=4,r=hole_d/2,h=2*hole_d+yn*lego_unit_xy,center=false);
    }
    for(yj=[0:yn]) translate([-hole_d,yj*lego_unit_xy,0]) rotate([0,90,0]) if(zk==0 || zk>=zn-1 || zk%2==1) {
      cylinder($fn=4,r=hole_d/2,h=2*hole_d+xn*lego_unit_xy,center=false);
    }
  }
  for(xi=[0:xn],yj=[0:yn]) translate([xi*lego_unit_xy,yj*lego_unit_xy,-hole_d]) {
    cylinder($fn=4,r=hole_d/2,h=zn*lego_unit_h/3+2*hole_d,center=false);
  }
  for(xi=[0:xn-1],yj=[0:yn-1]) translate([(xi+0.5)*lego_unit_xy,(yj+0.5)*lego_unit_xy,-hole_d]) {
    cylinder($fn=4,r=hole_d/2,h=(zn+1)*lego_unit_h/3+2*hole_d,center=false);
  }
}

if(render_part=="lattice_holes") {
  echo("Rendering lattice_holes()...");
  lattice_holes(xn=20,yn=30,zn=6);
}


module hhd_frame(grow_pcb=0.2,show_hhd=false) {
  // Frame relative to camera PCB base at [0,0,0]
  lu2side=(hhd_cam_rel_rhs+lego_unit_xy-(hhd_cam_rel_rhs+lego_unit_xy)%lego_unit_xy)/lego_unit_xy; // lego units to side
  lu2top= (hhd_cam_rel_top+lego_unit_xy-(hhd_cam_rel_top+lego_unit_xy)%lego_unit_xy)/lego_unit_xy; // lego units to top
  hhd_cam2bot=hhd_h-hhd_cam_rel_top;
  lu2bot=(hhd_cam2bot+lego_unit_xy-(hhd_cam2bot+lego_unit_xy)%lego_unit_xy)/lego_unit_xy; // lego units to bottom
  echo("lu2side: ",lu2side);
  echo(" lu2top: ",lu2top);
  echo(" lu2bot: ",lu2bot);
  difference() {
    translate([-(lu2side+1)*lego_unit_xy,-(lu2bot+1)*lego_unit_xy,-lego_unit_h]) difference() {
      cube([2*(lu2side+1)*lego_unit_xy,(lu2top+lu2bot+2)*lego_unit_xy,lego_unit_h],center=false);
      lattice_holes(xn=2*(lu2side+1),yn=(lu2top+lu2bot+2),zn=lego_unit_h/3);
    }
    translate([-hhd_cam_rel_rhs,-hhd_h+hhd_cam_rel_top,-2*lego_unit_h/3]) linear_extrude(height=3*lego_unit_3rd_h)
	minkowski() {
	  hackhd_pcb_2d();
	  circle($fn=8,r=grow_pcb/2);
	}
    translate([0,hhd_cam_rel_rhs-hhd_anchor_bolt_rel_top,-lego_unit_h-grow_pcb]) cylinder(r=m1p8_bolt_d/2,h=lego_unit_h+2*grow_pcb,center=false);
    translate([-hhd_cam_bolts_dx/2,0,-lego_unit_h-grow_pcb]) cylinder(r=m1p8_bolt_d/2,h=lego_unit_h+2*grow_pcb,center=false);
    translate([ hhd_cam_bolts_dx/2,0,-lego_unit_h-grow_pcb]) cylinder(r=m1p8_bolt_d/2,h=lego_unit_h+2*grow_pcb,center=false);
  }
  translate([-hhd_cam_bolts_dx/2,0,-2*lego_unit_h/3]) difference() {
    union() {
      cylinder(r=hhd_bolt_surround_d/2,h=2*lego_unit_h/3-hhd_pcb_th,center=false);
      cylinder(r1=lego_unit_h/3+hhd_bolt_surround_d/2,r2=hhd_bolt_surround_d/2,h=lego_unit_h/3,center=false);
    }
    cylinder(r=m1p8_bolt_d/2,h=2*lego_unit_h/3,center=false);
  }
  translate([hhd_cam_bolts_dx/2,0,-2*lego_unit_h/3]) difference() {
    union() {
      cylinder(r=hhd_bolt_surround_d/2,h=2*lego_unit_h/3-hhd_pcb_th,center=false);
      cylinder(r1=lego_unit_h/3+hhd_bolt_surround_d/2,r2=hhd_bolt_surround_d/2,h=lego_unit_h/3,center=false);
    }
    cylinder(r=m1p8_bolt_d/2,h=2*lego_unit_h/3,center=false);
  }
  translate([0,hhd_cam_rel_rhs-hhd_anchor_bolt_rel_top,-2*lego_unit_h/3]) difference() {
    union() {
      cylinder(r=hhd_bolt_surround_d/2,h=2*lego_unit_h/3-hhd_pcb_th,center=false);
      cylinder(r1=lego_unit_h/3+hhd_bolt_surround_d/2,r2=hhd_bolt_surround_d/2,h=lego_unit_h/3,center=false);
    }
    cylinder(r=m1p8_bolt_d/2,h=2*lego_unit_h/3,center=false);
  }
  for(iy=[-lu2bot:lu2top]) {
    translate([-(lu2side+0.5)*lego_unit_xy,(iy-0.5)*lego_unit_xy,0]) difference() {
	cylinder(r=lego_peg_d/2,h=lego_unit_peg_h,center=false);
	translate([0,0,-grow_pcb]) cylinder($fn=4,r=grow_pcb/2,h=lego_unit_peg_h+2*grow_pcb,center=false);
    }
    translate([(lu2side+0.5)*lego_unit_xy,(iy-0.5)*lego_unit_xy,0]) difference() {
	cylinder(r=lego_peg_d/2,h=lego_unit_peg_h,center=false);
	translate([0,0,-grow_pcb]) cylinder(r=grow_pcb/2,h=lego_unit_peg_h+2*grow_pcb,center=false);
    }
  }
  for(ix=[0:2*lu2side+1]) {
    translate([-(lu2side+0.5)*lego_unit_xy+ix*lego_unit_xy,(lu2top+0.5)*lego_unit_xy,0]) difference() {
	cylinder(r=lego_peg_d/2,h=lego_unit_peg_h,center=false);
	translate([0,0,-grow_pcb]) cylinder(r=grow_pcb/2,h=lego_unit_peg_h+2*grow_pcb,center=false);
    }
  }
  if(show_hhd==true) {
    translate([-hhd_cam_rel_rhs,-hhd_h+hhd_cam_rel_top,0]) % hackhd_body_blank();
  }
}

if(render_part=="hhd_frame") {
  echo("Rendering hhd_frame()...");
  translate([0,0,lego_unit_h]) hhd_frame(show_hhd=true);
}

