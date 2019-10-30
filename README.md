# LCG-HDR
**LUMINANCE CHROMINANCE GRADIENT - HIGH DYNAMIC RANGE METHOD**

<p align="center">
<b>//-----------------------------final year project---------------------------------//</b>
</p>



### System Architecture:

**Flow chart to generate Tone mapped HDR image**

<p align="center">
<img src= "documentation\screenshots\SystemArchitecture\ToneMappingFlow.jpg"  width = "40%" height = "40%" >
</p>

**Block diagram of LCG HDR**
<p align="center">
<img src= "documentation\screenshots\SystemArchitecture\LcgHdrBlockDiagram.jpg"  width = "60%" height = "70%" >
</p>

**Block diagram of IBTM process**
<p align="center">
<img src= "documentation\screenshots\SystemArchitecture\IBTMProcess.jpg"  width = "60%" height = "70%" >
</p>



#### Algorithm


<pre>
<b>Algorithm 1.1:</b> HDR image generation using LCGHDR technique
<b>Input</b>: image [1…n] with different exposures
<b>output</b>: HDR image

    <b>for</b> each image <b>C</b>i :

        <b>if</b> <b>C</b>i is in RGB color space <b>then</b>
                convert <b>C</b>i into YUV space
        end if

        extract Y i ,Cr i ,Cb i values from C i
        calculate Y,Cr,Cb component of final HDR image as per formulae using extracted values
        calculate scaling factor from extracted values

    <b>end for each</b>

    apply exponentiation on Y component of HDR image
    divide Cr and Cb components of HDR image with scaling factor

    <b>return</b> HDR image
</pre>





##### ONLINE RESOURCES:
1. [MITs new HDR video algorithm:](https://gadgets.ndtv.com/cameras/news/mit-develops-real-time-hdr-camera-algorithm-to-prevent-overexposure-731675)
2. [Teo de Campos page:](http://www.robots.ox.ac.uk/~teo/)
3. [HDR image database:](http://hdrplusdata.org/)
4. [Colin Doutre’s page:](http://www.ece.ubc.ca/~colind/)
5. [Google’s HDR + implementation:](http://timothybrooks.com/tech/hdr-plus/)
6. [Introduction to Visual Computing:](https://www.cs.toronto.edu/~mangas/teaching/320/calendar.html)
7. [Cotter’s HDR tools:](https://ttic.uchicago.edu/~cotter/projects/hdr_tools/)
8. [Paulbourke’s page:](http://paulbourke.net/)
9. [Plataniotis paper for tone mapping operator:](https://www.comm.utoronto.ca/~kostas/)
10. [Digital image processing class:](http://www.cs.umsl.edu/~sanjiv/classes/cs5420/)
11. [Evaluation of tone mapping operators:](http://cadik.posvete.cz/tmo/)
12. [Durand implementation:](http://vision.gel.ulaval.ca/~jflalonde/cours/4105/h14/tps/results/tp5/minghou/index.html)
13. [G treece bitonic filter:](https://www.repository.cam.ac.uk/bitstream/handle/1810/252987/treece_tr700.pdf?sequence=1&amp;isAllowed=y)
14. [Durand bilateral filter for hdr:](https://people.csail.mit.edu/fredo/PUBLI/Siggraph2002/DurandBilateral.pdf)
15. [Web hdr:](http://www.jaloxa.eu/webhdr)
16. [Dragos paper:](www.resources.mpi-inf.mpg.de/tmo/logmap/)
17. [Erik Reinhard website:](www.erikreinhard.com/hdr.html)
18. [Reinhard hdr implementation:](www.cybertron.cg.tu-berlin.de/eitz/hdr/index.html)
19. [luminance-chrominance approach:](http://www.cs.tut.fi/~hdr/#ref_problems)
20. [camera algorithms:](https://www.eecs.tuberlin.de/fileadmin/fg144/Courses/10WS/pdci/talks/camera_algorithms.pdf)
21. [pfstools for hdr:](www.pfstools.sourceforge.net/pfstmo.html)
22. [Computational photography Udacity:](https://in.udacity.com/course/computational-photography--ud955)

##### GITHUB REFERENCE CODES:

1. [vfx-hdr:(Reinhard) by Hsiaoyi](https://github.com/hsiaoyi0504/vfx-HDR/tree/master/submit/src)
2. [A Bio-Inspired Multi-Exposure Fusion Framework for Low-light Image Enhancement:](https://github.com/baidut/BIMEF)
3. [C++ code for finding camera response function:](https://github.com/cbraley/hdr)


###NOTE : IF YOU ARE A RESEARCHER , PLS DON'T WASTE TIME THIS IS A FAILURE EXPERIMENT DONE BY UNDERGRAD STUDENTS WITH LIMITED KNOWLEDGE THEY HAVE . 



