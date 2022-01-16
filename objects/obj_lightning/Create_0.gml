/// @description Insert description here
// You can write your code in this editor

//	How often the lightning should fire when the mouse is held down (10 = once every 10 frames)
fire_rate = 10;
//	How many "main" lightning beams should be created
fire_num = 1;

//	The width of the sprite the lightning uses
lightning_section_width = sprite_get_width(spr_lightning);
//	The minimum scale of lightning_section_width that each little part of the lightning can be
lightning_section_min_scale = 0.25;
//	The maximum scale as above
lightning_section_max_scale = 2;
//	The variance in direction the lightning can take (the higher this is, the more likely the lightning is to fail at reaching it's end point, < 180 will -usually- succeed)
lightning_section_random_direction = 75;

//	The maximum total length a branch can be (multiplied by the lightning section width)
branch_total_max_len = 4;
//	The minimum total length a branch can be
branch_total_min_len = 1;
//	The minimum scale a section of a branch can be
branch_min_scale = 0.5;
//	The maximum scale a section of a branch can be
branch_max_scale = 2;
//	The amount the width of a branch shrinks by each time it branches
branch_shrink = 0.75;
//	The initial chance of a branch to happen (25 = 25% per lightning section)
branch_chance = 25;
//	The variance in direction a branch can take (this cares not for your limits, unlike the lightning section direction)
branch_random_direction = 45;
//	The max times an initial branch can branch again
branch_max = 10;

//	The starting position of the beam
start_x = 5;
start_y = 5;

//	The ending position of the beam (set to the mouse when clicked in the step event
end_x = undefined;
end_y = undefined;

#region Code stuff
count = 0;

///@func	Branch(x,y,dir,yscale,sprw,branches)
Branch = function(_x,_y,_dir,_yscale,_sprw,_branches) {
	if (_branches > branch_max) {
		exit;
	}
	if (random(100) < branch_chance/(_branches+1)) {
		_branches++;
		// Branch
		var _total_len = _sprw * random_range(branch_total_min_len,branch_total_max_len);
		var _bdir;
		_bdir = _dir + choose(-branch_random_direction,branch_random_direction) + random_range(-branch_random_direction,branch_random_direction);
		var _bx = _x;
		var _by = _y;
		while (point_distance(_x,_y,_bx,_by) < _total_len) {
			var inst = instance_create_layer(_bx,_by,layer,obj_lightning_part);
			inst.image_angle = _bdir;
			inst.image_yscale = _yscale;
			var _scale = random_range(branch_min_scale,branch_max_scale);
			inst.image_xscale = _scale;
			if (point_distance(_x,_y,_bx,_by) > _total_len/2) {
				repeat(2) {
					Branch(_bx,_by,_bdir,_yscale*branch_shrink,_sprw,_branches);
				}
			}
			_bx += lengthdir_x(_sprw*_scale,_bdir);
			_by += lengthdir_y(_sprw*_scale,_bdir);
			_bdir += random_range(-branch_random_direction,branch_random_direction);
		}
	}
}

///@func	ShootLightning()
ShootLightning = function() {
	var _sprw = lightning_section_width;
	repeat(fire_num) {
		var _attempts = 0;
		var xx = start_x;
		var yy = start_y;
		var _start_dir = point_direction(xx,yy,end_x,end_y);
		var _dir = _start_dir+random_range(-lightning_section_random_direction,lightning_section_random_direction);
		while (point_distance(xx,yy,end_x,end_y) > 1) {
			var inst = instance_create_layer(xx,yy,layer,obj_lightning_part);
			var _scale = random_range(lightning_section_min_scale,lightning_section_max_scale);
			inst.image_xscale = _scale;
			inst.image_angle = _dir;
			var nx = xx+lengthdir_x(_sprw*_scale,_dir);
			var ny = yy+lengthdir_y(_sprw*_scale,_dir);
			var _end_dir = point_direction(nx,ny,end_x,end_y);
			if (point_distance(nx,ny,end_x,end_y) > _sprw) {
				_dir = _end_dir+random_range(-lightning_section_random_direction,lightning_section_random_direction);
				xx = nx;
				yy = ny;
				Branch(xx,yy,_dir,branch_shrink,_sprw,0);
			}
			else {
				var inst = instance_create_layer(nx,ny,layer,obj_lightning_part);
				inst.image_angle = _end_dir;
				inst.image_xscale = point_distance(nx,ny,end_x,end_y)/_sprw;
				xx = end_x;
				yy = end_y;
			}
			_attempts++;
			if (_attempts > 10000) {
				break;
			}
		}
	}
}
#endregion