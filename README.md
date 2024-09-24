Turn your pixel image into a 3d multimesh!

Use a blank white (or any color) image, trace some path with another color on the image, and import that image into the project. 
Attach the script PixelImageToMultimesh to a MultiMeshInstance3D, create a mesh, choose the color you want the mesh to appear on, click on "Regenerate Blueprint" in the inspector, and you got yourself several quickly-placed meshes!
(This is just a generic step-by-step, there is a more detailed one in the aforementioned script)
There are a lot of variables you can change in the inspector like positioning, scaling, rotation, and even add collision! 

This can be used to prototype levels for a game without needing to place the assets manually, or even going into the editor really. I used it to spawn tons of trees and shrubs on the ground as well as generate walls for a level for this example

Here's an introduction video that shows some of the various functionality of the script.

https://github.com/user-attachments/assets/252225f9-eaab-4fd3-a2d9-7589d52c0818

If you are interested in collisions, here is another video to show how you can do that.

https://github.com/user-attachments/assets/8bc0a606-73c3-402a-94f5-5c301f8a6e8e

Took inspiration from a similar tool I saw online but couldn't find it anymore. Feel free to use this code as I won't be making any changes to it.
(Note: There is a ton of unnecessary stuff in the project, I didn't bother to clean it up.)
