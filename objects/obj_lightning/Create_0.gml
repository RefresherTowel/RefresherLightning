/// @description Insert description here
// You can write your code in this editor

//	How often the lightning should fire when the mouse is held down (10 = once every 10 frames)
fire_rate = 10;
//	How many "main" lightning beams should be created
fire_num = 1;

//	The starting position of the beam
start_x = room_width div 2;
start_y = room_height div 2;

//	The ending position of the beam (set to the mouse when clicked in the step event
end_x = undefined;
end_y = undefined;

#region Code stuff
count = 0;

///@func	Branch(x,y,dir,yscale,sprw,branches)
Branch = function(_x,_y,_dir,_yscale,_sprw,_branches) {
	if (_branches > 3) {
		exit;
	}
	if (random(100) < 15/(_branches+1)) {
		_branches++;
		// Branch
		var _total_len = _sprw * random_range(1,2.5);
		var _bdir;
		_bdir = _dir + choose(-45,45) + random_range(-45,45);
		var _bx = _x;
		var _by = _y;
		while (point_distance(_x,_y,_bx,_by) < _total_len) {
			var inst = instance_create_layer(_bx,_by,layer,obj_lightning_part);
			inst.image_angle = _bdir;
			inst.image_yscale = _yscale * 0.75;
			var _scale = random_range(0.5,1);
			inst.image_xscale = _scale;
			repeat(2) {
				Branch(_bx,_by,_bdir,_yscale*0.5,_sprw,_branches);
			}
			_bx += lengthdir_x(_sprw*_scale,_bdir);
			_by += lengthdir_y(_sprw*_scale,_bdir);
			_bdir += random_range(-45,45);
		}
	}
}

///@func	ShootLightning()
ShootLightning = function() {
	repeat(fire_num) {
		var xx = start_x;
		var yy = start_y;
		var _start_dir = point_direction(xx,yy,end_x,end_y);
		var _dir = _start_dir+random_range(-45,45);
		var _sprw = sprite_get_width(spr_lightning);
		while (point_distance(xx,yy,end_x,end_y) > 1) {
			var inst = instance_create_layer(xx,yy,layer,obj_lightning_part);
			var _scale = random_range(0.5,1);
			inst.image_xscale = _scale;
			inst.image_angle = _dir;
			var nx = xx+lengthdir_x(_sprw*_scale,_dir);
			var ny = yy+lengthdir_y(_sprw*_scale,_dir);
			var _end_dir = point_direction(nx,ny,end_x,end_y);
			if (point_distance(nx,ny,end_x,end_y) > 16) {
				_dir = _end_dir+random_range(-45,45);
				xx = nx;
				yy = ny;
				Branch(xx,yy,_dir,0.75,_sprw,0);
			}
			else {
				var inst = instance_create_layer(nx,ny,layer,obj_lightning_part);
				inst.image_angle = _end_dir;
				inst.image_xscale = point_distance(nx,ny,end_x,end_y)/_sprw;
				xx = end_x;
				yy = end_y;
			}
		}
	}
}
#endregion