## ---- results="asis", echo=FALSE, message=FALSE--------------------------
# <!-- pkgdown --> 
# <!-- jquery --><script src="jquery.min.js" crossorigin="anonymous"></script>
myfile<-"jquery.min.js"
if(file.exists(myfile)){
cat(paste0('<script src="',myfile,'" crossorigin="anonymous"></script> <!-- # -->'))
}
# <!-- clipboard.js --><script src="clipboard.min.js"  crossorigin="anonymous"></script>
myfile<-"clipboard.min.js"
if(file.exists(myfile)){
cat(paste0('<script src="',myfile,'"crossorigin="anonymous"></script>'))
}
# <!-- Font Awesome icons --><link rel="stylesheet" href="all.minMod.css"  crossorigin="anonymous">
myfile<-"all.minMod.css"
if(file.exists(myfile)){
cat(paste0('<link rel="stylesheet" href="',myfile,'"  crossorigin="anonymous">'))
}
# <!-- Bootstrap --><link rel="stylesheet" href="bootstrap.minO.css" crossorigin="anonymous">
myfile<-"bootstrap.minO.css"
if(file.exists(myfile)){
cat(paste0('<link rel="stylesheet" href="',myfile,'"  crossorigin="anonymous">'))
}
# <!-- # <script src="bootstrap.min.js"  crossorigin="anonymous"></script> -->
myfile<-"bootstrap.min.js"
if(file.exists(myfile)){
cat(paste0('<script src="',myfile,'" crossorigin="anonymous"></script> <!-- # -->'))
}
myfile<-"pkgdown2.js"
if(file.exists(myfile)){
cat(paste0('<script src="',myfile,'"></script> <!-- # -->'))
}

## ---- results="hide", message=FALSE, warning=FALSE, eval=TRUE------------

#load package
library(idiogramFISH) 

## ---- message=FALSE, echo=FALSE------------------------------------------
packageCheck<-all(unlist(invisible(lapply(c("ggtree","grid","ggpubr","phytools","treeio","plyr"), function(pkg) requireNamespace(pkg, quietly=TRUE)  ) ) ) )

## ---- message=FALSE, eval=packageCheck-----------------------------------
require(ggplot2)
require(phytools)
require(ggpubr)
require(grid)   #pushViewport
require(ggtree)
# list.files(system.file('extdata', package = 'my_package') )

# find path of iqtree file
iqtreeFile    <- system.file("extdata", "eightSpIqtree.treefile", package = "idiogramFISH")

# load file as phylo object
iqtreephylo   <- read.newick(iqtreeFile) # phytools

# transform tree
iqtreephyloUM <- force.ultrametric(iqtreephylo, method= "extend") # phytools


## ---- message=FALSE, eval=packageCheck-----------------------------------
ggtreeOf8 <- ggtree(iqtreephyloUM) + geom_tiplab(size=6)

## ---- message=FALSE,eval=packageCheck------------------------------------
gbuil2      <-  ggplot_build(ggtreeOf8)       # get ggplot_built
gtgbuild    <-  ggplot_gtable(gbuil2)         # get gtable from ggplot_built
gtgbuild$layout$clip[gtgbuild$layout$name == "panel"] <- "off"                # modify gtable
ggtreeOf8   <- as_ggplot(gtgbuild)            # back to ggplot
gtgbuildgg2 <- ggtreeOf8 +  theme(plot.margin = unit(c(1,9.5,3,1.5), "cm") ) # top right bottom left - modify margins

## ---- message=FALSE,eval=packageCheck------------------------------------
iqtreephyloUM <- ladderize(iqtreephyloUM, right = FALSE)
is_tip <- iqtreephyloUM$edge[,2] <= length(iqtreephyloUM$tip.label)
ordered_tips  <- iqtreephyloUM$edge[is_tip, 2]
desiredOrder  <- rev(iqtreephyloUM$tip.label[ordered_tips])

## ---- message=FALSE,eval=packageCheck------------------------------------
# make a vector without missing OTUs
desiredFiltered <- intersect(desiredOrder,allChrSizeSample$OTU)

# establish desired order
allChrSizeSample$OTU <- factor(allChrSizeSample$OTU, levels = desiredFiltered)

# order
allChrSizeSample     <- allChrSizeSample[order(allChrSizeSample$OTU),]

