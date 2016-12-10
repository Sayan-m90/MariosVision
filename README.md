Final Project Report, Computer Vision
CSE 5524, Autumn 2016
Mario’s Vision
Shiuli Das, Sayan Mandal, Debanjan Nandi




Project Idea


The project aims to simulate a rendition of the classic Super Mario game. However, this time instead of using a keyboard or any other gaming console to control, players need to perform real-time actions to make the Mario move. The project is an application of real-time object and motion detection which estimates the human pose and moves Super Mario accordingly.
The game features Super Mario with obstacles coming towards him. Much like the retro versions, Mario is static in the scenes with the obstacles moving towards him in the reverse direction. The player is required to perform different actions which would be mimicked by Mario to maneuver through obstacles.
So basically, the following actions need to be performed:
If you see a pipe on the screen, jump and the Mario will follow your action and jump over it
In case there is a question block or brick floating, crouch down, and Mario will duck down ensuring that he is not hit by the block
To avoid being hit by a turtle, raise your arm, and Mario will actually shoot the turtle.


The game runs generating obstacles randomly until the player is hit by an obstacle or he opts to quit.



Figure 1: Super Mario

Approach


We take live streaming of video frames from a webcam as input. The player is extracted from each frame, and we detect and classify his/her posture as stand, jump, crouch, or shoot (any other random posture is detected as stand, which is the default posture). The pose is subsequently mapped to preset Mario actions and is used to control and maneuver Mario around obstacles in the game.

Figure 2: Detected Person

Figure 3: Pose Detection and Mapping onto Character on Screen
Thus, a simple breakup of the tasks performed is as follows:
Foreground Detection
Posture Recognition/Estimation
Static Pose (Standing, Crouching)
Dynamic Pose (Jumping, Shooting)
Posture Mapping onto the Mario


Foreground Detection


Foreground Detection, also known as Background Subtraction is a technique wherein the image’s foreground is extracted for further processing. The rationale in the approach is that of detecting objects from the difference between the current frame and a reference frame, often called “background model”. 
In the technique used to determine the background model, it is assumed that every pixel in the video frames can be modeled using a Gaussian Mixture Model.
At any time, t during background model estimation, a particular pixel (x, y)’s history is
    X1,…, Xt= {V(x,y,i):1≤i≤t}
