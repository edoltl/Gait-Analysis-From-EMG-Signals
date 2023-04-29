# Gait-Analysis-From-EMG-Signals <br />
Gait Analysis over three subjects to detect steps frequency, how many steps were taken and how long they walked. <br />
## Description of the context.
threeSubjects.mat is a collection of data obtained from an experiment at University Of Tokyo with the <br />
purpose to collect "Walkability" infos. <br />
Three experimental conditions have been considered: <br />
• Walking while avoiding obstacles <br />
• Walking while following a certain rythm <br />
• Walking freely <br />
Two groups were created to perform the experiment: <br />
• Young adults: 10 male students and 4 female students (from Master's Degree) (average age of 24,7) <br />
• Retired elderly people: 10 men and 10 women (average age of 65,15) <br />
During the experiment there were collected fisiological data using Shimmer sensors <br />
## The Assignment: <br />
For this exercise we are interested in the "Walking while following a certain rythm" task. <br />
Participants were asked to follow a certain route and there were considered three different velocities (low mid high). <br />
We need to understand how the three velocities are matching with the three subjects (subj1 subj4 subj5) inside <br />
threeSubjects.mat and how many steps did they take inside their given time. <br />
It was selected a Sample Rate of 512 Hz for each EMG Signal. <br />
## Structure of threeSubjects.mat: <br />
threeSubjects.mat contains three matrices with many rows and 2 columns, respectively for: <br />
• Gastrocnemius muscle signal variations during said activites <br />
• Tibial muscle signal variations during said activities <br />
## THRESHOLD.mat & FILTERED.mat: <br />
Are matrices that contain respectively: <br />
• Computed thresholds for v1 code <br />
• Computed emg_rms for each of the subjects (1 4 5) (from the filtered emgs) <br />
