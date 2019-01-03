# Data Toolkit - A Case for 'Medium' Data

## Introduction

Big data promises lots of benefits but it has a lot of pitfalls as well. The
data is readily available leading to possibilities but when we take up full on
big data analysis, we encounter a lot of added complexity and cost. We need to
be careful in terms of what is required for the data-sets in possession.
Moreover in most disciplines there are existing methods built for large datasets
e.g. geography, statistics etc. There have always been big data in other
disciplines but the improvements in hardware has made the processing of big data
possible so they need no major changes to do big data analysis. We need to
devise the right tools for the right problem/work. In the environment of
constant change and growth, we cannot afford to lose the opportunity of
extracting information while trying to utilise a future proof big data approach.
We need to have a pragmatic approach with a consistent philosophy in our
approach rather than reinventing the wheel. We need to look at other disciplines
and adopt approaches and solutions form them.

In the previous chapters we looked at the various methods devised to collect and
process data from WiFi probe requests emitted by phones. Though we discussed the
methods in detail we left out the rationale behind the toolkit chosen to
implement the methods. In this section we start by discussing the nature of 'Big
Data', we discuss the previous research in the 'Big Data' space to understand
the definition nature and challenges of big data. The we look at our data-sets
collected through the pilot studies and the Smart Street Sensor project closely
and evaluate their nature in terms of the dimensions of the big data. We also
discuss in detail the challenges faced in dealing with such dataset and the
requirements expected from a toolkit to do so. Finally we look across
disciplines, discuss and evaluate approaches and tools available in dealing with
such datasets and their fitness of purpose to do so.

## Big Data Discussion

Big data has become the new hot thing in research. Data has become the next oil
and we are in a data deluge moving from a data sparse to data rich environment.
As we saw in the previous chapters there are easy and quick ways to collect
large amount of data. The technological advancements has enabled us to be able
to think about utilising such large assemblages of data. Big data gives us
numerous benefits, it can provide us insights which were not possible before. I
can give comprehensive coverage. It can change the approach and methods in whole
disciplines such as computer science where the shift towards machine learning
and AI which is primarily fuelled by the explosion of data available. It also
poses a lot of challenges because of its nature, in analysing and managing it.
In addition to these, trying to solving 'normal' problem using big data tools
and approaches can introduce enormous overhead and introduce additional
complexity without providing much benefits. It can actually counter productive
to use these methods when they are not necessary. It is absolutely necessary for
any research to understand what is big data and how the subject at hand relates
to big data.

The first and foremost challenge in big data is its definition. It is not
clearly defined and the definition can vary widely based on the discipline and
perspective. What is big data in one discipline may not be in another. Data also
has various dimensions in which they can exhibit big data properties in limited
number of dimensions. In general it is defined in contrast to traditional data.
It is generally defined as the data which cannot be dealt with traditional
desktop or server client computing methods and hardware and requires substantial
change in the approach. Laney 2001 defined big data in three dimensions volume,
velocity and variety - the three Vs of big data. These have been extended to
include veracity - the reliability or truthfulness of the data, visualisation -
the complexity in visual interpretation and presentation, and other additional
dimensions such as visibility validity, variability, volatility and value. There
have been other alternative dimensions proposed as well such as Cardinality,
continuity and complexity - three Cs. However for our purposes we consider 5Vs
of Big data, volume, velocity, variety, veracity and visualisation. It has to be
noted that Not all data is 'Big' in all these dimensions and each dimension can
lead to their own challenge in the analysis and management of the data. It is
important to understand the dataset in terms of its Big data properties so that
the corresponding challenges can be tackled with confidence.

The second set of challenges arise from the above mentioned nature of big data
while processing it. The 'processing' of data can be categorised broadly as the
following steps - data acquisition and recording, extraction cleaning and
annotation, data integration and aggregation, modeling and analysis, and finally
visualisation and interpretation. Each step in this processing poses its own
challenges. The volume, velocity and variety poses the problem in data
acquisition by introducing the need for distributed, crowdsourced collection of
data, need for heavitly parallelised computing and functional programming
concepts while we clean and aggregate the data into valuable information. This
is where the approaches in Programming languagaes such as Haskell,
distributed storage and computing such as MapReduce, Hadoop and parallel
processing approaches such as spark are introduced. There is a lot of bias
arising from the unstrucutred way of collecting data which requires
consideration on calibrating and weighting the data collection process to weed
out any potential uncertainities and biases. The veracity of the big data
introduces significant challenges in modelling and analysis of the data. The
need for new ML algorithms which are data heavy and Deep learning methods such
as CNN which focuses on processing heavy become prominent. The HPC methods with
ultra paralllelised techniques such as GPU processing are indispensible to be
able to model and predict in such data sets. These properties also introduces
significant challenges in presenting the knowledge mined with such data like
visualisation. Visulisation is not only a presentation task supporting critical
activity such as policy decision making support but also an indespensible tool
in exploratory analysis. The volume and velocity of the data makes is hard to be
able to visually digest the data, the variety especially in the time dimension
can make the data too complex to interpret even when presented in small parts.
GIS systems do a good job in visualising complext Geographic datasets but
struggle to maintain legibility and understandability when dealing with the
temporal dimension. There is a need for interactivity and connected components
to be able to visually keep track of information presented. There needs to be a
balance between functionality, aesthetics and performance. Finally the variety
of the data set poses the challange of interoperability between various
approaches and tools. This creates need for consistent standards in terms of
dealing with data. 

Apart from these processing challanges, we also have management challanges to
consider such as privacy and security, Data governance and ownership, data and
information sharing, and cost. Privacy and security is one of the basic
consideration in any project dealing with big data. 