## ---- message=FALSE,eval=packageCheck------------------------------------
# Establish position of OTUs before missing data OTUs
matchres <- match(desiredOrder,desiredFiltered)
matchres[is.na(matchres)] <- "R"
reps     <- rle(matchres)
posOTUsBeforeMissing      <- as.numeric(matchres[which(matchres=="R")-1][which(matchres[which(matchres=="R")-1]!="R")] )

# This are the OTUs that come before missing chr. data OTUs
BeforeMissing             <- desiredFiltered[posOTUsBeforeMissing]

# This is the amount of missing OTUs, spaces to add (ghost karyotypes)
valuesOfMissRepsBefore    <- reps$lengths[which(reps$values=="R")]

## ---- message=FALSE, comment=NA, results="hide",eval=packageCheck--------
# plot to png file
png(file="firstplot.png" ,width=962,height=962 )

par(omi=rep(0,4) , mar=c(0,1,2,1), 
    mfrow=c(1,2) )   # one row two columns
par(fig=c(0,.3,0,1)) # location of left ghost plot
plot.new()           # ghost plot to the left
par(fig=c(.3,1,0,1)) # location of right plot

plotIdiograms(allChrSizeSample,                # data.frame of Chr. Sizes
              allMarksSample,                  # d.f. of Marks (not cen.) 
              dfCenMarks = allCenMarksSample,  # d.f. of centromeric marks
              dfMarkColor =  mydfMaColor,      # d.f. of mark characteristics

              roundness = 10.5,                # roundness of vertices
              dotRoundCorr = .8,               # correct roundness aspect ratio
              lwd.chr=.5,                      # width of lines
              orderBySize = FALSE,             # don't order chr. by size
              centromereSize = 1.3,            # apparent cen. size
              OTUTextSize = 1,                 # Size of OTU name
              chrWidth =3,                     # width of chr.
              chrSpacing = 3,                  # horizontal spacing of chr.
              karHeiSpace = 1.8,               # karyotype vertical relative size with spacing
              
              nameChrIndexPos=4,               # move the name of chr. indexes to left
              morpho=TRUE,                     # add chr. morphology
              chrIndex = TRUE,                 # add chr. indices
              karIndex = TRUE,                 # add karyotype indices

              markLabelSpacer = 0              # spaces from rightmost chr. to legend
              ,markLabelSize = 1               # font size of legend
              ,legend="aside"                  # position of legends
              
              ,ylimTopMod = -.3                # modify ylim top margin
              ,ylimBotMod=.9                   # modify ylim bottom margin
              ,xlimRightMod=2                  # modify right xlim
              
              ,rulerPos = -0.7                 # position of rulers
              ,rulerNumberSize = .35           # font size of ruler number
              ,rulerNumberPos = .4             # position of ruler numbers
              
              ,addMissingOTUAfter = BeforeMissing          # OTUs after which there are ghost karyotypes - empty spaces
              ,missOTUspacings    = valuesOfMissRepsBefore # number of ghost karyotypes
)

# plot to the left the ggtree
pushViewport(viewport(layout = grid.layout(1, 2)))
pushViewport(viewport(layout.pos.col = 1, layout.pos.row = 1))
print(gtgbuildgg2,newpage=F) 

# close png
dev.off()

## ---- results="asis", comment=NA, echo=FALSE-----------------------------
if(packageCheck){
# cat(paste0("![](",myt,")"))
cat(paste0("![](firstplot.png)" ) )
# cat(paste0("![](firstplot.svg)" ) )
} else {
cat(paste0("![](firstplot2.png)" ) )
# img1_path <- "../man/figures/firstplot2.svg"
# if(file.exists(img1_path)) {
# cat(paste0("<img src=",img1_path," width=\"100%\">") )
# }
}

## ---- message=FALSE, eval=packageCheck-----------------------------------
require(ggplot2)
require(phytools)
require(ggpubr)
require(grid)   #pushViewport
require(ggtree)
require(treeio)

# find path of iqtree file
revBayesFile    <- system.file("extdata", "revBayesTutorial.tree", package = "idiogramFISH")

# load file as phylo object
revBayesPhylo   <- read.beast(revBayesFile) # ggtree or treeio

# transform tree
revBayesPhyloUM <- force.ultrametric(revBayesPhylo@phylo, method= "extend") # phytools


## ---- message=FALSE,eval=packageCheck------------------------------------
is_tip           <- revBayesPhyloUM$edge[,2] <= length(revBayesPhyloUM$tip.label)
ordered_tips     <- revBayesPhyloUM$edge[is_tip, 2]
desiredorderRevB <- rev(revBayesPhyloUM$tip.label[ordered_tips])

