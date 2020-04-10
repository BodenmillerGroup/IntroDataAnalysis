# Python sessions 

This folder contains IPython notebooks that were used in the Python sessions.

To convert the notebooks to Reveal.js slides, execute the following command in this folder:
```bash
jupyter nbconvert notebook.ipynb --to slides
```

Replace `notebook.ipynb` with the IPython notebook file name you'd like to convert.


## Schedule

Every Friday, 10:00-12:00  
https://zoom.us/j/854293838

27.03. Programming with Python  
03.04. The `numpy` package, plotting with `matplotlib`  
10.04. Processing tabular data with `pandas`, image processing  
17.04. Development environments, Q&A session

## Prerequisites

To follow the Python sessions, you will need to install the software listed in this section.

### Anaconda for Python 3.7

Required for all sessions.

1. Install Anaconda for Python 3.7 from [https://www.anaconda.com/distribution](https://www.anaconda.com/distribution)
2. Launch “Spyder” and “Jupyter Notebook” from the Anaconda Navigator  
   Recommendation: install Kite if Spyder asks you whether you want to
3. Run the following command in Spyder (bottom right) and Jupyter Notebook:

```python
import this
```

### tifffile

Required from session 3 onwards.

1. Open Anaconda Navigator, go to `Environments` and select your environment, e.g. `base`
2. In the first dropdown, select `All` and refresh your package index by clicking `Update index...`
3. Search for the `tifffile` package, mark it for installation and apply your changes by clicking on `Apply`

## Resources

Mattermost channel  
https://mattermost.dqbm.uzh.ch/department/channels/data-analysis-intro

Slides, notebooks, data & material  
https://github.com/BodenmillerGroup/IntroDataAnalysis

Session recordings (please do not share)  
https://drive.switch.ch/index.php/s/NDMZ9M1QeKXtsvm

UZH BIO134 Open edX course: Python for Biologists  
https://mnf.openedx.uzh.ch/courses/course-v1:MNF+BIO134+HS19
