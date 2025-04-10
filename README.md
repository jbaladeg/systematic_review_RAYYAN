# Systematic review and RAYYAN exportation


1. [What is Rayyan?](#what-is-rayyan)
2. [Belur Approach](#belur-approach)
3. [articles.csv](#articlescsv)
4. [Agreement Indices](#agreement-indices)
5. [The Structure of the Script](#the-structure-of-the-script)


Rayyan is a key tool for the early stages of systematic reviews and/or meta-analyses. This repository focuses on adapting its export from the official website to analyze judge relationships and calculate initial agreement indices

## What is Rayyan? https://www.rayyan.ai/


Rayyan AI is an AI-powered platform designed to streamline and accelerate systematic reviews and literature reviews in research. It offers collaborative tools that allow research teams to efficiently select, filter, and manage articles, enhancing productivity and accuracy throughout the review process. Additionally, it enables blind screening, helping to avoid potential biases in decision-making.

![image](https://github.com/user-attachments/assets/94f0c2ee-c35d-456b-9e2a-92d2d30e44c8)

## Belur approach
On the other hand, the method proposed by Belur et al. (2021) suggests that the screening process should be carried out in independent blocks. 
The method described by Belur et al. (2021) outlines a process for screening documents in systematic reviews and meta-analyses in three separate blocks. This approach involves independent screening by multiple judges for each block of documents, followed by a discussion of any agreements and disagreements regarding the inclusion or exclusion of articles. After these discussions, the inclusion and exclusion criteria are refined to reduce any discrepancies in future screenings.

The method emphasizes the importance of improving interrater reliability (IRR) through this iterative process, where judges continuously adjust their understanding of the criteria based on feedback and discussions. Each block is screened independently to avoid bias and ensure consistency across the process. After screening each block, the IRR is calculated, which helps assess the level of agreement between judges. The goal is to increase the IRR with each block as judges align more closely on the criteria and their decision-making.

This structured, block-by-block approach helps to refine the inclusion criteria progressively and improves the overall accuracy and consistency of the screening process.

- Belur, J., Tompson, L., Thornton, A., & Simon, M. (2021). Interrater reliability in systematic review methodology: exploring variation in coder decision-making. Sociological methods & research, 50(2), 837-865.

## articles.csv

Exporting data from Rayyan in CSV format can be somewhat cumbersome, as all the decisions and labels from the judges during the screening phase are stored in a single character-type variable. This can make it challenging to analyze or manipulate the data efficiently, as the information is not separated into distinct columns for each decision or label, requiring additional steps to process and organize the data for further analysis. This is one of the biggest issues that slow down the progress of final projects (TFGs) for our undergraduate students.

When you export from rayyan, the platform offers you something like this:

![image](https://github.com/user-attachments/assets/d9d407fe-c236-4f3b-81d2-b86dc8fae58f)

horrible, isn't it?

The aim of this repository is transforming this horrible data in this beautiful order:

```
     Blocks     Loren     Kim    Carlos  Loren_n    Kim_n  Carlos_n
1       <NA> Excluded     <NA> Excluded       0         NA       0
2       <NA> Excluded     <NA> Excluded       0         NA       0
3       <NA> Excluded     <NA> Excluded       0         NA       0
4   bloque 1 Excluded Excluded Excluded       0          0       0
5   bloque 1 Excluded Included Excluded       0          1       0
6   bloque 1 Excluded Included Included       0          1       1
7   bloque 1 Excluded Excluded Excluded       0          0       0
```

## Agreement indices

As a bonus, we also need to consider which indices we should use when calculating the degree of agreement during the screening phase. In the case of systematic reviews, the decisions will always be categorical, so we must determine whether these decisions were made by two or more judges.

![image](https://github.com/user-attachments/assets/a591aa9a-7306-4c45-8632-1273a12c7471)

## The struture of the script

0. Load the necessary libraries  
1. Open the directory  
2. Read the file  
3. Prepare the dataset with the variables we need. Identify and separate the inclusion variables and the labels with the blocks  
4. Prepare the decision variables  
5. Convert decisions to numeric values  
6. Filter based on the block you want to analyze  
7. Calculate agreement indices based on the number of judges