## ---- message=FALSE,eval=packageCheck------------------------------------
allChrSizeSampleHolo <- allChrSizeSample
allChrSizeSampleHolo <- allChrSizeSampleHolo[,c("OTU","chrName","longArmSize")]
colnames(allChrSizeSampleHolo)[which(names(allChrSizeSampleHolo)=="longArmSize")]<-"chrSize"

allMarksSampleHolo   <-allMarksSample
allMarksSampleHolo   <-allMarksSampleHolo[c("OTU","chrName","markName","markDistCen","markSize")]
colnames(allMarksSampleHolo)[which(names(allMarksSampleHolo)=="markDistCen")] <- "markPos"
allMarksSampleHolo[which(allMarksSampleHolo$markName=="5S"),]$markSize <- .5

## ---- message=FALSE,eval=packageCheck------------------------------------
# make a vector without missing OTUs
desiredFiltered <- intersect(desiredorderRevB,allChrSizeSampleHolo$OTU)

# establish desired order
allChrSizeSampleHolo$OTU <- factor(allChrSizeSampleHolo$OTU, levels = desiredFiltered)

# order
allChrSizeSampleHolo <- allChrSizeSampleHolo[order(allChrSizeSampleHolo$OTU),]

## ---- message=FALSE,eval=packageCheck------------------------------------
# Establish position of OTUs before missing data OTUs
matchres <- match(desiredorderRevB,desiredFiltered)
matchres[is.na(matchres)]   <- "R"
reps     <- rle(matchres)
posOTUsBeforeMissing        <- as.numeric(matchres[which(matchres=="R")-1][which(matchres[which(matchres=="R")-1]!="R")] )

# This are the OTUs that come before missing chr. data OTUs
BeforeMissingPlot2          <- desiredFiltered[posOTUsBeforeMissing]

# This is the amount of missing OTUs, spaces to add (ghost karyotypes)
valuesOfMissRepsBeforePlot2 <- reps$lengths[which(reps$values=="R")]

## ---- message=FALSE, comment=NA, results="hide",eval=packageCheck--------
# plot to png file
png(file=paste0("secondplot.png" ),width=962,height=700)

{
par(omi=rep(0,4) , mar=c(0,0,0,0), mfrow=c(1,2))
par(fig=c(0,.3,0,1)) 
plot(revBayesPhyloUM)
par(fig=c(0.3,1,0,1), new=TRUE)
par(mar=c(3,0,0,0))

# Function plotIdiogramsHolo deprecated after ver. 1.5.1 

plotIdiograms(allChrSizeSampleHolo,               # chr. size data.frame
              allMarksSampleHolo,                 # data.frame of marks' positions
              dfMarkColor =  mydfMaColor,         # d.f. of mark characteristics
              
              roundness = 10.5,                   # vertices roundness
              dotRoundCorr = 0.9,                 # correction of roundness of dots and vertices

              chrWidth =2,                        # width of chr.  
              chrSpacing = 1.5,                   # horizontal spacing among chr.
              karHeiSpace = 2,                    # vertical size of kar. including spacing
              karIndex = TRUE                     # add karyotype index
              ,OTUTextSize = 1                    # Size of OTU name
              
              ,addMissingOTUAfter = BeforeMissingPlot2           # add ghost OTUs after these names
              ,missOTUspacings    = valuesOfMissRepsBeforePlot2  # how many ghosts, respectively
              ,lwd.chr=.5                         # line width

              ,legend="aside"                     # make legend to the right
              ,markLabelSpacer = 0                # dist. of legend to rightmost chr.
              ,markLabelSize = 1                  # font size of legend
              ,legendWidth = 2.3                  # width of square or dots of legend
              
              ,ylimTopMod = - .3                  # modify ylim of top
              ,ylimBotMod = - 1.5                 # modify ylim of bottom
              ,xlimRightMod=2                     # modify xlim of right
              
              ,rulerPos = - 0.7                   # position of ruler
              ,rulerNumberSize = .35              # font size of number of ruler
              ,rulerNumberPos = .4                # position of ruler number

)
}

# close png
dev.off()

## ---- results="asis", comment=NA, echo=FALSE-----------------------------
if(packageCheck){
# myt2<-normalizePath(myt2)
# cat(paste0("![](",myt2,")"))
cat(paste0("![](secondplot.png)" ) )
} else {
cat(paste0("![](secondplot2.png)" ) )
# img1_path <- "../man/figures/secondplot2.svg"
# if(file.exists(img1_path)) {
# cat(paste0("<img src=",img1_path," width=\"100%\">") )
# }
}

