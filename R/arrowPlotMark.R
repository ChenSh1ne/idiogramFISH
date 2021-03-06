#' arrowPlotMark
#' This is an internal function that plot marks
#'
#' It returns a plot
#'
#' @keywords internal
#'
#' @param roundness roundness of vertices <
#' @param xMark x component of polygon
#' @param yMark yMark component of polygon
#' @param dfMarkColorInternal colors for marks
#' @param listOfdfMarkPosArrow list of df. of mark pos.
#' @param chrWidth numeric, width of chr.
#' @param n numeric, to define vertices of rounded portions
#' @param lwd.chr thick of border line
#' @param circularPlot boolean TRUE for circ.
#' @param y list, y coords.
#' @param markLabelSize numeric, font size
#' @param separFactor numeric, sep. kars.
#' @param labelSpacing numeric, spacing
#' @param circleCenter numeric
#' @param circleCenterY numeric
#' @param radius numeric
#' @param ylistTransChr list, transf. coords.
#' @param rotation rotate*
#'
#' @return plot
#' @importFrom graphics polygon text
#'

arrowPlotMark<-function(roundness, xMark, yMark,
                        dfMarkColorInternal,listOfdfMarkPosArrow,
                        chrWidth,
                        n,
                        lwd.chr,
                        circularPlot,
                        y,
                        x,
                        markLabelSize,
                        separFactor,
                        labelSpacing,
                        circleCenter,circleCenterY,radius,
                        ylistTransChr,rotation,arrowheadWidthShrink) {

#  xMarkSq<<-xMark
#  yMarkSq<<-yMark

#  listOfdfMarkPosArrowInternal<<-listOfdfMarkPosArrow
#  dfMarkColorInternal2<<-dfMarkColorInternal

  # if(roundness>20) {

    if(circularPlot==FALSE) {

            lapply(1:length(xMark), function(w) mapply(function(x,y,z)
                graphics::polygon(
                  x=x,
                  y=y,
                  col= dfMarkColorInternal$markColor[match(     z   , dfMarkColorInternal$markName)],
                  lwd=lwd.chr,
                  border =
                    # ifelse(dfMarkColorInternal$markColor[match(z,dfMarkColorInternal$markName)]=="white",
                  # "black",
                  dfMarkColorInternal$markBorderColor[match(z,dfMarkColorInternal$markName)]
                          # ) # ifelse
                ), # pol
              x=xMark[[w]],
              y=yMark[[w]]
              ,z=listOfdfMarkPosArrow[[w]]$markName

        ) # mapply
    ) # lapp
    } # CIRC
    else { # circ true

      #
      #   x to vertical
      #

#       # xMarkArr<<-xMark
        # xlistNewOrig<-xHortoVer(xMark,arrowheadWidthShrink)
#        # xlistNewOrig1<<-xlistNewOrig
#      # x1 <<- x

        yMarkPer<-markMapPer(yMark,y)

        xlistNew <- xMarkMap(xMark,x, arrowheadWidthShrink)

        textyMarkPer<-centerMarkMapPer(yMark,y)

        ylistTransMark<-transyListMark(yMarkPer,ylistTransChr)

        textylistTransMark<-transyListMark(textyMarkPer,ylistTransChr)

        circleMapsMarks  <- applyMapCircle(radius,circleCenter,circleCenterY,separFactor,    ylistTransMark,xlistNew,n,0,chrWidth,rotation=rotation)

        # circleMapsLabels <- applyMapCircle(radius,circleCenter,circleCenterY,separFactor,textylistTransMark,xlistNew,n,
                                           # labelSpacing,chrWidth,rotation=rotation)

        drawPlotMark(circleMapsMarks,dfMarkColorInternal,listOfdfMarkPosArrow,lwd.chr)

} # circular
} # FUN
