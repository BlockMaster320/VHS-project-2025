function Input()
{
	left = keyboard_check(ord("A")) or keyboard_check(vk_left)
	right = keyboard_check(ord("D")) or keyboard_check(vk_right)
	down = keyboard_check(ord("S")) or keyboard_check(vk_down)
	up = keyboard_check(ord("W")) or keyboard_check(vk_up)
	
	escapeButton = keyboard_check_pressed(vk_escape)
}