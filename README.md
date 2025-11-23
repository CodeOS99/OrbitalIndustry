
# Orbital Industry

OrbitalIndustry is a game about making an orbital industry!

# Tech Stack

The main game itself was made in [Godot](https://godotengine.org/) and all the 3D models were made by me in [Blender](https://www.blender.org/). And also mspaint for the title screen drone ¯\\_ (ツ)\_/¯

# Making

I built this project mainly to get a bit more experience modelling things, thats why all the assets are made by me. I wanted the game to have more stuff, like I wanted the automatic drones to be actually visibly go and collect resources. However, due to a lack of time, I made this as a proof of concept.

I also wanted different types of minerals, and different methods to collect and use them, but currently there are just rocks.

The placement of rocks is constant and they regenerate after 3 seconds initially. Each rock can give 4 rocks, 2 rocks at one shoot, giving one for each bullet that shoots it from the manual drone.

The whole on screen UI, like the HUD and the computer UI is just a huge hierarchy of control nodes whose visibility is controlled. I didn't have a need for anything more complex, and this works.

The drone has a shader which makes it look a bit better? It has a green overlay and scan lines and stuff.

The shop is implemented by a grid container, whose children are buttons. In the ready function, for every child of the grid container(so every upgrade button), its on click signal is bound to a function with that child's index as an argument. The buttons are checked for if the current amount of rocks is enough to buy its upgrade(its cost is present in a list, with the i-th element giving the price of the i-th upgrade) and if so they are enabled otherwise disabled.

The function of buying upgrades calls another function from an array of functions of outputs of buying the upgrade of the corresponding index.
