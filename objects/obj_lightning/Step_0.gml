/// @description Insert description here
// You can write your code in this editor

#region Controls to adjust the parameters on the fly (can be deleted)
if (keyboard_check_pressed(ord("Q"))) {
	fire_rate++;
}
if (keyboard_check_pressed(ord("A"))) {
	fire_rate--;
	if (fire_rate <= 0) {
		fire_rate = 1;
	}
}
if (keyboard_check_pressed(ord("W"))) {
	fire_num++;
}
if (keyboard_check_pressed(ord("S"))) {
	fire_num--;
	if (fire_num <= 0) {
		fire_num = 1;
	}
}
#endregion

if (mouse_check_button(mb_left)) {
	
	//	This if statement is only necessary if you want the fire_rate to be triggered
	if (count mod fire_rate == 0) {
		
		//	Set the position for where the lightning should end
		//	you could also set start_x and start_y here to something
		//	if you wanted (like the instance shooting the lightning)
		end_x = mouse_x;
		end_y = mouse_y;
		
		//	Actually shoot the lightning
		ShootLightning();
	}
	
	//	Increase count for the fire_rate
	count++;
}
else {
	//	If the mouse isn't being held, set count to 0, without this,
	//	the lightning may not be as responsive to mouse clicks
	//	Only necessary if you are using the fire_rate
	count = 0;
}