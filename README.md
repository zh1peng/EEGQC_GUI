# EEG_QC_GUI----Make QC on EEG data a bit easier. 
by zhipeng

![image](https://user-images.githubusercontent.com/25647407/28079377-11530226-6660-11e7-9fcb-07fde29b938a.png)

### Key Features :clap::
1. Read eeg data set (preprocessed) in a given dir
2. After loading data, it allows you explore data/ics,reject bad epoch/ics, interpolate bad channel.
3. QCed data can be saved and info like bad epoch/channel/ics/QCer's comments can be recorded.
4. There is an anoying but tiny bug on the scroll window, that won't affect use.

### Requirement:
1. EEGlab
2. Matlab
3. filesearch_regexp.m (it returns the file name and path with a certain pattern,search with regexp).
4. :disappointed:our lab is using Biosemi-64 system, data was preprocessed using EEGlab and FASTER [a link here].
    (haven't tested yet).
5. :bear: Change regexp if your data set is not in 'Finalxxxxx.set' format. Current regexp is '^Final.*.set' (line 56).

### Features in the Future :microscope:
1. Advanced GUI code instead of Guide
2. Automatically detect data quality
3. Bug fixed,especially that in reject epoch process.
4. Submit as a plug-in to EEGlab.
5. Be compatiable with more system.
6. :fearful:Suggest potential bad epoches based on machine learning results, another project [a link here] 



## Breif Mannual

Thanks to Hanni Kiiski (@tcd) for making this manual. :clap:

1. Add QC_GUI folder in path, type to command line: EEGQC·

2. Enter the path where you can find the datasets to QC, press 'Get filenames' to see how many datasets are in this directory (This will automatically find file names that start with ‘Final’ and end with ‘.set’ in the entered directory)

3. Enter the output path where the QCed datasets and summary will save

4. Enter dataset number where you will start going through the data
	i. Type 1 to start from the first dataset on the list
	ii. If you have already gone through a number of datasets, type the    
            number of the next dataset in order

5. Press 'Load' -> On the text field you can now see the number and name of the dataset you are working on

6. Press 'Scroll' 

	a. no eyeblinks left in the data -> highlight epochs that you want to remove from data (select ‘Zoom Off’ in Setting to allow 		you highlight epochs)
	- Press 'Update marks' -> You will get a prompt that says these have been saved but to remove them from data you need to press 		'Confirm' in the prompt

	b. eyeblinks left in the data – go to point 17.

7. Set bad channels (if any) to be interpolated by checking 'Bad channels' and 'Interpolate Bad Channel' and then choosing the specific channel/s from the list (press ‘Ctrl’ to select multiple channels)

8. If data does not look good during scrolling, for example it seems there is alpha and/or eyeblink artefacts in the data

	a. Press 'Topoplot' to plot topographies to check data looks ok
	b. Press 'Channel properties' to check
		i. if there is too much alpha in the data
		channels 31(=Pz) & 30(=POz)
		ii. if there are too many eyeblinks influencing the data
		channels 33(=Fpz) & 37(=AFz) & 38(=Fz)


10. If data looks good to use, selection ‘Usable’, if data looks too bad to use in the data analysis, select ‘Caution’ or ‘Unusable’. Note: over 20% epochs removed -> select ‘Caution’, over 40-50% epochs removed -> select ‘Unusable’

11. Add any comments (e.g. a lot of alpha, EMG) to the text field 'Any comment?’

12. Press 'Update Information' to update the QC summary file -> main text field shows a summary of rejected epochs, interpolated channels, IC removal, whether data is usable and comments

13. Press 'Confirm' -> The main text field will show 'QCed files are saved'
    -> you can confirm that the new QCed dataset saved in the output
    Directory

14. Remember to save your QC info by saving the variable in your workspace.
	a. right-click results.mat or temp_results.mat in Workspace, choose ‘Save as..’ and save as autosaved.mat (remember to include 		ICs from autosaved_IC.mat to the final autosaved.mat)
	b. or type in following line in command window
	save(‘location/filename’,’results’) 

15. Copy-paste the QC information from autosaved.mat to QCvariable excel file for the specific task

16. Continue to the next dataset:
	a. the GUI will automatically have 2 in the dataset number field Press 'Load' -> 
	continue as above

	b. OR go to point 1. and load each participant’s dataset separately

17. If there are eyeblinks or other clear, repetitive/consistent artifacts left in the data after FASTER you can check Independent Components (ICs)

	a. Press 'IC scroll' to see IC activations
	b. Press 'IC properties' -> choose which ICs to plot (typically 1:10)
c. Base your decision to remove ICs on information from both ‘IC scroll’ and ‘IC properties’ 
d. to remove bad ICs -> add the IC/comp number to the text field
	e. Press 'Compare single trial' -> blue trace shows original raw
	   EEG, red trace shows the new EEG data with the ICs removed
	   -> based on this you can choose whether it's useful to remove ICs
	f. Press 'Compare average' -> same as above but for the average of
           all trials
	g. Press ‘Update information’, press ‘Confirm’
h. rename autosaved.mat as autosaved_IC.mat and qc_Final[participant code].set file as Final[participant code].set – load this file with no bad ICs and go to point 6.


Comments: 

Next time if you want to continue recording the results in a correct order, load the results you saved before after the GUI is launched (you can check the variable [results] in your workspace)

Or an easy way is to copy the information to an excel 

