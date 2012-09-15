// HackHD Parts

include <hackhd_dimensions.scad>

$fn=16;

render_part="hackhd_pcb";
render_part="hackhd_pcb with holes";
render_part="hackhd_body_blank";

module hackhd_pcb_2d() {
  hull() {
    square([hhd_w,hhd_h-hhd_corner_h],center=false);
    translate([hhd_corner_w,hhd_h-hhd_corner_h])
	square([hhd_w-2*hhd_corner_w,hhd_corner_h],center=false);
  }
}

module hackhd_pcb() {
  linear_extrude(height=hhd_pcb_th) hackhd_pcb_2d();
}

if(render_part=="hackhd_pcb") {
  echo("Rendering hackhd_pcb()...");
  hackhd_pcb();
}

module hackhd_cam_bolt_holes_2d() {
  translate([hhd_w-hhd_cam_rel_rhs,hhd_h-hhd_cam_bolts_rel_top]) {
	translate([-hhd_cam_bolts_dx/2,0]) circle(r=hhd_bolt_d/2);
	translate([ hhd_cam_bolts_dx/2,0]) circle(r=hhd_bolt_d/2);
  }
}

module hackhd_anchor_bolt_hole_2d() {
  translate([hhd_w-hhd_anchor_bolt_rel_rhs,hhd_h-hhd_anchor_bolt_rel_top]) circle(r=hhd_bolt_d/2);
}

if(render_part=="hackhd_pcb with holes") {
  linear_extrude(height=hhd_pcb_th) difference() {
    hackhd_pcb_2d();
    hackhd_cam_bolt_holes_2d();
    hackhd_anchor_bolt_hole_2d();
  }
}

module hackhd_terminal_block() {
  translate([hhd_w-hhd_terms_w_rel_rhs,hhd_h-hhd_terms_rel_top,hhd_pcb_th])
    cube([hhd_terms_w_rel_rhs,hhd_terms_h,hhd_terms_rel_bck-hhd_pcb_th],center=false);
}

module hackhd_cam_lens() {
  translate([hhd_w-hhd_cam_rel_rhs,hhd_h-hhd_cam_rel_top,0])
    cylinder(r=hhd_cam_lens_d/2,h=hhd_cam_lens_rel_bck,center=false);
}

module hackhd_microsd() {
  translate([hhd_w-hhd_socket_rel_rhs,hhd_h-hhd_socket_rel_top-hhd_socket_h,hhd_pcb_th])
    cube([hhd_socket_rel_rhs+hhd_socket_dx,hhd_socket_h,hhd_socket_rel_bck-hhd_pcb_th],center=false);
}

module hackhd_mic() {
  translate([hhd_mic_edge_rel_lhs+hhd_mic_d/2,hhd_h-hhd_mic_edge_rel_top-hhd_mic_d/2,hhd_pcb_th])
    cylinder(r=hhd_mic_d/2,h=hhd_mic_rel_bck-hhd_pcb_th,center=false);
}

module hackhd_body_blank() {
  hackhd_pcb();
  hackhd_terminal_block();
  hackhd_cam_lens();
  hackhd_microsd();
  hackhd_mic();
}

if(render_part=="hackhd_body_blank") {
  echo("Rendering hackhd_body_blank()...");
  hackhd_body_blank();
}

