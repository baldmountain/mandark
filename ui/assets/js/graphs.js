const displayGraph = data => {
    // set the dimensions and margins of the graph
    var margin = {top: 10, right: 30, bottom: 30, left: 60},
      width = 460 - margin.left - margin.right,
      height = 400 - margin.top - margin.bottom;

    // append the svg object to the body of the page
    var svg = d3.select("#temp_chart")
      .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
        .attr("transform",
              "translate(" + margin.left + "," + margin.top + ")");
    // Add X axis --> it is a date format
    var x = d3.scaleTime()
      .domain(d3.extent(data, function(d) { return d.timestamp; }))
      .range([ 0, width ]);
    svg.append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x));

    // Add Y axis
    var y = d3.scaleLinear()
      .domain([
        d3.min(data, function(d) {
          return Math.min(d.humidity, +d.pressure, +d.temperature) - 5.0;
        }),
        d3.max(data, function(d) {
          return Math.max(+d.humidity, +d.pressure, +d.temperature) + 5.0;
        })
      ])
      .range([ height, 0 ]);
    svg.append("g")
      .call(d3.axisLeft(y));

    // temperature line
    svg.append("path")
      .datum(data)
      .attr("fill", "none")
      .attr("stroke", "steelblue")
      .attr("stroke-width", 1.5)
      .attr("d", d3.line()
        .x(function(d) { return x(d.timestamp) })
        .y(function(d) { return y(d.temperature) })
        );
    // humidity line
    svg.append("path")
      .datum(data)
      .attr("fill", "none")
      .attr("stroke", "green")
      .attr("stroke-width", 1.5)
      .attr("d", d3.line()
        .x(function(d) { return x(d.timestamp) })
        .y(function(d) { return y(d.humidity) })
        );
};

export default displayGraph;