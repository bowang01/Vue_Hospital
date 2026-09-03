<template>
  <div class="Echarts">
    <div id="orderPeople" class="chart-wide"></div>
    <div id="orderSection" class="chart-wide"></div>
    <div id="orderGender" class="chart-pie"></div>
    <div id="patientAge" class="chart-pie"></div>
  </div>
</template>
<script>
import request from "@/utils/request.js";
export default {
  name: "dataExpore",
  data() {
    return {
      sevenDate: [],
      sevenOrder: [],
    };
  },
  methods: {
    // Patient age distribution
    patientAge() {
      var myChart = this.$echarts.init(document.getElementById("patientAge"));
      request.get("hospital/patient/patientAge")
        .then(res => {
          var option = {
            title: {
              text: 'Patient Age Distribution',
              left: 'center'
            },
            tooltip: {
              trigger: 'item'
            },
            legend: {
              top: '5%',
              left: 'center'
            },
            series: [
              {
                name: 'Age group',
                type: 'pie',
                radius: ['40%', '70%'],
                avoidLabelOverlap: false,
                itemStyle: {
                  borderRadius: 10,
                  borderColor: '#fff',
                  borderWidth: 2
                },
                label: {
                  show: false,
                  position: 'center'
                },
                emphasis: {
                  label: {
                    show: true,
                    fontSize: '40',
                    fontWeight: 'bold'
                  }
                },
                labelLine: {
                  show: false
                },
                data: [
                  { value: res.data.data[0], name: '0-9' },
                  { value: res.data.data[1], name: '10-19' },
                  { value: res.data.data[2], name: '20-29' },
                  { value: res.data.data[3], name: '30-39' },
                  { value: res.data.data[4], name: '40-49' },
                  { value: res.data.data[5], name: '50-59' },
                  { value: res.data.data[6], name: '60-69' },
                  { value: res.data.data[7], name: '70-79' },
                  { value: res.data.data[8], name: '80-89' },
                  { value: res.data.data[9], name: '90-99' },
                ]
              }
            ]
          };



          // Render the chart with the specified options.
          myChart.setOption(option);


        })
        .catch(err => {
          console.error(err);
        })
    },
    // Appointments by department
    orderSection() {
      var myChart = this.$echarts.init(document.getElementById("orderSection"));
      request.get("hospital/order/orderSection")
        .then(res => {
          var option = {
            title: {
              text: 'Appointments by Department (Last 20 Days)',
              left: 'center'
            },
            xAxis: {
              type: 'category',
              data: res.data.data.map((item) => item.doctor.dSection),
              axisLabel: {// Fix labels not showing
                interval: 0,
                rotate: 10,
              }

            },
            yAxis: {
              type: 'value'
            },
            series: [{
              data: res.data.data.map((item) => item.countSection),
              type: 'bar',
              showBackground: true,
              backgroundStyle: {
                color: 'rgba(180, 180, 180, 0.2)'
              }
            }]
          };
          // Render the chart with the specified options.
          myChart.setOption(option);

        })
        .catch(err => {
          console.error(err);
        })
    },
    // Patient gender ratio
    orderGender() {
      var myChart = this.$echarts.init(document.getElementById("orderGender"));
      request.get("hospital/order/orderGender",)
        .then(res => {
          var option = {
            title: {
              text: 'Patient Gender Ratio',
              left: 'center'
            },
            tooltip: {
              trigger: 'item'
            },
            legend: {
              orient: 'vertical',
              left: 'left',
            },
            series: [
              {
                name: 'Count',
                type: 'pie',
                radius: '50%',
                data: [
                  { value: res.data.data.map((item) => item.countGender)[0], name: res.data.data.map((item) => item.patient.pGender)[0] },
                  { value: res.data.data.map((item) => item.countGender)[1], name: res.data.data.map((item) => item.patient.pGender)[1] },

                ],
                emphasis: {
                  itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                  }
                }
              }
            ]
          };
          // Render the chart with the specified options.
          myChart.setOption(option);

        })
        .catch(err => {
          console.error(err);
        });


    },
    // Get date from num days ago
    pastSeven(num) {
      var date = new Date();
      date.setDate(date.getDate() - num);
      var time = date.getMonth() + 1 + "-" + date.getDate();
      return time;
    },
    // Appointments in the last 20 days line chart
    orderPeople() {
      var myChart = this.$echarts.init(document.getElementById("orderPeople"));
      request
        .get("hospital/order/orderSeven")
        .then((res) => {
          if (res.data.status !== 200)
            return this.$message.error("Failed to load data");
          console.log(this.sevenDate)
          var option = {
            title: {
              text: "Appointments in the Last 20 Days",
              left: "5%",
            },
            xAxis: {
              type: "category",
              data: this.sevenDate,
            },
            yAxis: {
              type: "value",
              interval: 1,
            },
            series: [
              {
                data: res.data.data,
                type: "line",
              },
            ],
          };
          // Render the chart with the specified options.
          myChart.setOption(option);
        })
        .catch((err) => {
          console.error(err);
        });
    },
  },
  mounted() {
    this.orderPeople();
    this.orderGender();
    this.orderSection();
    this.patientAge();
  },
  created() {
    // Centered on today, get 20 days (10 before and 10 after)
    for (var i = 10; i > -10; i--) {
      this.sevenDate.push(this.pastSeven(i));
    }
  },
};
</script>

<style scoped>
.Echarts {
  overflow-x: auto;
  overflow-y: hidden;
}
.chart-wide {
  width: 100%;
  min-width: 720px;
  height: 400px;
}
.chart-pie {
  width: 48%;
  min-width: 360px;
  height: 500px;
  display: inline-block;
  vertical-align: top;
}
</style>
