

thickness = 5;

width = 146.5;
hight  = 57.4;

sieve_hight = 21;
bottom_space = 13;
top_space = 5;

sieve_width = 140;
slot_width = 2.5;

difference() {    
    top_space = 5;
    stock();
    
    
    bottom_flange();
    side_flanges();
    
    sieve(bottom_space, sieve_hight, slot_width, sieve_width);
}

module stock(){
    cube([width, hight, thickness]);
}

module side_flanges(){
    cube([5, hight, thickness-2]);
    translate([width-5, 0, 0]){
        cube([5, hight, thickness-2]);
    }
}

module bottom_flange(){
        translate([0, 0, thickness-1]){
        cube([width, 3, thickness-1]);
    }
}

module slot(channel_hight, channel_width){
    union(){
        cube([channel_width, channel_hight - channel_width, thickness]);
        translate([channel_width/2, 0, 0]){
            cylinder(h=thickness, d=channel_width, center=false, $fn=50);
            translate([0, channel_hight - channel_width, 0]){
                cylinder(h=thickness, d=channel_width, center=false, $fn=50);
            }  
        }
    }
}                     
    

module sieve(bottom_hight, channel_hight, channel_width, total_width){
    slots = floor( (total_width + channel_width) / (channel_width*2));
    grate_width = channel_width*2*slots - channel_width;
    center = width / 2;
    translate([center - (grate_width/2), bottom_hight, 0]){
        lineup(slots, channel_width*2){
            slot(channel_hight, channel_width);
        }
    }
    overflow(grate_width);
}

module overflow(total_width){
    overflow_hight = hight - sieve_hight - bottom_space - top_space - 3;
    echo("Overflow hight=", overflow_hight);
    space = 3;
    slots  = 4;
    slot_width = (total_width - (( slots - 1) * space)) / slots;
    center = width / 2;
    translate([center - (total_width/2), (hight - top_space - overflow_hight), 0]){
        lineup(slots, slot_width+space){
            overflow_slot(slot_width, overflow_hight);
        }
    }
}

module overflow_slot(slot_width, overflow_hight){
    union(){
        translate([overflow_hight/2, 0, 0]){
            cube([slot_width - overflow_hight, overflow_hight, thickness]);
        }
        translate([overflow_hight/2, overflow_hight/2, 0]){
            cylinder(h=thickness, d=overflow_hight, center=false, $fn=50);
            translate([slot_width - overflow_hight, 0, 0]){
                cylinder(h=thickness, d=overflow_hight, center=false, $fn=50);
            }
        }
    }
}
module lineup(num, space) {
   for (i = [0 : num-1])
     translate([ space*i, 0, 0 ]) children(0);
}