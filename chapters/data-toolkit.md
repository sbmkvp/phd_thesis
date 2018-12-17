## Introduction
--------------------------------------------------------------------------------

Data has been collected at a national level for a long period of time. The size
of the data is unique in terms of size and complexity. It is neither small
enough for desktop processing nor big enough for a cluster. We define this a
medium sized slow data. We develop a minimal, open-source, free toolkit for the
collection, storage, analysis and dissemination of the information. We start by
looking at the size and complexity of our data set. Make a list of requirements.
Choose tools for each requirement and finally integrate all the tools to put
together a complete took kit that suits our needs finally we do some test case
scenarios and evaluate performance of our toolkit.

## Literature on Big data
--------------------------------------------------------------------------------

Big data is defined as data which cannot be handled with traditional methods.
but there are also other definitions/ dimensions of this. The famous one is the
3Vs definition where volume, velocity and variety (Laney 2001). There are more
like cardinality, continuity and complexity as well (suthaharan 2014) and
additional vs are proposed as well. For my research I follow the 5V approach.
 
 - volume
 - variety
 - velocity
 - veracity and
 - visualisation

We need to think about the development of a tool kit which suits our data set in
all these aspects


## footfall data - Big data?
--------------------------------------------------------------------------------

### volume
volume of the data in different perspectives. number of records, size on disk vs
yearly, monthly vs location and overall. The data is not trivial amount. but at
the same time it is not in league of big data as well.it is medium in terms of
volume. We are not at GBs but at the same time we are not at PBs we are around
TBs but can grow into PBs if the number of locations scaled or the time period
scaled.

### velocity
The velocity is every 5 minutes. This is close to real-time but not close to
real time as many bigdata systems have it the data also has a strong temporal
regularity as well. the basic unit being daily. we genearte around xx
data/records every minutes. This again in the middle of both stuff it is neither
slow nor fast data. It is somewhere in between.

### variety
The footfall data collected by smart street sensor is does not exhibit much
variability or complexity. It is pretty plain. There are few information we
collect and the strucutre of the data is plain. the underlying standards for the
format deosn't change enough and every data point is almost standardised.

### veracity
This is the dimension at which the data is truly big data. The data is dirty. Is
not complete in lot of ways. It doesn't has full coverage. The vcoverage
changes. The people captured has bias towards ownership. The way phones send
data is varied and changes with time. The data needs a lot of quality control
and processing to get to a point where it can be used with confidence. It also
needs a lot thought in terms of fit for purpose.

### visualisation
This again falls in the same range as that of the first three. The spatial
dimension of the data is easily visulaisable, but the temporal granularity is
hard to visualise in smaller scales. aggregation is also a challange because of
the veracity of the data which in turn makes visualisation harder. The temporal
dimension needs more of a dynamic or interactive visualisation techniques.

## Requirements from a toolkit
--------------------------------------------------------------------------------

Things we look to do with the data

1) standardise the dataset.
2) aggregate and count the dataset.
3) retrieve the data over certain sections.
4) 

### Data collection & retrieval

### Data storage - raw data

### Data processing

### Data Storage

### Visualisation

## Comparison of tools
--------------------------------------------------------------------------------

## Conclusions
--------------------------------------------------------------------------------
