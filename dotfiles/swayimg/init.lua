-- Configuration for VIEWER mode

-- 1. Delete file (Delete)
swayimg.viewer.on_key("Delete", function()
	local image = swayimg.viewer.get_image()
	if image then
		os.remove(image.path)
		print("Removed: " .. image.path)
	end
end)

-- 2. Set wallpaper (w)
swayimg.viewer.on_key("w", function()
	local image = swayimg.viewer.get_image()
	if image then
		local cmd = string.format('swww img "%s" --transition-type wipe --transition-fps 60', image.path)
		os.execute(cmd)
	end
end)

-- 3. Copying path and showing notification (c)
swayimg.viewer.on_key("c", function()
	local image = swayimg.viewer.get_image()
	if image then
		local cmd =
			string.format('echo -n "%s" | wl-copy && notify-send -u low "Swayimg" "Copied: %s"', image.path, image.path)
		os.execute(cmd)
	end
end)

-- 4. Copy image (Ctrl + c)
swayimg.viewer.on_key("Ctrl+c", function()
	local image = swayimg.viewer.get_image()
	if image then
		local cmd = string.format('wl-copy < "%s"', image.path)
		os.execute(cmd)
	end
end)
