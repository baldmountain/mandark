const displayGraph = data => {
    // set the dimensions and margins of the graph
    var margin = {top: 10, right: 30, bottom: 30, left: 60},
      width = 640 - margin.left - margin.right,
      height = 480 - margin.top - margin.bottom;

    // append the svg object to the body of the page
    var svg = d3.select("#temp_chart")
      .append("svg")
      .attr("viewBox", [0, 0, 640, 480])
      .append("g")
        .attr("transform",
              "translate(" + margin.left + "," + margin.top + ")");

    // Add X axis --> it is a date format
    var xAxis = d3.scaleTime()
      .domain(d3.extent(data, function(d) { return d.timestamp; }))
      .range([ 0, width ]);
    svg.append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(xAxis));

    // Add Y axis
    var yAxisLeft = d3.scaleLinear()
      .domain([
        d3.min(data, function(d) {
          return Math.min(+d.humidity, +d.temperature) - 5.0;
        }),
        d3.max(data, function(d) {
          return Math.max(+d.humidity, +d.temperature) + 5.0;
        })
      ])
      .range([ height, 0 ]);
    svg.append("g")
      .call(d3.axisLeft(yAxisLeft));

    var yAxisRight = d3.scaleLinear()
      .domain([
        d3.min(data, function(d) {
          return +d.vpd - 0.3;
        }),
        d3.max(data, function(d) {
          return +d.vpd + 0.3;
        })
      ])
      .range([ height, 0 ]);
    svg.append("g")
        .attr("transform", "translate("+ width +",0)")
        .call(d3.axisRight(yAxisRight));

    // temperature line
    svg.append("path")
      .datum(data)
      .attr("fill", "none")
      .attr("stroke", "steelblue")
      .attr("stroke-width", 1.5)
      .attr("d", d3.line()
        .defined(d => !isNaN(d.temperature))
        .x(function(d) { return xAxis(d.timestamp) })
        .y(function(d) { return yAxisLeft(d.temperature) })
        );
    // humidity line
    svg.append("path")
      .datum(data)
      .attr("fill", "none")
      .attr("stroke", "green")
      .attr("stroke-width", 1.5)
      .attr("d", d3.line()
        .x(function(d) { return xAxis(d.timestamp) })
        .y(function(d) { return yAxisLeft(d.humidity) })
        );

    // vpd line
    svg.append("path")
      .datum(data)
      .attr("fill", "none")
      .attr("stroke", "red")
      .attr("stroke-width", 1.5)
      .attr("d", d3.line()
        .x(function(d) { return xAxis(d.timestamp) })
        .y(function(d) { return yAxisRight(d.vpd) })
        );

    // Legend
    svg.append("circle").attr("cx",20).attr("cy", 10).attr("r", 6).style("fill", "steelblue")
    svg.append("circle").attr("cx",20).attr("cy", 24).attr("r", 6).style("fill", "green")
    svg.append("circle").attr("cx",530).attr("cy", 10).attr("r", 6).style("fill", "red")
    svg.append("text").attr("x", 30).attr("y", 10).text("temperature").style("font-size", "13px").attr("alignment-baseline","middle")
    svg.append("text").attr("x", 30).attr("y", 24).text("humidity").style("font-size", "13px").attr("alignment-baseline","middle")
    svg.append("text").attr("x", 496).attr("y", 10).text("vpd").style("font-size", "13px").attr("alignment-baseline","middle")
};

export default displayGraph;