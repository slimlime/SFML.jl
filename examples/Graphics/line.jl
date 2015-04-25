using SFML

window = RenderWindow("Test", 800, 600)
event = Event()

p1 = Vector2f(400, 300)
p2 = Vector2f(5, 5)

line = Line(p1, p2, 10)
set_fillcolor(line, Color(255, 0, 0))

while isopen(window)
	while pollevent(window, event)
		if get_type(event) == EventType.CLOSED
			close(window)
		end
	end

	clear(window, Color(255, 255, 255))
	draw(window, line)
	display(window)
end