## ---- message=FALSE,eval=packageCheck------------------------------------

monosel<-c("Species_F","Species_C","Species_A")
allChrSizeSampleSel <- allChrSizeSample[which(allChrSizeSample$OTU %in% monosel  ),]
allMarksSampleSel   <- allMarksSample[which(allMarksSample$OTU %in% monosel),]

holosel    <- setdiff(unique(allChrSizeSampleHolo$OTU),monosel)
allChrSizeSampleHoloSel <- allChrSizeSampleHolo[which(allChrSizeSampleHolo$OTU %in% holosel  ),]
allMarksSampleHoloSel   <- allMarksSampleHolo[which(allMarksSampleHolo$OTU %in% holosel),]

mixChrSize <- plyr::rbind.fill(allChrSizeSampleSel,allChrSizeSampleHoloSel)

mixMarks   <- plyr::rbind.fill(allMarksSampleSel,allMarksSampleHoloSel)

## ---- message=FALSE,eval=packageCheck------------------------------------
# make a vector without missing OTUs
desiredFiltered <- intersect(desiredorderRevB, mixChrSize$OTU)

# establish desired order
mixChrSize$OTU <- factor(mixChrSize$OTU, levels = desiredFiltered)

# order data.frame
mixChrSize <- mixChrSize[order(mixChrSize$OTU),]

# Establish position of OTUs before missing data OTUs
matchres <- match(desiredorderRevB,desiredFiltered)
matchres[is.na(matchres)]   <- "R"
reps     <- rle(matchres)
posOTUsBeforeMissing        <- as.numeric(matchres[which(matchres=="R")-1][which(matchres[which(matchres=="R")-1]!="R")] )

# This are the OTUs that come before missing chr. data OTUs
BeforeMissingPlot2          <- desiredFiltered[posOTUsBeforeMissing]

# This is the amount of missing OTUs, spaces to add (ghost karyotypes)
valuesOfMissRepsBeforePlot2 <- reps$lengths[which(reps$values=="R")]

## ---- message=FALSE, comment=NA, results="hide",eval=packageCheck--------
# plot to png file
png(file=paste0("thirdplot.png" ),width=962,height=1000)
{
  par(omi=rep(0,4) , mar=c(0,0,0,0), mfrow=c(1,2))
  par(fig=c(0,.25,0,1)) 
  plot(revBayesPhyloUM)
  par(fig=c(0.25,1,0,1), new=TRUE)
  par(mar=c(3,0,0,0))
  
plotIdiograms(mixChrSize,                         # chr. size data.frame
              mixMarks,                           # data.frame of marks' positions
              dfMarkColor =  mydfMaColor,         # d.f. of mark characteristics
              origin="b",
              karHeiSpace=2.2,
              
              roundness = 10.5,                   # vertices roundness
              dotRoundCorr = 1.0,                 # correction of roundness of dots and vertices
              
              chrWidth =1.8,                      # width of chr.  
              chrSpacing = 1.5,                   # horizontal spacing among chr.
              karIndex = TRUE                     # add karyotype index
              ,OTUTextSize = 1                    # Size of OTU name
              
              ,addMissingOTUAfter = BeforeMissingPlot2           # add ghost OTUs after these names
              ,missOTUspacings    = valuesOfMissRepsBeforePlot2  # how many ghosts, respectively
              ,lwd.chr=.5                         # line width
              
              ,legend="aside"                     # make legend to the right
              ,markLabelSpacer = 0                # dist. of legend to rightmost chr.
              ,markLabelSize = 1                  # font size of legend
              ,legendWidth = 2                    # width of square or dots of legend
              
              ,ylimTopMod = -.3                   # modify ylim of top
              ,ylimBotMod = -1.8                  # modify ylim of bottom
              ,xlimRightMod=2                     # modify xlim of right
              
              ,rulerPos = -0.7                    # position of ruler
              ,rulerNumberSize = .35              # font size of number of ruler
              ,rulerNumberPos = .4                # position of ruler number
)
}
# close png
dev.off()

## ---- results="asis", comment=NA, echo=FALSE, eval=TRUE------------------
if(packageCheck){
cat(paste0("![](thirdplot.png)" ) )
} else {
cat(paste0("![](thirdplot2.png)" ) )
# img1_path <- "../man/figures/logo.svg"
# if(file.exists(img1_path)) {
# cat(paste0("<img src=",img1_path," width=\"100%\">") )
# }
}
