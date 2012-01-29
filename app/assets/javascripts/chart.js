/**
 * Creates bar charts using Protovis library.
 * 
 * Bars representing different categories of data can be either stacked or 
 * not.
 */

/**
 * Creates and renders a bar chart with given chartData and options.
 * 
 * param chartData an object with the following required properties:
 *                 data:: an associative array of data to plot
 *                 labels:: x-axis lables
 *                 ymax:: y-axis maximum
 *                 ylabel:: y-axis unit label
 *                 categories:: keys in the data array
 */ 
var BarChart = function (chartData, options) {
  var data = chartData.data;
  var labels = chartData.labels;
  var ymax = chartData.ymax;
  var ylabel = chartData.ylabel;
  var categories = chartData.categories;
  var colors = options.fillColors || BarChart.DefaultStyle.fillColors
  var fillColors = pv.colors(colors).domain(categories);
  var width = options.width || BarChart.DefaultStyle.width;
  var height = options.height || BarChart.DefaultStyle.height;
  var leftMargin = options.leftMargin || BarChart.DefaultStyle.leftMargin;
  var xlabelHeight = options.xlabelHeight || BarChart.DefaultStyle.xlabelHeight;
  var ylabelWidth = options.ylabelWidth || BarChart.DefaultStyle.ylabelWidth;
  
  var barData = function (d) {
    var array = new Array(categories.length);
    for (var i = 0; i < categories.length; i++) {
      array[i] = d[categories[i]];
    }
    return array;
  };
      
  this.vis = new pv.Panel()
      .width(width - ylabelWidth)
      .height(height - xlabelHeight)
      .left(ylabelWidth)
      .bottom(xlabelHeight);
  var y = pv.Scale.linear(0, ymax).range(0, height);
  var x = pv.Scale.ordinal(pv.range(data.length)).
          splitBanded(0, width - leftMargin, 4 / 5);
  var bar;
  
  // Y-axis labels.
  this.vis.add(pv.Rule)
    .data(y.ticks(5))
    .bottom(y)
    .strokeStyle(function (d) { return d ? "rgba(127,127,127,.3)" : "#000"; })
  .add(pv.Label)
    .left(0)  
    .text(y.tickFormat);      
  
  this.vis.add(pv.Label)
    .left(0)
    .bottom((height - xlabelHeight) / 4)
    .textAngle(-Math.PI / 2)
    .text(ylabel)
    .font("12px sans-serif");
    
  if (options.stack) {    
    bar = this.vis.add(pv.Layout.Stack)
        .layers(categories)
        .values(data)
        .y(function(d, p) { return y(d[p]); })
      .layer.add(pv.Bar)
        .width(x.range().band)
        .left(function() { return x(this.index) + leftMargin; } )
        .fillStyle(function(d, p) { return fillColors(p); } );   
    bar.add(pv.Label)
        .bottom(5)
        .left(function() { return x(this.index) + leftMargin + x.range().band / 2; })
        .text(function () { return labels[this.index]; })
        .textAngle(-Math.PI / 2)
        .textAlign("left")
        .textBaseline("middle")
        .font("12pt sans-serif")
  } else {
    bar = this.vis.add(pv.Panel)
        .data(data)
        .width(x.range().band)
        .left(function () { return x(this.index) + leftMargin; })
    bar.add(pv.Bar)
        .data(barData)
        .bottom(0)
        .height(function(d) { return y(d); })
        .width(x.range().band / categories.length)
        .left(function () { return this.index * x.range().band / 
                                  categories.length; })
        .fillStyle(function () { return fillColors(this.index); });
        
    bar.add(pv.Label)
      .bottom(-xlabelHeight)
      .left(0)
      .text(function () { return labels[this.parent.index]; })
      .font("12px sans-serif");
  }
  
};

BarChart.prototype.render = function (id) {
  this.vis.canvas(id).render();
}

BarChart.DefaultStyle = {
  width: 600, height: 250, xlabelHeight: 0, ylabelWidth: 12, leftMargin: 8,
  fillColors: ["#60D698", "#F26C6C"]
};

var TimelineChart = function (chartData, options) {
  var height = options.height || TimelineChart.DefaultStyle.height;
  var width = options.width || TimelineChart.DefaultStyle.width;
  var rightMargin = options.rightMargin || 
                    TimelineChart.DefaultStyle.rightMargin;
  var leftMargin = options.leftMargin || TimelineChart.DefaultStyle.leftMargin;
  var xlabelHeight = options.xlabelHeight || 
                     TimelineChart.DefaultStyle.xlabelHeight;
  var data = chartData.data;
  var labels = chartData.labels;
  width -= leftMargin;
  
  this.vis = new pv.Panel()
      .width(width)
      .height(height)
      .left(leftMargin)
      .bottom(xlabelHeight);
  var x = pv.Scale.linear(0, 24).range(0, width - rightMargin);
  var y = pv.Scale.ordinal(pv.range(data.length)).splitBanded(0, height, 4 / 5);
  var categories = ["completed_quanta", "incomplete_quanta"];
  var bar = this.vis.add(pv.Panel)
      .data(data)
      .height(y.range().band)
      .bottom(function() { return y(this.index); })
    .add(pv.Bar)
      .data(function (d) { return d; })
      .width(function(d) { return x(d.duration); })
      .left(function(d) { return x(d.started_at); })
      .fillStyle(function(d) { return d.completed? "#60D698" : "#F26C6C"; });
      
  this.vis.add(pv.Rule)
      .data(x.ticks(24))
      .left(x)
      .strokeStyle(function (d) { return d ? "rgba(127,127,127,.3)" : "#000"; })
    .add(pv.Rule)
      .bottom(0)
      .height(5)
      .strokeStyle("#000")
    .anchor("bottom").add(pv.Label)      
      .text(x.tickFormat);        
      
  bar.parent.anchor("left").add(pv.Label)
    .textAlign("right")
    .textMargin(5)
    .text(function() { return labels[this.parent.index]; }); 
};

TimelineChart.DefaultStyle = {
  width: 450, height: 250, xlabelHeight: 20, leftMargin: 50, rightMargin: 10
};
  
TimelineChart.prototype.render = function (id) {
  this.vis.canvas(id).render();  
}