The history of every pixel is modeled by a single Gaussian distribution:
P(Xt)=Ν(Xt | μ, σ)
Each pixel is characterized by its intensity in the RGB color space. However, this space is very sensitive to shadows, which are nothing but a drop in the intensity values of the pixels. To deselect shadows as part of the foreground, we converted each pixel to the YIQ color space which decouples the intensity (Y) and chrominance channels (I-Q)
Therefore, for a particular pixel (x, y), it’s Gaussian distribution is calculated as:
I-Q Vector:        Cx,y= [VI[x,y],VQ[x,y]]T
Mean Vector:        μx,y=1N iCx,yi 
Covariance Matrix:    σx,y= 1N i(Cx,yi - μx,y)(Cx,yi - μx,y)T
Although I and Q channels are correlated, we considered them to be independent during covariance matrix calculation for the purpose of faster calculations
Following the estimation of the background model, every pixel in every subsequent frame of video input was classified as a part of the background or foreground based on multimodal Mahalanobis Distance of the current pixel value from the background model. A mahalanobis distance of more than 2.5 standard deviations from its mean value classified the pixel as a part of the foreground moving object.
B[x, y]= {1,    if [Cx,y -μx,y]Tσx,y-1[Cx,y -μx,y] >T2           (foreground) 0,                                                             otherwise            (background) 
The foreground image thus obtained had a lot noise which were removed by the following image pre-processing operations:
Median Filtering (5x5 square mask to remove salt and pepper noise)
Dilation/ Close operation (disk mask, radius = 3, to plug tiny gaps)
2D Connected Component Analysis, Retention of Largest Component


Figure 4: Foreground Detection




Pose Estimation


Stand
This is the default pose for the game


Crouch
Crouching is detected by performing the circularity test on the foreground object, using the formula: C= 4πAP2  where A, represents the Area, and P, the perimeter of the foreground object. Since the value of C for an ideal Circle is equal to 1, and as a person crouches, his silhouette resembles more like a circle, therefore, a threshold of 0.7 is set for the detection of position of crouch i.e. if C > 0.7, the position is classified as crouch.
An additional test was performed for crouch using the ratio of the two Eigen Vectors. As depicted in Figure 5, the ratio of the minor to major axis for standing or jumping is much smaller than ratio when the body crouches down and its vectors become more of the same length. If the ratio of the minor and major axes was greater than 0.4, we classify the pose as crouching.

Figure 5: Circularity Check


Finally, we trained and used a SVM classifier using the calculated similitude moments as Feature Vectors for every video frame of the static poses. The SVM was further trained using Motion History Images (MHI) and Motion Energy Images (MEI) to classify crouching, however it provided inferior result compared to when only individual frames were provided. Hence similitude moments of only individual frames were calculated and provided as input for crouch classification.


Jump


A SVM classifier was trained on the similitude moments of MHI and MEI with 5 trailing frames. However, this classifier generated a lot of False Positive output since it was not able to distinguish between crouching and jumping whose MHI and MEI appeared very similar. 




Therefore, an additional check on sudden large changes in centroid value of the image was performed. A sudden dip in centroid value (Origin is at the top-left corner and y axis points towards bottom) was observed during jumping (Figure 7), whereas crouching resulted in a large spike instead. This check further helped in dealing with the false positives. 
Shoot
Shooting had a distinctive MHI as well as an individual frame. However, training a classifier on individual frames gave better results compared to those trained over the MHI. This is probably because the frame rate of the camera was much slower compared to the speed at which a person usually raises his arm. Consequently, a proper MHI could often be not generated. Instead the individual frames, which always have a distinct shape, were able to generate good similitude moments as feature vectors.
A decision tree classifier was trained on the similitude moments of the still silhouette images to identify shooting action
. 
Figure 8: Shoot MHI (left) and Individual Frame (right)


Pose Estimation Statistics


The Classifier training was done using 2217 frames and tested on 750 other frames. This included frames captured on 5 different subjects which were then manually annotated.



Figure 9: Sample Images from Training Set (top – bottom: 
Jump (MHI), Shoot(Static), Crouch (Static), Random)


For each of the poses (Crouch, Jump, and Shoot), multiple classifiers were tried and the classifier giving the best results were then chosen. The classifier, marked in bold for each of the poses, represents the classifier used for detecting the corresponding pose.


    




Graphics


Each image (.png) is plotted using graphics objects. The program is basically a single loop moving randomly generated obstacles such as pipes, question blocks and turtles till the exit criteria satisfied. These obstacles are plotted as graphics entities, maintaining the following constraints:
There is sufficient distance between randomly generated objects.
The entire screen is split into four compartments as there are four objects (pipe, question block, turtle and brick) and an obstacle is randomly generated in one of the compartments. Then this screen is positioned in front of Mario, ensuring random obstacles appear and the player has sufficient time to react to each obstacle.
The game ends if Mario collides with any obstacle


Demo


https://drive.google.com/file/d/0B6Zg5OaW82ilalhaY3BOUnNQSms/view?usp=sharing
(Download and view in “slide show” mode for better viewing)


Discussion and Future Work


We successfully developed an application which does foreground detection and estimates the pose. We used the standard VGA camera and the foreground detection worked pretty well despite the poor and decaying frame rate. Converting the images to YIQ enabled us to deal with shadows. Various techniques were explored for the classification of poses and finally the combinations that gave the best results were used. We used sample data sets from only 5 subjects. However, with a larger training set, the classifiers would fare much better. Also, there is a little lag between the person’s and Mario’s actions. Future work would involve further optimization of the code to deal with this.
Work Division


Debanjan Nandi – Foreground detection
Sayan Mandal – Static pose (stand, crouch) and graphics
Shiuli Das – Dynamic pose (jump, shoot)


NOTE: The work division was strictly with respect to code development. Each member contributed equally to algorithm development for all aspects of the application.


References


[1]  http://web.cse.ohio-state.edu/~jwdavis/Teaching/5524/syllabus2016.htm








