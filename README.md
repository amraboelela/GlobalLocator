# GlobalLocator-iOS

## GL benefits if used in aviation 
Using GlobalLocator code can make airplane navigation much easier, as the code is a location and a name at the same time, so can be used to name airports / waypoints.

For example if I am going from San Francisco (GL: 5Q3QW0) to Florida airport (GL: 8MRQEY), from the 2 codes I can estimate the distance between both airports, which is 8-5 = 3 times 750 miles = 2250 east and M - Q = -3 times 325 = 975 miles south. Direct distance = sqrt(2250^2 + 975^2) = 2452 miles. The actual direct flight distance is 2481 miles, which is pretty close to our estimate. We know all of these info from just the code.

Another benefit is that the GL code is easier to communicate between pilots and ATC, as you only need 6 digits, vs. 12 digits in case of Latitude and Langitude numbers.

E.g. if we use GL codes to name waypoints, we can know from its name, how far we are to that waypoint. E.g. if I am at SFO with my location is 5Q3QW0, and the ATC told me as a pilot to fly to waypoint 5Q3QW8, I know that I just need to go north (8 - 0) * 0.35 = 3 miles. Then if they tell me to go waypoint 5Q3QZ8, then that means I need to go (Z - W) * 0.7 = 2.1 miles east.

### Location shortcut
If my location is 5Q3QW0 and ATC asks me to move to 5Q3QZ8, then they can skip the common part, and just say, move to location *Z8, i.e. replace the common part which is 5Q3Q with *.

### Show GL location in the airplane radar screen 
I suggest showing the GL location in the Radar screen of the airplane, as it shows the current location, and if we set the distination in the computer then it can also show the GL of the final distination. E.g. if I am going from SFO to Florida airport then it would show 5Q3QW0 to 8MRQEY, then while flying if my location change for example to 4QZQW0 then I know I am going away from my final distination. While if my location changed while flying to 6Q3QW0 then I know I am getting closer, as 6 is closer to 8 than 5. And so on. And that would make it difficult for pilots to get lost or go in wrong direction.
